/// 字节帧组装器（半包 / 粘包处理）。
///
/// socket 推过来的字节流可能在任意边界上切分：
/// - 一次 feed 多个完整帧；
/// - 一次 feed 半个帧；
/// - 一次 feed 跨多帧。
/// Framer 内部维护一个残留缓冲，把到齐的完整帧吐出来，剩余字节留在缓冲里
/// 等下一次 feed。
///
/// 错误语义（Day 1 约定）：
/// - `decode_fixed_header` 返回 Err 时一律视为「半包，等下一批字节」并停止本轮。
///   这覆盖了最常见的「剩余长度还没到齐」场景。
/// - 若真的是协议层错误（剩余长度 >4 字节 / 保留报文类型），本帧会一直卡在
///   缓冲里、永远不会产出——Day 1 不做 fatal-reset，留 Day 2 加显式 reset 钩子。
///
/// 每帧返回的 Array[Int] 都包含完整固定头（第一字节 + 剩余长度变长编码），
/// 可以直接喂给 `@protocol.decode_packet`。

pub struct Framer {
  buf : Array[Int]
}

pub fn Framer::new() -> Framer {
  return { buf: [] }
}

/// 当前残留字节数（调试用）。
pub fn Framer::len(self : Framer) -> Int {
  return self.buf.length()
}

/// 把新字节追加到缓冲，循环尝试切出完整帧，返回完整帧列表。
pub fn Framer::feed(self : Framer, bytes : Array[Int]) -> Array[Array[Int]] {
  // 追加新字节（Array 是引用语义，push 直接作用于底层数组）
  for b in bytes {
    self.buf.push(b)
  }
  let frames : Array[Array[Int]] = []
  let mut partial = false
  while !partial && self.buf.length() > 0 {
    match @protocol.decode_fixed_header(self.buf, 0) {
      Err(_) => {
        // Day 1：半包，等下一批字节。
        // 真协议错误（>4 字节剩余长度 / 保留类型）会卡住缓冲，Day 2 加 reset。
        partial = true
      }
      Ok((_t, _flags, rlen, header_end)) => {
        let total = header_end + rlen
        if self.buf.length() < total {
          // 半包：剩余长度已知但可变头 + 载荷还没到齐
          partial = true
        } else {
          // 切出完整帧
          let frame : Array[Int] = []
          for i in 0..<total {
            frame.push(self.buf[i])
          }
          frames.push(frame)
          // 把剩余字节左移回缓冲
          let remaining : Array[Int] = []
          for i in total..<self.buf.length() {
            remaining.push(self.buf[i])
          }
          self.buf.clear()
          for b in remaining {
            self.buf.push(b)
          }
        }
      }
    }
  }
  return frames
}

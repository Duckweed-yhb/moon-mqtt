/// 字节帧组装器（半包 / 粘包处理）。
///
/// socket 推过来的字节流可能在任意边界上切分：
/// - 一次 feed 多个完整帧；
/// - 一次 feed 半个帧；
/// - 一次 feed 跨多帧。
/// Framer 内部维护一个残留缓冲，把到齐的完整帧吐出来，剩余字节留在缓冲里
/// 等下一次 feed。
///
/// 错误语义：
/// - 「半包」不算错：固定头不完整、或剩余长度到了但载荷没到齐，都返回
///   `Ok(已切出的帧)`，剩余字节留着等下一批。
/// - 「畸形头」是错：保留报文类型、剩余长度超过 4 字节等，返回 `Err`，
///   同时清空缓冲——否则这一帧会永久卡住，后面的帧再也出不来。
/// - 缓冲超过协议允许的最大帧（5 字节固定头 + 268435455 载荷）也返回 `Err`。
///
/// 每帧返回的 Array[Int] 都包含完整固定头（第一字节 + 剩余长度变长编码），
/// 可以直接喂给 `@protocol.decode_packet`。

///|
/// 协议允许的最大帧：固定头最多 5 字节 + 剩余长度上限 268435455。
let max_frame_bytes = 268435460

///|
pub struct Framer {
  buf : Array[Int32]
}

///|
pub fn Framer::new() -> Framer {
  return { buf: [], }
}

///|
/// 当前残留字节数（调试用）。
pub fn Framer::len(self : Framer) -> Int32 {
  return self.buf.length()
}

///|
/// 清空残留缓冲（断线重连时调用：旧连接的半包字节不能带到新连接）。
pub fn Framer::reset(self : Framer) -> Unit {
  self.buf.clear()
}

///|
/// 区分「半包」与「畸形头」：`decode_fixed_header` 的两类半包错误。
fn is_partial(err : String) -> Bool {
  err == "empty fixed header" || err == "remaining length truncated"
}

///|
/// 把新字节追加到缓冲，循环尝试切出完整帧，返回完整帧列表。
///
/// 返回 `Err` 表示帧组装进入不可恢复状态（畸形固定头或缓冲超限），
/// 此时缓冲已清空，调用方应断开连接而不是继续读。
pub fn Framer::feed(
  self : Framer,
  bytes : Array[Int32],
) -> Result[Array[Array[Int32]], String] {
  // 追加新字节（Array 是引用语义，push 直接作用于底层数组）
  for b in bytes {
    self.buf.push(b)
  }
  if self.buf.length() > max_frame_bytes {
    self.buf.clear()
    return Err("framer buffer overflow")
  }
  let frames : Array[Array[Int32]] = []
  // 用游标读，循环里不搬缓冲；一轮喂进来 N 帧时是 O(n) 而不是 O(n²)。
  let mut offset = 0
  let mut partial = false
  while !partial && offset < self.buf.length() {
    match @protocol.decode_fixed_header(self.buf, offset) {
      Err(e) =>
        if is_partial(e) {
          // 半包，等下一批字节。
          partial = true
        } else {
          // 畸形头：清空缓冲并上报，避免永久卡死。
          self.buf.clear()
          return Err("framer fatal: " + e)
        }
      Ok((_t, _flags, rlen, header_end)) => {
        let total = header_end - offset + rlen
        if self.buf.length() - offset < total {
          // 半包：剩余长度已知但可变头 + 载荷还没到齐
          partial = true
        } else {
          let frame : Array[Int32] = []
          for i in offset..<(offset + total) {
            frame.push(self.buf[i])
          }
          frames.push(frame)
          offset += total
        }
      }
    }
  }
  // 只搬一次剩余字节。
  if offset > 0 {
    let remaining : Array[Int32] = []
    let mut i = offset
    while i < self.buf.length() {
      remaining.push(self.buf[i])
      i += 1
    }
    self.buf.clear()
    for b in remaining {
      self.buf.push(b)
    }
  }
  return Ok(frames)
}

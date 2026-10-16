/// examples/resume — QoS2 中断重连（会话恢复）演示。
///
/// 纯计算路径，不连真实 broker。完整时间线见 moon.pkg 顶部注释。
fn main() -> Unit {
  let qos2 = match @protocol.qos_from_int(2) {
    Some(q) => q
    None => return
  }

  println("=== moon-mqtt · QoS2 中断重连演示 ===")
  println("")

  // 1) 客户端发一条 QoS2 PUBLISH，store 记录在途（WaitPubrec）
  let mut store = @session.SessionStore::new()
  let seed = @protocol.PublishPacket::new(
    "device/accel",
    [0x01, 0x02, 0x03, 0x04],
    qos2,
    false,
    false,
    0,
  )
  let (s1, pid) = @session.record_outbound(store, seed)
  store = s1
  println("[1] 发出 QoS2 PUBLISH packet_id=" + pid.to_string() +
    " topic=device/accel；store 进入 WaitPubrec")
  println("    inflight 计数 = " + store.inflight_count().to_string())
  println("")

  // 2) 模拟 broker 回 PUBREC —— 但此刻网络断开，客户端没收到 PUBCOMP
  //    （现实中：TCP 被对端 reset，或设备掉电）
  println("[2] 模拟：broker 回了 PUBREC，但客户端在等 PUBCOMP 前断线")
  let (s2, _pubrel_bytes) = @session.on_pubrec(store, pid)
  store = s2
  println("    本地收到 PUBREC，store 推进到 WaitPubcomp（已生成 PUBREL 待发）")
  println("")

  // 3) 设备重启 / 重连。从持久化（实际项目里是文件）读回 store 快照。
  //    这里用 from_parts 模拟：在途条目仍在，next_id 游标不变。
  println("[3] 重连后用 SessionStore.replay() 取待重放帧：")
  let frames = @session.replay(store)
  println("    replay 返回 " + frames.length().to_string() + " 帧：")
  let mut i = 0
  for f in frames {
    i = i + 1
    println("    帧 " + i.to_string() + "：" + f.length().to_string() +
      " 字节（WaitPubcomp 状态应产出 PUBREL，DUP PUBLISH 已在 WaitPubrec 阶段完成）")
  }
  println("")

  // 4) 重连后把 PUBREL 发给 broker，broker 回 PUBCOMP
  println("[4] 重连后重发 PUBREL，broker 回 PUBCOMP")
  store = @session.on_pubcomp(store, pid)
  println("    on_pubcomp 后 inflight 计数 = " + store.inflight_count().to_string())
  println("")

  // 5) 再 replay 应为空
  let after = @session.replay(store)
  println("[5] 握手完成。再 replay 返回 " + after.length().to_string() + " 帧（应为 0）")
  println("")
  println("=== 结论：QoS2 exactly-once 在断线重连后通过 DUP 重发 + PUBREL 幂等语义")
  println("     保证不丢失、不重复。见 session/persistent.mbt 单测。 ===")
}

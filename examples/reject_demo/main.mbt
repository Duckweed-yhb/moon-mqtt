///|
/// 拒绝演示：畸形报文与非法 topic 会得到什么。
///
/// 这个库对入站字节的校验比功能本身更值得看：QoS0 不许带 DUP、QoS1/2 的
/// packet_id 不许为 0、topic 不许带通配符或 U+0000、固定头 flags 必须精确。
/// 这里把每条拒绝路径跑一遍，包括「解码失败要当作协议错误并关闭连接」。
///
/// 运行：`moon run examples/reject_demo --target native`
fn main {
  println("== 报文解码（decode_packet）==")
  let cases : Array[(String, Array[Int32])] = [
    (
      "QoS1 PUBLISH 但 packet_id = 0",
      [0x32, 0x05, 0x00, 0x01, 0x61, 0x00, 0x00],
    ),
    ("topic 带通配符 +", [0x30, 0x04, 0x00, 0x01, 0x2B, 0x01]),
    ("QoS0 PUBLISH 置了 DUP 位", [0x38, 0x03, 0x00, 0x01, 0x61]),
    ("PINGRESP 的 flags 非 0", [0xD8, 0x00]),
    ("broker 发来 CONNECT（类型 1）", [0x10, 0x00]),
  ]
  for c in cases {
    let (label, bytes) = c
    match @protocol.decode_packet(bytes) {
      Ok(_) => println("  " + label + " -> 接受（预期之外）")
      Err(e) => println("  " + label + " -> 拒绝：" + e)
    }
  }

  println("")
  println("== 主题规则（§3.3.2.1 / §4.7.1.2）==")
  for t in ["a/b", "a/+", "a/#", ""] {
    let r = @protocol.validate_topic_name(t)
    match r {
      Ok(_) => println("  topic name \"" + t + "\" -> 通过")
      Err(e) => println("  topic name \"" + t + "\" -> 拒绝：" + e)
    }
  }
  for f in ["a/#", "a/+/b", "a/#/b", "a/x+"] {
    let r = @protocol.validate_topic_filter(f)
    match r {
      Ok(_) => println("  filter \"" + f + "\" -> 通过")
      Err(e) => println("  filter \"" + f + "\" -> 拒绝：" + e)
    }
  }

  println("")
  println("== 状态机：畸形帧不是「忽略」，而是协议错误 ==")
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("reject-demo"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  match core.feed([0x32, 0x05, 0x00, 0x01, 0x61, 0x00, 0x00]) {
    (events, _) =>
      for e in events {
        match e {
          @core.CoreEvent::MalformedFrame(t, reason) => {
            println(
              "  malformed -> MalformedFrame(type=" +
              t.to_string() +
              ", " +
              reason +
              ")",
            )
            match @core.plan_event(e) {
              @core.DispatchAction::Fatal(m) =>
                println("  plan_event -> Fatal：" + m)
              _ => println("  plan_event -> 非 Fatal（预期之外）")
            }
          }
          @core.CoreEvent::UnknownPacketType(t) =>
            println(
              "  malformed -> UnknownPacketType(" +
              t.to_string() +
              ")（预期之外）",
            )
          _ => println("  malformed -> 其它事件（预期之外）")
        }
      }
  }
}

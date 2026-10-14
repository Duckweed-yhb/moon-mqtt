/// examples/pubsub — 最小可运行示例。
///
/// 演示 `protocol` 层：构造一条 QoS1 PUBLISH → 编码成字节 → 解码回读。
/// 这是 MQTT 客户端最核心的确定性路径，本地即可运行验证。

fn main() -> Unit {
  // 1. 构造一条 QoS1 PUBLISH。
  //    位置参数：topic / payload / qos / retain / dup / packet_id。
  //    qos 经 `qos_from_int` 构造（返回 Option[QoS]，1 = AtLeastOnce）。
  let qos = match @protocol.qos_from_int(1) {
    Some(q) => q
    None => return
  }
  let pkt = @protocol.PublishPacket::new(
    "sensors/temp",
    [0x32, 0x33], // 载荷字节 "23"
    qos,
    false,
    false,
    7,
  )

  // 2. 编码成完整报文（含固定头）
  let bytes = @protocol.encode_publish(pkt)
  let enc = "encoded ("
  let enc2 = enc + bytes.length().to_string() + " bytes)"
  println(enc2)

  // 3. 解码回读，验证往返一致
  match @protocol.decode_publish(bytes) {
    Ok(d) =>
      println(
        "decoded: topic=" + d.topic + " payload=" +
        @debug.Debug::to_repr(d.payload).to_string() + " qos=" +
        @protocol.qos_value(d.qos).to_string(),
      )
    Err(e) => println("decode failed: " + e)
  }
}

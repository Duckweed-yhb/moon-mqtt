///|
/// PUBLISH 编解码往返的随机测试。
///
/// 现有单测是「几个固定报文编码对不对」，这里补的是「任意合法输入都能
/// encode → decode → 字段一一还原」。用固定种子的 LCG 生成 topic / payload /
/// QoS / retain / dup 组合，失败可复现（种子写死在测试里，不用系统随机）。
///
/// 这类测试抓的是边界：空 payload、单字节 payload、topic 里带 '/' 的层级、
/// QoS2 的 packet_id、以及 dup 在 QoS0 上本就不允许的拒绝路径。

///|
/// 固定参数的线性同余发生器：结果是确定的，失败能在本机复现。
fn lcg_next(state : Int32) -> Int32 {
  (state * 1103515245 + 12345) & 0x7FFFFFFF
}

///|
/// 用生成器造一个长度 `n` 的字节数组（0..255）。
fn lcg_bytes(state : Int32, n : Int32) -> (Array[Int32], Int32) {
  let out : Array[Int32] = []
  let mut s = state
  let mut i = 0
  while i < n {
    s = lcg_next(s)
    out.push(s % 256)
    i += 1
  }
  (out, s)
}

///|
/// 造一个由若干层组成、每层非空的 topic（避免与空层/通配符规则纠缠）。
fn lcg_topic(state : Int32) -> (String, Int32) {
  let mut s = lcg_next(state)
  let levels = s % 4 + 1
  let mut topic = ""
  let mut i = 0
  while i < levels {
    s = lcg_next(s)
    if i > 0 {
      topic = topic + "/"
    }
    topic = topic + "t" + (s % 100).to_string()
    i += 1
  }
  (topic, s)
}

///|
test "publish roundtrip over generated inputs" {
  let mut seed = 20261111
  let mut case = 0
  while case < 200 {
    let (topic, s1) = lcg_topic(seed)
    let (payload, s2) = lcg_bytes(s1, case % 7)
    seed = s2
    let qos_code = case % 3
    let qos = match @protocol.qos_from_int(qos_code) {
      Some(q) => q
      None => fail("bad qos code")
    }
    let retain = case % 2 == 0
    // §3.3.1.3：QoS0 不许带 DUP，其余可以
    let dup = qos_code != 0 && case % 3 == 0
    let pid = if qos_code == 0 { 0 } else { case % 65535 + 1 }
    let pkt = @protocol.PublishPacket::new(
      topic, payload, qos, retain, dup, pid,
    )
    let frame = @protocol.encode_publish(pkt)
    match @protocol.decode_packet(frame) {
      Ok(@protocol.IncomingPacket::Publish(back)) => {
        assert_eq(back.topic, topic)
        assert_eq(back.payload.length(), payload.length())
        let mut i = 0
        while i < payload.length() {
          assert_eq(back.payload[i], payload[i])
          i += 1
        }
        assert_eq(back.qos, qos)
        assert_eq(back.retain, retain)
        assert_eq(back.dup, dup)
        assert_eq(back.packet_id, pid)
      }
      Ok(_) => fail("decoded to a non-publish packet")
      Err(e) => fail("decode failed: " + e)
    }
    case += 1
  }
}

///|
test "publish roundtrip keeps multi-byte utf8 topics" {
  // 中文 topic 走 UTF-8 多字节路径，长度前缀必须是字节数而不是字符数。
  let topic = "设备/一号/状态"
  let payload = [0x00, 0xFF, 0x7F]
  let pkt = @protocol.PublishPacket::new(
    topic,
    payload,
    @protocol.qos1(),
    false,
    false,
    42,
  )
  match @protocol.decode_packet(@protocol.encode_publish(pkt)) {
    Ok(@protocol.IncomingPacket::Publish(back)) => {
      assert_eq(back.topic, topic)
      assert_eq(back.payload, payload)
      assert_eq(back.packet_id, 42)
    }
    _ => fail("utf8 topic roundtrip failed")
  }
}

///|
test "qos0 with dup flag is rejected by the decoder" {
  // 手工构造一条 QoS0 + DUP 的帧：§3.3.1.3 明确禁止。
  // 0x38 = PUBLISH(QoS0, DUP=1, RETAIN=0)
  let frame = @protocol.encode_publish(
    @protocol.PublishPacket::new("a", [0x01], @protocol.qos0(), false, false, 0),
  )
  let tampered = frame.copy()
  tampered[0] = 0x38
  match @protocol.decode_packet(tampered) {
    Ok(_) => fail("qos0 + dup must be rejected")
    Err(_) => ()
  }
}

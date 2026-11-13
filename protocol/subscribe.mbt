/// SUBSCRIBE（3.1.1 §3.8）/ SUBACK（§3.9）/ UNSUBSCRIBE（§3.10）/ UNSUBACK（§3.11）。

///|
/// 一条订阅：主题过滤器 + 请求的 QoS。
pub struct Subscription {
  topic : String
  qos : QoS
}

///|
/// 构造一条订阅（供消费者在库外创建）。
pub fn Subscription::new(topic : String, qos : QoS) -> Subscription {
  return { topic, qos, }
}

///|
pub struct SubscribePacket {
  packet_id : Int32
  subscriptions : Array[Subscription]
}

///|
/// 构造 SUBSCRIBE 参数（供消费者在库外创建）。
pub fn SubscribePacket::new(
  packet_id : Int32,
  subscriptions : Array[Subscription],
) -> SubscribePacket {
  return { packet_id, subscriptions, }
}

///|
/// 编码 SUBSCRIBE 为完整报文（含固定头 0x82）。
///
/// 过滤器不合法（`a/#/b`、`a/x+` 这类）会被整条剔除：编进去 broker 只会
/// 当协议错误断连，调用方还拿不到线索。全部不合法时返回空数组，由调用方
/// 决定怎么上报（`browser/`、`async/` 都会打印警告）。
pub fn encode_subscribe(pkt : SubscribePacket) -> Array[Int32] {
  let valid : Array[Subscription] = []
  for sub in pkt.subscriptions {
    if is_valid_topic_filter(sub.topic) {
      valid.push(sub)
    }
  }
  if valid.length() == 0 {
    return []
  }
  // §2.3.1：SUBSCRIBE 的 packet identifier 必须在 1..65535。与 PUBLISH、
  // QoS 控制包编码侧同款守卫：库外构造 pid=0 时直接失败，不把 broker 必须
  // 按协议错误断连的帧编出去。
  if pkt.packet_id <= 0 || pkt.packet_id > 0xFFFF {
    abort(
      "mqtt: subscribe packet id must be in 1..65535, got " +
      pkt.packet_id.to_string(),
    )
  }
  let body = ByteWriter::new()
  body.push_u16(pkt.packet_id)
  for sub in valid {
    body.push_string(sub.topic)
    body.push_byte(qos_value(sub.qos))
  }
  let out = ByteWriter::new()
  out.push_byte(0x82)
  out.push_remaining_length(body.bytes().length())
  for b in body.bytes() {
    out.push_byte(b)
  }
  return out.bytes()
}

///|
/// SUBACK 每个订阅返回码（§3.9.3）。
#derive(Eq, Debug)
pub enum SubAckCode {
  Success0
  Success1
  Success2
  Failure
}

///|
pub extend SubAckCode with Eq::{not_equal, equal}

///|
pub extend SubAckCode with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub fn suback_code_from_int(v : Int32) -> SubAckCode? {
  match v {
    0 => Some(SubAckCode::Success0)
    1 => Some(SubAckCode::Success1)
    2 => Some(SubAckCode::Success2)
    0x80 => Some(SubAckCode::Failure)
    _ => None
  }
}

///|
pub struct Suback {
  packet_id : Int32
  codes : Array[SubAckCode]
}

///|
/// 所有订阅项都被 broker 接受（没有 0x80 Failure）。
pub fn Suback::all_accepted(self : Suback) -> Bool {
  for c in self.codes {
    match c {
      SubAckCode::Failure => return false
      _ => ()
    }
  }
  return true
}

///|
/// 解码 SUBACK。data 为完整报文。
pub fn decode_suback(data : Array[Int32]) -> Result[Suback, String] {
  if data.length() < 5 {
    return Err("suback too short")
  }
  if data[0] != 0x90 {
    return Err("not a suback")
  }
  // 剩余长度是变长编码：一次订阅很多 topic 时 RL > 127，会占两个字节。
  // 旧实现直接按「RL 占 1 字节」读 pid，这种帧会被解成错的 packet id。
  let (rlen, header_end) = match decode_remaining_length(data, 1) {
    Ok(x) => x
    Err(e) => return Err(e)
  }
  // §3.9：SUBACK 至少包含一个返回码
  if rlen < 3 {
    return Err("suback remaining length too small")
  }
  if header_end + rlen != data.length() {
    return Err("suback length mismatch")
  }
  let r = ByteReader::new(data)
  match r.read_u16(header_end) {
    Err(e) => Err(e)
    Ok((pid, after_pid)) => {
      // §2.3.1：packet identifier 不得为 0
      if pid == 0 {
        return Err("suback packet id must be nonzero")
      }
      let mut pos = after_pid
      let codes : Array[SubAckCode] = []
      while pos < header_end + rlen {
        match suback_code_from_int(data[pos]) {
          Some(c) => codes.push(c)
          None => return Err("suback bad code")
        }
        pos = pos + 1
      }
      Ok({ packet_id: pid, codes, })
    }
  }
}

///|
pub struct UnsubscribePacket {
  packet_id : Int32
  topics : Array[String]
}

///|
/// 构造 UNSUBSCRIBE 参数（供消费者在库外创建）。
pub fn UnsubscribePacket::new(
  packet_id : Int32,
  topics : Array[String],
) -> UnsubscribePacket {
  return { packet_id, topics, }
}

///|
/// 编码 UNSUBSCRIBE 为完整报文（含固定头 0xA2）。
pub fn encode_unsubscribe(pkt : UnsubscribePacket) -> Array[Int32] {
  // §2.3.1：UNSUBSCRIBE 的 packet identifier 必须在 1..65535，守卫口径与
  // SUBSCRIBE、PUBLISH 及 QoS 控制包一致。
  if pkt.packet_id <= 0 || pkt.packet_id > 0xFFFF {
    abort(
      "mqtt: unsubscribe packet id must be in 1..65535, got " +
      pkt.packet_id.to_string(),
    )
  }
  let body = ByteWriter::new()
  body.push_u16(pkt.packet_id)
  for t in pkt.topics {
    body.push_string(t)
  }
  let out = ByteWriter::new()
  out.push_byte(0xA2)
  out.push_remaining_length(body.bytes().length())
  for b in body.bytes() {
    out.push_byte(b)
  }
  return out.bytes()
}

///|
/// 解码 UNSUBACK，返回 packet_id。data 为完整报文。
///
/// §3.11：UNSUBACK 的剩余长度恒为 2，没有其它字段。这里和 `decode_suback`
/// 用同一套严格度——此前 `data[1]` 完全不看、pid=0 也放过，截断的 UNSUBACK
/// 会被当成成功，pid=0 的变体则在调用方变成 "UNSUBACK id mismatch"，
/// 把协议错误报成业务错误。
pub fn decode_unsuback(data : Array[Int32]) -> Result[Int32, String] {
  if data.length() < 2 {
    return Err("unsuback too short")
  }
  if data[0] != 0xB0 {
    return Err("not an unsuback")
  }
  match decode_remaining_length(data, 1) {
    Err(e) => Err(e)
    Ok((rlen, header_end)) => {
      if rlen != 2 {
        return Err(
          "unsuback remaining length must be 2, got " + rlen.to_string(),
        )
      }
      if header_end + rlen != data.length() {
        return Err("unsuback length mismatch")
      }
      let r = ByteReader::new(data)
      match r.read_u16(header_end) {
        Err(e) => Err(e)
        Ok((pid, _)) =>
          if pid == 0 {
            Err("unsuback packet id must be nonzero")
          } else {
            Ok(pid)
          }
      }
    }
  }
}

///|
test "encode_subscribe" {
  let pkt = {
    packet_id: 1,
    subscriptions: [{ topic: "a/#", qos: QoS::AtLeastOnce, }],
  }
  let bytes = encode_subscribe(pkt)
  // 0x82, rlen=2(pid) + 2(len)+3(topic a/#) + 1(qos) = 8
  assert_eq(bytes[0], 0x82)
  assert_eq(bytes[1], 8)
  assert_eq(bytes[2], 0x00)
  assert_eq(bytes[3], 0x01) // pid=1
  assert_eq(bytes[4], 0x00)
  assert_eq(bytes[5], 0x03) // "a/#" len
  assert_eq(bytes[6], 0x61) // 'a'
  assert_eq(bytes[7], 0x2F) // '/'
  assert_eq(bytes[8], 0x23) // '#'
  assert_eq(bytes[9], 0x01) // qos
}

///|
/// 上界 packet id（65535）属于合法范围，编码不应被守卫拦下。
test "encode_subscribe accepts upper packet id" {
  let pkt = {
    packet_id: 0xFFFF,
    subscriptions: [{ topic: "a/#", qos: QoS::AtMostOnce, }],
  }
  let bytes = encode_subscribe(pkt)
  assert_eq(bytes[0], 0x82)
  assert_eq(bytes[2], 0xFF)
  assert_eq(bytes[3], 0xFF)
}

///|
test "decode_suback" {
  match decode_suback([0x90, 0x04, 0x00, 0x07, 0x01, 0x80]) {
    Ok(s) => {
      assert_eq(s.packet_id, 7)
      assert_eq(s.codes, [SubAckCode::Success1, SubAckCode::Failure])
    }
    Err(e) => fail(e)
  }
  assert_true(
    match decode_suback([0x20, 0x02, 0x00, 0x00]) {
      Err(_) => true
      Ok(_) => false
    },
  )
}

///|
test "unsubscribe roundtrip" {
  let pkt = { packet_id: 3, topics: ["a/b", "c"], }
  let bytes = encode_unsubscribe(pkt)
  match decode_unsuback([0xB0, 0x02, 0x00, 0x03]) {
    Ok(pid) => assert_eq(pid, 3)
    Err(e) => fail(e)
  }
  assert_eq(bytes[0], 0xA2)
}

///|
/// 上界 packet id（65535）属于合法范围，编码不应被守卫拦下。
test "encode_unsubscribe accepts upper packet id" {
  let pkt = UnsubscribePacket::new(0xFFFF, ["a/b"])
  let bytes = encode_unsubscribe(pkt)
  assert_eq(bytes[0], 0xA2)
  assert_eq(bytes[2], 0xFF)
  assert_eq(bytes[3], 0xFF)
}

///|
/// 剩余长度跨两个字节的 SUBACK：一次订阅很多 topic 时 RL > 127。
/// 旧实现按「RL 占 1 字节」读 pid，这种帧会被解成错的 packet id。
test "suback with multi byte remaining length parses correctly" {
  let pid = 300
  // 130 个返回码 → RL = 2 + 130 = 132 → 变长编码 0x84 0x01
  let codes = 130
  let data : Array[Int32] = [0x90, 0x84, 0x01, (pid >> 8) & 0xFF, pid & 0xFF]
  let mut i = 0
  while i < codes {
    data.push(0x01) // 每个都 granted QoS1
    i += 1
  }
  match decode_suback(data) {
    Ok(s) => {
      assert_eq(s.packet_id, pid)
      assert_eq(s.codes.length(), codes)
      assert_true(s.all_accepted())
    }
    Err(e) => fail("multi-byte RL suback failed: " + e)
  }
}

///|
/// packet id 为 0 的 SUBACK §2.3.1 明确非法。
test "suback rejects zero packet id" {
  match decode_suback([0x90, 0x03, 0x00, 0x00, 0x01]) {
    Ok(_) => fail("zero packet id must be rejected")
    Err(e) => assert_true(e.contains("must be nonzero"))
  }
}

///|
/// 剩余长度与实际字节数不符：截断帧必须报错，不能把缺的字节当没有。
test "suback rejects length mismatch" {
  match decode_suback([0x90, 0x05, 0x00, 0x07, 0x01]) {
    Ok(_) => fail("truncated suback must be rejected")
    Err(e) => assert_true(e.contains("length mismatch"))
  }
  // 剩余长度小于 3（连 pid 都不够）
  match decode_suback([0x90, 0x02, 0x00, 0x07]) {
    Ok(_) => fail("short suback must be rejected")
    Err(_) => ()
  }
}

/// SUBSCRIBE（3.1.1 §3.8）/ SUBACK（§3.9）/ UNSUBSCRIBE（§3.10）/ UNSUBACK（§3.11）。

/// 一条订阅：主题过滤器 + 请求的 QoS。
pub struct Subscription {
  topic : String
  qos : QoS
}

/// 构造一条订阅（供消费者在库外创建）。
pub fn Subscription::new(topic : String, qos : QoS) -> Subscription {
  return { topic, qos }
}

pub struct SubscribePacket {
  packet_id : Int
  subscriptions : Array[Subscription]
}

/// 构造 SUBSCRIBE 参数（供消费者在库外创建）。
pub fn SubscribePacket::new(
  packet_id : Int, subscriptions : Array[Subscription]
) -> SubscribePacket {
  return { packet_id, subscriptions }
}

/// 编码 SUBSCRIBE 为完整报文（含固定头 0x82）。
pub fn encode_subscribe(pkt : SubscribePacket) -> Array[Int] {
  let body = ByteWriter::new()
  body.push_u16(pkt.packet_id)
  for sub in pkt.subscriptions {
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

/// SUBACK 每个订阅返回码（§3.9.3）。
pub enum SubAckCode {
  Success0
  Success1
  Success2
  Failure
} derive(Eq, Debug)

pub extend SubAckCode with Eq::{not_equal, equal}
pub extend SubAckCode with @moonbitlang/core/debug.Debug::{to_repr}

pub fn suback_code_from_int(v : Int) -> Option[SubAckCode] {
  match v {
    0 => Some(SubAckCode::Success0)
    1 => Some(SubAckCode::Success1)
    2 => Some(SubAckCode::Success2)
    0x80 => Some(SubAckCode::Failure)
    _ => None
  }
}

pub struct Suback {
  packet_id : Int
  codes : Array[SubAckCode]
}

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

/// 解码 SUBACK。data 为完整报文。
pub fn decode_suback(data : Array[Int]) -> Result[Suback, String] {
  if data.length() < 4 {
    return Err("suback too short")
  }
  if data[0] != 0x90 {
    return Err("not a suback")
  }
  let r = ByteReader::new(data)
  match r.read_u16(2) {
    Err(e) => Err(e)
    Ok((pid, p)) => {
      let mut pos = p
      let codes : Array[SubAckCode] = []
      while pos < data.length() {
        match suback_code_from_int(data[pos]) {
          Some(c) => codes.push(c)
          None => return Err("suback bad code")
        }
        pos = pos + 1
      }
      Ok({ packet_id: pid, codes })
    }
  }
}

pub struct UnsubscribePacket {
  packet_id : Int
  topics : Array[String]
}

/// 编码 UNSUBSCRIBE 为完整报文（含固定头 0xA2）。
pub fn encode_unsubscribe(pkt : UnsubscribePacket) -> Array[Int] {
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

/// 解码 UNSUBACK，返回 packet_id。data 为完整报文。
pub fn decode_unsuback(data : Array[Int]) -> Result[Int, String] {
  if data.length() < 4 {
    return Err("unsuback too short")
  }
  if data[0] != 0xB0 {
    return Err("not an unsuback")
  }
  let r = ByteReader::new(data)
  match r.read_u16(2) {
    Ok((pid, _)) => Ok(pid)
    Err(e) => Err(e)
  }
}

test "encode_subscribe" {
  let pkt = { packet_id: 1, subscriptions: [{ topic: "a/#", qos: QoS::AtLeastOnce }] }
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

test "decode_suback" {
  match decode_suback([0x90, 0x04, 0x00, 0x07, 0x01, 0x80]) {
    Ok(s) => {
      assert_eq(s.packet_id, 7)
      assert_eq(s.codes, [SubAckCode::Success1, SubAckCode::Failure])
    }
    Err(e) => fail(e)
  }
  assert_true(match decode_suback([0x20, 0x02, 0x00, 0x00]) {
    Err(_) => true
    Ok(_) => false
  })
}

test "unsubscribe roundtrip" {
  let pkt = { packet_id: 3, topics: ["a/b", "c"] }
  let bytes = encode_unsubscribe(pkt)
  match decode_unsuback([0xB0, 0x02, 0x00, 0x03]) {
    Ok(pid) => assert_eq(pid, 3)
    Err(e) => fail(e)
  }
  assert_eq(bytes[0], 0xA2)
}

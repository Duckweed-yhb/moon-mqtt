/// PUBLISH 报文（3.1.1 §3.3）编解码，以及 QoS 1/2 握手控制包：
/// PUBACK(0x40)/PUBREC(0x50)/PUBREL(0x62)/PUBCOMP(0x70)。

/// PUBLISH 报文参数。packet_id 仅 QoS 1/2 需要。
pub struct PublishPacket {
  topic : String
  payload : Array[Int]
  qos : QoS
  retain : Bool
  dup : Bool
  packet_id : Int
}

/// 构造 PUBLISH 参数（供消费者在库外创建报文）。
pub fn PublishPacket::new(
  topic : String, payload : Array[Int], qos : QoS, retain : Bool, dup : Bool, packet_id : Int
) -> PublishPacket {
  return { topic, payload, qos, retain, dup, packet_id }
}

/// 返回一个仅改写报文标识的副本（发送侧分配 packet_id 后回填用）。
pub fn PublishPacket::with_packet_id(pkt : PublishPacket, packet_id : Int) -> PublishPacket {
  return { topic: pkt.topic, payload: pkt.payload, qos: pkt.qos, retain: pkt.retain, dup: pkt.dup, packet_id }
}

/// 返回一个仅改写 DUP 标记的副本（断线重连重放时置 DUP=1）。
pub fn PublishPacket::with_dup(pkt : PublishPacket, dup : Bool) -> PublishPacket {
  return { topic: pkt.topic, payload: pkt.payload, qos: pkt.qos, retain: pkt.retain, dup, packet_id: pkt.packet_id }
}

/// 编码 PUBLISH 为完整报文（含固定头）。
pub fn encode_publish(pkt : PublishPacket) -> Array[Int] {
  let body = ByteWriter::new()
  body.push_string(pkt.topic)
  if pkt.qos != QoS::AtMostOnce {
    body.push_u16(pkt.packet_id)
  }
  for b in pkt.payload {
    body.push_byte(b)
  }
  let mut flags = 0
  if pkt.retain {
    flags = flags | 0x01
  }
  flags = flags | ((qos_value(pkt.qos) << 1) & 0x06)
  if pkt.dup {
    flags = flags | 0x08
  }
  let out = ByteWriter::new()
  out.push_byte(0x30 | flags)
  out.push_remaining_length(body.bytes().length())
  for b in body.bytes() {
    out.push_byte(b)
  }
  return out.bytes()
}

/// 解码 PUBLISH。data 为完整报文（含固定头）。
pub fn decode_publish(data : Array[Int]) -> Result[PublishPacket, String] {
  if data.length() < 2 {
    return Err("publish too short")
  }
  let first = data[0]
  if (first >> 4) != 3 {
    return Err("not a publish")
  }
  let flags = first & 0x0F
  match qos_from_int((flags >> 1) & 0x03) {
    None => Err("publish bad qos")
    Some(q) => match decode_remaining_length(data, 1) {
      Err(e) => Err(e)
      Ok((rlen, p)) => {
        let end = p + rlen
        if end > data.length() {
          return Err("publish length exceeds data")
        }
        let r = ByteReader::new(data)
        match r.read_string(p) {
          Err(e) => Err(e)
          Ok((topic, p2)) => {
            let mut pos = p2
            let mut pid = 0
            if q != QoS::AtMostOnce {
              match r.read_u16(pos) {
                Err(e) => return Err(e)
                Ok((id, p3)) => {
                  pid = id
                  pos = p3
                }
              }
            }
            let payload : Array[Int] = []
            for i in pos..<end {
              payload.push(data[i])
            }
            Ok(
              {
                topic,
                payload,
                qos: q,
                retain: (flags & 0x01) != 0,
                dup: (flags & 0x08) != 0,
                packet_id: pid,
              },
            )
          }
        }
      }
    }
  }
}

/// 编码仅含 packet_id 的 QoS 控制包（PUBACK/PUBREC/PUBREL/PUBCOMP）。
pub fn encode_packet_id(type_byte : Int, packet_id : Int) -> Array[Int] {
  let out = ByteWriter::new()
  out.push_byte(type_byte)
  out.push_remaining_length(2)
  out.push_u16(packet_id)
  return out.bytes()
}

pub fn encode_puback(packet_id : Int) -> Array[Int] {
  return encode_packet_id(0x40, packet_id)
}

pub fn encode_pubrec(packet_id : Int) -> Array[Int] {
  return encode_packet_id(0x50, packet_id)
}

pub fn encode_pubrel(packet_id : Int) -> Array[Int] {
  return encode_packet_id(0x62, packet_id)
}

pub fn encode_pubcomp(packet_id : Int) -> Array[Int] {
  return encode_packet_id(0x70, packet_id)
}

/// 解码 QoS 控制包，取出 packet_id。
pub fn decode_packet_id(data : Array[Int], type_byte : Int) -> Result[Int, String] {
  if data.length() < 4 {
    return Err("packet id packet too short")
  }
  if data[0] != type_byte {
    return Err("packet id type mismatch")
  }
  let r = ByteReader::new(data)
  match r.read_u16(2) {
    Ok((id, _)) => Ok(id)
    Err(e) => Err(e)
  }
}

test "encode_publish qos0" {
  let pkt = { topic: "a/b", payload: [0x01, 0x02, 0x03], qos: QoS::AtMostOnce, retain: false, dup: false, packet_id: 0 }
  let bytes = encode_publish(pkt)
  // body: topic "a/b"(00 02 61 2F 62)=5 + payload 01 02 03=3 → rlen=8
  assert_eq(bytes[0], 0x30)
  assert_eq(bytes[1], 8)
  assert_eq(bytes[2], 0x00)
  assert_eq(bytes[3], 0x03) // "a/b" 长度 = 3
  assert_eq(bytes[4], 0x61) // 'a'
  assert_eq(bytes[5], 0x2F) // '/'
  assert_eq(bytes[6], 0x62) // 'b'
  assert_eq(bytes[7], 0x01)
  assert_eq(bytes[8], 0x02)
  assert_eq(bytes[9], 0x03)
}

test "encode_publish qos1 with packet id" {
  let pkt = { topic: "t", payload: [0x00], qos: QoS::AtLeastOnce, retain: false, dup: false, packet_id: 7 }
  let bytes = encode_publish(pkt)
  // 0x32 (qos1 flag=0x02)
  assert_eq(bytes[0], 0x32)
  // body: topic(00 01 74)=3 + pid(00 07)=2 + payload(00)=1 → 6
  assert_eq(bytes[1], 6)
  assert_eq(bytes[2], 0x00)
  assert_eq(bytes[3], 0x01)
  assert_eq(bytes[4], 0x74) // 't'
  assert_eq(bytes[5], 0x00)
  assert_eq(bytes[6], 0x07) // packet_id
  assert_eq(bytes[7], 0x00) // payload
}

test "publish roundtrip" {
  let pkt = { topic: "dev/1/status", payload: [0xAB, 0xCD], qos: QoS::ExactlyOnce, retain: true, dup: false, packet_id: 42 }
  let bytes = encode_publish(pkt)
  match decode_publish(bytes) {
    Ok(d) => {
      assert_eq(d.topic, "dev/1/status")
      assert_eq(d.payload, [0xAB, 0xCD])
      assert_eq(d.qos, QoS::ExactlyOnce)
      assert_eq(d.retain, true)
      assert_eq(d.dup, false)
      assert_eq(d.packet_id, 42)
    }
    Err(e) => fail(e)
  }
}

test "decode_publish bad type" {
  assert_true(match decode_publish([0x20, 0x02, 0x00, 0x00]) {
    Err(_) => true
    Ok(_) => false
  })
}

test "qos control packets" {
  // QoS1: PUBLISH → PUBACK
  assert_eq(encode_puback(5), [0x40, 0x02, 0x00, 0x05])
  assert_eq(encode_pubrec(5), [0x50, 0x02, 0x00, 0x05])
  assert_eq(encode_pubrel(5), [0x62, 0x02, 0x00, 0x05])
  assert_eq(encode_pubcomp(5), [0x70, 0x02, 0x00, 0x05])

  match decode_packet_id(encode_pubrec(5), 0x50) {
    Ok(id) => assert_eq(id, 5)
    Err(e) => fail(e)
  }
  assert_true(match decode_packet_id(encode_pubrec(5), 0x62) {
    Err(_) => true
    Ok(_) => false
  })
}

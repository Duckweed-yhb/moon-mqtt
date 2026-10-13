/// 统一入站报文分发：根据固定头类型字节把完整报文解到具体类型。
/// 客户端 session/transport 层通过 decode_packet 统一接收服务端报文。

pub enum IncomingPacket {
  Connack(Connack)
  Publish(PublishPacket)
  Puback(Int)
  Pubrec(Int)
  Pubrel(Int)
  Pubcomp(Int)
  Suback(Suback)
  Unsuback(Int)
  PingResp
}

/// 解码一个完整入站报文（含固定头）到 IncomingPacket。
pub fn decode_packet(data : Array[Int]) -> Result[IncomingPacket, String] {
  if data.length() < 2 {
    return Err("packet too short")
  }
  let t = data[0] >> 4
  match t {
    2 => match decode_connack(data) {
      Ok(c) => Ok(IncomingPacket::Connack(c))
      Err(e) => Err(e)
    }
    3 => match decode_publish(data) {
      Ok(p) => Ok(IncomingPacket::Publish(p))
      Err(e) => Err(e)
    }
    4 => match decode_packet_id(data, 0x40) {
      Ok(id) => Ok(IncomingPacket::Puback(id))
      Err(e) => Err(e)
    }
    5 => match decode_packet_id(data, 0x50) {
      Ok(id) => Ok(IncomingPacket::Pubrec(id))
      Err(e) => Err(e)
    }
    6 => match decode_packet_id(data, 0x62) {
      Ok(id) => Ok(IncomingPacket::Pubrel(id))
      Err(e) => Err(e)
    }
    7 => match decode_packet_id(data, 0x70) {
      Ok(id) => Ok(IncomingPacket::Pubcomp(id))
      Err(e) => Err(e)
    }
    9 => match decode_suback(data) {
      Ok(s) => Ok(IncomingPacket::Suback(s))
      Err(e) => Err(e)
    }
    11 => match decode_unsuback(data) {
      Ok(id) => Ok(IncomingPacket::Unsuback(id))
      Err(e) => Err(e)
    }
    13 => Ok(IncomingPacket::PingResp)
    _ => Err("unsupported incoming packet type " + t.to_string())
  }
}

test "decode_packet dispatch" {
  // CONNACK
  match decode_packet([0x20, 0x02, 0x00, 0x00]) {
    Ok(IncomingPacket::Connack(_)) => ()
    _ => fail("expected connack")
  }
  // PUBLISH
  match decode_packet([0x30, 0x07, 0x00, 0x03, 0x61, 0x2F, 0x62, 0x01, 0x02, 0x03]) {
    Ok(IncomingPacket::Publish(p)) => assert_eq(p.topic, "a/b")
    _ => fail("expected publish")
  }
  // PUBREC
  match decode_packet([0x50, 0x02, 0x00, 0x05]) {
    Ok(IncomingPacket::Pubrec(id)) => assert_eq(id, 5)
    _ => fail("expected pubrec")
  }
  // SUBACK
  match decode_packet([0x90, 0x04, 0x00, 0x07, 0x01, 0x80]) {
    Ok(IncomingPacket::Suback(s)) => assert_eq(s.packet_id, 7)
    _ => fail("expected suback")
  }
  // PINGRESP
  match decode_packet([0xD0, 0x00]) {
    Ok(IncomingPacket::PingResp) => ()
    _ => fail("expected pingresp")
  }
}

test "decode_packet unsupported" {
  assert_true(match decode_packet([0x0E, 0x00]) {
    Err(_) => true
    Ok(_) => false
  })
}

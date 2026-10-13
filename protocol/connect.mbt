/// CONNECT 报文（3.1.1 §3.1）编码与 CONNACK 应答（§3.2）解码。

/// 客户端发起连接参数。
pub struct ConnectPacket {
  client_id : String
  keep_alive : Int
  clean_session : Bool
  username : String?
  password : Array[Int]?
  will_topic : String?
  will_message : Array[Int]?
  will_qos : QoS
  will_retain : Bool
}

/// 最小 CONNECT 参数：默认 keep_alive=60、clean_session=true、无认证无遗嘱。
pub fn ConnectPacket::new(client_id : String) -> ConnectPacket {
  return {
    client_id,
    keep_alive: 60,
    clean_session: true,
    username: None,
    password: None,
    will_topic: None,
    will_message: None,
    will_qos: QoS::AtMostOnce,
    will_retain: false
  }
}

/// 把 CONNECT 编码为完整报文（含固定头）。
pub fn encode_connect(pkt : ConnectPacket) -> Array[Int] {
  // 可变头：协议名 + 级别 + 连接标志 + 保持连接
  let vh = ByteWriter::new()
  vh.push_string("MQTT")
  vh.push_byte(4) // protocol level 3.1.1
  let mut flags = 0
  if pkt.clean_session {
    flags = flags | 0x02
  }
  match pkt.username {
    Some(_) => flags = flags | 0x80
    None => ()
  }
  match pkt.password {
    Some(_) => flags = flags | 0x40
    None => ()
  }
  match pkt.will_topic {
    Some(_) => {
      flags = flags | 0x04
      if pkt.will_retain {
        flags = flags | 0x20
      }
      flags = flags | ((qos_value(pkt.will_qos) << 3) & 0x18)
    }
    None => ()
  }
  vh.push_byte(flags)
  vh.push_u16(pkt.keep_alive)

  // 载荷：clientId, will topic+message, username, password（按标志位顺序）
  let pl = ByteWriter::new()
  pl.push_string(pkt.client_id)
  match pkt.will_topic {
    Some(t) => {
      pl.push_string(t)
      match pkt.will_message {
        Some(m) => pl.push_binary(m)
        None => pl.push_binary([])
      }
    }
    None => ()
  }
  match pkt.username {
    Some(u) => pl.push_string(u)
    None => ()
  }
  match pkt.password {
    Some(p) => pl.push_binary(p)
    None => ()
  }

  // 组装
  let body = ByteWriter::new()
  for b in vh.bytes() {
    body.push_byte(b)
  }
  for b in pl.bytes() {
    body.push_byte(b)
  }
  let out = ByteWriter::new()
  out.push_byte(0x10)
  out.push_remaining_length(body.bytes().length())
  for b in body.bytes() {
    out.push_byte(b)
  }
  return out.bytes()
}

/// CONNACK 返回码（3.1.1 §3.2.2.3）。
pub enum ConnectReturnCode {
  ConnectionAccepted
  UnacceptableProtocolVersion
  IdentifierRejected
  ServerUnavailable
  BadUsernameOrPassword
  NotAuthorized
} derive(Eq, Debug)

pub extend ConnectReturnCode with Eq::{not_equal, equal}
pub extend ConnectReturnCode with @moonbitlang/core/debug.Debug::{to_repr}

/// 返回码字节值到枚举；未知值返回 None。
pub fn return_code_from_int(v : Int) -> Option[ConnectReturnCode] {
  match v {
    0 => Some(ConnectReturnCode::ConnectionAccepted)
    1 => Some(ConnectReturnCode::UnacceptableProtocolVersion)
    2 => Some(ConnectReturnCode::IdentifierRejected)
    3 => Some(ConnectReturnCode::ServerUnavailable)
    4 => Some(ConnectReturnCode::BadUsernameOrPassword)
    5 => Some(ConnectReturnCode::NotAuthorized)
    _ => None
  }
}

/// 解码后的 CONNACK。
pub struct Connack {
  session_present : Bool
  return_code : ConnectReturnCode
}

/// 解码 CONNACK。data 为完整报文（含固定头）。
pub fn decode_connack(data : Array[Int]) -> Result[Connack, String] {
  if data.length() < 4 {
    return Err("connack too short")
  }
  if data[0] != 0x20 {
    return Err("not a connack")
  }
  if data[1] != 2 {
    return Err("connack remaining length != 2")
  }
  let ack_flags = data[2]
  let session_present = (ack_flags & 0x01) == 1
  match return_code_from_int(data[3]) {
    Some(rc) => Ok({ session_present, return_code: rc })
    None => Err("unknown connack return code")
  }
}

test "encode_connect minimal" {
  let pkt = ConnectPacket::new("client-1")
  let bytes = encode_connect(pkt)
  assert_eq(
    bytes,
    [
      0x10, 0x14, 0x00, 0x04, 0x4D, 0x51, 0x54, 0x54, 0x04, 0x02, 0x00, 0x3C, 0x00,
      0x08, 0x63, 0x6C, 0x69, 0x65, 0x6E, 0x74, 0x2D, 0x31,
    ],
  )
}

test "encode_connect with auth and will" {
  let pkt = {
    client_id: "c2",
    keep_alive: 30,
    clean_session: false,
    username: Some("u1"),
    password: Some([0x01, 0x02]),
    will_topic: Some("w/t"),
    will_message: Some([0xAA]),
    will_qos: QoS::AtLeastOnce,
    will_retain: true
  }
  let bytes = encode_connect(pkt)
  // 固定头 0x10 + 剩余长度 + 可变头 + 载荷
  assert_eq(bytes[0], 0x10)
  let flags = bytes[9]
  // clean=0, username(0x80) + password(0x40) + will(0x04) + will retain(0x20) + will qos=1(0x08)
  assert_eq(flags, 0x80 | 0x40 | 0x04 | 0x20 | 0x08)
}

test "decode_connack accepted" {
  match decode_connack([0x20, 0x02, 0x00, 0x00]) {
    Ok(c) => {
      assert_eq(c.session_present, false)
      assert_eq(c.return_code, ConnectReturnCode::ConnectionAccepted)
    }
    Err(e) => fail(e)
  }
}

test "decode_connack session present" {
  match decode_connack([0x20, 0x02, 0x01, 0x00]) {
    Ok(c) => {
      assert_eq(c.session_present, true)
      assert_eq(c.return_code, ConnectReturnCode::ConnectionAccepted)
    }
    Err(e) => fail(e)
  }
}

test "decode_connack bad credentials" {
  match decode_connack([0x20, 0x02, 0x00, 0x04]) {
    Ok(c) => assert_eq(c.return_code, ConnectReturnCode::BadUsernameOrPassword)
    Err(e) => fail(e)
  }
}

test "decode_connack invalid" {
  assert_true(match decode_connack([0x10, 0x02, 0x00, 0x00]) {
    Err(_) => true
    Ok(_) => false
  })
}

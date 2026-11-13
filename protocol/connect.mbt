/// CONNECT 报文（3.1.1 §3.1）编码与 CONNACK 应答（§3.2）解码。

///|
/// 客户端发起连接参数。
pub struct ConnectPacket {
  client_id : String
  keep_alive : Int32
  clean_session : Bool
  username : String?
  password : Array[Int32]?
  will_topic : String?
  will_message : Array[Int32]?
  will_qos : QoS
  will_retain : Bool
}

///|
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
    will_retain: false,
  }
}

///|
/// 设置 keep_alive（秒，0 = 不发 PINGREQ）。
pub fn ConnectPacket::with_keep_alive(
  self : ConnectPacket,
  secs : Int32,
) -> ConnectPacket {
  { ..self, keep_alive: secs, }
}

///|
/// 设置 clean_session。false = 让 broker 保留同名 client_id 的会话。
pub fn ConnectPacket::with_clean_session(
  self : ConnectPacket,
  v : Bool,
) -> ConnectPacket {
  { ..self, clean_session: v, }
}

///|
/// 设置用户名密码（两者必须同时给或同时 None）。
pub fn ConnectPacket::with_auth(
  self : ConnectPacket,
  user : String,
  pass : Array[Int32],
) -> ConnectPacket {
  { ..self, username: Some(user), password: Some(pass), }
}

///|
/// 设置遗嘱（Will）：连接异常掉线时 broker 会向 will_topic 发 will_message。
/// qos / retain 同 PUBLISH 语义。
pub fn ConnectPacket::with_will(
  self : ConnectPacket,
  topic : String,
  msg : Array[Int32],
  qos : QoS,
  retain : Bool,
) -> ConnectPacket {
  {
    ..self,
    will_topic: Some(topic),
    will_message: Some(msg),
    will_qos: qos,
    will_retain: retain,
  }
}

///|
/// 把 CONNECT 编码为完整报文（含固定头）。
///
/// §3.1.3.1：client_id 为空时 clean_session 必须为 1，否则 broker 必须回
/// IdentifierRejected。这一条在编码侧先拒，别把一次注定失败的握手发出去。
pub fn encode_connect(pkt : ConnectPacket) -> Array[Int32] {
  if pkt.client_id == "" && !pkt.clean_session {
    abort("mqtt: empty client id requires clean_session=true")
  }
  // §3.1.2.11 [MQTT-3.1.2-12]：Password 标志置 1 时 User Name 标志必须置 1；
  // 反过来 §3.1.2.10 规定 User Name 为 0 时 Password 必须为 0。公开结构体可以
  // 绕过 with_auth 直接拼出「有密码没用户名」，编码侧先挡下，不把必然被 broker
  // 当协议错误断连的帧编出去。
  match (pkt.username, pkt.password) {
    (None, Some(_)) =>
      abort("mqtt: password requires username (§3.1.2.11)")
    _ => ()
  }
  // §3.1.2.9：Will Message 标志只在 Will Topic 标志存在时才有意义；
  // 反过来「有遗嘱消息没遗嘱主题」是单侧不一致，编码侧先挡下。
  match (pkt.will_topic, pkt.will_message) {
    (None, Some(_)) =>
      abort("mqtt: will message requires will topic (§3.1.2.9)")
    _ => ()
  }
  // 遗嘱主题本质是一条 PUBLISH topic name，通配符 / NUL / 超长同样不允许。
  match pkt.will_topic {
    Some(t) =>
      match validate_topic_name(t) {
        Ok(_) => ()
        Err(e) => abort("mqtt: invalid will topic: " + e)
      }
    None => ()
  }
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

///|
/// CONNACK 返回码（3.1.1 §3.2.2.3）。
#derive(Eq, Debug)
pub enum ConnectReturnCode {
  ConnectionAccepted
  UnacceptableProtocolVersion
  IdentifierRejected
  ServerUnavailable
  BadUsernameOrPassword
  NotAuthorized
}

///|
pub extend ConnectReturnCode with Eq::{not_equal, equal}

///|
pub extend ConnectReturnCode with @moonbitlang/core/debug.Debug::{to_repr}

///|
/// 返回码字节值到枚举；未知值返回 None。
pub fn return_code_from_int(v : Int32) -> ConnectReturnCode? {
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

///|
/// 解码后的 CONNACK。
pub struct Connack {
  session_present : Bool
  return_code : ConnectReturnCode
}

///|
/// 解码 CONNACK。data 为完整报文（含固定头）。
pub fn decode_connack(data : Array[Int32]) -> Result[Connack, String] {
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
  // §3.2.2.1：acknowledge flags 的 bit 7-1 是保留位，必须为 0。
  if (ack_flags & 0xFE) != 0 {
    return Err("connack reserved flags must be zero")
  }
  let session_present = (ack_flags & 0x01) == 1
  match return_code_from_int(data[3]) {
    Some(rc) => {
      // §3.2.2.1.2：连接被拒时 session present 必须为 0。
      match rc {
        ConnectReturnCode::ConnectionAccepted => ()
        _ =>
          if session_present {
            return Err(
              "connack session present must be 0 when the connection is refused",
            )
          }
      }
      Ok({ session_present, return_code: rc, })
    }
    None => Err("unknown connack return code")
  }
}

///|
test "encode_connect minimal" {
  let pkt = ConnectPacket::new("client-1")
  let bytes = encode_connect(pkt)
  assert_eq(bytes, [
    0x10, 0x14, 0x00, 0x04, 0x4D, 0x51, 0x54, 0x54, 0x04, 0x02, 0x00, 0x3C, 0x00,
    0x08, 0x63, 0x6C, 0x69, 0x65, 0x6E, 0x74, 0x2D, 0x31,
  ])
}

///|
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
    will_retain: true,
  }
  let bytes = encode_connect(pkt)
  // 固定头 0x10 + 剩余长度 + 可变头 + 载荷
  assert_eq(bytes[0], 0x10)
  let flags = bytes[9]
  // clean=0, username(0x80) + password(0x40) + will(0x04) + will retain(0x20) + will qos=1(0x08)
  assert_eq(flags, 0x80 | 0x40 | 0x04 | 0x20 | 0x08)
}

///|
/// 只有用户名、不带密码是规范允许的组合：User Name 标志 0x80 置位，
/// Password 标志 0x40 不置位；反过来「有密码没用户名」在编码侧直接 abort。
test "encode_connect username without password" {
  let pkt = {
    client_id: "c3",
    keep_alive: 60,
    clean_session: true,
    username: Some("u1"),
    password: None,
    will_topic: None,
    will_message: None,
    will_qos: QoS::AtMostOnce,
    will_retain: false,
  }
  let bytes = encode_connect(pkt)
  assert_eq(bytes[9], 0x80 | 0x02)
}

///|
test "decode_connack accepted" {
  match decode_connack([0x20, 0x02, 0x00, 0x00]) {
    Ok(c) => {
      assert_eq(c.session_present, false)
      assert_eq(c.return_code, ConnectReturnCode::ConnectionAccepted)
    }
    Err(e) => fail(e)
  }
}

///|
test "decode_connack session present" {
  match decode_connack([0x20, 0x02, 0x01, 0x00]) {
    Ok(c) => {
      assert_eq(c.session_present, true)
      assert_eq(c.return_code, ConnectReturnCode::ConnectionAccepted)
    }
    Err(e) => fail(e)
  }
}

///|
test "decode_connack bad credentials" {
  match decode_connack([0x20, 0x02, 0x00, 0x04]) {
    Ok(c) => assert_eq(c.return_code, ConnectReturnCode::BadUsernameOrPassword)
    Err(e) => fail(e)
  }
}

///|
test "decode_connack invalid" {
  assert_true(
    match decode_connack([0x10, 0x02, 0x00, 0x00]) {
      Err(_) => true
      Ok(_) => false
    },
  )
}

///|
/// CONNACK 的保留位必须为 0（§3.2.2.1），旧实现只读 bit0。
test "connack rejects reserved flags" {
  match decode_connack([0x20, 0x02, 0x02, 0x00]) {
    Ok(_) => fail("reserved flags must be rejected")
    Err(e) => assert_true(e.contains("reserved"))
  }
  // 正常的接受帧仍然通过
  match decode_connack([0x20, 0x02, 0x01, 0x00]) {
    Ok(c) => assert_true(c.session_present)
    Err(e) => fail(e)
  }
}

///|
/// 连接被拒时 session present 必须为 0（§3.2.2.1.2）。
test "connack rejects session present on a refused connection" {
  match decode_connack([0x20, 0x02, 0x01, 0x05]) {
    Ok(_) => fail("session_present=1 with refusal must be rejected")
    Err(e) => assert_true(e.contains("session present"))
  }
  // 被拒且 session_present=0 是合法的
  match decode_connack([0x20, 0x02, 0x00, 0x05]) {
    Ok(c) => assert_true(c.return_code == ConnectReturnCode::NotAuthorized)
    Err(e) => fail(e)
  }
}

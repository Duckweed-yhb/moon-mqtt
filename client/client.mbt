/// MQTT 高层客户端（阻塞式，native）。
///
/// 用 `protocol`（报文编解码）+ `session`（QoS2 状态机）+ `transport`
/// （原生 TCP）组装：`connect` → `publish` / `subscribe` / `ping` →
/// `disconnect`。单线程阻塞式，适合 CLI / 边缘遥测上报等确定性场景。

/// MQTT 客户端。`next_id` 是可变报文标识计数器（单元素数组，会话内不重复）。
pub struct MqttClient {
  tcp : @transport.TcpClient
  client_id : String
  keep_alive : Int
  connected : Bool
  next_id : Array[Int]
}

/// 用默认参数连接（keep_alive=60、clean_session=true、无认证）。
pub fn connect(
  host : String, port : Int, client_id : String
) -> Result[MqttClient, String] {
  connect_opts(host, port, @protocol.ConnectPacket::new(client_id))
}

/// 用自定义 CONNECT 参数连接，握手 CONNACK 通过后返回已连接客户端。
/// 任何失败路径都会关闭已建立的 TCP 连接，避免 fd 泄漏。
pub fn connect_opts(
  host : String, port : Int, pkt : @protocol.ConnectPacket
) -> Result[MqttClient, String] {
  let tcp = match @transport.connect(host, port) {
    Ok(t) => t
    Err(e) => return Err(e)
  }
  // 发 CONNECT
  match tcp.write(@protocol.encode_connect(pkt)) {
    Err(e) => {
      tcp.close()
      return Err(e)
    }
    Ok(_) => ()
  }
  // 读 CONNACK
  let connack = match read_frame(tcp) {
    Ok(bytes) => match @protocol.decode_packet(bytes) {
      Ok(@protocol.IncomingPacket::Connack(c)) => c
      Ok(_) => {
        tcp.close()
        return Err("expected CONNACK")
      }
      Err(e) => {
        tcp.close()
        return Err(e)
      }
    }
    Err(e) => {
      tcp.close()
      return Err(e)
    }
  }
  match connack.return_code {
    @protocol.ConnectReturnCode::ConnectionAccepted => ()
    code => {
      tcp.close()
      return Err("CONNACK refused: " + return_code_desc(code))
    }
  }
  return Ok(
    {
      tcp,
      client_id: pkt.client_id,
      keep_alive: pkt.keep_alive,
      connected: true,
      next_id: [1],
    },
  )
}

/// 发送 PUBLISH。QoS 语义：
/// - QoS0：直发；
/// - QoS1：等 PUBACK；
/// - QoS2：走 PUBREC → PUBREL → PUBCOMP 三段握手（exactly-once）。
pub fn MqttClient::publish(
  self : MqttClient, topic : String, payload : Array[Int], qos : @protocol.QoS
) -> Result[Unit, String] {
  let pid = self.alloc_id()
  let pkt = @protocol.PublishPacket::new(topic, payload, qos, false, false, pid)
  match self.tcp.write(@protocol.encode_publish(pkt)) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  match qos {
    @protocol.QoS::AtMostOnce => return Ok(())
    @protocol.QoS::AtLeastOnce =>
      match self.read_packet() {
        Ok(@protocol.IncomingPacket::Puback(id)) if id == pid => Ok(())
        Ok(@protocol.IncomingPacket::Puback(_)) => Err("PUBACK id mismatch")
        Ok(_) => Err("expected PUBACK")
        Err(e) => Err(e)
      }
    @protocol.QoS::ExactlyOnce => {
      match self.read_packet() {
        Ok(@protocol.IncomingPacket::Pubrec(id)) if id == pid =>
          match @session.qos2_on_pubrec(@session.qos2_send_started(), id) {
            (_, pubrel) => match self.tcp.write(pubrel) {
              Err(e) => return Err(e)
              Ok(_) => ()
            }
          }
        Ok(@protocol.IncomingPacket::Pubrec(_)) => return Err("PUBREC id mismatch")
        Ok(_) => return Err("expected PUBREC")
        Err(e) => return Err(e)
      }
      match self.read_packet() {
        Ok(@protocol.IncomingPacket::Pubcomp(id)) if id == pid => Ok(())
        Ok(@protocol.IncomingPacket::Pubcomp(_)) => Err("PUBCOMP id mismatch")
        Ok(_) => Err("expected PUBCOMP")
        Err(e) => Err(e)
      }
    }
  }
}

/// 订阅一个主题过滤器，等 SUBACK 确认。
pub fn MqttClient::subscribe(
  self : MqttClient, topic : String, qos : @protocol.QoS
) -> Result[Unit, String] {
  let pid = self.alloc_id()
  let subs = [@protocol.Subscription::new(topic, qos)]
  let pkt = @protocol.SubscribePacket::new(pid, subs)
  match self.tcp.write(@protocol.encode_subscribe(pkt)) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  match self.read_packet() {
    Ok(@protocol.IncomingPacket::Suback(s)) if s.packet_id == pid => Ok(())
    Ok(@protocol.IncomingPacket::Suback(_)) => Err("SUBACK id mismatch")
    Ok(_) => Err("expected SUBACK")
    Err(e) => Err(e)
  }
}

/// 发送 PINGREQ 并等 PINGRESP（保活）。
pub fn MqttClient::ping(self : MqttClient) -> Result[Unit, String] {
  match self.tcp.write(@protocol.encode_pingreq()) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  match self.read_packet() {
    Ok(@protocol.IncomingPacket::PingResp) => Ok(())
    Ok(_) => Err("expected PINGRESP")
    Err(e) => Err(e)
  }
}

/// 发送 DISCONNECT 并关闭连接。写失败时也强制关闭 socket，避免 fd 泄漏。
pub fn MqttClient::disconnect(self : MqttClient) -> Result[Unit, String] {
  let res = match self.tcp.write(@protocol.encode_disconnect()) {
    Err(e) => Err(e)
    Ok(_) => Ok(())
  }
  self.tcp.close()
  return res
}

/// 读一个入站报文并解码。
pub fn MqttClient::read_packet(
  self : MqttClient
) -> Result[@protocol.IncomingPacket, String] {
  match read_frame(self.tcp) {
    Ok(bytes) => @protocol.decode_packet(bytes)
    Err(e) => Err(e)
  }
}

/// 分配报文标识（1..65535 循环，会话内不重复）。
fn MqttClient::alloc_id(self : MqttClient) -> Int {
  let id = self.next_id[0]
  let nid = if id >= 0xFFFF { 1 } else { id + 1 }
  self.next_id[0] = nid
  return id
}

// ---------- 内部 ----------

/// CONNACK 返回码的人类可读描述。
fn return_code_desc(code : @protocol.ConnectReturnCode) -> String {
  match code {
    @protocol.ConnectReturnCode::ConnectionAccepted => "accepted"
    @protocol.ConnectReturnCode::UnacceptableProtocolVersion =>
      "unacceptable protocol version"
    @protocol.ConnectReturnCode::IdentifierRejected => "identifier rejected"
    @protocol.ConnectReturnCode::ServerUnavailable => "server unavailable"
    @protocol.ConnectReturnCode::BadUsernameOrPassword =>
      "bad username or password"
    @protocol.ConnectReturnCode::NotAuthorized => "not authorized"
  }
}

/// 从 TCP 读一帧 MQTT 报文：首字节 + 剩余长度变长 + 剩余字节。
fn read_frame(tcp : @transport.TcpClient) -> Result[Array[Int], String] {
  let frame : Array[Int] = []
  // 首字节
  match read_byte(tcp) {
    Ok(b) => frame.push(b)
    Err(e) => return Err(e)
  }
  // 剩余长度（最多 4 字节）
  let mut rlen = 0
  let mut mult = 1
  let mut cont = true
  while cont {
    let b = match read_byte(tcp) {
      Ok(x) => x
      Err(e) => return Err(e)
    }
    frame.push(b)
    rlen = rlen + ((b & 0x7F) * mult)
    if (b & 0x80) == 0 {
      cont = false
    } else {
      mult = mult * 128
      if mult > 128 * 128 * 128 {
        return Err("remaining length overflow")
      }
    }
  }
  // 读够 rlen 字节
  let mut got = 0
  while got < rlen {
    let need = rlen - got
    match tcp.read_some(need) {
      Ok(chunk) if chunk.length() > 0 => {
        for b in chunk {
          frame.push(b)
        }
        got = got + chunk.length()
      }
      Ok(_) => return Err("EOF in payload")
      Err(e) => return Err(e)
    }
  }
  return Ok(frame)
}

/// 读单字节。
fn read_byte(tcp : @transport.TcpClient) -> Result[Int, String] {
  match tcp.read_some(1) {
    Ok(b) if b.length() > 0 => Ok(b[0])
    Ok(_) => Err("EOF")
    Err(e) => Err(e)
  }
}

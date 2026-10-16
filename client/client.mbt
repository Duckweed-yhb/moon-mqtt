/// MQTT 高层客户端（阻塞式，native）。
///
/// 用 `protocol`（报文编解码）+ `session`（QoS2 状态机 + 持久会话在途存储）
/// + `transport`（原生 TCP）组装：`connect` → `publish` / `subscribe` /
/// `ping` → `disconnect`。单线程阻塞式，适合 CLI / 边缘遥测上报等确定性场景。
///
/// 会话状态：`store` 是 `Array[SessionStore]` 单元素 workaround。每个
/// publish 都会在 store 里记录在途 QoS1/2 PUBLISH，等 PUBACK/PUBREC/
/// PUBCOMP 后推进状态；断线后调用 `replay_frames()` 可拿到待重放帧序列，
/// 用于实现 clean_session=false 的会话恢复。

/// 一条本地订阅注册：topic filter + 收到 PUBLISH 时的回调。
/// 回调参数是 (topic, payload)，QoS 由入站 PUBLISH 帧自带。
type SubHandler = (String, Array[Int]) -> Unit

struct SubscriptionReg {
  filter : String
  handler : SubHandler
}

/// MQTT 客户端。
pub struct MqttClient {
  tcp : @transport.TcpClient
  client_id : String
  keep_alive : Int
  store : Array[@session.SessionStore]
  /// CONNACK 返回的 session_present 标志（MQTT §3.2.2.3）。
  /// false 表示 broker 上没有保留的会话，本地 inflight 已被清空。
  session_present : Array[Bool]
  /// 本地订阅注册表：poll() 收到 PUBLISH 时按 topic filter 匹配并派发。
  subs : Array[SubscriptionReg]
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
  // MQTT §3.2.2.3：session_present=false 表示 broker 没有保留会话。
  // 首次连接 store 本来就是空；重连场景下调用方应在重连前用
  // set_session_store() 把旧 store 塞回来，再依据 is_session_present()
  // 决定是否 replay()。
  return Ok(
    {
      tcp,
      client_id: pkt.client_id,
      keep_alive: pkt.keep_alive,
      store: [@session.SessionStore::new()],
      session_present: [connack.session_present],
      subs: [],
    },
  )
}

/// 返回上次 CONNACK 的 session_present 标志（MQTT §3.2.2.3）。
/// true = broker 保留了同名 client_id 的会话，可调用 `replay_frames()`
/// 重发在途报文；false = broker 上无保留会话，replay 无意义。
pub fn MqttClient::is_session_present(self : MqttClient) -> Bool {
  return self.session_present[0]
}

/// 替换内部 SessionStore（用于断线重连场景：把旧 client 的 store
/// 快照塞回新建的 client，再依据 `is_session_present()` 决定是否 replay）。
pub fn MqttClient::set_session_store(self : MqttClient, store : @session.SessionStore) -> Unit {
  self.store[0] = store
}

/// 发送 PUBLISH。QoS 语义：
/// - QoS0：直发；
/// - QoS1：记录在途 → 发 PUBLISH → 等 PUBACK → 从在途清除；
/// - QoS2：记录在途 → 发 PUBLISH → 等 PUBREC（推进到 WaitPubcomp）→
///   发 PUBREL → 等 PUBCOMP → 从在途清除（exactly-once）。
///
/// 在途报文由 `store` 持久化；断线后 `replay_frames()` 可拿到待重放帧。
pub fn MqttClient::publish(
  self : MqttClient, topic : String, payload : Array[Int], qos : @protocol.QoS
) -> Result[Unit, String] {
  // 用不带 pid 的种子报文让 store 分配并记录在途
  let seed = @protocol.PublishPacket::new(topic, payload, qos, false, false, 0)
  let (s0, pid) = @session.record_outbound(self.store[0], seed)
  self.store[0] = s0
  let need_id = match qos {
    @protocol.QoS::AtMostOnce => false
    _ => true
  }
  if pid == 0 && need_id {
    return Err("out of packet ids")
  }
  let pkt = if pid == 0 { seed } else { seed.with_packet_id(pid) }
  match self.tcp.write(@protocol.encode_publish(pkt)) {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  match qos {
    @protocol.QoS::AtMostOnce => return Ok(())
    @protocol.QoS::AtLeastOnce =>
      match self.read_packet() {
        Ok(@protocol.IncomingPacket::Puback(id)) if id == pid => {
          self.store[0] = @session.on_puback(self.store[0], pid)
          Ok(())
        }
        Ok(@protocol.IncomingPacket::Puback(_)) => Err("PUBACK id mismatch")
        Ok(_) => Err("expected PUBACK")
        Err(e) => Err(e)
      }
    @protocol.QoS::ExactlyOnce => {
      match self.read_packet() {
        Ok(@protocol.IncomingPacket::Pubrec(id)) if id == pid => {
          let (s1, pubrel) = @session.on_pubrec(self.store[0], pid)
          self.store[0] = s1
          match self.tcp.write(pubrel) {
            Err(e) => return Err(e)
            Ok(_) => ()
          }
        }
        Ok(@protocol.IncomingPacket::Pubrec(_)) => return Err("PUBREC id mismatch")
        Ok(_) => return Err("expected PUBREC")
        Err(e) => return Err(e)
      }
      match self.read_packet() {
        Ok(@protocol.IncomingPacket::Pubcomp(id)) if id == pid => {
          self.store[0] = @session.on_pubcomp(self.store[0], pid)
          Ok(())
        }
        Ok(@protocol.IncomingPacket::Pubcomp(_)) => Err("PUBCOMP id mismatch")
        Ok(_) => Err("expected PUBCOMP")
        Err(e) => Err(e)
      }
    }
  }
}

/// 订阅一个主题过滤器，等 SUBACK 确认。SUBSCRIBE 的 packet_id 从 store
/// 分配（与 PUBLISH 共享 id 空间），但不入 inflight（同步握手完成即释放）。
pub fn MqttClient::subscribe(
  self : MqttClient, topic : String, qos : @protocol.QoS
) -> Result[Unit, String] {
  let (s0, pid) = @session.alloc_control_packet_id(self.store[0])
  self.store[0] = s0
  if pid == 0 {
    return Err("out of packet ids")
  }
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

/// 订阅并注册回调：发 SUBSCRIBE 等 SUBACK，成功后把 (filter, handler)
/// 存进本地注册表。之后调 `poll_once()` 收到匹配的 PUBLISH 时会逐个调用
/// handler(topic, payload)。同一个 filter 重复订阅会覆盖旧 handler。
pub fn MqttClient::subscribe_with_handler(
  self : MqttClient, topic : String, qos : @protocol.QoS, handler : SubHandler
) -> Result[Unit, String] {
  match self.subscribe(topic, qos) {
    Ok(_) => {
      // 覆盖同 filter 的旧 handler
      let mut i = 0
      while i < self.subs.length() {
        if self.subs[i].filter == topic {
          self.subs[i] = { filter: topic, handler }
          return Ok(())
        }
        i = i + 1
      }
      self.subs.push({ filter: topic, handler })
      Ok(())
    }
    Err(e) => Err(e)
  }
}

/// 阻塞读一帧入站报文并派发：
/// - PUBLISH：按 topic filter 匹配本地订阅表，调对应 handler；
///   QoS1/2 的 PUBLISH 会自动回 PUBACK / PUBREC+PUBREL；
/// - PUBACK/PUBREC/PUBCOMP：推进在途 store（publish 同步路径通常已处理，
///   这里兜底）；
/// - PINGRESP/SUBACK/UNSUBACK：静默消化；
/// - PUBREL：兜底静默。
///
/// 返回 `Ok(true)` 表示处理了一帧；`Ok(false)` 表示 timeout_ms 内无数据
/// （调用方可借此检查是否该发 PINGREQ 保活）；`Err` 表示读错误。
pub fn MqttClient::poll_once(self : MqttClient, timeout_ms : Int) -> Result[Bool, String] {
  match self.tcp.wait_read(timeout_ms) {
    Ok(false) => return Ok(false)
    Ok(true) => ()
    Err(e) => return Err(e)
  }
  let pkt = match self.read_packet() {
    Ok(p) => p
    Err(e) => return Err(e)
  }
  match pkt {
    @protocol.IncomingPacket::Publish(p) => {
      // QoS1/2 先回 ACK，再调用户回调（慢回调不阻塞 ACK）
      match p.qos {
        @protocol.QoS::AtLeastOnce => {
          let ack = @protocol.encode_puback(p.packet_id)
          match self.tcp.write(ack) {
            Ok(_) => ()
            Err(e) => return Err(e)
          }
        }
        @protocol.QoS::ExactlyOnce => {
          let rec = @protocol.encode_pubrec(p.packet_id)
          match self.tcp.write(rec) {
            Ok(_) => ()
            Err(e) => return Err(e)
          }
          // 等 PUBREL，回 PUBCOMP（MQTT §4.3.3 服务端侧流程）
          match self.read_packet() {
            Ok(@protocol.IncomingPacket::Pubrel(id)) if id == p.packet_id => {
              let comp = @protocol.encode_pubcomp(p.packet_id)
              match self.tcp.write(comp) {
                Ok(_) => ()
                Err(e) => return Err(e)
              }
            }
            Ok(_) => return Err("expected PUBREL")
            Err(e) => return Err(e)
          }
        }
        @protocol.QoS::AtMostOnce => ()
      }
      // topic 匹配派发
      for reg in self.subs {
        if @protocol.topic_matches(reg.filter, p.topic) {
          (reg.handler)(p.topic, p.payload)
        }
      }
      Ok(true)
    }
    @protocol.IncomingPacket::Puback(id) => {
      self.store[0] = @session.on_puback(self.store[0], id)
      Ok(true)
    }
    @protocol.IncomingPacket::Pubrec(id) => {
      let (s1, pubrel) = @session.on_pubrec(self.store[0], id)
      self.store[0] = s1
      match self.tcp.write(pubrel) {
        Ok(_) => Ok(true)
        Err(e) => Err(e)
      }
    }
    @protocol.IncomingPacket::Pubcomp(id) => {
      self.store[0] = @session.on_pubcomp(self.store[0], id)
      Ok(true)
    }
    // PUBREL 只在出站 QoS2 握手的同步路径里出现，poll 阶段兜底静默
    @protocol.IncomingPacket::Pubrel(_) => Ok(true)
    // SUBACK/UNSUBACK/PINGRESP：同步握手已消化，静默
    @protocol.IncomingPacket::Suback(_) => Ok(true)
    @protocol.IncomingPacket::Unsuback(_) => Ok(true)
    @protocol.IncomingPacket::PingResp => Ok(true)
    // CONNACK 不会在 poll 阶段出现
    @protocol.IncomingPacket::Connack(_) => Ok(true)
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

/// 返回当前在途（尚未完成握手）的 QoS1/2 PUBLISH 的待重放帧序列。
/// 用于 clean_session=false 的会话恢复：调用方重新建立 TCP + CONNECT 后，
/// 依次 write 这些帧（QoS1/2 在途 PUBLISH 带 DUP=1），再继续等
/// PUBACK/PUBREC/PUBCOMP。
///
/// 帧顺序与在途表插入顺序一致；WaitPubcomp 状态的条目会产出 PUBREL 而非
/// DUP PUBLISH（见 `session.persistent.replay`）。
pub fn MqttClient::replay_frames(self : MqttClient) -> Array[Array[Int]] {
  return @session.replay(self.store[0])
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

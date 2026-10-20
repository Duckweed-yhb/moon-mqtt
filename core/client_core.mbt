/// 客户端纯计算核心。
///
/// B 方案：JS/C 胶水层持有 socket，MoonBit 导出纯函数：
/// - `start()`：socket 打开后调用，返回 CONNECT 帧字节让胶水层发出去。
/// - `feed(bytes)`：socket 收到字节后调用，返回 (事件列表, 出站字节列表)。
///
/// Day 1 范围：
/// - CONNECT / CONNACK / PUBLISH(QoS0) / PINGREQ / PINGRESP 最小状态机。
/// - QoS1/2 握手（PUBACK/PUBREC/PUBREL/PUBCOMP 自动回包）留 Day 2。
/// - 出站字节列表 Day 1 恒为空（自动 PUBACK 留 Day 2），但函数签名已预留。
///
/// 注：CoreEvent 不 derive(Eq, Debug)，因为 protocol 包的 Connack / PublishPacket /
/// Suback struct 没有实现这两个 trait（Day 1 不修改 protocol/）。Day 1 测试用
/// match 解构事件，不需要 Eq/Debug；Day 2 若需要比较，可在 protocol/ 补 derive。

/// 上抛给胶水层的事件。
pub enum CoreEvent {
  /// 收到 CONNACK（ConnectionAccepted 时状态机转 Connected）。
  ConnackReceived(@protocol.Connack)
  /// 收到 PUBLISH。QoS0 直接派发；QoS1/2 Day 1 也先派发，自动回 PUBACK 留 Day 2。
  PublishReceived(@protocol.PublishPacket)
  /// 收到 SUBACK。
  SubackReceived(@protocol.Suback)
  /// 收到 PINGRESP（pending_pings 减一）。
  PingRespReceived
  /// 收到 decode_packet 不认识 / 解不出来的报文。
  UnknownPacketType(Int)
}

/// 核心 struct。
///
/// - `opts`：CONNECT 参数（不可变）。
/// - `state`：连接状态（mut 字段，feed 收到 CONNACK 时推进）。
/// - `framer`：字节帧组装器（内部 buf 是 Array 引用语义，字段本身不需要 mut）。
/// - `pending_pings`：已发出未收到 PINGRESP 的 PINGREQ 计数（mut 字段）。
pub struct ClientCore {
  opts : @protocol.ConnectPacket
  mut state : CoreState
  framer : Framer
  mut pending_pings : Int
}

/// 构造核心：初始状态 = Connecting（等 CONNACK）。
pub fn ClientCore::new(opts : @protocol.ConnectPacket) -> ClientCore {
  return {
    opts,
    state: CoreState::Connecting,
    framer: Framer::new(),
    pending_pings: 0,
  }
}

/// 当前状态（只读，供测试 / 胶水层查询）。
pub fn ClientCore::state(self : ClientCore) -> CoreState {
  return self.state
}

/// 已发出未收到 PINGRESP 的 PINGREQ 计数。
pub fn ClientCore::pending_pings(self : ClientCore) -> Int {
  return self.pending_pings
}

/// socket 打开后调用，返回 CONNECT 帧字节让胶水层发出去。
pub fn ClientCore::start(self : ClientCore) -> Array[Int] {
  return @protocol.encode_connect(self.opts)
}

/// 喂入 socket 收到的字节，返回 (事件列表, 出站字节列表)。
///
/// Day 1 出站字节列表恒为空：
/// - QoS1/2 收到 PUBLISH 后自动回 PUBACK/PUBREC 留 Day 2；
/// - 收到 QoS1/2 控制包（PUBACK/PUBREC/PUBREL/PUBCOMP）也先不回，
///   由 session/ 层在 Day 2 接入。
pub fn ClientCore::feed(
  self : ClientCore, bytes : Array[Int]
) -> (Array[CoreEvent], Array[Int]) {
  let frames = self.framer.feed(bytes)
  let events : Array[CoreEvent] = []
  let outgoing : Array[Int] = []
  for frame in frames {
    match @protocol.decode_packet(frame) {
      Err(_) => {
        // Day 1：解不出来的帧抛 UnknownPacketType 事件，让胶水层记录。
        events.push(CoreEvent::UnknownPacketType(0))
      }
      Ok(pkt) => {
        match pkt {
          @protocol.IncomingPacket::Connack(c) => {
            self.state = CoreState::Connected
            events.push(CoreEvent::ConnackReceived(c))
          }
          @protocol.IncomingPacket::Publish(p) => {
            // Day 1：QoS0 直接派发。
            // QoS1/2 也先派发，但自动回 PUBACK/PUBREC 留 Day 2。
            events.push(CoreEvent::PublishReceived(p))
          }
          @protocol.IncomingPacket::Suback(s) => {
            events.push(CoreEvent::SubackReceived(s))
          }
          @protocol.IncomingPacket::PingResp => {
            if self.pending_pings > 0 {
              self.pending_pings = self.pending_pings - 1
            }
            events.push(CoreEvent::PingRespReceived)
          }
          @protocol.IncomingPacket::Puback(_)
          | @protocol.IncomingPacket::Pubrec(_)
          | @protocol.IncomingPacket::Pubrel(_)
          | @protocol.IncomingPacket::Pubcomp(_)
          | @protocol.IncomingPacket::Unsuback(_) => {
            // Day 1：QoS1/2 握手控制包先不处理，留 Day 2 接入 session/。
            ()
          }
        }
      }
    }
  }
  return (events, outgoing)
}

/// Day 1 便利方法：返回 QoS0 PUBLISH 编码字节（胶水层直接发出）。
pub fn ClientCore::publish(
  self : ClientCore, topic : String, payload : Array[Int]
) -> Array[Int] {
  let _ = self.state
  let pkt = @protocol.PublishPacket::new(
    topic, payload, @protocol.qos0(), false, false, 0
  )
  return @protocol.encode_publish(pkt)
}

/// 发出 PINGREQ：pending_pings += 1，返回编码字节。
pub fn ClientCore::pingreq(self : ClientCore) -> Array[Int] {
  self.pending_pings = self.pending_pings + 1
  return @protocol.encode_pingreq()
}

/// 发出 DISCONNECT：状态转 Disconnecting，返回编码字节。
pub fn ClientCore::disconnect(self : ClientCore) -> Array[Int] {
  self.state = CoreState::Disconnecting
  return @protocol.encode_disconnect()
}

/// 构造一个已断开状态的 ClientCore（供 Day 2 断线重连用）。
pub fn ClientCore::disconnected(opts : @protocol.ConnectPacket) -> ClientCore {
  return {
    opts,
    state: CoreState::Disconnected,
    framer: Framer::new(),
    pending_pings: 0,
  }
}

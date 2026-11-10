///|
/// 入站 QoS2 去重：pids 里是否已有该 packet_id。
fn inbound_pid_contains(pids : Array[Int32], pid : Int32) -> Bool {
  for p in pids {
    if p == pid {
      return true
    }
  }
  return false
}

///|
/// 返回去掉指定 packet_id 的新数组（PUBREL 到达后调用）。
fn inbound_pid_without(pids : Array[Int32], pid : Int32) -> Array[Int32] {
  let kept : Array[Int32] = []
  for p in pids {
    if p != pid {
      kept.push(p)
    }
  }
  return kept
}

/// 客户端纯计算核心。
///
/// B 方案：JS/C 胶水层持有 socket，MoonBit 导出纯函数：
/// - `start()`：socket 打开后调用，返回 CONNECT 帧字节让胶水层发出去。
/// - `feed(bytes)`：socket 收到字节后调用，返回 (事件列表, 出站字节列表)。
///
/// 当前范围：
/// - CONNECT / CONNACK / PUBLISH / PINGREQ / PINGRESP 最小状态机。
/// - QoS1/2 自动握手：
///   * 入站 QoS1 PUBLISH → 自动回 PUBACK；
///   * 入站 QoS2 PUBLISH → 自动回 PUBREC；
///   * 入站 PUBREL → 自动回 PUBCOMP；
///   * 出站 QoS1 PUBLISH（`publish(qos1)`）→ 自动等 PUBACK，清理在途；
///   * 出站 QoS2 PUBLISH（`publish(qos2)`）→ 自动等 PUBREC→PUBREL→PUBCOMP，
///     PUBREC 时自动产出 PUBREL 字节；
/// - 出站字节列表由上述自动握手产生，胶水层需把返回的第二元素
///   原样写回 socket。
///
/// 注：CoreEvent 不 derive(Eq, Debug)，因为 protocol 包的 Connack / PublishPacket /
/// Suback struct 没有实现这两个 trait。测试用 match 解构事件，不需要 Eq/Debug。

///|
/// 上抛给胶水层的事件。
pub enum CoreEvent {
  /// 收到 CONNACK（ConnectionAccepted 时状态机转 Connected）。
  ConnackReceived(@protocol.Connack)
  /// 收到 PUBLISH（QoS0/1/2 统一派发；QoS1/2 的自动握手已在出站字节里完成）。
  PublishReceived(@protocol.PublishPacket)
  /// 收到 SUBACK。
  SubackReceived(@protocol.Suback)
  /// 收到 PINGRESP（pending_pings 减一）。
  PingRespReceived
  /// 收到 decode_packet 不认识 / 解不出来的报文。
  UnknownPacketType(Int32)
  /// 帧组装进入不可恢复状态（畸形固定头或缓冲超限），缓冲已清空。
  /// 收到该事件后调用方应断开连接，不要再继续 feed。
  FramerError(String)
}

///|
/// 核心 struct。
///
/// - `opts`：CONNECT 参数（不可变）。
/// - `state`：连接状态（mut 字段，feed 收到 CONNACK 时推进）。
/// - `framer`：字节帧组装器（内部 buf 是 Array 引用语义，字段本身不需要 mut）。
/// - `pending_pings`：已发出未收到 PINGRESP 的 PINGREQ 计数（mut 字段）。
/// - `session`：出站在途 QoS 握手状态（mut 字段，收到 PUBACK/PUBREC/PUBCOMP 时推进）。
///   入站 QoS1/2 的 PUBACK/PUBREC/PUBCOMP 由本核心直接编码返回，不依赖 SessionStore；
///   SessionStore 只负责"客户端自己发出的 QoS1/2 PUBLISH"的在途追踪。
pub struct ClientCore {
  opts : @protocol.ConnectPacket
  mut state : CoreState
  framer : Framer
  mut pending_pings : Int32
  mut session : @session.SessionStore
  /// 入站 QoS2 尚未收到 PUBREL 的 packet_id，用于重复 PUBLISH 去重。
  mut inbound_qos2 : Array[Int32]
  /// 已成功的订阅列表（按 topic 去重），用于断线重连后自动重订。
  mut subscriptions : Array[@protocol.Subscription]
  /// 出站 SUBSCRIBE 在途映射：pid -> 该次订阅携带的 Subscription 列表。
  /// 胶水层编码 SUBSCRIBE 后调 `record_outbound_subscribe(pid, subs)` 登记，
  /// 收到对应 SUBACK 且 `all_accepted()` 为 true 时自动落库并清掉此条目。
  mut pending_subscribes : Array[(Int32, Array[@protocol.Subscription])]
}

///|
/// 构造核心：初始状态 = Connecting（等 CONNACK），SessionStore 为空。
pub fn ClientCore::new(opts : @protocol.ConnectPacket) -> ClientCore {
  return {
    opts,
    state: CoreState::Connecting,
    framer: Framer::new(),
    pending_pings: 0,
    session: @session.SessionStore::new(),
    inbound_qos2: [],
    subscriptions: [],
    pending_subscribes: [],
  }
}

///|
/// 当前状态（只读，供测试 / 胶水层查询）。
pub fn ClientCore::state(self : ClientCore) -> CoreState {
  return self.state
}

///|
/// 已发出未收到 PINGRESP 的 PINGREQ 计数。
pub fn ClientCore::pending_pings(self : ClientCore) -> Int32 {
  return self.pending_pings
}

///|
/// 出站在途会话存储（只读 getter，供测试 / 落盘层查询）。
pub fn ClientCore::session(self : ClientCore) -> @session.SessionStore {
  return self.session
}

///|
/// socket 打开后调用，返回 CONNECT 帧字节让胶水层发出去。
pub fn ClientCore::start(self : ClientCore) -> Array[Int32] {
  return @protocol.encode_connect(self.opts)
}

///|
/// 把一段字节追加到出站字节数组末尾（就地 push，Array 是引用语义）。
fn append_bytes(out : Array[Int32], src : Array[Int32]) -> Unit {
  for b in src {
    out.push(b)
  }
}

///|
/// 喂入 socket 收到的字节，返回 (事件列表, 出站字节列表)。
///
/// 出站字节列表：
/// - 收到 QoS1 PUBLISH → 追加 PUBACK(packet_id)；
/// - 收到 QoS2 PUBLISH → 追加 PUBREC(packet_id)；
/// - 收到 PUBREL → 追加 PUBCOMP(packet_id)；
/// - 收到 PUBREC → 驱动 SessionStore.on_pubrec，若在途则追加 PUBREL；
/// - 收到 PUBACK/PUBCOMP → 仅清理 SessionStore，不产出字节。
pub fn ClientCore::feed(
  self : ClientCore,
  bytes : Array[Int32],
) -> (Array[CoreEvent], Array[Int32]) {
  let events : Array[CoreEvent] = []
  let outgoing : Array[Int32] = []
  let frames = match self.framer.feed(bytes) {
    Ok(f) => f
    Err(e) => {
      // 畸形头 / 缓冲超限：帧组装已不可恢复，上报后由调用方断开。
      events.push(CoreEvent::FramerError(e))
      return (events, outgoing)
    }
  }
  for frame in frames {
    match @protocol.decode_packet(frame) {
      Err(_) =>
        // 解不出来的帧抛 UnknownPacketType 事件，让胶水层记录。
        events.push(CoreEvent::UnknownPacketType(frame[0] >> 4))
      Ok(pkt) =>
        match pkt {
          @protocol.IncomingPacket::Connack(c) => {
            // 只有 ConnectionAccepted 才进入 Connected；拒绝码停在 Disconnected。
            self.state = match c.return_code {
              @protocol.ConnectReturnCode::ConnectionAccepted =>
                CoreState::Connected
              _ => CoreState::Disconnected
            }
            // session_present=false：broker 丢了会话，自动重订已记录的订阅。
            // session_present=true：broker 保留了订阅，无需重订。
            match c.return_code {
              @protocol.ConnectReturnCode::ConnectionAccepted =>
                if !c.session_present {
                  append_bytes(outgoing, self.resubscribe_bytes())
                }
              _ => ()
            }
            events.push(CoreEvent::ConnackReceived(c))
          }
          @protocol.IncomingPacket::Publish(p) => {
            // 入站 PUBLISH：QoS1 直接派发；QoS2 按 packet_id 去重，
            // 首次派发并记入 inbound_qos2，重复 PUBLISH 只回 PUBREC。
            let mut deliver = true
            match p.qos {
              @protocol.QoS::AtLeastOnce =>
                append_bytes(outgoing, @protocol.encode_puback(p.packet_id))
              @protocol.QoS::ExactlyOnce => {
                if inbound_pid_contains(self.inbound_qos2, p.packet_id) {
                  deliver = false
                } else {
                  self.inbound_qos2.push(p.packet_id)
                }
                append_bytes(outgoing, @protocol.encode_pubrec(p.packet_id))
              }
              _ => ()
            }
            if deliver {
              events.push(CoreEvent::PublishReceived(p))
            }
          }
          @protocol.IncomingPacket::Suback(s) => {
            // SUBACK：broker 对出站 SUBSCRIBE 的应答。
            //
            // 无论成败都要把 pending 条目摘掉：以前只在 all_accepted 时才摘，
            // 失败那次会永远挂在 pending_subscribes 里——既泄漏内存，又会让
            // 之后同一个 pid 的 SUBACK 把这条失败的订阅补记进订阅表。
            let accepted = s.all_accepted()
            self.commit_pending_subscribe(s.packet_id, accepted)
            events.push(CoreEvent::SubackReceived(s))
          }
          @protocol.IncomingPacket::PingResp => {
            if self.pending_pings > 0 {
              self.pending_pings = self.pending_pings - 1
            }
            events.push(CoreEvent::PingRespReceived)
          }
          @protocol.IncomingPacket::Puback(pid) =>
            // 出站 QoS1 PUBLISH 被 broker 确认：清理在途。
            self.session = @session.on_puback(self.session, pid)
          @protocol.IncomingPacket::Pubrec(pid) =>
            // 出站 QoS2 PUBLISH 被 broker 确认收到：推进到 WaitPubcomp，
            // 若在途则产出 PUBREL 字节让胶水层发出去。
            match @session.on_pubrec(self.session, pid) {
              (s, pubrel) => {
                self.session = s
                append_bytes(outgoing, pubrel)
              }
            }
          @protocol.IncomingPacket::Pubrel(pid) => {
            // 入站 PUBREL：broker 对我们已回 PUBREC 的 QoS2 PUBLISH 的确认，
            // 客户端必须回 PUBCOMP 完成握手，并清掉去重表里的 pid。
            self.inbound_qos2 = inbound_pid_without(self.inbound_qos2, pid)
            append_bytes(outgoing, @protocol.encode_pubcomp(pid))
          }
          @protocol.IncomingPacket::Pubcomp(pid) =>
            // 出站 QoS2 PUBLISH 握手完成：清理在途。
            self.session = @session.on_pubcomp(self.session, pid)
          @protocol.IncomingPacket::Unsuback(_) =>
            // UNSUBACK：客户端发起 UNSUBSCRIBE 的应答，当前版本不处理。
            ()
        }
    }
  }
  return (events, outgoing)
}

///|
/// 便利方法：编码 PUBLISH 并记录在途（QoS1/2）。
///
/// QoS0：不入在途，直接返回编码字节。
/// QoS1/2：内部调用 `@session.record_outbound` 分配 packet_id 并记入
/// `self.session`，返回带 pid 的编码字节；收到 PUBACK/PUBREC/PUBCOMP
/// 后由 `feed()` 自动清理在途。
pub fn ClientCore::publish(
  self : ClientCore,
  topic : String,
  payload : Array[Int32],
  qos : @protocol.QoS,
) -> Array[Int32] {
  // 未收到 CONNACK(Accepted) 前不发 PUBLISH（§3.1.4）。
  match self.state {
    CoreState::Connected => ()
    _ => return []
  }
  // §3.3.2.1：topic 为空 / 带通配符 / 含 U+0000 时不下发。发出去 broker 会
  // 当协议错误断连，调用方还以为是网络问题。
  match @protocol.validate_topic_name(topic) {
    Ok(_) => ()
    Err(_) => return []
  }
  let pkt = @protocol.PublishPacket::new(topic, payload, qos, false, false, 0)
  match qos {
    @protocol.QoS::AtMostOnce => return @protocol.encode_publish(pkt)
    _ =>
      match @session.record_outbound(self.session, pkt) {
        (store, pid) => {
          self.session = store
          if pid == 0 {
            return []
          }
          let with_pid = pkt.with_packet_id(pid)
          return @protocol.encode_publish(with_pid)
        }
      }
  }
}

///|
/// 分配一个控制报文 packet_id（SUBSCRIBE/UNSUBSCRIBE 用），
/// 与 PUBLISH 共享 id 空间并跳过在途占用。
pub fn ClientCore::allocate_control_packet_id(self : ClientCore) -> Int32 {
  match @session.alloc_control_packet_id(self.session) {
    (store, pid) => {
      self.session = store
      return pid
    }
  }
}

///|
/// 记录一条已订阅的 (topic, qos)。同一 topic 重复订阅时更新 qos，不重复追加。
/// 由胶水层在 SUBACK 收到且 `all_accepted()` 为 true 后调用。
pub fn ClientCore::record_subscription(
  self : ClientCore,
  topic : String,
  qos : @protocol.QoS,
) -> Unit {
  for i in 0..<self.subscriptions.length() {
    if self.subscriptions[i].topic == topic {
      self.subscriptions[i] = @protocol.Subscription::new(topic, qos)
      return
    }
  }
  self.subscriptions.push(@protocol.Subscription::new(topic, qos))
}

///|
/// 登记一条出站 SUBSCRIBE：编码完 SUBSCRIBE 帧后由胶水层调用，
/// 把 pid 和该次订阅携带的 Subscription 列表挂起。收到对应 SUBACK 且
/// `all_accepted()` 为 true 时，feed() 会自动把这些订阅落库并清掉此条目。
pub fn ClientCore::record_outbound_subscribe(
  self : ClientCore,
  pid : Int32,
  subs : Array[@protocol.Subscription],
) -> Unit {
  // 同 pid 已存在时先替换（理论上 pid 不会复用，但保险起见）。
  let kept : Array[(Int32, Array[@protocol.Subscription])] = []
  for entry in self.pending_subscribes {
    if entry.0 != pid {
      kept.push(entry)
    }
  }
  kept.push((pid, subs))
  self.pending_subscribes = kept
}

///|
/// SUBACK 到达后调用：摘掉 pid 对应的挂起条目；`accepted` 为真时把
/// 该次订阅逐条落库。
///
/// 摘条目是无条件的——失败也要摘，否则条目永久泄漏，且后续同 pid 的
/// SUBACK 会把一条被 broker 拒绝的订阅补记进本地订阅表，之后每次重连
/// 都会替它重订，broker 每次都拒绝。
fn ClientCore::commit_pending_subscribe(
  self : ClientCore,
  pid : Int32,
  accepted : Bool,
) -> Unit {
  let mut found : Array[@protocol.Subscription] = []
  let kept : Array[(Int32, Array[@protocol.Subscription])] = []
  for entry in self.pending_subscribes {
    if entry.0 == pid {
      found = entry.1
    } else {
      kept.push(entry)
    }
  }
  self.pending_subscribes = kept
  if accepted {
    for sub in found {
      self.record_subscription(sub.topic, sub.qos)
    }
  }
}

///|
/// 当前已记录的订阅列表。
///
/// 返回的是**拷贝**：`Array` 是引用语义，直接给出内部数组会让调用方
/// 一个 `push` 就改掉客户端的订阅表（重连重订会跟着错），而文档还写着
/// 「只读」。
pub fn ClientCore::subscriptions(
  self : ClientCore,
) -> Array[@protocol.Subscription] {
  let out : Array[@protocol.Subscription] = []
  for sub in self.subscriptions {
    out.push(sub)
  }
  return out
}

///|
/// 从本地订阅表删除指定 topic filter。
///
/// 胶水层发 UNSUBSCRIBE 后调用——这样重连后不会把已经退订的 topic 重订回去。
/// topic 不在表里时静默忽略。
pub fn ClientCore::forget_subscription(
  self : ClientCore,
  topic : String,
) -> Unit {
  let kept : Array[@protocol.Subscription] = []
  for sub in self.subscriptions {
    if sub.topic != topic {
      kept.push(sub)
    }
  }
  self.subscriptions = kept
}

///|
/// 断线重连后生成重订 SUBSCRIBE 帧字节。
///
/// 分配一个新 packet_id，把当前所有记录的订阅打包进一个 SUBSCRIBE 帧。
/// 若无订阅则返回空数组。胶水层在 CONNACK(session_present=0) 后调用——
/// 此时 broker 已丢会话，必须全量重订；session_present=1 时 broker 保留订阅，
/// 由调用方自行决定是否重订（通常不需要）。
pub fn ClientCore::resubscribe_bytes(self : ClientCore) -> Array[Int32] {
  if self.subscriptions.length() == 0 {
    return []
  }
  let pid = self.allocate_control_packet_id()
  if pid == 0 {
    return []
  }
  let pkt = @protocol.SubscribePacket::new(pid, self.subscriptions)
  return @protocol.encode_subscribe(pkt)
}

///|
/// 断线重连后需要重发的在途报文序列（按原始发送序）。
/// 由 `@session.replay` 产出：WaitingPuback/WaitPubrec 重发 PUBLISH(DUP=1)，
/// WaitPubcomp 重发 PUBREL。
pub fn ClientCore::replay_bytes(self : ClientCore) -> Array[Array[Int32]] {
  return @session.replay(self.session)
}

///|
/// 清空会话状态：`session_present=false` 时调用，避免本地僵尸在途
/// 在下次重连时被重放给已经丢会话的 broker。
pub fn ClientCore::reset_session(self : ClientCore) -> Unit {
  self.session = @session.SessionStore::new()
  self.inbound_qos2 = []
}

///|
/// 发出 PINGREQ：pending_pings += 1，返回编码字节。
pub fn ClientCore::pingreq(self : ClientCore) -> Array[Int32] {
  self.pending_pings = self.pending_pings + 1
  return @protocol.encode_pingreq()
}

///|
/// 发出 DISCONNECT：状态转 Disconnecting，返回编码字节。
pub fn ClientCore::disconnect(self : ClientCore) -> Array[Int32] {
  self.state = CoreState::Disconnecting
  return @protocol.encode_disconnect()
}

///|
/// 通知胶水层 transport 已断开（对端关闭 / 网络异常）：
/// - 状态切到 Disconnected；
/// - 清空在途 PINGREQ 计数（不会再有 PINGRESP 回来）；
/// - **保留 SessionStore**：in-flight QoS1/2 PUBLISH 待重连后继续推进，
///   不新建空 store。
pub fn ClientCore::on_transport_close(self : ClientCore) -> Unit {
  self.state = CoreState::Disconnected
  self.pending_pings = 0
}

///|
/// 重连时由胶水层调用：
/// - 复用同一 ConnectPacket 重新编码 CONNECT（与首次 start() 字节一致）；
/// - 状态切回 Connecting（等新 CONNACK）；
/// - 清空 framer 残留缓冲（旧连接的半包字节不能带到新连接）；
/// - 清空在途 PINGREQ 计数；
/// - **SessionStore 保留**：in-flight QoS1/2 重连后由后续 PUBACK/PUBREC/PUBCOMP 继续推进。
pub fn ClientCore::reconnect_bytes(self : ClientCore) -> Array[Int32] {
  self.state = CoreState::Connecting
  self.pending_pings = 0
  self.framer.reset()
  return @protocol.encode_connect(self.opts)
}

///|
/// 构造一个已断开状态的 ClientCore（供断线重连用，SessionStore 保留供重放）。
pub fn ClientCore::disconnected(opts : @protocol.ConnectPacket) -> ClientCore {
  return {
    opts,
    state: CoreState::Disconnected,
    framer: Framer::new(),
    pending_pings: 0,
    session: @session.SessionStore::new(),
    inbound_qos2: [],
    subscriptions: [],
    pending_subscribes: [],
  }
}

///|
/// 用一个已有的 SessionStore 构造 ClientCore（断线重连恢复在途状态用）。
/// 胶水层从持久化读回 store 后，通过此方法把在途清单注入新的连接实例。
pub fn ClientCore::with_session(
  opts : @protocol.ConnectPacket,
  session : @session.SessionStore,
) -> ClientCore {
  return {
    opts,
    state: CoreState::Connecting,
    framer: Framer::new(),
    pending_pings: 0,
    session,
    inbound_qos2: [],
    subscriptions: [],
    pending_subscribes: [],
  }
}

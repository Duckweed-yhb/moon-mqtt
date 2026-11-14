// core/dispatch.mbt — 事件 → 胶水层动作的纯决策表。
//
// `ClientCore::feed` 只产出事件，不碰 socket。「这条事件该不该关连接、
// 该回调谁」由胶水层（browser、async、调用方自己的事件循环）决定。
// 把这张表放在 core 里，是为了让它脱离 WebSocket 与 TCP 也能单测：
// 畸形帧之后不关连接、CONNACK 被拒之后继续 subscribe 这类错误，在真实
// 网络上几乎撞不出来，在这里是可断言的。
//
// 这张表同时是文档：`CoreEvent` 的每个 variant 都必须在 `plan_event` 里
// 有明确落点，不允许「默认忽略」——编不过比静默吞掉好。

///|
/// 胶水层对一条 `CoreEvent` 该执行的动作。
pub enum DispatchAction {
  /// 无事可做：事件已被 core 内部消费（如 PINGRESP 递减未应答计数）。
  Ignore
  /// CONNACK 接受。`true` 表示 broker 保留了上一次会话（session_present=1）。
  /// 调用方在这里回调 on_connect，此后才允许 subscribe / publish。
  Connected(Bool)
  /// CONNACK 拒绝：链路不可用，调用方应关 socket 并上报原因码。
  Refused(@protocol.ConnectReturnCode)
  /// 不可恢复（畸形帧 / 缓冲超限）：帧边界已丢失，调用方必须关 socket，
  /// 不要再继续 feed——继续喂只会把后续字节解释成垃圾帧。
  Fatal(String)
  /// 派发一条业务消息给使用者：(topic, payload)。
  Deliver(String, Array[Int32])
  /// SUBACK：全部订阅项被接受，调用 on_suback。
  Subacked
  /// SUBACK：broker 对至少一项返回 0x80。调用方不应把这次订阅算作成功，
  /// 也不该在这里回调 on_suback。带上返回码数组（按 SUBSCRIBE 条目顺序），
  /// 好让调用方报出「哪几项被拒」。
  SubackRejected(Array[@protocol.SubAckCode])
  /// 不认识 / 解不出的报文：记录即可，不算致命。
  Unknown(Int32)
}

///|
/// 把一条事件翻译成动作。纯函数，不读全局状态、不碰 I/O。
pub fn plan_event(event : CoreEvent) -> DispatchAction {
  match event {
    CoreEvent::ConnackReceived(c) =>
      match c.return_code {
        @protocol.ConnectReturnCode::ConnectionAccepted =>
          Connected(c.session_present)
        other => Refused(other)
      }
    CoreEvent::PublishReceived(p) => Deliver(p.topic, p.payload)
    CoreEvent::SubackReceived(s) =>
      if s.all_accepted() {
        Subacked
      } else {
        SubackRejected(s.codes())
      }
    CoreEvent::PingRespReceived => Ignore
    CoreEvent::UnknownPacketType(t) => Unknown(t)
    CoreEvent::MalformedFrame(_, reason) => Fatal(reason)
    CoreEvent::FramerError(e) => Fatal(e)
  }
}

///|
/// 该动作是否要求调用方立刻关掉传输层。
///
/// `Refused` 与 `Fatal` 都属于「这条连接已经不可用」，胶水层漏掉任何一个
/// 都会留下一个「看起来还开着、实际再也收不到正确报文」的连接。
pub fn DispatchAction::needs_close(self : DispatchAction) -> Bool {
  match self {
    Refused(_) | Fatal(_) => true
    _ => false
  }
}

///|
/// CONNACK 返回码的人类可读说明（3.1.1 §3.2.2.3 的 6 个值）。
/// 只用于日志与错误上报，不参与协议逻辑。
pub fn return_code_name(code : @protocol.ConnectReturnCode) -> String {
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

///|
/// 返回码回写成的线上字节值（0–5），日志里带上便于对照规范 §3.2.2.3 的表。
pub fn return_code_byte(code : @protocol.ConnectReturnCode) -> Int32 {
  match code {
    @protocol.ConnectReturnCode::ConnectionAccepted => 0
    @protocol.ConnectReturnCode::UnacceptableProtocolVersion => 1
    @protocol.ConnectReturnCode::IdentifierRejected => 2
    @protocol.ConnectReturnCode::ServerUnavailable => 3
    @protocol.ConnectReturnCode::BadUsernameOrPassword => 4
    @protocol.ConnectReturnCode::NotAuthorized => 5
  }
}

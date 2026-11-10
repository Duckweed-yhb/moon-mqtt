///|
/// dispatch 纯计算单测：事件 → 动作的映射表（whitebox：需要构造 CoreEvent）。
///
/// 这些用例锁住的是浏览器 / 异步外观最容易写错的三件事：
/// ① 拒绝 CONNACK 之后必须关连接；② 畸形帧是致命错误，不是「可忽略」；
/// ③ 业务消息与 SUBACK 不触发关闭。
///
/// 注：`Connack` / `Suback` 的字段对外只读，测试里不手搓结构体，而是让
/// 真实字节走 `@protocol.decode_packet` 产出——顺带把解码路径也断言了。

///|
/// 用真实 CONNACK 字节造事件：`0x20, len=2, ack_flags, return_code`。
fn connack_event(ack_flags : Int32, return_code : Int32) -> CoreEvent {
  let bytes : Array[Int32] = [0x20, 0x02, ack_flags, return_code]
  match @protocol.decode_packet(bytes) {
    Ok(@protocol.IncomingPacket::Connack(c)) => CoreEvent::ConnackReceived(c)
    _ => abort("CONNACK bytes did not decode")
  }
}

///|
/// 用真实 SUBACK 字节造事件：`0x90, len=3, pid_hi, pid_lo, code`。
fn suback_event(pid : Int32, code : Int32) -> CoreEvent {
  let bytes : Array[Int32] = [0x90, 0x03, 0x00, pid, code]
  match @protocol.decode_packet(bytes) {
    Ok(@protocol.IncomingPacket::Suback(s)) => CoreEvent::SubackReceived(s)
    _ => abort("SUBACK bytes did not decode")
  }
}

///|
test "dispatch: accepted connack maps to connected with session flag" {
  assert_true(
    plan_event(connack_event(0x00, 0x00)) is DispatchAction::Connected(false),
  )
  assert_true(
    plan_event(connack_event(0x01, 0x00)) is DispatchAction::Connected(true),
  )
}

///|
test "dispatch: refused connack is fatal for the transport" {
  let action = plan_event(connack_event(0x00, 0x05))
  assert_true(
    action
    is DispatchAction::Refused(@protocol.ConnectReturnCode::NotAuthorized),
  )
  assert_true(action.needs_close())
  // 五个拒绝码都必须走 Refused，不许漏成 Connected 或 Ignore。
  for code in 1..<=5 {
    let a = plan_event(connack_event(0x00, code))
    assert_true(a is DispatchAction::Refused(_))
    assert_true(a.needs_close())
  }
}

///|
test "dispatch: framer error demands closing the socket" {
  let action = plan_event(CoreEvent::FramerError("bad fixed header"))
  assert_true(action is DispatchAction::Fatal(msg) && msg == "bad fixed header")
  assert_true(action.needs_close())
}

///|
test "dispatch: publish is delivered with topic and payload" {
  let ev = CoreEvent::PublishReceived(
    @protocol.PublishPacket::new(
      "sensors/temp",
      [0x32, 0x33],
      @protocol.qos1(),
      false,
      false,
      7,
    ),
  )
  let action = plan_event(ev)
  match action {
    DispatchAction::Deliver(topic, payload) => {
      assert_eq(topic, "sensors/temp")
      assert_eq(payload.length(), 2)
      assert_eq(payload[0], 50)
      assert_eq(payload[1], 51)
    }
    _ => abort("expected Deliver, got something else")
  }
  assert_false(action.needs_close())
}

///|
test "dispatch: suback is not fatal" {
  let action = plan_event(suback_event(3, 0x01))
  assert_true(action is DispatchAction::Subacked)
  assert_false(action.needs_close())
}

///|
test "dispatch: pingresp and unknown packet do not close" {
  let ping = plan_event(CoreEvent::PingRespReceived)
  assert_true(ping is Ignore)
  assert_false(ping.needs_close())
  let unknown = plan_event(CoreEvent::UnknownPacketType(15))
  assert_true(unknown is DispatchAction::Unknown(15))
  assert_false(unknown.needs_close())
}

///|
/// 字节 → 返回码；取不到直接让测试挂掉（等价于「协议表缺值」）。
fn code_of(v : Int32) -> @protocol.ConnectReturnCode {
  match @protocol.return_code_from_int(v) {
    Some(c) => c
    None => abort("unknown connack code " + v.to_string())
  }
}

///|
test "dispatch: every connack code has a readable name" {
  assert_eq(return_code_name(code_of(0)), "accepted")
  assert_eq(return_code_name(code_of(1)), "unacceptable protocol version")
  assert_eq(return_code_name(code_of(2)), "identifier rejected")
  assert_eq(return_code_name(code_of(3)), "server unavailable")
  assert_eq(return_code_name(code_of(4)), "bad username or password")
  assert_eq(return_code_name(code_of(5)), "not authorized")
  // 六个值都要有名字，不许有落空分支。
  for code in 0..<=5 {
    assert_true(return_code_name(code_of(code)).length() > 0)
  }
}

///|
/// 评审回归：会话丢失（session_present=0）时，本地会话状态必须作废。
///
/// 以前 CONNACK 只补重订、不清在途清单与入站 QoS2 去重表，导致
/// ① 旧在途被重放给已经丢会话的 broker；
/// ② 新会话复用同一个 packet_id 的 QoS2 消息被当成重复投递，只回 PUBREC
///    不派发，消息永久丢失且不报任何错。
test "session_present=0 discards outbound in-flight" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("guard"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00]) // 首联，session_present=0
  let _ = core.publish("out/t", [0xAA], @protocol.qos1())
  assert_eq(core.session().inflight_count(), 1)
  // 断线后重连，broker 说会话没了
  core.on_transport_close()
  let _ = core.reconnect_bytes()
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  assert_eq(core.session().inflight_count(), 0)
  // 也不能再重放旧帧
  assert_eq(core.replay_bytes().length(), 0)
}

///|
/// 同一条 QoS2 PUBLISH 在「会话丢失」后必须重新派发（pid 在新会话里可复用）。
test "session_present=0 clears inbound qos2 dedupe" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("guard"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  // QoS2 PUBLISH：topic "a"，packet_id=7，无载荷
  let qos2_publish : Array[Int32] = [0x34, 0x05, 0x00, 0x01, 0x61, 0x00, 0x07]
  match core.feed(qos2_publish) {
    (events, outgoing) => {
      assert_eq(events.length(), 1)
      // 回了 PUBREC
      assert_eq(outgoing, [0x50, 0x02, 0x00, 0x07])
    }
  }
  // 同一会话内重复投递：不派发，只重发 PUBREC
  match core.feed(qos2_publish) {
    (events, _) => assert_eq(events.length(), 0)
  }
  // 断线重连，broker 会话丢失
  core.on_transport_close()
  let _ = core.reconnect_bytes()
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  // 新会话里 packet_id 复用：必须重新派发，而不是被当成重复
  match core.feed(qos2_publish) {
    (events, outgoing) => {
      assert_eq(events.length(), 1)
      assert_eq(outgoing, [0x50, 0x02, 0x00, 0x07])
    }
  }
}

///|
/// 会话丢失时，挂起的 SUBSCRIBE 也必须作废：它们的 packet_id 属于旧会话，
/// 新会话里这个 id 可能被别的请求占用，迟到的 SUBACK 会把一条早已作废的
/// 订阅补进本地订阅表，之后每次重连都替它重订。
test "session_present=0 drops pending subscribes from the old session" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("guard"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  core.record_outbound_subscribe(7, [
    @protocol.Subscription::new("a/#", @protocol.qos1()),
  ])
  core.on_transport_close()
  let _ = core.reconnect_bytes()
  let _ = core.feed([0x20, 0x02, 0x00, 0x00]) // session_present=0
  // 迟到的 SUBACK（pid 恰好复用）：不能把作废的订阅补记进来
  let _ = core.feed([0x90, 0x03, 0x00, 0x07, 0x01])
  assert_eq(core.subscriptions().length(), 0)
}

///|
/// 评审回归：已知入站类型的解码失败是协议错误，必须带出原因并触发关闭，
/// 不能压成一个 "unknown packet type 3"。
test "malformed inbound frame carries reason and is fatal" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("guard"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  // QoS1 PUBLISH 但 packet_id=0（非法）
  match core.feed([0x32, 0x05, 0x00, 0x01, 0x61, 0x00, 0x00]) {
    (events, _) => {
      assert_eq(events.length(), 1)
      match events[0] {
        @core.CoreEvent::MalformedFrame(t, reason) => {
          assert_eq(t, 3)
          assert_true(reason.length() > 0)
          match @core.plan_event(events[0]) {
            @core.DispatchAction::Fatal(_) => ()
            _ => fail("malformed frame must map to Fatal")
          }
        }
        @core.CoreEvent::UnknownPacketType(_) =>
          fail("known type must not be reported as unknown")
        _ => fail("expected MalformedFrame")
      }
    }
  }
}

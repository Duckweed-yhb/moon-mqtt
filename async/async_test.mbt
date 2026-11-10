///|
/// async 包最小骨架测试：构造 → 初始待发 CONNECT → feed CONNACK →
/// 事件派发 / 状态迁移 / 队列 drain。
test "new queues connect frame as initial pending" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let out = client.drain_pending()
  // CONNECT 固定头第一字节 = 0x10
  assert_eq(out[0], 0x10)
  // "async-test" = 10 字节，可变头 10 + 载荷 2+10 = 22 → 帧总长 24
  assert_eq(out.length(), 24)
  // drain 后队列为空
  assert_eq(client.drain_pending().length(), 0)
  // 初始没有事件
  assert_eq(client.drain_events().length(), 0)
}

///|
test "feed connack yields event and transitions state" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let _ = client.drain_pending() // 丢掉初始 CONNECT
  // 喂 CONNACK Accepted
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let evs = client.drain_events()
  assert_eq(evs.length(), 1)
  match evs[0] {
    @core.CoreEvent::ConnackReceived(c) =>
      match c.return_code {
        @protocol.ConnectReturnCode::ConnectionAccepted => ()
        _ => fail("expected ConnectionAccepted")
      }
    _ => fail("expected ConnackReceived")
  }
  // 状态应迁移到 Connected
  match client.state() {
    @core.CoreState::Connected => ()
    _ => fail("expected Connected")
  }
  // drain 之后事件队列空
  assert_eq(client.drain_events().length(), 0)
}

///|
test "feed qos1 publish queues puback as outgoing" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let _ = client.drain_pending()
  // 先 CONNACK 进入 Connected
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let _ = client.drain_events()
  // 构造一条入站 QoS1 PUBLISH（pid=5）：topic "a/b"，payload [0x01]
  let pkt = @protocol.PublishPacket::new(
    "a/b",
    [0x01],
    @protocol.qos1(),
    false,
    false,
    5,
  )
  client.feed_bytes(@protocol.encode_publish(pkt))
  // 事件应有一条 PublishReceived
  let evs = client.drain_events()
  assert_eq(evs.length(), 1)
  match evs[0] {
    @core.CoreEvent::PublishReceived(p) => assert_eq(p.packet_id, 5)
    _ => fail("expected PublishReceived")
  }
  // 待发字节应是 PUBACK(0x40, pid=5)
  let out = client.drain_pending()
  assert_eq(out, [0x40, 0x02, 0x00, 0x05])
}

///|
test "subscribe sends suback accepted records subscription" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let _ = client.drain_pending()
  // 先 CONNACK 进入 Connected
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let _ = client.drain_events()
  // 发订阅
  client.subscribe("sensors/#", @protocol.qos1())
  let out = client.drain_pending()
  // SUBSCRIBE 固定头 0x82
  assert_eq(out[0], 0x82)
  // pid = 1（CONNECT 没用 pid，第一个控制报文 id = 1）
  assert_eq(out[2], 0x00)
  assert_eq(out[3], 0x01)
  // 喂 SUBACK（pid=1, Success1）
  client.feed_bytes([0x90, 0x03, 0x00, 0x01, 0x01])
  let evs = client.drain_events()
  assert_eq(evs.length(), 1)
  // 核心层订阅表应已落库（通过 core.state 间接验证：没有直接暴露 subscriptions getter，
  // 但重连后 CONNACK session_present=false 应自动重订）
  // 触发重连：transport close + reconnect
  client.on_transport_close()
  client.reconnect()
  let _ = client.drain_pending() // 丢掉重连的 CONNECT
  // 喂 CONNACK session_present=0 → 应自动重订 "sensors/#"
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let _ = client.drain_events()
  let after = client.drain_pending()
  // 自动重订的 SUBSCRIBE 固定头 0x82
  assert_eq(after[0], 0x82)
}

///|
test "unsubscribe removes topic from local subscriptions" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let _ = client.drain_pending()
  // CONNACK → Connected
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let _ = client.drain_events()
  // 订阅 a/b 和 c/d
  client.subscribe("a/b", @protocol.qos1())
  client.feed_bytes([0x90, 0x03, 0x00, 0x01, 0x01])
  let _ = client.drain_events()
  client.subscribe("c/d", @protocol.qos0())
  client.feed_bytes([0x90, 0x03, 0x00, 0x02, 0x00])
  let _ = client.drain_events()
  let _ = client.drain_pending()
  // 退订 a/b
  client.unsubscribe("a/b")
  let out = client.drain_pending()
  // UNSUBSCRIBE 固定头 0xA2
  assert_eq(out[0], 0xA2)
  // 重连后只重订 c/d
  client.on_transport_close()
  client.reconnect()
  let _ = client.drain_pending()
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let _ = client.drain_events()
  let after = client.drain_pending()
  // 重订帧里应该只有 c/d（11 字节 topic + qos），不含 a/b
  // 验证方式：重订 SUBSCRIBE 帧的剩余长度应该只包含 c/d 这一条
  // pid(2) + [len(2)+2("c/d")+1(qos)] = 7 → rlen=7
  assert_eq(after[0], 0x82)
  assert_eq(after[1], 8)
}

///|
test "subscribe before connack emits nothing" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let _ = client.drain_pending()
  // 还没收到 CONNACK，此时订阅不应产生任何字节
  client.subscribe("early/#", @protocol.qos1())
  assert_eq(client.drain_pending().length(), 0)
}

///|
test "reconnect replays in-flight qos1 when session_present" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test").with_clean_session(false),
  )
  let _ = client.drain_pending()
  // 首次连接：session_present=0
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let _ = client.drain_events()
  // 发一条 QoS1，丢掉发出的 PUBLISH，模拟未确认就断线
  client.publish("a", [1], @protocol.qos1())
  let _ = client.drain_pending()
  client.on_transport_close()
  client.reconnect()
  let _ = client.drain_pending()
  // 重连成功且 broker 保留会话：应重发在途 PUBLISH(DUP=1)
  client.feed_bytes([0x20, 0x02, 0x01, 0x00])
  assert_true(client.drain_pending().length() > 0)
}

///|
test "publish qos1 queues encoded outbound bytes when connected" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let _ = client.drain_pending()
  // CONNACK Accepted → Connected
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let _ = client.drain_events()
  // Connected 后出站 QoS1 PUBLISH 的编码字节应进入待发队列
  client.publish("a", [1], @protocol.qos1())
  let out = client.drain_pending()
  assert_true(out.length() > 0)
  // PUBLISH 类型 0x30 | QoS1(0x02) = 0x32
  assert_eq(out[0], 0x32)
}

///|
test "transport close discards undrained pending before reconnect" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let _ = client.drain_pending()
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let _ = client.drain_events()
  // Connected 后产生出站字节，但刻意不 drain：尚未交给 socket。
  client.publish("a", [1], @protocol.qos1())
  // 传输断开：未落网的待发字节应被丢弃，不能沿带到重连后的新连接，
  // 否则会与后续基于 SessionStore 的 DUP 重放形成重复出站。
  client.on_transport_close()
  let dropped = client.drain_pending()
  assert_eq(dropped.length(), 0)
  // 重连后的待发序列只能是一条全新 CONNECT（"async-test" 10 字节，帧长 24）。
  client.reconnect()
  let fresh = client.drain_pending()
  assert_eq(fresh[0], 0x10)
  assert_eq(fresh.length(), 24)
}

///|
/// 畸形固定头（报文类型 0 保留）必须落成 fatal：帧边界已丢，实例不该再吃字节。
test "malformed frame sets fatal and freezes the client" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let _ = client.drain_pending()
  assert_true(client.fatal() is None)
  // 0x00 = 保留报文类型 → Framer 判畸形头，产出 FramerError 事件
  client.feed_bytes([0x00, 0x00])
  assert_true(client.fatal() is Some(msg) && msg.length() > 0)
  let evs = client.drain_events()
  assert_eq(evs.length(), 1)
  // 之后继续喂合法 CONNACK 也不许再生效（冻结）
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  assert_eq(client.drain_events().length(), 0)
  assert_true(client.state() is @core.CoreState::Connecting)
}

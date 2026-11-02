/// async 包最小骨架测试：构造 → 初始待发 CONNECT → feed CONNACK →
/// 事件派发 / 状态迁移 / 队列 drain。

test "new queues connect frame as initial pending" {
  let client = @async.AsyncClient::new(@protocol.ConnectPacket::new("async-test"))
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

test "feed connack yields event and transitions state" {
  let client = @async.AsyncClient::new(@protocol.ConnectPacket::new("async-test"))
  let _ = client.drain_pending() // 丢掉初始 CONNECT
  // 喂 CONNACK Accepted
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let evs = client.drain_events()
  assert_eq(evs.length(), 1)
  match evs[0] {
    @core.CoreEvent::ConnackReceived(c) => {
      match c.return_code {
        @protocol.ConnectReturnCode::ConnectionAccepted => ()
        _ => fail("expected ConnectionAccepted")
      }
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

test "feed qos1 publish queues puback as outgoing" {
  let client = @async.AsyncClient::new(@protocol.ConnectPacket::new("async-test"))
  let _ = client.drain_pending()
  // 先 CONNACK 进入 Connected
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  let _ = client.drain_events()
  // 构造一条入站 QoS1 PUBLISH（pid=5）：topic "a/b"，payload [0x01]
  let pkt = @protocol.PublishPacket::new(
    "a/b", [0x01], @protocol.qos1(), false, false, 5
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

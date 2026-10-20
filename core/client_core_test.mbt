/// Day 1 单测：CONNECT 黄金字节 / CONNACK / QoS0 PUBLISH 往返 / 半包 / 粘包。
///
/// 注：本文件是 _test.mbt，按仓库惯例所有当前包类型加 @core. 前缀，
/// 跨包类型加 @protocol. 前缀。跨包 enum variant 不能直接构造
/// （"Cannot create values of the read-only type"），用 match 模式匹配代替 assert_eq。

test "connect golden bytes core-test" {
  let pkt = @protocol.ConnectPacket::new("core-test")
  let bytes = @protocol.encode_connect(pkt)
  // "core-test" = 9 字节，剩余长度 = 可变头(10) + 载荷(2+9=11) = 21 = 0x15
  assert_eq(
    bytes,
    [
      0x10, 0x15, 0x00, 0x04, 0x4D, 0x51, 0x54, 0x54, 0x04, 0x02, 0x00, 0x3C,
      0x00, 0x09, 0x63, 0x6F, 0x72, 0x65, 0x2D, 0x74, 0x65, 0x73, 0x74,
    ],
  )
}

test "start emits connect frame" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  let frame = core.start()
  assert_eq(
    frame,
    [
      0x10, 0x15, 0x00, 0x04, 0x4D, 0x51, 0x54, 0x54, 0x04, 0x02, 0x00, 0x3C,
      0x00, 0x09, 0x63, 0x6F, 0x72, 0x65, 0x2D, 0x74, 0x65, 0x73, 0x74,
    ],
  )
  // 初始状态仍是 Connecting
  match core.state() {
    @core.CoreState::Connecting => ()
    _ => fail("expected Connecting state")
  }
}

test "connack transitions to connected" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  let _ = core.start() // 发出 CONNECT（不校验内容，只推进状态）
  match core.feed([0x20, 0x02, 0x00, 0x00]) {
    (events, outgoing) => {
      assert_eq(events.length(), 1)
      assert_eq(outgoing.length(), 0)
      match events[0] {
        @core.CoreEvent::ConnackReceived(c) => {
          // return_code = 0 = ConnectionAccepted（跨包 enum variant 不能直接构造，
          // 用 match 模式匹配代替 assert_eq）
          match c.return_code {
            @protocol.ConnectReturnCode::ConnectionAccepted => ()
            _ => fail("expected ConnectionAccepted")
          }
        }
        _ => fail("expected ConnackReceived")
      }
      match core.state() {
        @core.CoreState::Connected => ()
        _ => fail("expected Connected state")
      }
    }
  }
}

test "qos0 publish roundtrip" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  // 构造一个 QoS0 PUBLISH 帧：topic "a/b"、payload [0x01,0x02,0x03]
  let pkt = @protocol.PublishPacket::new(
    "a/b", [0x01, 0x02, 0x03], @protocol.qos0(), false, false, 0
  )
  let frame = @protocol.encode_publish(pkt)
  match core.feed(frame) {
    (events, outgoing) => {
      assert_eq(events.length(), 1)
      assert_eq(outgoing.length(), 0) // Day 1 不自动回 PUBACK
      match events[0] {
        @core.CoreEvent::PublishReceived(p) => {
          assert_eq(p.topic, "a/b")
          assert_eq(p.payload, [0x01, 0x02, 0x03])
          assert_eq(p.qos, @protocol.qos0())
        }
        _ => fail("expected PublishReceived")
      }
    }
  }
}

test "half packet split across two feeds" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  // 第一次只喂 CONNACK 的固定头 + 剩余长度
  match core.feed([0x20, 0x02]) {
    (events, _) => {
      assert_eq(events.length(), 0)
    }
  }
  // 第二次喂完剩余两个字节
  match core.feed([0x00, 0x00]) {
    (events, _) => {
      assert_eq(events.length(), 1)
      match events[0] {
        @core.CoreEvent::ConnackReceived(_) => ()
        _ => fail("expected ConnackReceived")
      }
      match core.state() {
        @core.CoreState::Connected => ()
        _ => fail("expected Connected state")
      }
    }
  }
}

test "sticky packet two frames in one feed" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  // 一次喂 CONNACK + PINGRESP 两帧字节
  let batch = [0x20, 0x02, 0x00, 0x00, 0xD0, 0x00]
  match core.feed(batch) {
    (events, _) => {
      assert_eq(events.length(), 2)
      match events[0] {
        @core.CoreEvent::ConnackReceived(_) => ()
        _ => fail("first event should be ConnackReceived")
      }
      match events[1] {
        @core.CoreEvent::PingRespReceived => ()
        _ => fail("second event should be PingRespReceived")
      }
    }
  }
}

test "pingreq increments pending_pings and pingresp decrements" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  assert_eq(core.pending_pings(), 0)
  let req = core.pingreq()
  assert_eq(req, [0xC0, 0x00])
  assert_eq(core.pending_pings(), 1)
  // 收到 PINGRESP
  match core.feed([0xD0, 0x00]) {
    (events, _) => {
      assert_eq(events.length(), 1)
      match events[0] {
        @core.CoreEvent::PingRespReceived => ()
        _ => fail("expected PingRespReceived")
      }
      assert_eq(core.pending_pings(), 0)
    }
  }
}

test "framer leftover buffer drains on next feed" {
  let f = @core.Framer::new()
  // 半包：CONNACK 固定头 + 剩余长度
  let frames1 = f.feed([0x20, 0x02])
  assert_eq(frames1.length(), 0)
  assert_eq(f.len(), 2)
  // 补全
  let frames2 = f.feed([0x00, 0x00])
  assert_eq(frames2.length(), 1)
  assert_eq(frames2[0], [0x20, 0x02, 0x00, 0x00])
  assert_eq(f.len(), 0)
}

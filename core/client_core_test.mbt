/// 单测：CONNECT 黄金字节 / CONNACK / QoS0 PUBLISH 往返 / 半包 / 粘包。
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
      assert_eq(outgoing.length(), 0) // QoS0 不自动回 PUBACK
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

// ---------- QoS1/2 自动握手 ----------

// 构造一条 QoS1 PUBLISH 帧（topic="a/b"，payload=[0x01]，packet_id=7）。
// 字节 = 固定头(0x32, 0x08) + topic(00 02 61 2F 62) + pid(00 07) + payload(01)
fn qos1_publish_frame(pid : Int) -> Array[Int] {
  let qos = @protocol.qos1()
  let pkt = @protocol.PublishPacket::new("a/b", [0x01], qos, false, false, pid)
  return @protocol.encode_publish(pkt)
}

// 构造一条 QoS2 PUBLISH 帧（topic="a/b"，payload=[0x01]）。
fn qos2_publish_frame(pid : Int) -> Array[Int] {
  let qos = @protocol.qos2()
  let pkt = @protocol.PublishPacket::new("a/b", [0x01], qos, false, false, pid)
  return @protocol.encode_publish(pkt)
}

test "qos1 publish auto replies puback" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  // 先 CONNACK 进入 Connected
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  // 喂 QoS1 PUBLISH，packet_id=7
  match core.feed(qos1_publish_frame(7)) {
    (events, outgoing) => {
      // 1 个事件：PublishReceived
      assert_eq(events.length(), 1)
      match events[0] {
        @core.CoreEvent::PublishReceived(p) => {
          assert_eq(p.packet_id, 7)
          assert_eq(@protocol.qos_value(p.qos), 1)
        }
        _ => fail("expected PublishReceived")
      }
      // 出站字节 = PUBACK(0x40, rlen=2, pid=7)
      assert_eq(outgoing, [0x40, 0x02, 0x00, 0x07])
    }
  }
}

test "qos2 publish auto replies pubrec" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  // 喂 QoS2 PUBLISH，packet_id=9
  match core.feed(qos2_publish_frame(9)) {
    (events, outgoing) => {
      assert_eq(events.length(), 1)
      match events[0] {
        @core.CoreEvent::PublishReceived(p) => {
          assert_eq(p.packet_id, 9)
          assert_eq(@protocol.qos_value(p.qos), 2)
        }
        _ => fail("expected PublishReceived")
      }
      // 出站字节 = PUBREC(0x50, rlen=2, pid=9)
      assert_eq(outgoing, [0x50, 0x02, 0x00, 0x09])
    }
  }
}

test "pubrel auto replies pubcomp after qos2 publish" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  // 第一步：收到 QoS2 PUBLISH(pid=9) → 自动回 PUBREC
  let _ = core.feed(qos2_publish_frame(9))
  // 第二步：broker 回 PUBREL(pid=9) → 应自动回 PUBCOMP(0x70, pid=9)
  match core.feed([0x62, 0x02, 0x00, 0x09]) {
    (events, outgoing) => {
      // 入站 PUBREL 不产生业务事件
      assert_eq(events.length(), 0)
      // 出站字节 = PUBCOMP(0x70, rlen=2, pid=9)
      assert_eq(outgoing, [0x70, 0x02, 0x00, 0x09])
    }
  }
}

test "inbound puback clears outbound inflight via session" {
  // 构造一条在途 QoS1 PUBLISH（packet_id=1），注入 core；
  // 然后喂 PUBACK(pid=1)，断言 core 内部 inflight 归零。
  let seed = @protocol.PublishPacket::new(
    "out/t", [0xAA], @protocol.qos1(), false, false, 0
  )
  match @session.record_outbound(@session.SessionStore::new(), seed) {
    (store, pid) => {
      assert_eq(pid, 1)
      assert_eq(store.inflight_count(), 1)
      let core = @core.ClientCore::with_session(
        @protocol.ConnectPacket::new("core-test"), store
      )
      let _ = core.feed([0x20, 0x02, 0x00, 0x00]) // CONNACK
      // 喂 PUBACK(pid=1)
      match core.feed([0x40, 0x02, 0x00, 0x01]) {
        (events, outgoing) => {
          assert_eq(events.length(), 0)
          assert_eq(outgoing.length(), 0)
        }
      }
      // inflight 已被清理
      assert_eq(core.session().inflight_count(), 0)
    }
  }
}

test "inbound pubrec triggers pubrel for outbound qos2" {
  // 构造一条在途 QoS2 PUBLISH（WaitPubrec 阶段，packet_id=1），注入 core；
  // 收到 broker 回的 PUBREC(pid=1)，应自动产出 PUBREL 出站字节。
  let seed = @protocol.PublishPacket::new(
    "out/t", [0xAA], @protocol.qos2(), false, false, 0
  )
  match @session.record_outbound(@session.SessionStore::new(), seed) {
    (store, pid) => {
      assert_eq(pid, 1)
      let core = @core.ClientCore::with_session(
        @protocol.ConnectPacket::new("core-test"), store
      )
      let _ = core.feed([0x20, 0x02, 0x00, 0x00]) // CONNACK
      // 喂 PUBREC(pid=1)
      match core.feed([0x50, 0x02, 0x00, 0x01]) {
        (events, outgoing) => {
          assert_eq(events.length(), 0)
          // 出站字节 = PUBREL(0x62, rlen=2, pid=1)
          assert_eq(outgoing, [0x62, 0x02, 0x00, 0x01])
        }
      }
      // 此时在途仍存在（WaitPubcomp 阶段，等 PUBCOMP）
      assert_eq(core.session().inflight_count(), 1)
    }
  }
}

test "inbound pubcomp clears outbound qos2 inflight" {
  // 构造一条在途 QoS2 PUBLISH，先 PUBREC 推进到 WaitPubcomp，再喂 PUBCOMP，
  // 断言 inflight 归零。
  let seed = @protocol.PublishPacket::new(
    "out/t", [0xAA], @protocol.qos2(), false, false, 0
  )
  match @session.record_outbound(@session.SessionStore::new(), seed) {
    (store, pid) => {
      let core = @core.ClientCore::with_session(
        @protocol.ConnectPacket::new("core-test"), store
      )
      let _ = core.feed([0x20, 0x02, 0x00, 0x00]) // CONNACK
      let _ = core.feed([0x50, 0x02, 0x00, pid]) // PUBREC → WaitPubcomp
      // 喂 PUBCOMP(pid)
      match core.feed([0x70, 0x02, 0x00, pid]) {
        (events, outgoing) => {
          assert_eq(events.length(), 0)
          assert_eq(outgoing.length(), 0)
        }
      }
      assert_eq(core.session().inflight_count(), 0)
    }
  }
}

// ---------- 断线重连 ----------

test "on_transport_close moves to disconnected and reconnect_bytes reproduces start" {
  // "ws-spike" = 8 字节 client id → CONNECT 帧总长 = 2 + 10 + 2 + 8 = 22 字节。
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("ws-spike"))
  let first = core.start()
  assert_eq(first.length(), 22)
  // 先 CONNACK 进入 Connected
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  match core.state() {
    @core.CoreState::Connected => ()
    _ => fail("expected Connected before close")
  }
  // 模拟 transport 断开
  core.on_transport_close()
  match core.state() {
    @core.CoreState::Disconnected => ()
    _ => fail("expected Disconnected after on_transport_close")
  }
  // 重连拿新 CONNECT 字节：与首次 start() 字节完全一致
  let second = core.reconnect_bytes()
  assert_eq(second.length(), 22)
  assert_eq(second, first)
  // 状态切回 Connecting（等新 CONNACK）
  match core.state() {
    @core.CoreState::Connecting => ()
    _ => fail("expected Connecting after reconnect_bytes")
  }
}

test "reconnect preserves in-flight session and continues qos handshake" {
  // 种子：一条在途 QoS1 PUBLISH（pid=1）注入 core。
  let seed = @protocol.PublishPacket::new(
    "out/t", [0xAA], @protocol.qos1(), false, false, 0
  )
  match @session.record_outbound(@session.SessionStore::new(), seed) {
    (store, pid) => {
      assert_eq(pid, 1)
      assert_eq(store.inflight_count(), 1)
      let core = @core.ClientCore::with_session(
        @protocol.ConnectPacket::new("ws-spike"), store
      )
      let _ = core.start() // CONNECT
      let _ = core.feed([0x20, 0x02, 0x00, 0x00]) // 首联 CONNACK → Connected
      assert_eq(core.session().inflight_count(), 1)
      // 断线
      core.on_transport_close()
      match core.state() {
        @core.CoreState::Disconnected => ()
        _ => fail("expected Disconnected")
      }
      // 断线后 session 仍在（in-flight 不丢）
      assert_eq(core.session().inflight_count(), 1)
      // 重连：拿新 CONNECT 字节
      let reconnect = core.reconnect_bytes()
      assert_eq(reconnect.length(), 22)
      match core.state() {
        @core.CoreState::Connecting => ()
        _ => fail("expected Connecting after reconnect_bytes")
      }
      // 重连后喂新 CONNACK → 状态迁移回 Connected
      let _ = core.feed([0x20, 0x02, 0x00, 0x00])
      match core.state() {
        @core.CoreState::Connected => ()
        _ => fail("expected Connected after second CONNACK")
      }
      // session 还在，in-flight 仍为 1
      assert_eq(core.session().inflight_count(), 1)
      // 喂 PUBACK(pid=1) → in-flight 被清理，说明重连后握手继续推进
      match core.feed([0x40, 0x02, 0x00, pid]) {
        (events, outgoing) => {
          assert_eq(events.length(), 0)
          assert_eq(outgoing.length(), 0)
        }
      }
      assert_eq(core.session().inflight_count(), 0)
    }
  }
}

// ---------- 出站 QoS1/2 PUBLISH 完整握手（core.publish 接入 record_outbound） ----------

test "outbound qos1 publish records inflight and puback clears" {
  // core.publish(qos1) 应自动分配 pid=1、记入 session，
  // 喂 PUBACK(pid=1) 后 inflight 清零。
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00]) // CONNACK → Connected
  let bytes = core.publish("out/t", [0xAA], @protocol.qos1())
  // PUBLISH 帧：0x32 (qos1) + rlen=10 + topic(00 05 6F 75 74 2F 74) + pid(00 01) + payload(AA)
  assert_eq(bytes[0], 0x32)
  assert_eq(bytes[1], 10)
  assert_eq(bytes[9], 0x00) // pid high
  assert_eq(bytes[10], 0x01) // pid low
  // session 有 1 条在途
  assert_eq(core.session().inflight_count(), 1)
  // 喂 PUBACK(pid=1) → 清理
  match core.feed([0x40, 0x02, 0x00, 0x01]) {
    (events, outgoing) => {
      assert_eq(events.length(), 0)
      assert_eq(outgoing.length(), 0)
    }
  }
  assert_eq(core.session().inflight_count(), 0)
}

test "outbound qos2 publish full handshake pubrec pubrel pubcomp" {
  // core.publish(qos2) → 自动记录在途；
  // 喂 PUBREC(pid=1) → 自动产出 PUBREL 字节；
  // 喂 PUBCOMP(pid=1) → inflight 清零。
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00]) // CONNACK
  let _ = core.publish("out/qos2", [0xBB], @protocol.qos2())
  assert_eq(core.session().inflight_count(), 1)
  // 喂 PUBREC(pid=1)
  match core.feed([0x50, 0x02, 0x00, 0x01]) {
    (events, outgoing) => {
      assert_eq(events.length(), 0)
      // 出站字节 = PUBREL(0x62, pid=1)
      assert_eq(outgoing, [0x62, 0x02, 0x00, 0x01])
    }
  }
  // 仍在 WaitPubcomp 阶段
  assert_eq(core.session().inflight_count(), 1)
  // 喂 PUBCOMP(pid=1)
  match core.feed([0x70, 0x02, 0x00, 0x01]) {
    (events, outgoing) => {
      assert_eq(events.length(), 0)
      assert_eq(outgoing.length(), 0)
    }
  }
  assert_eq(core.session().inflight_count(), 0)
}

test "reconnect after outbound qos2 publish replays dup publish" {
  // 发 QoS2 PUBLISH 后断线，reconnect_bytes() 保留 session；
  // replay_bytes() 应产出 DUP=1 的 PUBLISH 帧（WaitPubrec 阶段）。
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("ws-spike"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00]) // CONNACK
  let _ = core.publish("out/t", [0xCC], @protocol.qos2())
  assert_eq(core.session().inflight_count(), 1)
  // 断线
  core.on_transport_close()
  // 重连：拿新 CONNECT 字节
  let reconnect = core.reconnect_bytes()
  assert_eq(reconnect.length(), 22)
  // session 仍在
  assert_eq(core.session().inflight_count(), 1)
  // replay_bytes 产出 DUP=1 的 PUBLISH
  let replay = core.replay_bytes()
  assert_eq(replay.length(), 1)
  // DUP flag = 0x08，所以 PUBLISH 第一个字节 = 0x30 | 0x08 | (2<<1) = 0x3C
  assert_eq(replay[0][0], 0x3C)
  // 喂新 CONNACK → Connected
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  // 喂 PUBREC → 自动 PUBREL
  match core.feed([0x50, 0x02, 0x00, 0x01]) {
    (_, outgoing) => {
      assert_eq(outgoing, [0x62, 0x02, 0x00, 0x01])
    }
  }
  // 喂 PUBCOMP → 清理
  let _ = core.feed([0x70, 0x02, 0x00, 0x01])
  assert_eq(core.session().inflight_count(), 0)
}

test "connack refused stays disconnected" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  let _ = core.start()
  // return_code=4 BadUsernameOrPassword
  let _ = core.feed([0x20, 0x02, 0x00, 0x04])
  match core.state() {
    @core.CoreState::Disconnected => ()
    _ => fail("expected Disconnected after refused CONNACK")
  }
}

test "inbound qos2 duplicate is delivered once" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  let _ = core.feed([0x20, 0x02, 0x00, 0x00])
  let pkt = @protocol.PublishPacket::new(
    "a/b", [0x01], @protocol.qos2(), false, false, 7
  )
  let frame = @protocol.encode_publish(pkt)
  match core.feed(frame) {
    (events, outgoing) => {
      assert_eq(events.length(), 1)
      assert_eq(outgoing, [0x50, 0x02, 0x00, 0x07])
    }
  }
  // 重复 PUBLISH：只回 PUBREC，不再派发
  match core.feed(frame) {
    (events, outgoing) => {
      assert_eq(events.length(), 0)
      assert_eq(outgoing, [0x50, 0x02, 0x00, 0x07])
    }
  }
  // PUBREL → PUBCOMP，并清掉去重表
  match core.feed([0x62, 0x02, 0x00, 0x07]) {
    (_, outgoing) => assert_eq(outgoing, [0x70, 0x02, 0x00, 0x07])
  }
  // 握手完成后再来同 pid 的新 PUBLISH，应重新派发
  match core.feed(frame) {
    (events, _) => assert_eq(events.length(), 1)
  }
}

test "unknown packet type reports actual type" {
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("core-test"))
  match core.feed([0xE0, 0x00]) {
    (events, _) => {
      assert_eq(events.length(), 1)
      match events[0] {
        @core.CoreEvent::UnknownPacketType(t) => assert_eq(t, 14)
        _ => fail("expected UnknownPacketType")
      }
    }
  }
}

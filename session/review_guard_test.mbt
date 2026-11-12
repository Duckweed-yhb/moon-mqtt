///|
/// 评审回归：ACK 必须与在途条目的握手阶段匹配。
///
/// 旧实现无条件按 packet_id 删除，一条 QoS2 在 `WaitPubrec` 阶段收到 PUBACK
/// 就被清掉，PUBREL 永远不会发出——QoS2 静默降级成至多一次，且不报协议错误。
test "on_puback only completes qos1 entries" {
  let qos1 = @protocol.PublishPacket::new(
    "s/t",
    [0x01],
    @protocol.qos1(),
    false,
    false,
    0,
  )
  match @session.record_outbound(@session.SessionStore::new(), qos1) {
    (store, pid) => {
      assert_eq(store.inflight_count(), 1)
      // 阶段匹配：清掉
      assert_eq(@session.on_puback(store, pid).inflight_count(), 0)
      // 阶段不匹配（PUBCOMP 是 QoS2 的收尾）：必须保留
      let still = @session.on_pubcomp(store, pid)
      assert_eq(still.inflight_count(), 1)
    }
  }
}

///|
test "on_puback does not clear a qos2 entry waiting for pubrec" {
  let qos2 = @protocol.PublishPacket::new(
    "s/t",
    [0x02],
    @protocol.qos2(),
    false,
    false,
    0,
  )
  match @session.record_outbound(@session.SessionStore::new(), qos2) {
    (store, pid) => {
      // WaitPubrec 阶段收到 PUBACK：错序，保留
      let after_bogus = @session.on_puback(store, pid)
      assert_eq(after_bogus.inflight_count(), 1)
      // 正常推进到 WaitPubcomp 之后，PUBCOMP 才该清掉
      match @session.on_pubrec(after_bogus, pid) {
        (after_pubrec, pubrel) => {
          assert_eq(pubrel, [0x62, 0x02, 0x00, 0x01])
          assert_eq(after_pubrec.inflight_count(), 1)
          assert_eq(@session.on_pubcomp(after_pubrec, pid).inflight_count(), 0)
        }
      }
    }
  }
}

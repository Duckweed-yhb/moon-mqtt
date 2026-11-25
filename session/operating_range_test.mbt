///|
test "QoS2 restore replays PUBREL across packet identifier boundaries" {
  for n in 0..<2000 {
    let id = 1 + (65500 + n) % 65535
    let s = @session.SessionStore::from_parts(id, [])
    let pkt = @protocol.PublishPacket::new(
      "stream",
      [id & 255],
      @protocol.qos2(),
      false,
      false,
      0,
    )
    let (s, pid) = @session.record_outbound(s, pkt)
    assert_eq(pid, id)
    let (s, rel) = @session.on_pubrec(s, id)
    let (s, duplicate_rel) = @session.on_pubrec(s, id)
    assert_eq(duplicate_rel, rel)
    let (cursor, items) = s.snapshot()
    let resumed = @session.SessionStore::restore(cursor, items).unwrap()
    assert_eq(@session.replay(resumed), [rel])
    assert_eq(rel, [0x62, 2, id >> 8, id & 255])
    assert_eq(@session.on_pubcomp(resumed, id).inflight_count(), 0)
  }
}

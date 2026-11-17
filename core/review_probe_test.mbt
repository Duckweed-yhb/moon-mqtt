///|
test "probe mixed suback loses accepted topic" {
  let c = @core.ClientCore::new(@protocol.ConnectPacket::new("probe"))
  let _ = c.feed([0x20, 2, 0, 0])
  c.record_outbound_subscribe(7, [
    @protocol.Subscription::new("a", @protocol.qos1()),
    @protocol.Subscription::new("b", @protocol.qos1()),
  ])
  let _ = c.feed([0x90, 4, 0, 7, 1, 0x80])
  assert_eq(c.subscriptions().length(), 1)
}

///|
test "mixed suback restores successful topic after session loss" {
  let c = @core.ClientCore::new(@protocol.ConnectPacket::new("probe"))
  let _ = c.feed([0x20, 2, 0, 0])
  c.record_outbound_subscribe(7, [
    @protocol.Subscription::new("a", @protocol.qos1()),
    @protocol.Subscription::new("b", @protocol.qos1()),
  ])
  let _ = c.feed([0x90, 4, 0, 7, 1, 0x80])
  c.on_transport_close()
  let _ = c.reconnect_bytes()
  let (_, outgoing) = c.feed([0x20, 2, 0, 0])
  assert_eq(outgoing, [0x82, 6, 0, 1, 0, 1, 0x61, 1])
}

///|
test "malformed frame stops subsequent delivery in same batch" {
  let c = @core.ClientCore::new(@protocol.ConnectPacket::new("guard"))
  let _ = c.feed([0x20, 2, 0, 0])
  // Empty topic is invalid; the following valid PUBLISH must not be delivered.
  let (events, outgoing) = c.feed([0x30, 2, 0, 0, 0x30, 3, 0, 1, 0x61])
  assert_eq(events.length(), 1)
  assert_eq(outgoing.length(), 0)
  match c.state() {
    @core.Disconnected => ()
    _ => fail("must disconnect")
  }
  assert_eq(c.publish("a", [1], @protocol.qos1()).length(), 0)
}

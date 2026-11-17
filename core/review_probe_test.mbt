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

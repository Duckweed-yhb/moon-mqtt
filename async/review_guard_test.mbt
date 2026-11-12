///|
/// 评审回归：`reconnect()` 必须解冻。
///
/// `fatal` 的语义是「这条连接不可再用」，而 reconnect 的语义正是换一条新连接；
/// 不清 fatal 的话，reconnect 只是把 CONNECT 塞进待发队列，`feed_bytes` 却永远
/// 早退——客户端看起来活着，实际再也不会推进。
test "reconnect clears a fatal freeze" {
  let client = @async.AsyncClient::new(
    @protocol.ConnectPacket::new("async-test"),
  )
  let _ = client.drain_pending()
  // 0x00 = 保留报文类型 → framer 判畸形头 → Fatal
  client.feed_bytes([0x00, 0x00])
  assert_true(client.fatal() is Some(_))
  client.reconnect()
  assert_true(client.fatal() is None)
  // 解冻后必须能继续推进：新 CONNACK 应产生事件
  client.feed_bytes([0x20, 0x02, 0x00, 0x00])
  assert_true(client.drain_events().length() > 0)
}

///|
/// keep_alive 纯计算单测：禁用、等待、发 ping、判定死链。

///|
test "keep alive: disabled never pings" {
  assert_true(@core.next_action(1000000, 0, 0, 0) is @core.Wait)
}

///|
test "keep alive: waits before half the keep alive" {
  // keep_alive=60s，一半是 30s；过去 29.9s 还不到点
  assert_true(@core.next_action(29900, 0, 0, 60) is @core.Wait)
}

///|
test "keep alive: pings at half the keep alive" {
  assert_true(@core.next_action(30000, 0, 0, 60) is @core.SendPing)
}

///|
test "keep alive: pings again after another half cycle" {
  assert_true(@core.next_action(60000, 30000, 1, 60) is @core.SendPing)
}

///|
test "keep alive: closes after three unanswered pings" {
  assert_true(@core.next_action(120000, 90000, 3, 60) is @core.Close)
}

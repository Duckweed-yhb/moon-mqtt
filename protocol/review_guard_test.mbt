///|
/// 评审回归：UNSUBACK 必须和 SUBACK 一样严格（§3.11：剩余长度恒为 2）。
///
/// 旧实现只检查总长 ≥4 与首字节，`data[1]` 的剩余长度完全不看、pid=0 也放过：
/// 截断的 UNSUBACK 会被当成成功，pid=0 的变体到调用方那里变成
/// "UNSUBACK id mismatch"，把协议错误报成业务错误。
test "decode_unsuback accepts the canonical frame" {
  match @protocol.decode_unsuback([0xB0, 0x02, 0x00, 0x07]) {
    Ok(pid) => assert_eq(pid, 7)
    Err(e) => fail("unexpected err: " + e)
  }
}

///|
test "decode_unsuback rejects packet id zero" {
  assert_true(
    match @protocol.decode_unsuback([0xB0, 0x02, 0x00, 0x00]) {
      Err(_) => true
      Ok(_) => false
    },
  )
}

///|
test "decode_unsuback rejects wrong remaining length" {
  assert_true(
    match @protocol.decode_unsuback([0xB0, 0x03, 0x00, 0x07, 0x00]) {
      Err(_) => true
      Ok(_) => false
    },
  )
  // 剩余长度字段与实际字节数不一致
  assert_true(
    match @protocol.decode_unsuback([0xB0, 0x07, 0x00, 0x07]) {
      Err(_) => true
      Ok(_) => false
    },
  )
  // 帧尾多余字节
  assert_true(
    match @protocol.decode_unsuback([0xB0, 0x02, 0x00, 0x07, 0x99]) {
      Err(_) => true
      Ok(_) => false
    },
  )
}

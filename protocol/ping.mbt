/// PINGREQ（3.1.1 §3.12）/ PINGRESP（§3.13）/ DISCONNECT（§3.14）。
/// 三者均无可变头与载荷，固定头即可。

pub fn encode_pingreq() -> Array[Int] {
  return [0xC0, 0x00]
}

pub fn encode_pingresp() -> Array[Int] {
  return [0xD0, 0x00]
}

pub fn encode_disconnect() -> Array[Int] {
  return [0xE0, 0x00]
}

/// 判断给定完整报文是否为 PINGRESP。
pub fn is_pingresp(data : Array[Int]) -> Bool {
  return data.length() == 2 && data[0] == 0xD0 && data[1] == 0x00
}

test "ping and disconnect" {
  assert_eq(encode_pingreq(), [0xC0, 0x00])
  assert_eq(encode_pingresp(), [0xD0, 0x00])
  assert_eq(encode_disconnect(), [0xE0, 0x00])
  assert_eq(is_pingresp([0xD0, 0x00]), true)
  assert_eq(is_pingresp([0xC0, 0x00]), false)
}

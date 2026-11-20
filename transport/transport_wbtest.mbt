///|
/// transport 字节范围检查的白盒回归：`write` 的入参在交给 C 之前必须
/// 全是 0-255，越界要带下标报出来，不能让 C 侧按低 8 位静默截断。

///|
test "byte range accepts 0 to 255" {
  let bytes : Array[Int32] = [0, 1, 127, 128, 255]
  assert_true(byte_range_error(bytes) is None)
}

///|
test "byte range reports negative and oversized bytes" {
  let negative : Array[Int32] = [1, 2, -1]
  match byte_range_error(negative) {
    Some(e) => {
      assert_true(e.contains("index 2"))
      assert_true(e.contains("-1"))
    }
    None => fail("negative byte must be rejected")
  }
  let oversized : Array[Int32] = [0, 300]
  match byte_range_error(oversized) {
    Some(e) => {
      assert_true(e.contains("index 1"))
      assert_true(e.contains("300"))
    }
    None => fail("byte above 255 must be rejected")
  }
}

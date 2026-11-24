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

///|
/// 坏 fd 上读：recv 出错要报成读失败，不能和「对端正常关闭」混成同一句 EOF。
test "read_some reports socket error instead of EOF" {
  let client : TcpClient = { fd: -1L, host: "none", port: 0, }
  match client.read_some(4) {
    Ok(_) => fail("invalid socket must not yield bytes")
    Err(e) => {
      assert_true(e.contains("read failed"))
      assert_false(e.contains("EOF"))
    }
  }
}

///|
/// `read_some` 的 max 守卫：0 和负数必须在进 C 之前报错，不能让 C 侧
/// 换成 4096 悄悄读一批字节回来。
test "read_some rejects non positive max before reaching C" {
  let client : TcpClient = { fd: -1L, host: "none", port: 0, }
  match client.read_some(0) {
    Ok(_) => fail("max = 0 must be rejected")
    Err(e) => assert_true(e.contains("max must be positive"))
  }
  match client.read_some(-3) {
    Ok(_) => fail("negative max must be rejected")
    Err(e) => assert_true(e.contains("-3"))
  }
}

///|
/// select 出错时 C 侧给 -2，这里要报成 select 错误，而不是笼统的失败。
test "wait_read reports the select error code" {
  let client : TcpClient = { fd: -1L, host: "none", port: 0, }
  match client.wait_read(0) {
    Err(e) => assert_true(e.contains("select error"))
    Ok(_) => fail("invalid socket must not report readable or timeout")
  }
}

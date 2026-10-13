/// ByteWriter / ByteReader（无状态读端）往返测试。

test "writer reader roundtrip" {
  let w = @protocol.ByteWriter::new()
  w.push_byte(0x10)
  w.push_u16(300) // 大端 → 0x01 0x2C
  w.push_string("MQTT")
  w.push_binary([1, 2, 3])
  w.push_remaining_length(128) // → 0x80 0x01
  let data = w.bytes()
  let r = @protocol.ByteReader::new(data)
  let mut pos = 0
  match r.read_byte(pos) {
    Ok((b, p)) => {
      assert_eq(b, 0x10)
      pos = p
    }
    Err(e) => fail(e)
  }
  match r.read_u16(pos) {
    Ok((v, p)) => {
      assert_eq(v, 300)
      pos = p
    }
    Err(e) => fail(e)
  }
  match r.read_string(pos) {
    Ok((s, p)) => {
      assert_eq(s, "MQTT")
      pos = p
    }
    Err(e) => fail(e)
  }
  match r.read_binary(pos) {
    Ok((b, p)) => {
      assert_eq(b, [1, 2, 3])
      pos = p
    }
    Err(e) => fail(e)
  }
  match r.read_remaining_length(pos) {
    Ok((v, p)) => {
      assert_eq(v, 128)
      pos = p
    }
    Err(e) => fail(e)
  }
  assert_eq(pos, data.length())
}

test "writer reader chinese string" {
  let w = @protocol.ByteWriter::new()
  w.push_string("IoT/设备/状态")
  let data = w.bytes()
  let r = @protocol.ByteReader::new(data)
  match r.read_string(0) {
    Ok((s, _)) => assert_eq(s, "IoT/设备/状态")
    Err(e) => fail(e)
  }
}

test "reader out of range" {
  let r = @protocol.ByteReader::new([])
  assert_true(match r.read_byte(0) {
    Err(_) => true
    Ok(_) => false
  })
}

test "reader binary truncated" {
  // 声明长度 5 但只剩 2 字节
  let r = @protocol.ByteReader::new([0x00, 0x05, 0x01, 0x02])
  assert_true(match r.read_binary(0) {
    Err(_) => true
    Ok(_) => false
  })
}

test "writer bytes length matches reader" {
  let w = @protocol.ByteWriter::new()
  w.push_string("a")
  w.push_u16(1)
  let data = w.bytes()
  // "a" 编码: 00 01 61；u16(1): 00 01
  assert_eq(data, [0x00, 0x01, 0x61, 0x00, 0x01])
}

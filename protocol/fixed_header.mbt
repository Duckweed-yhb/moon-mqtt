/// MQTT 3.1.1 控制报文类型，见规范 §2.2.1 表 2-1。
///
/// 每个报文的第一字节高 4 位是类型，低 4 位是 flags。
pub enum PacketType {
  Connect // 1
  Connack // 2
  Publish // 3
  Puback // 4
  Pubrec // 5
  Pubrel // 6
  Pubcomp // 7
  Subscribe // 8
  Suback // 9
  Unsubscribe // 10
  Unsuback // 11
  Pingreq // 12
  Pingresp // 13
  Disconnect // 14
} derive(Eq, Debug)

/// PacketType 到协议字节值。
pub fn packet_type_value(t : PacketType) -> Int {
  match t {
    PacketType::Connect => 1
    PacketType::Connack => 2
    PacketType::Publish => 3
    PacketType::Puback => 4
    PacketType::Pubrec => 5
    PacketType::Pubrel => 6
    PacketType::Pubcomp => 7
    PacketType::Subscribe => 8
    PacketType::Suback => 9
    PacketType::Unsubscribe => 10
    PacketType::Unsuback => 11
    PacketType::Pingreq => 12
    PacketType::Pingresp => 13
    PacketType::Disconnect => 14
  }
}

/// 协议字节值（1..=14）到 PacketType；0/15 为保留，返回 None。
pub fn packet_type_from_int(v : Int) -> Option[PacketType] {
  if v == 1 {
    Some(PacketType::Connect)
  } else if v == 2 {
    Some(PacketType::Connack)
  } else if v == 3 {
    Some(PacketType::Publish)
  } else if v == 4 {
    Some(PacketType::Puback)
  } else if v == 5 {
    Some(PacketType::Pubrec)
  } else if v == 6 {
    Some(PacketType::Pubrel)
  } else if v == 7 {
    Some(PacketType::Pubcomp)
  } else if v == 8 {
    Some(PacketType::Subscribe)
  } else if v == 9 {
    Some(PacketType::Suback)
  } else if v == 10 {
    Some(PacketType::Unsubscribe)
  } else if v == 11 {
    Some(PacketType::Unsuback)
  } else if v == 12 {
    Some(PacketType::Pingreq)
  } else if v == 13 {
    Some(PacketType::Pingresp)
  } else if v == 14 {
    Some(PacketType::Disconnect)
  } else {
    None
  }
}

/// 剩余长度变长编码（规范 §2.2.3）：每字节 7 位有效 + MSB 续传，最多 4 字节。
pub fn encode_remaining_length(len : Int) -> Array[Int] {
  let out : Array[Int] = []
  let mut value = len
  let mut count = 0
  while value > 0 && count < 4 {
    let digit0 = value % 128
    value = value / 128
    let digit = if value > 0 { digit0 | 0x80 } else { digit0 }
    out.push(digit)
    count = count + 1
  }
  if count == 0 {
    out.push(0)
  }
  return out
}

/// 剩余长度变长解码，返回 (剩余长度, 下一字节位置)。
/// 失败返回 Err：截断 / 超过 4 字节。
pub fn decode_remaining_length(data : Array[Int], start : Int) -> Result[(Int, Int), String] {
  let mut multiplier = 1
  let mut value = 0
  let mut pos = start
  let mut count = 0
  while true {
    if pos >= data.length() {
      return Err("remaining length truncated")
    }
    if count >= 4 {
      return Err("remaining length exceeds 4 bytes")
    }
    let byte = data[pos]
    value = value + (byte & 0x7f) * multiplier
    if (byte & 0x80) == 0 {
      break
    }
    pos = pos + 1
    multiplier = multiplier * 128
    count = count + 1
  }
  return Ok((value, pos + 1))
}

/// 编码固定头（第一字节 + 剩余长度），见规范 §2.2。
pub fn encode_fixed_header(t : PacketType, flags : Int, remaining_length : Int) -> Array[Int] {
  let byte0 = (packet_type_value(t) << 4) | (flags & 0x0f)
  let out : Array[Int] = []
  out.push(byte0)
  let rl = encode_remaining_length(remaining_length)
  for b in rl {
    out.push(b)
  }
  return out
}

/// 解码固定头，返回 (PacketType, flags, 剩余长度, 下一字节位置)。
pub fn decode_fixed_header(
  data : Array[Int], start : Int
) -> Result[(PacketType, Int, Int, Int), String] {
  if start >= data.length() {
    return Err("empty fixed header")
  }
  let byte0 = data[start]
  match packet_type_from_int(byte0 >> 4) {
    None => Err("reserved packet type")
    Some(t) => {
      let flags = byte0 & 0x0f
      match decode_remaining_length(data, start + 1) {
        Err(e) => Err(e)
        Ok((len, pos)) => Ok((t, flags, len, pos))
      }
    }
  }
}

// 显式声明 trait 方法提升，避免新版工具链弃用警告
pub extend PacketType with Eq::{not_equal, equal}
pub extend PacketType with @moonbitlang/core/debug.Debug::{to_repr}

test "remaining_length encoding" {
  assert_eq(encode_remaining_length(0), [0])
  assert_eq(encode_remaining_length(127), [127])
  assert_eq(encode_remaining_length(128), [0x80, 0x01])
  assert_eq(encode_remaining_length(16383), [0xFF, 0x7F])
  assert_eq(encode_remaining_length(16384), [0x80, 0x80, 0x01])
  assert_eq(encode_remaining_length(268435455), [0xFF, 0xFF, 0xFF, 0x7F])
}

test "remaining_length roundtrip" {
  for n in [0, 1, 127, 128, 255, 256, 16383, 16384, 2097151, 268435455] {
    let enc = encode_remaining_length(n)
    match decode_remaining_length(enc, 0) {
      Ok((v, _)) => assert_eq(v, n)
      Err(_) => fail("decode failed for " + n.to_string())
    }
  }
}

test "remaining_length decode errors" {
  assert_true(match decode_remaining_length([], 0) {
    Err(_) => true
    Ok(_) => false
  })
  // 5 个续传字节 → 超过 4 字节限制
  assert_true(match decode_remaining_length([0x80, 0x80, 0x80, 0x80, 0x01], 0) {
    Err(_) => true
    Ok(_) => false
  })
}

test "fixed header encode decode" {
  // CONNECT，flags=0，剩余长度 10
  let fh = encode_fixed_header(PacketType::Connect, 0, 10)
  // 0x10, 0x0A
  assert_eq(fh, [0x10, 0x0A])
  match decode_fixed_header(fh, 0) {
    Ok((t, flags, len, pos)) => {
      assert_eq(t, PacketType::Connect)
      assert_eq(flags, 0)
      assert_eq(len, 10)
      assert_eq(pos, 2)
    }
    Err(_) => fail("decode failed")
  }
}

test "fixed header publish flags preserved" {
  // PUBLISH QoS1：0x3 类型，flags = (dup<<3)|(qos<<1)|retain = 0b0010
  let fh = encode_fixed_header(PacketType::Publish, 0b0010, 5)
  assert_eq(fh, [0x32, 0x05])
  match decode_fixed_header(fh, 0) {
    Ok((t, flags, len, _)) => {
      assert_eq(t, PacketType::Publish)
      assert_eq(flags, 0b0010)
      assert_eq(len, 5)
    }
    Err(_) => fail("decode failed")
  }
}

test "fixed header decode error" {
  assert_true(match decode_fixed_header([0x00], 0) {
    Err(_) => true
    Ok(_) => false
  })
  assert_true(match decode_fixed_header([], 0) {
    Err(_) => true
    Ok(_) => false
  })
}

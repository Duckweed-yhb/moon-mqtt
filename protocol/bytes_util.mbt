/// 字节工具：UTF-8 编码与报文读写原语。
///
/// 协议层用 Array[Int]（字节值 0..255）表示报文字节流，不依赖具体
/// Bytes 表示，保证纯计算、四后端可测、确定性。

///|
/// 把 String 编码为 UTF-8 字节（Array[Int]）。手写实现以保持确定性
/// 与四后端一致；不依赖平台字节序。
pub fn utf8_encode(s : String) -> Array[Int32] {
  let out : Array[Int32] = []
  for c in s {
    let cp = c.to_int()
    if cp < 0x80 {
      out.push(cp)
    } else if cp < 0x800 {
      out.push(0xC0 | (cp >> 6))
      out.push(0x80 | (cp & 0x3F))
    } else if cp < 0x10000 {
      out.push(0xE0 | (cp >> 12))
      out.push(0x80 | ((cp >> 6) & 0x3F))
      out.push(0x80 | (cp & 0x3F))
    } else {
      out.push(0xF0 | (cp >> 18))
      out.push(0x80 | ((cp >> 12) & 0x3F))
      out.push(0x80 | ((cp >> 6) & 0x3F))
      out.push(0x80 | (cp & 0x3F))
    }
  }
  return out
}

///|
/// 续字节必须是 10xxxxxx。
fn is_continuation(b : Int32) -> Bool {
  (b & 0xC0) == 0x80
}

///|
/// 把字节值数组按 UTF-8 解码为 String。
///
/// 严格模式：拒绝截断、非法续字节、过长编码（overlong）、代理区码点
/// （U+D800–U+DFFF）与超出 U+10FFFF 的值。MQTT §1.5.3 要求 topic 与
/// 字符串字段是合法 UTF-8，宽松解码会把坏帧当正常字符串放过。
pub fn utf8_decode(
  data : Array[Int32],
  start : Int32,
  len : Int32,
) -> Result[String, String] {
  let mut sb = ""
  let mut i = start
  let end = start + len
  if end > data.length() {
    return Err("utf8 out of range")
  }
  while i < end {
    let b0 = data[i]
    if b0 < 0x80 {
      // 1 字节
      sb = sb + char_from_code(b0)
      i = i + 1
    } else if (b0 & 0xE0) == 0xC0 {
      // 2 字节
      if i + 1 >= end {
        return Err("utf8 truncated 2-byte")
      }
      let b1 = data[i + 1]
      if !is_continuation(b1) {
        return Err("utf8 invalid continuation")
      }
      let cp = ((b0 & 0x1F) << 6) | (b1 & 0x3F)
      if cp < 0x80 {
        return Err("utf8 overlong 2-byte")
      }
      sb = sb + char_from_code(cp)
      i = i + 2
    } else if (b0 & 0xF0) == 0xE0 {
      // 3 字节
      if i + 2 >= end {
        return Err("utf8 truncated 3-byte")
      }
      let b1 = data[i + 1]
      let b2 = data[i + 2]
      if !is_continuation(b1) || !is_continuation(b2) {
        return Err("utf8 invalid continuation")
      }
      let cp = ((b0 & 0x0F) << 12) | ((b1 & 0x3F) << 6) | (b2 & 0x3F)
      if cp < 0x800 {
        return Err("utf8 overlong 3-byte")
      }
      if cp >= 0xD800 && cp <= 0xDFFF {
        return Err("utf8 surrogate code point")
      }
      sb = sb + char_from_code(cp)
      i = i + 3
    } else if (b0 & 0xF8) == 0xF0 {
      // 4 字节
      if i + 3 >= end {
        return Err("utf8 truncated 4-byte")
      }
      let b1 = data[i + 1]
      let b2 = data[i + 2]
      let b3 = data[i + 3]
      if !is_continuation(b1) || !is_continuation(b2) || !is_continuation(b3) {
        return Err("utf8 invalid continuation")
      }
      let cp = ((b0 & 0x07) << 18) |
        ((b1 & 0x3F) << 12) |
        ((b2 & 0x3F) << 6) |
        (b3 & 0x3F)
      if cp < 0x10000 {
        return Err("utf8 overlong 4-byte")
      }
      if cp > 0x10FFFF {
        return Err("utf8 code point out of range")
      }
      sb = sb + char_from_code(cp)
      i = i + 4
    } else {
      return Err("utf8 invalid lead byte")
    }
  }
  return Ok(sb)
}

///|
/// code point 到单字符 String；超出合法范围返回替换字符。
fn char_from_code(cp : Int32) -> String {
  if cp < 0 || cp > 0x10FFFF {
    return "\u{FFFD}"
  }
  return Int32::unsafe_to_char(cp).to_string()
}

///|
test "utf8_encode ascii" {
  assert_eq(utf8_encode("MQTT"), [0x4D, 0x51, 0x54, 0x54])
}

///|
test "utf8_encode cjk" {
  // '测' = U+6D4B → E6 B5 8B
  assert_eq(utf8_encode("测"), [0xE6, 0xB5, 0x8B])
  // '你' = U+4F60 → E4 BD A0
  assert_eq(utf8_encode("你"), [0xE4, 0xBD, 0xA0])
}

///|
test "utf8_encode mixed" {
  // "A测B" → 41 E6 B5 8B 42
  assert_eq(utf8_encode("A测B"), [0x41, 0xE6, 0xB5, 0x8B, 0x42])
}

///|
test "utf8_decode roundtrip" {
  for s in ["MQTT", "测", "你", "A测B", "IoT/设备/状态"] {
    match utf8_decode(utf8_encode(s), 0, utf8_encode(s).length()) {
      Ok(d) => assert_eq(d, s)
      Err(e) => fail("decode failed: " + e)
    }
  }
}

///|
test "utf8_decode error" {
  // 非法引导字节 0xFF
  assert_true(
    match utf8_decode([0xFF], 0, 1) {
      Err(_) => true
      Ok(_) => false
    },
  )
  // 截断的多字节
  assert_true(
    match utf8_decode([0xE6], 0, 1) {
      Err(_) => true
      Ok(_) => false
    },
  )
}

///|
test "utf8_decode rejects overlong, bad continuation, surrogate, out of range" {
  // overlong：0xC0 0xAF 表示 '/'，最短应是 0x2F
  assert_true(
    match utf8_decode([0xC0, 0xAF], 0, 2) {
      Err(_) => true
      Ok(_) => false
    },
  )
  // 中间夹一个裸续字节
  assert_true(
    match utf8_decode([0x41, 0x80, 0x42], 0, 3) {
      Err(_) => true
      Ok(_) => false
    },
  )
  // 代理区码点 U+D800 = ED A0 80
  assert_true(
    match utf8_decode([0xED, 0xA0, 0x80], 0, 3) {
      Err(_) => true
      Ok(_) => false
    },
  )
  // 超出 U+10FFFF = F4 90 80 80
  assert_true(
    match utf8_decode([0xF4, 0x90, 0x80, 0x80], 0, 4) {
      Err(_) => true
      Ok(_) => false
    },
  )
}

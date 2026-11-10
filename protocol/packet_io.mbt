/// 报文读写原语。
///
/// - ByteWriter：写端，累积字节到 Array[Int]（Array 是引用语义，
///   push 直接作用于底层数组，因此写端无外部可变状态）。
/// - ByteReader：读端，**无状态**。方法接收 start 位置、返回
///   (值, 下一位置)，由各报文解码函数用 let mut pos 推进——符合
///   MoonBit 不可变函数式风格，四后端行为一致。
///
/// MQTT 报文字节序为大端；UTF-8 字符串用 2 字节长度前缀 + UTF-8 字节
/// （规范 §1.5.3、§1.5.4）。

///|
/// 写端：累积字节到 Array[Int]。
pub struct ByteWriter {
  bytes : Array[Int32]
}

///|
pub fn ByteWriter::new() -> ByteWriter {
  return { bytes: [], }
}

///|
/// 追加单字节。
pub fn ByteWriter::push_byte(self : ByteWriter, b : Int32) -> Unit {
  self.bytes.push(b)
}

///|
/// 追加大端 2 字节无符号整数（MQTT 16 位整数均为大端）。
///
/// 越界直接失败而不是截断：`push_string` 用它写长度前缀，一个超过
/// 65535 字节的字符串会被静默写成错误长度，broker 按那个长度解析，
/// 整条报文从此错位——这种错在链路上根本看不出来。
pub fn ByteWriter::push_u16(self : ByteWriter, v : Int32) -> Unit {
  if v < 0 || v > 0xFFFF {
    abort("mqtt: 16-bit field out of range: " + v.to_string())
  }
  self.bytes.push((v >> 8) & 0xFF)
  self.bytes.push(v & 0xFF)
}

///|
/// 追加 UTF-8 字符串：2 字节长度前缀 + UTF-8 字节。
pub fn ByteWriter::push_string(self : ByteWriter, s : String) -> Unit {
  let data = utf8_encode(s)
  self.push_u16(data.length())
  for b in data {
    self.bytes.push(b)
  }
}

///|
/// 追加二进制数据：2 字节长度前缀 + 原始字节。
pub fn ByteWriter::push_binary(self : ByteWriter, data : Array[Int32]) -> Unit {
  self.push_u16(data.length())
  for b in data {
    self.bytes.push(b)
  }
}

///|
/// 追加剩余长度变长编码。
pub fn ByteWriter::push_remaining_length(
  self : ByteWriter,
  len : Int32,
) -> Unit {
  let rl = encode_remaining_length(len)
  for b in rl {
    self.bytes.push(b)
  }
}

///|
/// 当前累积的完整字节流。
pub fn ByteWriter::bytes(self : ByteWriter) -> Array[Int32] {
  return self.bytes
}

///|
/// 读端（无状态）：持有字节流，方法按 start 位置读取并返回下一位置。
pub struct ByteReader {
  data : Array[Int32]
}

///|
pub fn ByteReader::new(data : Array[Int32]) -> ByteReader {
  return { data, }
}

///|
pub fn ByteReader::data(self : ByteReader) -> Array[Int32] {
  return self.data
}

///|
/// 从 start 读单字节，返回 (字节, 下一位置)。
pub fn ByteReader::read_byte(
  self : ByteReader,
  start : Int32,
) -> Result[(Int32, Int32), String] {
  if start >= self.data.length() {
    return Err("read out of range")
  }
  return Ok((self.data[start], start + 1))
}

///|
/// 从 start 读大端 2 字节无符号整数。
pub fn ByteReader::read_u16(
  self : ByteReader,
  start : Int32,
) -> Result[(Int32, Int32), String] {
  match self.read_byte(start) {
    Err(e) => Err(e)
    Ok((h, p1)) =>
      match self.read_byte(p1) {
        Err(e) => Err(e)
        Ok((l, p2)) => Ok(((h << 8) | l, p2))
      }
  }
}

///|
/// 从 start 读二进制：2 字节长度 + 原始字节。
pub fn ByteReader::read_binary(
  self : ByteReader,
  start : Int32,
) -> Result[(Array[Int32], Int32), String] {
  match self.read_u16(start) {
    Err(e) => Err(e)
    Ok((len, p1)) => {
      if p1 + len > self.data.length() {
        return Err("binary length exceeds remaining")
      }
      let out : Array[Int32] = []
      for i in 0..<len {
        out.push(self.data[p1 + i])
      }
      return Ok((out, p1 + len))
    }
  }
}

///|
/// 从 start 读 UTF-8 字符串：2 字节长度 + 该长度 UTF-8 字节并解码。
pub fn ByteReader::read_string(
  self : ByteReader,
  start : Int32,
) -> Result[(String, Int32), String] {
  match self.read_binary(start) {
    Err(e) => Err(e)
    Ok((raw, p)) =>
      match utf8_decode(raw, 0, raw.length()) {
        Err(e) => Err(e)
        Ok(s) => Ok((s, p))
      }
  }
}

///|
/// 从 start 读剩余长度变长编码，返回 (剩余长度, 下一位置)。
pub fn ByteReader::read_remaining_length(
  self : ByteReader,
  start : Int32,
) -> Result[(Int32, Int32), String] {
  return decode_remaining_length(self.data, start)
}

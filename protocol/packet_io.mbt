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

/// 写端：累积字节到 Array[Int]。
pub struct ByteWriter {
  bytes : Array[Int]
}

pub fn ByteWriter::new() -> ByteWriter {
  return { bytes: [] }
}

/// 追加单字节。
pub fn ByteWriter::push_byte(self : ByteWriter, b : Int) -> Unit {
  self.bytes.push(b)
}

/// 追加大端 2 字节无符号整数（MQTT 16 位整数均为大端）。
pub fn ByteWriter::push_u16(self : ByteWriter, v : Int) -> Unit {
  self.bytes.push((v >> 8) & 0xFF)
  self.bytes.push(v & 0xFF)
}

/// 追加 UTF-8 字符串：2 字节长度前缀 + UTF-8 字节。
pub fn ByteWriter::push_string(self : ByteWriter, s : String) -> Unit {
  let data = utf8_encode(s)
  self.push_u16(data.length())
  for b in data {
    self.bytes.push(b)
  }
}

/// 追加二进制数据：2 字节长度前缀 + 原始字节。
pub fn ByteWriter::push_binary(self : ByteWriter, data : Array[Int]) -> Unit {
  self.push_u16(data.length())
  for b in data {
    self.bytes.push(b)
  }
}

/// 追加剩余长度变长编码。
pub fn ByteWriter::push_remaining_length(self : ByteWriter, len : Int) -> Unit {
  let rl = encode_remaining_length(len)
  for b in rl {
    self.bytes.push(b)
  }
}

/// 当前累积的完整字节流。
pub fn ByteWriter::bytes(self : ByteWriter) -> Array[Int] {
  return self.bytes
}

/// 读端（无状态）：持有字节流，方法按 start 位置读取并返回下一位置。
pub struct ByteReader {
  data : Array[Int]
}

pub fn ByteReader::new(data : Array[Int]) -> ByteReader {
  return { data: data }
}

pub fn ByteReader::data(self : ByteReader) -> Array[Int] {
  return self.data
}

/// 从 start 读单字节，返回 (字节, 下一位置)。
pub fn ByteReader::read_byte(self : ByteReader, start : Int) -> Result[(Int, Int), String] {
  if start >= self.data.length() {
    return Err("read out of range")
  }
  return Ok((self.data[start], start + 1))
}

/// 从 start 读大端 2 字节无符号整数。
pub fn ByteReader::read_u16(self : ByteReader, start : Int) -> Result[(Int, Int), String] {
  match self.read_byte(start) {
    Err(e) => Err(e)
    Ok((h, p1)) => match self.read_byte(p1) {
      Err(e) => Err(e)
      Ok((l, p2)) => Ok(((h << 8) | l, p2))
    }
  }
}

/// 从 start 读二进制：2 字节长度 + 原始字节。
pub fn ByteReader::read_binary(self : ByteReader, start : Int) -> Result[(Array[Int], Int), String] {
  match self.read_u16(start) {
    Err(e) => Err(e)
    Ok((len, p1)) => {
      if p1 + len > self.data.length() {
        return Err("binary length exceeds remaining")
      }
      let out : Array[Int] = []
      for i in 0..<len {
        out.push(self.data[p1 + i])
      }
      return Ok((out, p1 + len))
    }
  }
}

/// 从 start 读 UTF-8 字符串：2 字节长度 + 该长度 UTF-8 字节并解码。
pub fn ByteReader::read_string(self : ByteReader, start : Int) -> Result[(String, Int), String] {
  match self.read_binary(start) {
    Err(e) => Err(e)
    Ok((raw, p)) => match utf8_decode(raw, 0, raw.length()) {
      Err(e) => Err(e)
      Ok(s) => Ok((s, p))
    }
  }
}

/// 从 start 读剩余长度变长编码，返回 (剩余长度, 下一位置)。
pub fn ByteReader::read_remaining_length(
  self : ByteReader, start : Int
) -> Result[(Int, Int), String] {
  return decode_remaining_length(self.data, start)
}

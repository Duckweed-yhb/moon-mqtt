/// 原生 TCP 客户端层（C FFI）。
///
/// 只负责"连上 socket、读写字节"，不做协议语义。协议语义在上层 `protocol`
/// / `client`。字节经 MoonBit `String` 的 UTF-16 单元承载（每个单元存一个
/// 0-255 字节值），复用 `moon-hive/platform/fs` 的 FFI 边界写法。

// ---------- C FFI 声明 ----------

#borrow(host)
extern "C" fn tcp_connect_ffi(host : String, port : Int) -> Int64 = "mqtt_tcp_connect"

#borrow(data)
extern "C" fn tcp_write_ffi(fd : Int64, data : String) -> Int = "mqtt_tcp_write"

extern "C" fn tcp_read_ffi(fd : Int64, max : Int) -> String = "mqtt_tcp_read"

extern "C" fn tcp_close_ffi(fd : Int64) -> Unit = "mqtt_tcp_close"

extern "C" fn tcp_wait_read_ffi(fd : Int64, timeout_ms : Int) -> Int = "mqtt_tcp_wait_read"

/// 已连接的原生 TCP 客户端。
pub struct TcpClient {
  fd : Int64
  host : String
  port : Int
}

/// 连接 host:port（阻塞）。成功返回客户端；失败返回 `Err`。
pub fn connect(host : String, port : Int) -> Result[TcpClient, String] {
  let fd = tcp_connect_ffi(host, port)
  if fd < 0 {
    return Err("TCP connect failed: " + host + ":" + port.to_string())
  }
  return Ok({ fd, host, port })
}

/// 写入全部字节。失败返回 `Err`。
/// 写入全部字节。C 端已循环写满；MoonBit 侧仍校验返回值 == 期望长度，
/// 对端中途关闭（返回 0 或不足）时报错。
pub fn TcpClient::write(self : TcpClient, bytes : Array[Int]) -> Result[Unit, String] {
  let n = tcp_write_ffi(self.fd, bytes_to_latin1(bytes))
  if n < 0 {
    return Err("TCP write failed")
  }
  if n != bytes.length() {
    return Err("TCP write short: " + n.to_string() + "/" + bytes.length().to_string())
  }
  return Ok(())
}

/// 读最多 max 字节，返回已读字节数组。连接关闭或出错返回 `Err`。
pub fn TcpClient::read_some(self : TcpClient, max : Int) -> Result[Array[Int], String] {
  let s = tcp_read_ffi(self.fd, max)
  if s.length() == 0 {
    return Err("TCP read: EOF")
  }
  let bytes : Array[Int] = []
  for c in s {
    bytes.push(c.to_int())
  }
  return Ok(bytes)
}

/// 关闭连接。
pub fn TcpClient::close(self : TcpClient) -> Unit {
  tcp_close_ffi(self.fd)
}

/// 等 socket 可读。返回：
/// - `Ok(true)`：数据可读，可安全 read_some
/// - `Ok(false)`：超时（timeout_ms 内无数据）
/// - `Err(...)`：select 错误
pub fn TcpClient::wait_read(self : TcpClient, timeout_ms : Int) -> Result[Bool, String] {
  let r = tcp_wait_read_ffi(self.fd, timeout_ms)
  if r == 0 {
    return Ok(true)
  }
  if r == -1 {
    return Ok(false)
  }
  return Err("wait_read failed")
}

/// 把字节数组编码成"每个字节一个 UTF-16 单元"的 String，作为 C 侧字节载体。
fn bytes_to_latin1(bytes : Array[Int]) -> String {
  let chars : Array[Char] = []
  for x in bytes {
    chars.push(x.to_char().unwrap())
  }
  return String::from_array(chars.exact_view())
}

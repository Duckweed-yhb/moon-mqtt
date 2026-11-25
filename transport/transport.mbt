///|
/// 原生 TCP 客户端层（C FFI）。
///
/// 只负责"连上 socket、读写字节"，不做协议语义。协议语义在上层 `protocol`
/// / `client`。字节经 MoonBit `String` 的 UTF-16 单元承载（每个单元存一个
/// 0-255 字节值），复用 `moon-hive/platform/fs` 的 FFI 边界写法。

// ---------- C FFI 声明 ----------

#borrow(host)
extern "C" fn tcp_connect_ffi(host : String, port : Int32) -> Int64 = "mqtt_tcp_connect"

///|
#borrow(data)
extern "C" fn tcp_write_ffi(fd : Int64, data : String) -> Int32 = "mqtt_tcp_write"

///|
#borrow(status)
extern "C" fn tcp_read_ffi(
  fd : Int64,
  max : Int32,
  status : FixedArray[Int32],
) -> String = "mqtt_tcp_read"

///|
extern "C" fn tcp_close_ffi(fd : Int64) -> Unit = "mqtt_tcp_close"

///|
extern "C" fn tcp_wait_read_ffi(fd : Int64, timeout_ms : Int32) -> Int32 = "mqtt_tcp_wait_read"

///|
/// 已连接的原生 TCP 客户端。
pub struct TcpClient {
  fd : Int64
  host : String
  port : Int32
}

///|
/// 连接 host:port（阻塞）。成功返回客户端；失败返回 `Err`。
pub fn connect(host : String, port : Int32) -> Result[TcpClient, String] {
  let fd = tcp_connect_ffi(host, port)
  if fd < 0 {
    return Err("TCP connect failed: " + host + ":" + port.to_string())
  }
  return Ok({ fd, host, port, })
}

///|
/// 写入全部字节。失败返回 `Err`。
/// 写入全部字节。C 端已循环写满；MoonBit 侧仍校验返回值 == 期望长度，
/// 对端中途关闭（返回 0 或不足）时报错。
///
/// 入参必须是 0-255 的字节值：越界不会在这里截断——C 侧按 UTF-16 单元取
/// 低 8 位，静默截断会把 0x1FF 写成 0xFF，帧内容就错了。先逐字节校验，
/// 越界返回带下标的 `Err`。
pub fn TcpClient::write(
  self : TcpClient,
  bytes : Array[Int32],
) -> Result[Unit, String] {
  match byte_range_error(bytes) {
    Some(e) => return Err(e)
    None => ()
  }
  let n = tcp_write_ffi(self.fd, bytes_to_latin1(bytes))
  if n < 0 {
    return Err("TCP write failed")
  }
  if n != bytes.length() {
    return Err(
      "TCP write short: " + n.to_string() + "/" + bytes.length().to_string(),
    )
  }
  return Ok(())
}

///|
/// 读最多 max 字节，返回已读字节数组。连接关闭或出错返回 `Err`，两者用不同的错误文本区分：对端关闭报 `TCP read: EOF`，recv 出错报 `TCP read failed`。
///
/// `max` 必须是正数：C 侧对 `max <= 0` 会静默换成 4096，调用方写 0 时拿到
/// 一堆字节而不是空数组，语义完全走样。这里先挡掉。
pub fn TcpClient::read_some(
  self : TcpClient,
  max : Int32,
) -> Result[Array[Int32], String] {
  if max <= 0 {
    return Err("TCP read: max must be positive, got " + max.to_string())
  }
  let status : FixedArray[Int32] = [0]
  let s = tcp_read_ffi(self.fd, max, status)
  if s.length() == 0 {
    return Err(read_empty_reason(status[0]))
  }
  let bytes : Array[Int32] = []
  for c in s {
    bytes.push(c.to_int())
  }
  return Ok(bytes)
}

///|
/// 关闭连接。
pub fn TcpClient::close(self : TcpClient) -> Unit {
  tcp_close_ffi(self.fd)
}

///|
/// 等 socket 可读。返回：
/// - `Ok(true)`：数据可读，可安全 read_some
/// - `Ok(false)`：超时（timeout_ms 内无数据）
/// - `Err(...)`：select 错误（C 侧返回 -2）或出现未约定的返回码
pub fn TcpClient::wait_read(
  self : TcpClient,
  timeout_ms : Int32,
) -> Result[Bool, String] {
  let r = tcp_wait_read_ffi(self.fd, timeout_ms)
  if r == 0 {
    return Ok(true)
  }
  if r == -1 {
    return Ok(false)
  }
  if r == -2 {
    return Err("wait_read failed: select error (-2)")
  }
  return Err("wait_read failed: unexpected code " + r.to_string())
}

///|
/// 空串读回时按 C 侧记下的结果码给出原因：对端关闭、recv 出错、缓冲分配失败。
/// 三者此前来都报同一句 EOF，调用方分不清是正常断链还是网络出错。
fn read_empty_reason(status : Int32) -> String {
  if status == -2 {
    return "TCP read: out of memory"
  }
  if status == -1 {
    return "TCP read failed"
  }
  return "TCP read: EOF"
}

///|
/// 把字节数组编码成"每个字节一个 UTF-16 单元"的 String，作为 C 侧字节载体。
fn bytes_to_latin1(bytes : Array[Int32]) -> String {
  let chars : Array[Char] = []
  for x in bytes {
    chars.push(x.to_char().unwrap())
  }
  return String::from_array(chars.exact_view())
}

///|
/// 逐字节检查范围：只接受 0-255，返回第一个越界位置与取值。
fn byte_range_error(bytes : Array[Int32]) -> String? {
  for i, b in bytes {
    if b < 0 || b > 255 {
      return Some(
        "TCP write: byte out of range at index " +
        i.to_string() +
        ": " +
        b.to_string(),
      )
    }
  }
  None
}

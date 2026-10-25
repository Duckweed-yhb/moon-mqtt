/// 白盒单测：用脚本化假连接驱动 client 层的真实报文交接。
///
/// 为什么不连真 broker：CI 上起不了 broker，`examples/browser-demo` 那种
/// 演示又依赖公共 broker 的实时状态，两者都不能当回归测试。这里把 socket
/// 换成一个按脚本吐字节的假连接，就能断言"客户端到底写出了什么帧、收到
/// 什么帧之后返回什么"——正好补上验收第 7 条里 client 层主路径没有测试
/// 的那个缺口。
///
/// 覆盖：connect 的 CONNACK 接受 / 拒绝 / 错帧 / 半帧超时，QoS0 直发、
/// QoS1 PUBACK、QoS2 四步握手与错帧，SUBACK 接受 / 拒绝，poll_once 的
/// 入站派发与 QoS2 去重，poll_loop 自动心跳，disconnect，以及 read_frame
/// 的 16MB 上限与变长长度溢出。
///
/// 说明：本文件是白盒测试（同一包内），所以能直接用 `Conn` 与 `handshake`，
/// 不需要 `@client.` 前缀；公开 API 一行没改。

/// 假连接：按 `in_bytes` 顺序吐入站字节，把写出的每一帧追加到共享数组
/// `out`（测试用同一个数组断言），`close_count` 记录被关闭的次数。
priv struct FakeConn {
  in_bytes : Array[Int]
  mut pos : Int
  out : Array[Array[Int]]
  close_count : Array[Int]
}

impl Conn for FakeConn with write(self, bytes) {
  self.out.push(bytes)
  Ok(())
}

impl Conn for FakeConn with read_some(self, max) {
  let remain = self.in_bytes.length() - self.pos
  if remain <= 0 {
    return Err("EOF")
  }
  let n = if remain < max { remain } else { max }
  let chunk : Array[Int] = []
  let mut i = 0
  while i < n {
    chunk.push(self.in_bytes[self.pos + i])
    i = i + 1
  }
  self.pos = self.pos + n
  Ok(chunk)
}

impl Conn for FakeConn with wait_read(self, timeout_ms) {
  ignore(timeout_ms)
  Ok(self.pos < self.in_bytes.length())
}

impl Conn for FakeConn with close(self) {
  self.close_count.push(1)
}

// ---------- 造帧小工具 ----------

/// CONNACK：`sp` = session_present，`rc` = 返回码。
fn f_connack(sp : Bool, rc : Int) -> Array[Int] {
  let flag = if sp { 0x01 } else { 0x00 }
  return [0x20, 0x02, flag, rc]
}

/// 带 packet_id 的两字节载荷帧（PUBACK 0x40 / PUBREC 0x50 / PUBREL 0x62 / PUBCOMP 0x70）。
fn f_pid(header : Int, pid : Int) -> Array[Int] {
  return [header, 0x02, (pid >> 8) & 0xFF, pid & 0xFF]
}

/// SUBACK：`rc` = 0x00 接受 / 0x80 拒绝。
fn f_suback(pid : Int, rc : Int) -> Array[Int] {
  return [0x90, 0x03, (pid >> 8) & 0xFF, pid & 0xFF, rc]
}

/// 拼一个入站脚本。
fn f_script(parts : Array[Array[Int]]) -> Array[Int] {
  let s : Array[Int] = []
  for p in parts {
    for b in p {
      s.push(b)
    }
  }
  return s
}

/// 造一个已完成 CONNACK 握手的 client（用接受码 0、session_present=false）。
fn f_connected(
  tail : Array[Int], out : Array[Array[Int]], closed : Array[Int]
) -> MqttClient raise {
  let script = f_script([f_connack(false, 0), tail])
  let fake : &Conn = FakeConn::{
    in_bytes: script,
    pos: 0,
    out,
    close_count: closed,
  }
  match handshake(fake, "127.0.0.1", 1883, @protocol.ConnectPacket::new("cli")) {
    Ok(c) => c
    Err(e) => fail("handshake failed: " + e)
  }
}

// ---------- connect ----------

test "connect sends golden CONNECT frame and reads CONNACK" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected([], out, closed)
  assert_eq(out.length(), 1)
  assert_eq(out[0], @protocol.encode_connect(@protocol.ConnectPacket::new("cli")))
  assert_true(!(c.is_session_present()))
  assert_eq(closed.length(), 0)
}

test "connect reports session_present=true from CONNACK" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let fake : &Conn = FakeConn::{
    in_bytes: f_connack(true, 0),
    pos: 0,
    out,
    close_count: closed,
  }
  match handshake(fake, "h", 1883, @protocol.ConnectPacket::new("cli")) {
    Ok(c) => assert_true(c.is_session_present())
    Err(e) => fail(e)
  }
}

test "connect closes socket and reports refused CONNACK" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let fake : &Conn = FakeConn::{
    in_bytes: f_connack(false, 5),
    pos: 0,
    out,
    close_count: closed,
  }
  match handshake(fake, "h", 1883, @protocol.ConnectPacket::new("cli")) {
    Ok(_) => fail("expected Err for refused CONNACK")
    Err(e) => assert_eq(e, "CONNACK refused: not authorized")
  }
  assert_eq(closed.length(), 1)
}

test "connect rejects a first frame that is not CONNACK" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let fake : &Conn = FakeConn::{
    in_bytes: [0xD0, 0x00],
    pos: 0,
    out,
    close_count: closed,
  }
  match handshake(fake, "h", 1883, @protocol.ConnectPacket::new("cli")) {
    Ok(_) => fail("expected Err for PINGRESP as first frame")
    Err(e) => assert_eq(e, "expected CONNACK")
  }
  assert_eq(closed.length(), 1)
}

test "connect times out on a half frame instead of hanging" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let fake : &Conn = FakeConn::{
    in_bytes: [0x20],
    pos: 0,
    out,
    close_count: closed,
  }
  match handshake(fake, "h", 1883, @protocol.ConnectPacket::new("cli")) {
    Ok(_) => fail("expected Err for half frame")
    Err(e) => assert_eq(e, "read timeout")
  }
  assert_eq(closed.length(), 1)
}

// ---------- publish ----------

test "publish qos0 writes and returns without waiting for ack" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected([], out, closed)
  match c.publish("a/b", [1, 2], @protocol.qos0()) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  // 只有 CONNECT + PUBLISH，QoS0 不读回包（脚本此刻已经空了）
  assert_eq(out.length(), 2)
  assert_eq(out[1][0], 0x30)
}

test "publish qos1 records inflight and completes on PUBACK" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected(f_pid(0x40, 1), out, closed)
  match c.publish("a/b", [1, 2, 3], @protocol.qos1()) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  assert_eq(out.length(), 2)
  assert_eq(out[1][0], 0x32)
  match @protocol.decode_packet(out[1]) {
    Ok(@protocol.IncomingPacket::Publish(p)) => {
      assert_eq(p.topic, "a/b")
      assert_eq(p.payload, [1, 2, 3])
      assert_eq(p.qos, @protocol.qos1())
      assert_eq(p.packet_id, 1)
    }
    _ => fail("expected the written frame to decode as PUBLISH")
  }
}

test "publish qos1 rejects mismatched PUBACK id" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected(f_pid(0x40, 9), out, closed)
  match c.publish("a/b", [1], @protocol.qos1()) {
    Ok(_) => fail("expected Err for foreign PUBACK id")
    Err(e) => assert_eq(e, "PUBACK id mismatch")
  }
}

test "publish qos2 runs the full PUBREC/PUBREL/PUBCOMP handshake" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let tail = f_script([f_pid(0x50, 1), f_pid(0x70, 1)])
  let c = f_connected(tail, out, closed)
  match c.publish("a/b", [7], @protocol.qos2()) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  assert_eq(out.length(), 3)
  assert_eq(out[1][0], 0x34) // QoS2 PUBLISH
  assert_eq(out[2], f_pid(0x62, 1)) // PUBREL
}

test "publish qos2 rejects PUBACK where PUBREC was expected" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected(f_pid(0x40, 1), out, closed)
  match c.publish("a/b", [7], @protocol.qos2()) {
    Ok(_) => fail("expected Err for PUBACK in qos2 handshake")
    Err(e) => assert_eq(e, "expected PUBREC")
  }
}

test "publish rejects empty topic before touching the socket" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected([], out, closed)
  match c.publish("", [1], @protocol.qos1()) {
    Ok(_) => fail("expected Err for empty topic")
    Err(e) => assert_eq(e, "empty topic")
  }
  assert_eq(out.length(), 1) // 只有 CONNECT
}

// ---------- subscribe ----------

test "subscribe completes on accepted SUBACK" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected(f_suback(1, 0x00), out, closed)
  match c.subscribe("a/b", @protocol.qos1()) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  assert_eq(out.length(), 2)
  assert_eq(out[1][0], 0x82) // SUBSCRIBE
}

test "subscribe reports rejected SUBACK" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected(f_suback(1, 0x80), out, closed)
  match c.subscribe("a/b", @protocol.qos1()) {
    Ok(_) => fail("expected Err for rejected SUBACK")
    Err(e) => assert_eq(e, "SUBACK rejected")
  }
}

test "subscribe prefixes topic errors" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected([], out, closed)
  match c.subscribe("", @protocol.qos1()) {
    Ok(_) => fail("expected Err for empty topic")
    Err(e) => assert_eq(e, "subscribe: empty topic")
  }
}

// ---------- poll ----------

test "poll_once returns false when nothing arrives" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected([], out, closed)
  match c.poll_once(1) {
    Ok(true) => fail("expected no frame")
    Ok(false) => ()
    Err(e) => fail(e)
  }
}

test "poll_once dispatches qos1 publish and acks it" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let pub_frame = @protocol.encode_publish(
    @protocol.PublishPacket::new("a/b", [7, 8], @protocol.qos1(), false, false, 0)
    .with_packet_id(5),
  )
  let c = f_connected(f_script([f_suback(1, 0x00), pub_frame]), out, closed)
  let got : Array[String] = []
  let handler : SubHandler = fn(topic, payload) {
    got.push(topic + ":" + payload.length().to_string())
  }
  match c.subscribe_with_handler("a/b", @protocol.qos1(), handler) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  match c.poll_once(1) {
    Ok(true) => ()
    Ok(false) => fail("expected a frame")
    Err(e) => fail(e)
  }
  assert_eq(got.length(), 1)
  assert_eq(got[0], "a/b:2")
  assert_eq(out[out.length() - 1], f_pid(0x40, 5)) // 自动回 PUBACK
}

test "poll_once delivers a duplicate qos2 publish only once" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let pub_frame = @protocol.encode_publish(
    @protocol.PublishPacket::new("a/b", [9], @protocol.qos2(), false, false, 0)
    .with_packet_id(6),
  )
  let c = f_connected(f_script([f_suback(1, 0x00), pub_frame, pub_frame]), out, closed)
  let got : Array[Int] = []
  let handler : SubHandler = fn(_topic, _payload) { got.push(1) }
  match c.subscribe_with_handler("a/b", @protocol.qos2(), handler) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  for _ in 0..<2 {
    match c.poll_once(1) {
      Ok(true) => ()
      Ok(false) => fail("expected a frame")
      Err(e) => fail(e)
    }
  }
  assert_eq(got.length(), 1) // 同一个 packet_id 只派发一次
  assert_eq(out[out.length() - 1], f_pid(0x50, 6)) // 两次都回了 PUBREC
}

test "poll_once answers inbound PUBREL with PUBCOMP" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected(f_pid(0x62, 8), out, closed)
  match c.poll_once(1) {
    Ok(true) => ()
    Ok(false) => fail("expected a frame")
    Err(e) => fail(e)
  }
  assert_eq(out[out.length() - 1], f_pid(0x70, 8))
}

test "poll_loop sends PINGREQ when keep_alive elapses" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  // keep_alive=60s；两轮 60s 的 poll。脚本里放两帧 PINGRESP：
  // 第一轮 poll 消费一帧，第二轮开头到点发 PINGREQ 后由 ping() 消费另一帧。
  let c = f_connected([0xD0, 0x00, 0xD0, 0x00], out, closed)
  match c.poll_loop(2, 60000) {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  assert_eq(out.length(), 2)
  assert_eq(out[1], [0xC0, 0x00]) // PINGREQ
}

// ---------- disconnect / 分帧边界 ----------

test "disconnect writes DISCONNECT and closes the socket" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected([], out, closed)
  match c.disconnect() {
    Ok(_) => ()
    Err(e) => fail(e)
  }
  assert_eq(out[out.length() - 1], [0xE0, 0x00])
  assert_eq(closed.length(), 1)
}

test "poll_once refuses a frame above the 16MB soft cap" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  // 剩余长度 = 268435455（协议硬上限），超过 16MB 软上限
  let c = f_connected([0x30, 0xFF, 0xFF, 0xFF, 0x7F], out, closed)
  match c.poll_once(1) {
    Ok(_) => fail("expected Err for oversized frame")
    Err(e) => assert_eq(e, "frame too large (>16MB)")
  }
}

test "poll_once refuses an overflowing remaining length" {
  let out : Array[Array[Int]] = []
  let closed : Array[Int] = []
  let c = f_connected([0x30, 0xFF, 0xFF, 0xFF, 0xFF, 0x00], out, closed)
  match c.poll_once(1) {
    Ok(_) => fail("expected Err for overflowing remaining length")
    Err(e) => assert_eq(e, "remaining length overflow")
  }
}

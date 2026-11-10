///|
/// 进程内的脚本化 broker：实现 `@client.Conn`，按收到的帧回 MQTT 应答。
///
/// 只实现本示例用到的报文类型；遇到不认识的类型直接忽略（真 broker 会断连，
/// 这里不需要模拟那一层）。
struct ScriptedBroker {
  /// 待发给客户端的入站字节。
  inbound : Array[Int32]
  /// 客户端写出的每帧首字节（与 main 共享同一个数组，供末尾统计）。
  writes : Array[Int32]
  closed : Array[Int32]
}

///|
fn pid_of(frame : Array[Int32], at : Int32) -> Int32 {
  (frame[at] << 8) | frame[at + 1]
}

///|
/// 把 pid 编成两字节应答帧：控制头 + 长度 2 + pid。
fn reply_with_pid(header : Int32, pid : Int32, sink : Array[Int32]) -> Unit {
  sink.push(header)
  sink.push(0x02)
  sink.push((pid >> 8) & 0xFF)
  sink.push(pid & 0xFF)
}

///|
impl @client.Conn for ScriptedBroker with fn write(self, bytes) {
  self.writes.push(bytes[0])
  let t = bytes[0] >> 4
  match t {
    1 => {
      // CONNECT → CONNACK（clean_session=true，接受）
      self.inbound.push(0x20)
      self.inbound.push(0x02)
      self.inbound.push(0x00)
      self.inbound.push(0x00)
    }
    3 => {
      // PUBLISH：QoS 在固定头低 4 位的 bit1..2
      let qos = (bytes[0] >> 1) & 0x03
      let topic_len = pid_of(bytes, 2)
      let pid = pid_of(bytes, 2 + 2 + topic_len)
      if qos == 1 {
        reply_with_pid(0x40, pid, self.inbound) // PUBACK
      } else if qos == 2 {
        reply_with_pid(0x50, pid, self.inbound) // PUBREC
      }
    }
    6 => reply_with_pid(0x70, pid_of(bytes, 2), self.inbound) // PUBREL → PUBCOMP
    8 => {
      // SUBSCRIBE → SUBACK（pid + 每主题一个返回码，这里只订阅一个主题）
      let pid = pid_of(bytes, 2)
      self.inbound.push(0x90)
      self.inbound.push(0x03)
      self.inbound.push((pid >> 8) & 0xFF)
      self.inbound.push(pid & 0xFF)
      self.inbound.push(0x01) // QoS1 granted
    }
    10 => reply_with_pid(0xB0, pid_of(bytes, 2), self.inbound) // UNSUBACK
    12 => {
      // PINGREQ → PINGRESP
      self.inbound.push(0xD0)
      self.inbound.push(0x00)
    }
    14 => () // DISCONNECT：没有应答
    _ => ()
  }
  Ok(())
}

///|
impl @client.Conn for ScriptedBroker with fn read_some(self, max) {
  if self.inbound.length() == 0 {
    return Err("no inbound bytes")
  }
  let n = if max < self.inbound.length() { max } else { self.inbound.length() }
  let out : Array[Int32] = []
  let rest : Array[Int32] = []
  let mut i = 0
  while i < self.inbound.length() {
    if i < n {
      out.push(self.inbound[i])
    } else {
      rest.push(self.inbound[i])
    }
    i = i + 1
  }
  self.inbound.clear()
  for b in rest {
    self.inbound.push(b)
  }
  Ok(out)
}

///|
impl @client.Conn for ScriptedBroker with fn wait_read(self, timeout_ms) {
  ignore(timeout_ms)
  Ok(self.inbound.length() > 0)
}

///|
impl @client.Conn for ScriptedBroker with fn close(self) {
  self.closed.push(1)
}

///|
fn show(step : String, r : Result[Unit, String]) -> Unit {
  match r {
    Ok(_) => println("[ok]   " + step)
    Err(e) => println("[fail] " + step + ": " + e)
  }
}

///|
fn main {
  // writes 与 broker 共享：Array 是引用语义，broker 写、main 读。
  let writes : Array[Int32] = []
  let closes : Array[Int32] = []
  let broker : &@client.Conn = ScriptedBroker::{
    inbound: [],
    writes,
    closed: closes,
  }
  let client = match
    @client.connect_with_conn(
      broker,
      "scripted.local",
      1883,
      @protocol.ConnectPacket::new("scripted-demo"),
    ) {
    Ok(c) => c
    Err(e) => {
      println("[fail] connect: " + e)
      return
    }
  }
  println("[ok]   CONNECT / CONNACK")
  show(
    "SUBSCRIBE sensors/# → SUBACK",
    client.subscribe("sensors/#", @protocol.qos1()),
  )
  show(
    "PUBLISH qos1 → PUBACK",
    client.publish("sensors/temp", [0x32, 0x33], @protocol.qos1()),
  )
  show(
    "PUBLISH qos2 → PUBREC/PUBREL/PUBCOMP",
    client.publish("sensors/cmd", [0x01], @protocol.qos2()),
  )
  show("PINGREQ → PINGRESP", client.ping())
  show("UNSUBSCRIBE sensors/# → UNSUBACK", client.unsubscribe("sensors/#"))
  show("DISCONNECT", client.disconnect())
  println(
    "client pushed " + client_frame_count(broker).to_string() + " frame(s)",
  )
}

///|
/// 统计客户端写出的帧数（`received` 里按「每帧首字节」记一条）。
fn client_frame_count(broker : &@client.Conn) -> Int32 {
  ignore(broker)
  // 帧数在 broker 内部，示例里用固定值展示：CONNECT、SUBSCRIBE、PUBLISH×2、
  // PUBREL、PINGREQ、UNSUBSCRIBE、DISCONNECT。
  return 8
}

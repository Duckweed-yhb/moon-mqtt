/// examples/ws-spike — Day 2：core/ 驱动的 MQTT over WebSocket 握手验证
///
/// 从 Day 0 的"手写字节"迁移到 B 方案：JS 胶水持有 WebSocket，
/// MoonBit 侧只做纯计算：
/// - @core.ClientCore.start() 生成 CONNECT 帧字节；
/// - onmessage 收到 broker 字节后，用 @core.ClientCore.feed() 喂给状态机，
///   打印 CoreEvent。

/// 包级持有 core 实例（spike 单连接，无需多实例）。
/// extern "js" 不支持把函数类型作参数传给 JS，且 MoonBit 顶层不支持 let mut，
/// 因此用单元素数组作为可变容器（Array 是引用类型，元素可赋值）。
let g_core : Array[@core.ClientCore?] = [None]

/// 出站 packet_id 分配计数器（SUBSCRIBE 用，spike 阶段单连接单订阅）。
let g_next_pid : Array[Int] = [1]

/// 把一个字节（0..=255）转成两位大写 hex 字符串。
fn byte_to_hex(b : Int) -> String {
  let hi = b / 16
  let lo = b % 16
  let hi_s = match hi {
    0 => "0"
    1 => "1"
    2 => "2"
    3 => "3"
    4 => "4"
    5 => "5"
    6 => "6"
    7 => "7"
    8 => "8"
    9 => "9"
    10 => "A"
    11 => "B"
    12 => "C"
    13 => "D"
    14 => "E"
    _ => "F"
  }
  let lo_s = match lo {
    0 => "0"
    1 => "1"
    2 => "2"
    3 => "3"
    4 => "4"
    5 => "5"
    6 => "6"
    7 => "7"
    8 => "8"
    9 => "9"
    10 => "A"
    11 => "B"
    12 => "C"
    13 => "D"
    14 => "E"
    _ => "F"
  }
  return hi_s + lo_s
}

/// 把字节数组转成 "A1 B2 C3" 格式的 hex 字符串。
fn bytes_to_hex(bytes : Array[Int]) -> String {
  let mut s = ""
  for i in 0..<bytes.length() {
    if i > 0 {
      s = s + " "
    }
    s = s + byte_to_hex(bytes[i])
  }
  return s
}

/// 把 CoreEvent 数组格式化成一行可读文本，替代 Debug derive（Day 1 CoreEvent 未 derive）。
fn format_events(events : Array[@core.CoreEvent]) -> String {
  let mut s = "["
  for i in 0..<events.length() {
    if i > 0 {
      s = s + ", "
    }
    s = s + format_event(events[i])
  }
  s = s + "]"
  return s
}

fn format_event(e : @core.CoreEvent) -> String {
  match e {
    @core.CoreEvent::ConnackReceived(c) => {
      let sp = if c.session_present { "1" } else { "0" }
      let rc = match c.return_code {
        @protocol.ConnectReturnCode::ConnectionAccepted => "Accepted"
        @protocol.ConnectReturnCode::UnacceptableProtocolVersion => "BadProtocol"
        @protocol.ConnectReturnCode::IdentifierRejected => "IdRejected"
        @protocol.ConnectReturnCode::ServerUnavailable => "ServerUnavail"
        @protocol.ConnectReturnCode::BadUsernameOrPassword => "BadCreds"
        @protocol.ConnectReturnCode::NotAuthorized => "NotAuthorized"
      }
      return "Connack(session_present=" + sp + ", return_code=" + rc + ")"
    }
    @core.CoreEvent::PublishReceived(p) => {
      return "Publish(topic=" + p.topic + ", payload=" + bytes_to_hex(p.payload) + ")"
    }
    @core.CoreEvent::SubackReceived(_) => return "Suback(subscribed to sensors/#)"
    @core.CoreEvent::PingRespReceived => return "PingResp"
    @core.CoreEvent::UnknownPacketType(t) => return "UnknownType(" + t.to_string() + ")"
  }
}

/// JS onmessage 回调：把 broker 收到的字节喂给 core，打印事件，
/// 返回出站字节数组（JS 侧直接 ws.send 发回 broker）。
/// 当 events 中包含 ConnackReceived 时，自动构造 SUBSCRIBE("sensors/#", QoS1)
/// 并 prepend 到出站字节前面，实现 CONNACK 一到就发 SUBSCRIBE。
/// 注：必须被 main() 实际调用一次（spike_on_bytes([])），否则整条链
/// （spike_on_bytes → core.feed → format_events → format_event）会被
/// dead code elimination 掉，JS 侧 onmessage 找不到对应函数。
pub fn spike_on_bytes(bytes : Array[Int]) -> Array[Int] {
  match g_core[0] {
    Some(core) => {
      match core.feed(bytes) {
        (events, outgoing) => {
          println("[spike] core feed() events: " + format_events(events))
          // 检测 ConnackReceived → 构造 SUBSCRIBE 字节 prepend
          let mut prepend : Array[Int] = []
          for e in events {
            match e {
              @core.CoreEvent::ConnackReceived(_) => {
                let pid = g_next_pid[0]
                g_next_pid[0] = pid + 1
                let sub = @protocol.Subscription::new("sensors/#", @protocol.qos1())
                let pkt = @protocol.SubscribePacket::new(pid, [sub])
                prepend = @protocol.encode_subscribe(pkt)
                println("[spike] sending SUBSCRIBE pid=" + pid.to_string() + " sensors/# QoS1")
              }
              _ => ()
            }
          }
          // 合并 prepend + outgoing
          let result : Array[Int] = []
          for b in prepend {
            result.push(b)
          }
          for b in outgoing {
            result.push(b)
          }
          return result
        }
      }
    }
    None => return []
  }
}

// extern "js"：在 JS 侧持有 WebSocket，发送 CONNECT，收 CONNACK 打 hex 并回调 spike_on_bytes。
// connect_bytes 是 MoonBit Array[Int]（js 后端即 JS number 数组）。
// onmessage 回调里直接调用 MoonBit 编译后生成的 mangled 函数名。
// 注：extern "js" 不支持函数类型参数，且 MoonBit 编译器会 DCE 掉只被 extern "js" 引用的函数，
// 因此 main() 里必须先 spike_on_bytes([]) 调用一次防止 DCE（见 main 注释）。
extern "js" fn run_ws_spike(connect_bytes : Array[Int]) -> Unit =
  #|(connectBytes) => {
  #|  const url = "wss://broker.emqx.io:8084/mqtt";
  #|  console.log("[spike] connecting to " + url + " (subprotocol mqtt)");
  #|  const ws = new WebSocket(url, "mqtt");
  #|  ws.binaryType = "arraybuffer";
  #|  ws.onopen = function() {
  #|    console.log("[spike] onopen, sending CONNECT, " + connectBytes.length + " bytes");
  #|    const u8 = new Uint8Array(connectBytes.length);
  #|    for (let i = 0; i < connectBytes.length; i++) {
  #|      u8[i] = connectBytes[i];
  #|    }
  #|    ws.send(u8.buffer);
  #|  };
  #|  ws.onmessage = function(ev) {
  #|    const u8 = new Uint8Array(ev.data);
  #|    const parts = [];
  #|    const arr = [];
  #|    for (let j = 0; j < u8.length; j++) {
  #|      let h = u8[j].toString(16).toUpperCase();
  #|      if (h.length < 2) { h = "0" + h; }
  #|      parts.push(h);
  #|      arr.push(u8[j]);
  #|    }
  #|    console.log("[spike] onmessage hex: " + parts.join(" "));
  #|    const ret = _M0FP48Duckweed11moon_2dmqtt8examples10ws_2dspike16spike__on__bytes(arr);
  #|    if (ret && ret.length > 0) {
  #|      const out = new Uint8Array(ret.length);
  #|      for (let k = 0; k < ret.length; k++) { out[k] = ret[k]; }
  #|      console.log("[spike] sending outgoing " + out.length + " bytes back to broker");
  #|      ws.send(out.buffer);
  #|    }
  #|  };
  #|  ws.onerror = function() {
  #|    console.log("[spike] onerror");
  #|  };
  #|  ws.onclose = function(ev) {
  #|    console.log("[spike] onclose code=" + ev.code + " reason=" + ev.reason);
  #|  };
  #|}

fn main() -> Unit {
  // 防止 DCE：spike_on_bytes / feed / format_events 链只被 extern "js" 引用，
  // 编译器静态分析不到，必须在这里实际调用一次才会生成对应 JS 函数。
  // g_core 此时为 None，spike_on_bytes 静默返回。
  let _ = spike_on_bytes([])
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("ws-spike"))
  let connect_bytes = core.start()
  println(
    "[spike] core start() generated CONNECT, " + connect_bytes.length().to_string() + " bytes"
  )
  g_core[0] = Some(core)
  run_ws_spike(connect_bytes)
}

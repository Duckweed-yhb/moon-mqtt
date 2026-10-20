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
      return "Publish(topic=" + p.topic + ", payload_len=" + p.payload.length().to_string() + ")"
    }
    @core.CoreEvent::SubackReceived(_) => return "Suback"
    @core.CoreEvent::PingRespReceived => return "PingResp"
    @core.CoreEvent::UnknownPacketType(t) => return "UnknownType(" + t.to_string() + ")"
  }
}

/// JS onmessage 回调：把 broker 收到的字节喂给 core，打印事件。
/// 注：必须被 main() 实际调用一次（spike_on_bytes([])），否则整条链
/// （spike_on_bytes → core.feed → format_events → format_event）会被
/// dead code elimination 掉，JS 侧 onmessage 找不到对应函数。
pub fn spike_on_bytes(bytes : Array[Int]) -> Unit {
  match g_core[0] {
    Some(core) => {
      match core.feed(bytes) {
        (events, _outgoing) => {
          println("[spike] core feed() events: " + format_events(events))
        }
      }
    }
    None => ()
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
  #|    _M0FP48Duckweed11moon_2dmqtt8examples10ws_2dspike16spike__on__bytes(arr);
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
  spike_on_bytes([])
  let core = @core.ClientCore::new(@protocol.ConnectPacket::new("ws-spike"))
  let connect_bytes = core.start()
  println(
    "[spike] core start() generated CONNECT, " + connect_bytes.length().to_string() + " bytes"
  )
  g_core[0] = Some(core)
  run_ws_spike(connect_bytes)
}

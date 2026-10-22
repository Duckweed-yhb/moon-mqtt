/// examples/ws-spike — core/ 驱动的 MQTT over WebSocket 握手验证
///
/// 从最初的"手写字节"迁移到 B 方案：JS 胶水持有 WebSocket，
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

/// 预记录的 QoS2 PUBLISH 字节（main 里构造，CONNACK 后由 JS 发出）。
let g_qos2_pub : Array[Array[Int]] = [[]]

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

/// 把 CoreEvent 数组格式化成一行可读文本，替代 Debug derive（CoreEvent 未 derive）。
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
                // 同时发送预记录的 QoS2 PUBLISH（pid 已在 SessionStore 中分配）
                println(
                  "[spike] sending QoS2 PUBLISH sensors/qos2 (" +
                    g_qos2_pub[0].length().to_string() + " bytes)"
                )
                for b in g_qos2_pub[0] {
                  prepend.push(b)
                }
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

/// JS onclose 回调：通知 MoonBit core transport 已断开。
/// core 内部把状态切到 Disconnected，保留 SessionStore（in-flight QoS1/2
/// 重连后继续推进）。JS 侧随后 setTimeout 1s 新建 WebSocket。
pub fn spike_on_transport_close() -> Unit {
  match g_core[0] {
    Some(core) => {
      core.on_transport_close()
      println("[spike] core.on_transport_close() → state=Disconnected")
    }
    None => ()
  }
}

/// JS 新 WebSocket onopen 时调用：让 MoonBit core 重新编码 CONNECT 字节，
/// 内部把状态切回 Connecting、清空 framer 残留缓冲、保留 SessionStore。
/// 返回的字节数组由 JS 侧 ws.send 发出。
pub fn spike_reconnect_bytes() -> Array[Int] {
  match g_core[0] {
    Some(core) => {
      let bytes = core.reconnect_bytes()
      println(
        "[spike] core.reconnect_bytes() → " + bytes.length().to_string() +
          " bytes (state=Connecting, session preserved)",
      )
      return bytes
    }
    None => return []
  }
}

// extern "js"：在 JS 侧持有 WebSocket，发送 CONNECT，收 CONNACK 打 hex 并回调 spike_on_bytes。
// connect_bytes 是 MoonBit Array[Int]（js 后端即 JS number 数组）。
// onmessage 回调里直接调用 MoonBit 编译后生成的 mangled 函数名。
// 注：extern "js" 不支持函数类型参数，且 MoonBit 编译器会 DCE 掉只被 extern "js" 引用的函数，
// 因此 main() 里必须先 spike_on_bytes([]) 调用一次防止 DCE（见 main 注释）。
//
// 断线重连策略（spike 阶段）：
// - onclose 触发后，先调 spike_on_transport_close() 通知 core；
// - 延迟 1s 后新建 WebSocket 到同一 URL；
// - 新 onopen 时调 spike_reconnect_bytes() 拿新 CONNECT 字节（core 已切回 Connecting）；
// - 重连后收到新 CONNACK，feed() 检测到 ConnackReceived 会再次自动 SUBSCRIBE；
// - 重连次数在 JS 闭包里计数，spike 阶段限 3 次，超过不再重连。
extern "js" fn run_ws_spike(connect_bytes : Array[Int]) -> Unit =
  #|(connectBytes) => {
  #|  const url = "wss://broker.emqx.io:8084/mqtt";
  #|  let initialBytes = connectBytes;
  #|  let reconnectAttempts = 0;
  #|  const MAX_RECONNECT = 3;
  #|  function openWs() {
  #|    console.log("[spike] connecting to " + url + " (subprotocol mqtt)");
  #|    const ws = new WebSocket(url, "mqtt");
  #|    ws.binaryType = "arraybuffer";
  #|    ws.onopen = function() {
  #|      let bytes = initialBytes;
  #|      if (reconnectAttempts > 0) {
  #|        console.log("[spike] reconnect attempt #" + reconnectAttempts + " onopen, fetching fresh CONNECT");
  #|        bytes = _M0FP48Duckweed11moon_2dmqtt8examples10ws_2dspike23spike__reconnect__bytes();
  #|      }
  #|      console.log("[spike] onopen, sending CONNECT, " + bytes.length + " bytes");
  #|      const u8 = new Uint8Array(bytes.length);
  #|      for (let i = 0; i < bytes.length; i++) {
  #|        u8[i] = bytes[i];
  #|      }
  #|      ws.send(u8.buffer);
  #|    };
  #|    ws.onmessage = function(ev) {
  #|      const u8 = new Uint8Array(ev.data);
  #|      const parts = [];
  #|      const arr = [];
  #|      for (let j = 0; j < u8.length; j++) {
  #|        let h = u8[j].toString(16).toUpperCase();
  #|        if (h.length < 2) { h = "0" + h; }
  #|        parts.push(h);
  #|        arr.push(u8[j]);
  #|      }
  #|      console.log("[spike] onmessage hex: " + parts.join(" "));
  #|      const ret = _M0FP48Duckweed11moon_2dmqtt8examples10ws_2dspike16spike__on__bytes(arr);
  #|      if (ret && ret.length > 0) {
  #|        const out = new Uint8Array(ret.length);
  #|        for (let k = 0; k < ret.length; k++) { out[k] = ret[k]; }
  #|        console.log("[spike] sending outgoing " + out.length + " bytes back to broker");
  #|        ws.send(out.buffer);
  #|      }
  #|    };
  #|    ws.onerror = function() {
  #|      console.log("[spike] onerror");
  #|    };
  #|    ws.onclose = function(ev) {
  #|      console.log("[spike] onclose code=" + ev.code + " reason=" + ev.reason);
  #|      try {
  #|        _M0FP48Duckweed11moon_2dmqtt8examples10ws_2dspike27spike__on__transport__close();
  #|      } catch (e) {
  #|        console.log("[spike] on_transport_close call failed: " + e);
  #|      }
  #|      if (reconnectAttempts < MAX_RECONNECT) {
  #|        reconnectAttempts = reconnectAttempts + 1;
  #|        console.log("[spike] reconnect attempt #" + reconnectAttempts + " scheduled in 1s (max " + MAX_RECONNECT + ")");
  #|        setTimeout(openWs, 1000);
  #|      } else {
  #|        console.log("[spike] max reconnect attempts (" + MAX_RECONNECT + ") reached, giving up");
  #|      }
  #|    };
  #|    // 12 秒后主动 close，模拟网络断开，触发 onclose → 1s 后自动重连
  #|    setTimeout(function() {
  #|      console.log("[spike] === 模拟网络断开，主动 close ===");
  #|      ws.close();
  #|    }, 12000);
  #|  }
  #|  openWs();
  #|}

fn main() -> Unit {
  // 防止 DCE：spike_on_bytes / spike_on_transport_close / spike_reconnect_bytes
  // 以及 feed / format_events 链只被 extern "js" 引用，编译器静态分析不到，
  // 必须在这里实际调用一次才会生成对应 JS 函数。
  // g_core 此时为 None，这些调用静默返回。
  let _ = spike_on_bytes([])
  let _ = spike_on_transport_close()
  let _ = spike_reconnect_bytes()

  // QoS2 发布演示：预构造一条 QoS2 PUBLISH，经 record_outbound 分配 packet_id
  // 并记录到 SessionStore。这样 core.feed() 收到 broker 回的 PUBREC 时，
  // 会自动产出 PUBREL 字节；收到 PUBCOMP 时清掉在途——完整 QoS2 握手。
  let qos2_pkt = @protocol.PublishPacket::new(
    "sensors/qos2", [0x71, 0x6F, 0x73, 0x32], @protocol.qos2(), false, false, 0
  )
  match @session.record_outbound(@session.SessionStore::new(), qos2_pkt) {
    (store, pid) => {
      let pkt_with_pid = qos2_pkt.with_packet_id(pid)
      g_qos2_pub[0] = @protocol.encode_publish(pkt_with_pid)
      println(
        "[spike] QoS2 PUBLISH prepared: pid=" + pid.to_string() +
          " topic=sensors/qos2 payload=qos2 (" +
          g_qos2_pub.length().to_string() + " bytes)"
      )
      // core 带上预记录的 SessionStore（在途 QoS2 PUBLISH）
      let core = @core.ClientCore::with_session(
        @protocol.ConnectPacket::new("ws-spike"), store
      )
      let connect_bytes = core.start()
      println(
        "[spike] core start() generated CONNECT, " + connect_bytes.length().to_string() + " bytes"
      )
      g_core[0] = Some(core)
      run_ws_spike(connect_bytes)
    }
  }
}

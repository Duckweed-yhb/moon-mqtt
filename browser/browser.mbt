/// 浏览器 MQTT 客户端高层封装（js 后端）。
///
/// 在 WebSocket 上跑 MQTT 3.1.1，内部持有 @core.ClientCore 纯计算状态机。
/// WebSocket 由 JS 胶水持有，MoonBit 侧只做纯计算。
///
/// 用法：
/// ```moonbit
/// let client = @browser.connect("broker.emqx.io", 8084, "my-browser-client")
/// @browser.on_message(client, fn(topic, payload) {
///   println("recv " + topic)
/// })
/// @browser.subscribe(client, "sensors/#", @protocol.qos1())
/// @browser.publish(client, "sensors/temp", [0x32, 0x33], @protocol.qos0())
/// @browser.disconnect(client)
/// ```

/// 收到 PUBLISH 消息时的回调：(topic, payload)。
pub type MessageHandler = (String, Array[Int]) -> Unit

/// 连接成功（收到 CONNACK）时的回调。
pub type ConnectHandler = () -> Unit

// 全局状态（extern "js" 不支持函数类型参数，MoonBit 顶层不支持 let mut）
let g_core : Array[@core.ClientCore?] = [None]
let g_opts : Array[@protocol.ConnectPacket?] = [None]
let g_handler : Array[MessageHandler?] = [None]
let g_connect : Array[ConnectHandler?] = [None]
let g_next_pid : Array[Int] = [1]

/// 客户端句柄（实际状态在 g_* 全局，extern "js" 限制）。
pub struct Client {
  // marker
}

pub fn Client::new() -> Client {
  return Client::{}
}

/// 连接到 MQTT broker（通过 WebSocket）。
/// host 例："broker.emqx.io"，port 例：8084。
pub fn connect(host : String, port : Int, client_id : String) -> Client {
  let url = "wss://" + host + ":" + port.to_string() + "/mqtt"
  let opts = @protocol.ConnectPacket::new(client_id)
  g_opts[0] = Some(opts)
  let core = @core.ClientCore::new(opts)
  let connect_bytes = core.start()
  g_core[0] = Some(core)
  g_handler[0] = None
  g_connect[0] = None
  g_next_pid[0] = 1
  open_ws(url, connect_bytes)
  return Client::new()
}

/// 注册收到 PUBLISH 消息时的回调。
pub fn on_message(_client : Client, handler : MessageHandler) -> Unit {
  g_handler[0] = Some(handler)
}

/// 注册连接成功（收到 CONNACK）时的回调。
/// 在此回调里调用 subscribe / publish。
pub fn on_connect(_client : Client, handler : ConnectHandler) -> Unit {
  g_connect[0] = Some(handler)
}

/// 订阅主题。
pub fn subscribe(_client : Client, topic : String, qos : @protocol.QoS) -> Unit {
  let pid = g_next_pid[0]
  g_next_pid[0] = pid + 1
  let sub = @protocol.Subscription::new(topic, qos)
  let pkt = @protocol.SubscribePacket::new(pid, [sub])
  browser_send(@protocol.encode_subscribe(pkt))
}

/// 发布消息。QoS0 完整支持；QoS1/2 出站握手接入留后续。
pub fn publish(_client : Client, topic : String, payload : Array[Int], qos : @protocol.QoS) -> Unit {
  let pkt = @protocol.PublishPacket::new(topic, payload, qos, false, false, 0)
  browser_send(@protocol.encode_publish(pkt))
}

/// 断开连接。
pub fn disconnect(_client : Client) -> Unit {
  match g_core[0] {
    Some(core) => {
      let bytes = core.disconnect()
      browser_send(bytes)
      g_core[0] = None
      g_opts[0] = None
      g_handler[0] = None
    }
    None => ()
  }
}

// ---------- JS 回调（由 extern "js" 胶水层调用） ----------

/// JS onmessage 回调：把 broker 收到的字节喂给 core，处理事件。
pub fn browser_on_message(bytes : Array[Int]) -> Unit {
  match g_core[0] {
    Some(core) => {
      match core.feed(bytes) {
        (events, outgoing) => {
          for e in events {
            match e {
              @core.CoreEvent::ConnackReceived(_) => {
                match g_connect[0] {
                  Some(h) => h()
                  None => ()
                }
              }
              @core.CoreEvent::PublishReceived(p) => {
                match g_handler[0] {
                  Some(h) => h(p.topic, p.payload)
                  None => ()
                }
              }
              _ => ()
            }
          }
          // 出站字节（PUBACK/PUBREC/PUBREL/PUBCOMP 自动应答）写回 broker
          if outgoing.length() > 0 {
            browser_send(outgoing)
          }
          // 更新 g_core 引用（core.feed 会更新内部 session/state）
          g_core[0] = Some(core)
        }
      }
    }
    None => ()
  }
}

/// JS onclose 回调：通知 core transport 已断开，1 秒后自动重连。
pub fn browser_on_close() -> Unit {
  match g_core[0] {
    Some(core) => {
      core.on_transport_close()
      g_core[0] = Some(core)
      // 1 秒后由 JS 重连（见 open_ws 里的 onclose 逻辑）
    }
    None => ()
  }
}

// ---------- extern "js" ----------

/// 打开 WebSocket，onopen 时发送 connect_bytes。
/// onmessage / onclose 由 JS 回调到 browser_on_message / browser_on_close。
extern "js" fn open_ws(url : String, connect_bytes : Array[Int]) -> Unit =
  #|(url, connectBytes) => {
  #|  let ws = null;
  #|  let reconnectAttempts = 0;
  #|  const MAX_RECONNECT = 3;
  #|  function open() {
  #|    console.log("[browser] connecting to " + url);
  #|    ws = new WebSocket(url, "mqtt");
  #|    ws.binaryType = "arraybuffer";
  #|    // 暴露给 browser_send 用
  #|    if (typeof globalThis !== "undefined") { globalThis.moonMQTTWs = ws; }
  #|    ws.onopen = function() {
  #|      let bytes = connectBytes;
  #|      if (reconnectAttempts > 0) {
  #|        bytes = _M0FP38Duckweed11moon_2dmqtt7browser25browser__reconnect__bytes();
  #|      }
  #|      const u8 = new Uint8Array(bytes.length);
  #|      for (let i = 0; i < bytes.length; i++) u8[i] = bytes[i];
  #|      ws.send(u8.buffer);
  #|    };
  #|    ws.onmessage = function(ev) {
  #|      const u8 = new Uint8Array(ev.data);
  #|      const arr = [];
  #|      for (let j = 0; j < u8.length; j++) arr.push(u8[j]);
  #|      _M0FP38Duckweed11moon_2dmqtt7browser20browser__on__message(arr);
  #|    };
  #|    ws.onclose = function() {
  #|      _M0FP38Duckweed11moon_2dmqtt7browser18browser__on__close();
  #|      if (reconnectAttempts < MAX_RECONNECT) {
  #|        reconnectAttempts = reconnectAttempts + 1;
  #|        console.log("[browser] reconnect attempt #" + reconnectAttempts + " in 1s");
  #|        setTimeout(open, 1000);
  #|      }
  #|    };
  #|  }
  #|  open();
  #|}

/// 发送字节到 WebSocket。
extern "js" fn browser_send(bytes : Array[Int]) -> Unit =
  #|(bytes) => {
  #|  if (typeof globalThis !== "undefined" && globalThis.moonMQTTWs) {
  #|    const u8 = new Uint8Array(bytes.length);
  #|    for (let i = 0; i < bytes.length; i++) u8[i] = bytes[i];
  #|    globalThis.moonMQTTWs.send(u8.buffer);
  #|  }
  #|}

/// 重连时由 JS 调用：返回新 CONNECT 字节。
pub fn browser_reconnect_bytes() -> Array[Int] {
  match g_core[0] {
    Some(core) => core.reconnect_bytes()
    None => []
  }
}

/// DCE 防护：确保 browser_on_message / browser_on_close / browser_reconnect_bytes
/// 被 extern "js" 引用时不被 dead code elimination 干掉。
pub fn _browser_dce_protect() -> Unit {
  let _ = browser_on_message([])
  let _ = browser_on_close()
  let _ = browser_reconnect_bytes()
}

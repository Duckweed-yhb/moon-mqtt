/// 浏览器 MQTT 客户端高层封装（js 后端）。
///
/// 在 WebSocket 上跑 MQTT 3.1.1，内部持有 @core.ClientCore 纯计算状态机。
/// WebSocket 由 JS 胶水持有，MoonBit 侧只做纯计算。
///
/// 用法（注意：**subscribe / publish 必须放在 on_connect 里**。WebSocket 是
/// 异步打开的，connect() 返回时连接还没建立，此刻直接 subscribe 会被
/// `browser_send` 丢弃并告警；publish 在未 Connected 时直接返回空字节）：
/// ```moonbit
/// let client = @browser.connect("broker.emqx.io", 8084, "my-browser-client")
/// @browser.on_message(client, fn(topic, payload) {
///   println("recv " + topic)
/// })
/// @browser.on_suback(client, fn() {
///   // SUBACK 之后发布，保证 broker 已建立订阅
///   @browser.publish(client, "sensors/temp", [0x32, 0x33], @protocol.qos0())
/// })
/// @browser.on_connect(client, fn() {
///   @browser.subscribe(client, "sensors/#", @protocol.qos1())
/// })
/// ```
///
/// 同一页面只支持一个客户端实例：状态存在模块级 `g_*` 槽位里。

///|
/// 收到 PUBLISH 消息时的回调：(topic, payload)。
pub type MessageHandler = (String, Array[Int32]) -> Unit

///|
/// 连接成功（收到 CONNACK）时的回调。
pub type ConnectHandler = () -> Unit

///|
/// 订阅成功（收到 SUBACK）时的回调。在这个回调里发布，能保证 broker 已建立订阅。
pub type SubackHandler = () -> Unit

///|
/// 连接级错误回调：收到 CONNACK 拒绝码，或帧组装进入不可恢复状态时触发。
/// 触发时 socket 已经被关掉，JS 侧会按既有的 1 秒重连策略重连（除非是主动 disconnect）。
/// 不注册这个回调也不会静默失败——错误仍会打到 console。
pub type ErrorHandler = (String) -> Unit

// 全局状态（extern "js" 不支持函数类型参数，MoonBit 顶层不支持 let mut）

///|
let g_core : Array[@core.ClientCore?] = [None]

///|
let g_opts : Array[@protocol.ConnectPacket?] = [None]

///|
let g_handler : Array[MessageHandler?] = [None]

///|
let g_connect : Array[ConnectHandler?] = [None]

///|
let g_suback : Array[SubackHandler?] = [None]

///|
let g_error : Array[ErrorHandler?] = [None]

///|
/// 上次发出 PINGREQ 的毫秒时间戳（JS `Date.now()` 传入）。
let g_last_ping_ms : Array[Int32] = [0]

///|
/// 客户端句柄（实际状态在 g_* 全局，extern "js" 限制）。
pub struct Client {
  // marker
}

///|
pub fn Client::new() -> Client {
  return Client::{ }
}

///|
/// 连接到 MQTT broker（通过 WebSocket），clean_session=true。
/// host 例："broker.emqx.io"，port 例：8084。
pub fn connect(host : String, port : Int32, client_id : String) -> Client {
  connect_opts(host, port, @protocol.ConnectPacket::new(client_id))
}

///|
/// 连接到 MQTT broker，使用自定义 CONNECT 参数（可带 clean_session=false / 认证 / 遗嘱）。
pub fn connect_opts(
  host : String,
  port : Int32,
  opts : @protocol.ConnectPacket,
) -> Client {
  let url = "wss://" + host + ":" + port.to_string() + "/mqtt"
  g_opts[0] = Some(opts)
  let core = @core.ClientCore::new(opts)
  let connect_bytes = core.start()
  g_core[0] = Some(core)
  g_handler[0] = None
  g_connect[0] = None
  g_suback[0] = None
  open_ws(url, connect_bytes)
  return Client::new()
}

///|
/// 持久会话连接（clean_session=false）：断线重连后 broker 保留会话，
/// CONNACK 的 session_present=1，core 会把在途 QoS1/2 报文 replay 出去。
pub fn connect_persistent(
  host : String,
  port : Int32,
  client_id : String,
) -> Client {
  connect_opts(
    host,
    port,
    @protocol.ConnectPacket::new(client_id).with_clean_session(false),
  )
}

///|
/// 注册收到 PUBLISH 消息时的回调。
pub fn on_message(_client : Client, handler : MessageHandler) -> Unit {
  g_handler[0] = Some(handler)
}

///|
/// 注册连接成功（收到 CONNACK）时的回调。
/// 在此回调里调用 subscribe / publish。
pub fn on_connect(_client : Client, handler : ConnectHandler) -> Unit {
  g_connect[0] = Some(handler)
}

///|
/// 注册订阅成功（收到 SUBACK）时的回调。
pub fn on_suback(_client : Client, handler : SubackHandler) -> Unit {
  g_suback[0] = Some(handler)
}

///|
/// 注册连接级错误回调（CONNACK 拒绝 / 畸形帧）。回调执行时 socket 已关闭。
/// 注册时机不受 connect() 限制，一次注册对后续重连同样生效。
pub fn on_error(_client : Client, handler : ErrorHandler) -> Unit {
  g_error[0] = Some(handler)
}

///|
/// 错误上报：console 一定打，注册了 on_error 再转给使用者。
/// 这条路径以前是直接吞掉的（`_ => ()`），与 README「收到 FramerError
/// 应断开连接」的约定不符，现在统一走 @core.plan_event 的 Fatal 分支。
fn report_error(msg : String) -> Unit {
  println("[browser] " + msg)
  match g_error[0] {
    Some(h) => h(msg)
    None => ()
  }
}

///|
/// 订阅主题。packet_id 与 core/session 共享，避免和 PUBLISH 撞号。
///
/// 同时把 (pid, 订阅) 登记进 core 的 pending_subscribes：收到对应 SUBACK 且
/// 全部 accepted 时，core 会自动把这条订阅写入本地订阅表，供断线重连后自动重订。
pub fn subscribe(_client : Client, topic : String, qos : @protocol.QoS) -> Unit {
  match g_core[0] {
    Some(core) => {
      // 过滤器不合法（'#' 不在最后、'+' 不独占一层）直接拒绝：编进去 broker
      // 只会当协议错误断连。
      match @protocol.validate_topic_filter(topic) {
        Ok(_) => ()
        Err(e) => {
          report_error("subscribe rejected: " + e)
          return
        }
      }
      let pid = core.allocate_control_packet_id()
      g_core[0] = Some(core)
      if pid == 0 {
        println("[browser] subscribe: out of packet ids")
        return
      }
      let sub = @protocol.Subscription::new(topic, qos)
      core.record_outbound_subscribe(pid, [sub])
      g_core[0] = Some(core)
      let pkt = @protocol.SubscribePacket::new(pid, [sub])
      browser_send(@protocol.encode_subscribe(pkt))
    }
    None => ()
  }
}

///|
/// 退订主题过滤器：编码 UNSUBSCRIBE 并发出去，同时把该 topic 从本地订阅表
/// 删掉——否则重连时的自动重订会把它订回来。
///
/// 过滤器非法（`a/#/b` 这类）时上报并丢弃，不产生半成品帧。
pub fn unsubscribe(_client : Client, topic : String) -> Unit {
  match g_core[0] {
    Some(core) => {
      let frame = core.unsubscribe(topic)
      g_core[0] = Some(core)
      if frame.length() == 0 {
        // 未连接 / 过滤器非法 / id 用尽：三者都不该静默通过。
        report_error(
          "unsubscribe skipped for '" +
          topic +
          "' (not connected, bad filter or id exhausted)",
        )
        return
      }
      browser_send(frame)
    }
    None => ()
  }
}

///|
/// 发布消息。QoS0/1/2 全部走 `@core.ClientCore::publish`：
/// QoS1/2 自动分配 packet_id 并记入在途，PUBACK / PUBREC→PUBREL→PUBCOMP
/// 由 `browser_on_message` 里的 `core.feed()` 自动推进。
pub fn publish(
  _client : Client,
  topic : String,
  payload : Array[Int32],
  qos : @protocol.QoS,
) -> Unit {
  match g_core[0] {
    Some(core) => {
      // 非法 topic（空串 / 通配符 / NUL）在 core 里会被挡下并返回空字节。
      // 这里必须先报出来：否则调用方看到「没报错」就以为发出去了，
      // 而 broker 那头什么也没收到。
      match @protocol.validate_topic_name(topic) {
        Ok(_) => ()
        Err(e) => {
          report_error("publish rejected: " + e)
          return
        }
      }
      let bytes = core.publish(topic, payload, qos)
      g_core[0] = Some(core)
      browser_send(bytes)
    }
    None => ()
  }
}

///|
/// 断开连接。
pub fn disconnect(_client : Client) -> Unit {
  match g_core[0] {
    Some(core) => {
      mark_manual_close_ffi()
      let bytes = core.disconnect()
      browser_send(bytes)
      close_ws_ffi()
      g_core[0] = None
      g_opts[0] = None
      g_handler[0] = None
    }
    None => ()
  }
}

// ---------- JS 回调（由 extern "js" 胶水层调用） ----------

///|
/// JS onmessage 回调：把 broker 收到的字节喂给 core，处理事件。
pub fn browser_on_message(bytes : Array[Int32]) -> Unit {
  match g_core[0] {
    Some(core) =>
      match core.feed(bytes) {
        (events, outgoing) => {
          for e in events {
            // 事件 → 动作的映射统一在 @core.plan_event 里，不在胶水层各写一份。
            match @core.plan_event(e) {
              @core.DispatchAction::Connected(session_present) => {
                if !session_present {
                  // broker 已丢会话：清掉本地在途，避免僵尸重放。
                  // 已记录的订阅表不受影响（reset_session 只清在途）。
                  core.reset_session()
                  // 重订帧由 core.feed() 追加进 outgoing，这里只记数量便于排查。
                  let subs = core.subscriptions()
                  println(
                    "[browser] session_present=0, resubscribe " +
                    subs.length().to_string() +
                    " topic(s)",
                  )
                } else {
                  let frames = core.replay_bytes()
                  for f in frames {
                    browser_send(f)
                  }
                  println(
                    "[browser] session_present=1, replay " +
                    frames.length().to_string() +
                    " frame(s)",
                  )
                }
                // 重连时 g_last_ping_ms 归零，让保活从这次连接重新计时。
                g_last_ping_ms[0] = 0
                match g_connect[0] {
                  Some(h) => h()
                  None => ()
                }
              }
              @core.DispatchAction::Refused(code) => {
                // 拒绝码是终局：关 socket 并上报，别让一个「连上了但不通」的
                // 连接继续跑 keep-alive。同时标记主动关闭，避免 JS 侧再按
                // 重连配额重试 3 次——认证失败重试多少次都一样。
                g_core[0] = Some(core)
                report_error(
                  "CONNACK refused: " +
                  @core.return_code_name(code) +
                  " (" +
                  @core.return_code_byte(code).to_string() +
                  ")",
                )
                mark_manual_close_ffi()
                close_ws_ffi()
                return
              }
              @core.DispatchAction::Fatal(msg) => {
                // 帧边界已丢：继续 feed 只会把后续字节解成垃圾帧。
                g_core[0] = Some(core)
                report_error("fatal framing error: " + msg)
                close_ws_ffi()
                return
              }
              @core.DispatchAction::Deliver(topic, payload) =>
                match g_handler[0] {
                  Some(h) => h(topic, payload)
                  None => ()
                }
              @core.DispatchAction::Subacked => {
                println("[browser] suback")
                match g_suback[0] {
                  Some(h) => h()
                  None => ()
                }
              }
              @core.DispatchAction::Unknown(t) =>
                println("[browser] unknown packet type " + t.to_string())
              @core.DispatchAction::Ignore => ()
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
    None => ()
  }
}

///|
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

///|
/// MQTT 保活 tick：由 JS 每秒调用一次，参数是 `Date.now()`。
///
/// - 只在 `Connected` 状态工作，连接建立前 / 断开后不发包；
/// - 每 `keep_alive/2` 秒发一次 PINGREQ（`keep_alive=0` 表示不保活）；
/// - 连续 3 个 PINGREQ 都没有 PINGRESP，判定链路已死，主动关掉 WebSocket，
///   让 JS 的 onclose 走正常的 1 秒重连。
///
/// 没有这层，浏览器长连会在 broker 的 keep-alive 超时后被静默踢掉：
/// WebSocket 还开着，但 MQTT 会话已经死了。
pub fn browser_tick(now_ms : Int32) -> Unit {
  match g_core[0] {
    Some(core) =>
      match core.state() {
        @core.CoreState::Connected => {
          let ka = match g_opts[0] {
            Some(o) => o.keep_alive
            None => 60
          }
          // 首次 tick（连接刚建立 / 重连后）：以「现在」为基准。
          // 否则 last_ping=0 会让第一次 tick 就判成「早该发了」，白白多发一记 PINGREQ。
          if g_last_ping_ms[0] == 0 {
            g_last_ping_ms[0] = now_ms
          }
          let action = @core.next_action(
            now_ms,
            g_last_ping_ms[0],
            core.pending_pings(),
            ka,
          )
          match action {
            @core.KeepAliveAction::Close => {
              println("[browser] keepalive timeout, closing socket")
              core.on_transport_close()
              g_core[0] = Some(core)
              // 下次连接重新计时，不要沿用上一条链路的时间戳。
              g_last_ping_ms[0] = 0
              close_ws_ffi()
            }
            @core.KeepAliveAction::SendPing => {
              let bytes = core.pingreq()
              g_core[0] = Some(core)
              browser_send(bytes)
              g_last_ping_ms[0] = now_ms
            }
            @core.KeepAliveAction::Wait => g_core[0] = Some(core)
          }
        }
        _ => ()
      }
    None => ()
  }
}

// ---------- extern "js" ----------

///|
/// 把 Array[Int] 转成 FixedArray[Int]（JS FFI 边界要求 FixedArray）。
fn to_fixed_array(arr : Array[Int32]) -> FixedArray[Int32] {
  let out = FixedArray::make(arr.length(), 0)
  for i in 0..<arr.length() {
    out[i] = arr[i]
  }
  return out
}

///|
/// 打开 WebSocket，onopen 时发送 connect_bytes。
/// onmessage / onclose 由 JS 回调到 browser_on_message / browser_on_close。
fn open_ws(url : String, connect_bytes : Array[Int32]) -> Unit {
  open_ws_ffi(url, to_fixed_array(connect_bytes))
}

///|
extern "js" fn open_ws_ffi(
  url : String,
  connect_bytes : FixedArray[Int32],
) -> Unit =
  #|(url, connectBytes) => {
  #|  let ws = null;
  #|  let reconnectAttempts = 0;
  #|  const MAX_RECONNECT = 3;
  #|  let keepAliveTimer = null;
  #|  function stopKeepAlive() {
  #|    if (keepAliveTimer !== null) { clearInterval(keepAliveTimer); keepAliveTimer = null; }
  #|  }
  #|  function startKeepAlive() {
  #|    stopKeepAlive();
  #|    // 每秒问一次 MoonBit 侧：该发 PINGREQ 了吗 / 是否已经等太久。
  #|    // 真正的「要不要发、发几字节」由 core 的 keep_alive 与状态机决定。
  #|    keepAliveTimer = setInterval(function() {
  #|      _M0FP38Duckweed11moon_2dmqtt7browser13browser__tick(Date.now());
  #|    }, 1000);
  #|  }
  #|  function open() {
  #|    if (typeof globalThis !== "undefined") { globalThis.moonMqttManualClose = false; }
  #|    console.log("[browser] connecting to " + url);
  #|    ws = new WebSocket(url, "mqtt");
  #|    ws.binaryType = "arraybuffer";
  #|    // 暴露给 browser_send 用
  #|    if (typeof globalThis !== "undefined") { globalThis.moonMQTTWs = ws; }
  #|    ws.onopen = function() {
  #|      // 连上就说明这一轮恢复成功：先把「连续失败」计数归零。
  #|      // 不归零的话，MAX_RECONNECT 会变成「整个页面生命周期总共只有 3 次」，
  #|      // 成功重连也照扣配额，第 3 次之后再断线就永远不连了。
  #|      const isReconnect = reconnectAttempts > 0;
  #|      reconnectAttempts = 0;
  #|      let bytes = connectBytes;
  #|      if (isReconnect) {
  #|        bytes = _M0FP38Duckweed11moon_2dmqtt7browser25browser__reconnect__bytes();
  #|      }
  #|      const u8 = new Uint8Array(bytes.length);
  #|      for (let i = 0; i < bytes.length; i++) u8[i] = bytes[i];
  #|      ws.send(u8.buffer);
  #|      startKeepAlive();
  #|    };
  #|    ws.onmessage = function(ev) {
  #|      const u8 = new Uint8Array(ev.data);
  #|      const arr = [];
  #|      for (let j = 0; j < u8.length; j++) arr.push(u8[j]);
  #|      _M0FP38Duckweed11moon_2dmqtt7browser20browser__on__message(arr);
  #|    };
  #|    ws.onclose = function() {
  #|      stopKeepAlive();
  #|      _M0FP38Duckweed11moon_2dmqtt7browser18browser__on__close();
  #|      if (typeof globalThis !== "undefined" && globalThis.moonMqttManualClose) {
  #|        console.log("[browser] manual close, no reconnect");
  #|        return;
  #|      }
  #|      if (reconnectAttempts < MAX_RECONNECT) {
  #|        reconnectAttempts = reconnectAttempts + 1;
  #|        console.log("[browser] reconnect attempt #" + reconnectAttempts + " in 1s");
  #|        setTimeout(open, 1000);
  #|      }
  #|    };
  #|  }
  #|  open();
  #|}

///|
/// 发送字节到 WebSocket。未 OPEN 时丢弃并告警，避免抛 InvalidStateError。
fn browser_send(bytes : Array[Int32]) -> Unit {
  browser_send_ffi(to_fixed_array(bytes))
}

///|
/// 标记这是一次主动断开：onclose 不再自动重连。
extern "js" fn mark_manual_close_ffi() -> Unit =
  #|() => {
  #|  if (typeof globalThis !== "undefined") { globalThis.moonMqttManualClose = true; }
  #|}

///|
/// 主动关闭 WebSocket。
extern "js" fn close_ws_ffi() -> Unit =
  #|() => {
  #|  const ws = (typeof globalThis !== "undefined") ? globalThis.moonMQTTWs : null;
  #|  if (ws) { try { ws.close(); } catch (e) {} }
  #|}

///|
extern "js" fn browser_send_ffi(bytes : FixedArray[Int32]) -> Unit =
  #|(bytes) => {
  #|  const ws = (typeof globalThis !== "undefined") ? globalThis.moonMQTTWs : null;
  #|  if (ws && ws.readyState === 1) {
  #|    const u8 = new Uint8Array(bytes.length);
  #|    for (let i = 0; i < bytes.length; i++) u8[i] = bytes[i];
  #|    ws.send(u8.buffer);
  #|  } else {
  #|    console.warn("[browser] socket not open, drop " + bytes.length + " bytes");
  #|  }
  #|}

///|
/// 重连时由 JS 调用：返回新 CONNECT 字节。
pub fn browser_reconnect_bytes() -> Array[Int32] {
  match g_core[0] {
    Some(core) => core.reconnect_bytes()
    None => []
  }
}

///|
/// DCE 防护：确保 browser_on_message / browser_on_close / browser_reconnect_bytes
/// 被 extern "js" 引用时不被 dead code elimination 干掉。
pub fn _browser_dce_protect() -> Unit {
  let _ = browser_on_message([])
  let _ = browser_on_close()
  let _ = browser_reconnect_bytes()
  let _ = browser_tick(0)
}

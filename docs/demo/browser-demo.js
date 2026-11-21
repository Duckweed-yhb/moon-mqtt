function _M0TPB5ArrayGORP38Duckweed11moon_2dmqtt4core10ClientCoreE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGOWsRPB5ArrayGiEEuE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGOWEuE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGOWsEuE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGiE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGbE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPC16string10StringView(param0, param1, param2) {
  this.str = param0;
  this.start = param1;
  this.end = param2;
}
function $oob() {
  throw new Error("Index out of bounds");
}
class $PanicError extends Error {}
function $panic(message) {
  throw new $PanicError(message);
}
function _M0TPB13StringBuilder(param0) {
  this.val = param0;
}
const _M0FPB19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
function _M0TPB4IterGRPC16string10StringViewE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB4IterGcE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB8MutLocalGiE(param0) {
  this.val = param0;
}
const _M0FPB22js__code__unit__string = (c) => String.fromCharCode(c);
const _M0FPB13js__index__of = (s, start, end, p) => {
  if (end - start < p.length) return -1;
  if (end === s.length) return s.indexOf(p, start);
  const i = s.substring(start, end).indexOf(p);
  return i < 0 ? i : start + i;
};
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
const _M0FPB13js__substring = (s, start, end) => start === 0 && end === s.length ? s : s.substring(start, end);
function _M0TPB5ArrayGRPC16string10StringViewE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB8MutLocalGORPC16string10StringViewE(param0) {
  this.val = param0;
}
function _M0DTPB6ResultGusE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGusE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGusE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGusE2Ok.prototype.$tag = 1;
function _M0TP38Duckweed11moon_2dmqtt8protocol12Subscription(param0, param1) {
  this.topic = param0;
  this.qos = param1;
}
function _M0TP38Duckweed11moon_2dmqtt8protocol15SubscribePacket(param0, param1) {
  this.packet_id = param0;
  this.subscriptions = param1;
}
function _M0TP38Duckweed11moon_2dmqtt8protocol10ByteWriter(param0) {
  this.bytes = param0;
}
function _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0DTPB6ResultGUiiEsE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGUiiEsE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGUiiEsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGUiiEsE2Ok.prototype.$tag = 1;
function _M0TP38Duckweed11moon_2dmqtt8protocol10ByteReader(param0) {
  this.data = param0;
}
function _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE2Ok.prototype.$tag = 1;
function _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP38Duckweed11moon_2dmqtt8protocol6Suback(param0, param1) {
  this.packet_id = param0;
  this.codes = param1;
}
function _M0DTPB6ResultGisE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGisE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGisE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGisE2Ok.prototype.$tag = 1;
function _M0TP38Duckweed11moon_2dmqtt8protocol13PublishPacket(param0, param1, param2, param3, param4, param5) {
  this.topic = param0;
  this.payload = param1;
  this.qos = param2;
  this.retain = param3;
  this.dup = param4;
  this.packet_id = param5;
}
function _M0TPB8MutLocalGsE(param0) {
  this.val = param0;
}
function _M0DTPB6ResultGssE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGssE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGssE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGssE2Ok.prototype.$tag = 1;
function _M0DTPB6ResultGURPB5ArrayGiEiEsE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGURPB5ArrayGiEiEsE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGURPB5ArrayGiEiEsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGURPB5ArrayGiEiEsE2Ok.prototype.$tag = 1;
function _M0DTPB6ResultGUsiEsE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGUsiEsE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGUsiEsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGUsiEsE2Ok.prototype.$tag = 1;
function _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE2Ok.prototype.$tag = 1;
function _M0DTPB6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE2Ok.prototype.$tag = 1;
function _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE2Ok.prototype.$tag = 1;
function _M0TP38Duckweed11moon_2dmqtt8protocol7Connack(param0, param1) {
  this.session_present = param0;
  this.return_code = param1;
}
function _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok.prototype.$tag = 1;
function _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Connack(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Connack.prototype.$tag = 0;
function _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Publish(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Publish.prototype.$tag = 1;
function _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Puback(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Puback.prototype.$tag = 2;
function _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Pubrec(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Pubrec.prototype.$tag = 3;
function _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Pubrel(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Pubrel.prototype.$tag = 4;
function _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Pubcomp(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Pubcomp.prototype.$tag = 5;
function _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Suback(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Suback.prototype.$tag = 6;
function _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8Unsuback(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8Unsuback.prototype.$tag = 7;
function _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8PingResp() {}
_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8PingResp.prototype.$tag = 8;
const _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8PingResp__ = new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8PingResp();
function _M0TP38Duckweed11moon_2dmqtt8protocol13ConnectPacket(param0, param1, param2, param3, param4, param5, param6, param7, param8) {
  this.client_id = param0;
  this.keep_alive = param1;
  this.clean_session = param2;
  this.username = param3;
  this.password = param4;
  this.will_topic = param5;
  this.will_message = param6;
  this.will_qos = param7;
  this.will_retain = param8;
}
function _M0TP38Duckweed11moon_2dmqtt7session12SessionStore(param0, param1) {
  this.inflight = param0;
  this.next_id = param1;
}
function _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt7session13InFlightEntryE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB8MutLocalGbE(param0) {
  this.val = param0;
}
function _M0TP38Duckweed11moon_2dmqtt7session13InFlightEntry(param0, param1, param2) {
  this.packet_id = param0;
  this.publish = param1;
  this.stage = param2;
}
function _M0TPB8MutLocalGRPB5ArrayGiEE(param0) {
  this.val = param0;
}
function _M0TPB5ArrayGRPB5ArrayGiEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TP38Duckweed11moon_2dmqtt4core6Framer(param0, param1) {
  this.buf = param0;
  this.limit = param1;
}
function _M0DTPB6ResultGRPB5ArrayGRPB5ArrayGiEEsE3Err(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRPB5ArrayGRPB5ArrayGiEEsE3Err.prototype.$tag = 0;
function _M0DTPB6ResultGRPB5ArrayGRPB5ArrayGiEEsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPB6ResultGRPB5ArrayGRPB5ArrayGiEEsE2Ok.prototype.$tag = 1;
function _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction6Ignore() {}
_M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction6Ignore.prototype.$tag = 0;
const _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction6Ignore__ = new _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction6Ignore();
function _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction9Connected(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction9Connected.prototype.$tag = 1;
function _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction7Refused(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction7Refused.prototype.$tag = 2;
function _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction5Fatal(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction5Fatal.prototype.$tag = 3;
function _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction7Deliver(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction7Deliver.prototype.$tag = 4;
function _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction8Subacked() {}
_M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction8Subacked.prototype.$tag = 5;
const _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction8Subacked__ = new _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction8Subacked();
function _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction14SubackRejected(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction14SubackRejected.prototype.$tag = 6;
function _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction7Unknown(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction7Unknown.prototype.$tag = 7;
function _M0TP38Duckweed11moon_2dmqtt4core10ClientCore(param0, param1, param2, param3, param4, param5, param6, param7) {
  this.opts = param0;
  this.state = param1;
  this.framer = param2;
  this.pending_pings = param3;
  this.session = param4;
  this.inbound_qos2 = param5;
  this.subscriptions = param6;
  this.pending_subscribes = param7;
}
function _M0TPB5ArrayGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB8MutLocalGRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEE(param0) {
  this.val = param0;
}
function _M0TPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt4core9CoreEventE(param0, param1) {
  this.buf = param0;
  this.len = param1;
}
function _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent15ConnackReceived(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent15ConnackReceived.prototype.$tag = 0;
function _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent15PublishReceived(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent15PublishReceived.prototype.$tag = 1;
function _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent14SubackReceived(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent14SubackReceived.prototype.$tag = 2;
function _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent16PingRespReceived() {}
_M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent16PingRespReceived.prototype.$tag = 3;
const _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent16PingRespReceived__ = new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent16PingRespReceived();
function _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent17UnknownPacketType(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent17UnknownPacketType.prototype.$tag = 4;
function _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent14MalformedFrame(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent14MalformedFrame.prototype.$tag = 5;
function _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent11FramerError(param0) {
  this._0 = param0;
}
_M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent11FramerError.prototype.$tag = 6;
const _M0FP38Duckweed11moon_2dmqtt7browser13open__ws__ffi = (url, connectBytes) => {
  // 重新 connect 时，旧 socket 必须先摘掉回调再关：它的 onmessage 仍然指向
  // 同一套 MoonBit 入口，不摘的话旧连接的字节会灌进刚建好的新 core。
  const prev = (typeof globalThis !== "undefined") ? globalThis.moonMQTTWs : null;
  if (prev) {
    prev.onopen = null; prev.onmessage = null; prev.onclose = null; prev.onerror = null;
    try { prev.close(); } catch (e) {}
  }
  // 上面把旧 socket 的回调全摘了，它的 onclose 不会再跑，也就不会再走自己那份
  // stopKeepAlive。旧心跳定时器必须在这里显式清掉，否则每次重新 connect 都会
  // 多留一个 setInterval，它们一起 tick 新会话，把 PINGREQ 提前催出来。
  stopKeepAlive();
  let ws = null;
  let reconnectAttempts = 0;
  const MAX_RECONNECT = 3;
  let keepAliveTimer = null;
  function stopKeepAlive() {
    // 句柄同时挂在 globalThis 上：每次 connect 都是一个新的闭包，旧闭包里的
    // keepAliveTimer 从外面看不见，只能通过全局句柄把它关掉。
    if (typeof globalThis !== "undefined" && globalThis.moonMQTTKeepAliveTimer) {
      clearInterval(globalThis.moonMQTTKeepAliveTimer);
      globalThis.moonMQTTKeepAliveTimer = null;
    }
    if (keepAliveTimer !== null) { clearInterval(keepAliveTimer); keepAliveTimer = null; }
  }
  function startKeepAlive() {
    stopKeepAlive();
    // 每秒问一次 MoonBit 侧：该发 PINGREQ 了吗 / 是否已经等太久。
    // 真正的「要不要发、发几字节」由 core 的 keep_alive 与状态机决定。
    keepAliveTimer = setInterval(function() {
      _M0FP38Duckweed11moon_2dmqtt7browser13browser__tick(Date.now());
    }, 1000);
    if (typeof globalThis !== "undefined") { globalThis.moonMQTTKeepAliveTimer = keepAliveTimer; }
  }
  function open() {
    if (typeof globalThis !== "undefined") { globalThis.moonMqttManualClose = false; }
    console.log("[browser] connecting to " + url);
    ws = new WebSocket(url, "mqtt");
    ws.binaryType = "arraybuffer";
    // 暴露给 browser_send 用
    if (typeof globalThis !== "undefined") { globalThis.moonMQTTWs = ws; }
    ws.onopen = function() {
      // 连上就说明这一轮恢复成功：先把「连续失败」计数归零。
      // 不归零的话，MAX_RECONNECT 会变成「整个页面生命周期总共只有 3 次」，
      // 成功重连也照扣配额，第 3 次之后再断线就永远不连了。
      const isReconnect = reconnectAttempts > 0;
      reconnectAttempts = 0;
      let bytes = connectBytes;
      if (isReconnect) {
        bytes = _M0FP38Duckweed11moon_2dmqtt7browser25browser__reconnect__bytes();
      }
      const u8 = new Uint8Array(bytes.length);
      for (let i = 0; i < bytes.length; i++) u8[i] = bytes[i];
      ws.send(u8.buffer);
      startKeepAlive();
    };
    ws.onmessage = function(ev) {
      const u8 = new Uint8Array(ev.data);
      const arr = [];
      for (let j = 0; j < u8.length; j++) arr.push(u8[j]);
      _M0FP38Duckweed11moon_2dmqtt7browser20browser__on__message(arr);
    };
    ws.onclose = function() {
      stopKeepAlive();
      _M0FP38Duckweed11moon_2dmqtt7browser18browser__on__close();
      if (typeof globalThis !== "undefined" && globalThis.moonMqttManualClose) {
        console.log("[browser] manual close, no reconnect");
        return;
      }
      if (reconnectAttempts < MAX_RECONNECT) {
        reconnectAttempts = reconnectAttempts + 1;
        console.log("[browser] reconnect attempt #" + reconnectAttempts + " in 1s");
        // 定时器句柄挂到全局：disconnect() 要能把这个待重连取消掉。
        globalThis.moonMQTTRetryTimer = setTimeout(open, 1000);
      }
    };
  }
  open();
};
const _M0FP38Duckweed11moon_2dmqtt7browser18browser__send__ffi = (bytes) => {
  const ws = (typeof globalThis !== "undefined") ? globalThis.moonMQTTWs : null;
  if (ws && ws.readyState === 1) {
    const u8 = new Uint8Array(bytes.length);
    for (let i = 0; i < bytes.length; i++) u8[i] = bytes[i];
    ws.send(u8.buffer);
  } else {
    console.warn("[browser] socket not open, drop " + bytes.length + " bytes");
  }
};
const _M0FP38Duckweed11moon_2dmqtt7browser14close__ws__ffi = () => {
  if (typeof globalThis !== "undefined") {
    if (globalThis.moonMQTTRetryTimer) {
      clearTimeout(globalThis.moonMQTTRetryTimer);
      globalThis.moonMQTTRetryTimer = null;
    }
  }
  const ws = (typeof globalThis !== "undefined") ? globalThis.moonMQTTWs : null;
  if (ws) { try { ws.close(); } catch (e) {} }
};
const _M0FP38Duckweed11moon_2dmqtt7browser24mark__manual__close__ffi = () => {
  if (typeof globalThis !== "undefined") { globalThis.moonMqttManualClose = true; }
};
const _M0FP48Duckweed11moon_2dmqtt8examples14browser_2ddemo16demo__client__id = () => "moon-demo-" + Math.random().toString(36).slice(2, 8);
const _M0FP48Duckweed11moon_2dmqtt8examples14browser_2ddemo12is__autotest = () => {
  if (typeof location === "undefined") return false;
  return new URLSearchParams(location.search).has("autotest");
};
const _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IPB13StringBuilderPB6Logger13write__string, method_1: _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE, method_2: _M0IPB13StringBuilderPB6Logger11write__view, method_3: _M0IPB13StringBuilderPB6Logger11write__char, method_4: _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE, method_5: _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE };
const _M0MPB4Iter4nextN6constrS314GRPC16string10StringViewE = 0;
const _M0MPB4Iter4nextN6constrS315GRPC16string10StringViewE = 0;
const _M0MPB4Iter4nextN6constrS322GcE = 0;
const _M0MPB4Iter4nextN6constrS323GcE = 0;
const _M0MPB4Iter3newN6constrS332GRPC16string10StringViewE = 0;
const _M0MPB4Iter3newN6constrS338GcE = 0;
const _M0FP38Duckweed11moon_2dmqtt4core22max__unanswered__pings = 3;
const _M0FP38Duckweed11moon_2dmqtt4core17max__frame__bytes = 268435460;
const _M0FP38Duckweed11moon_2dmqtt7browser7g__core = new _M0TPB5ArrayGORP38Duckweed11moon_2dmqtt4core10ClientCoreE([undefined], 1);
const _M0FP38Duckweed11moon_2dmqtt7browser7g__opts = new _M0TPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE([undefined], 1);
const _M0FP38Duckweed11moon_2dmqtt7browser10g__handler = new _M0TPB5ArrayGOWsRPB5ArrayGiEEuE([undefined], 1);
const _M0FP38Duckweed11moon_2dmqtt7browser10g__connect = new _M0TPB5ArrayGOWEuE([undefined], 1);
const _M0FP38Duckweed11moon_2dmqtt7browser9g__suback = new _M0TPB5ArrayGOWEuE([undefined], 1);
const _M0FP38Duckweed11moon_2dmqtt7browser8g__error = new _M0TPB5ArrayGOWsEuE([undefined], 1);
const _M0FP38Duckweed11moon_2dmqtt7browser17g__last__ping__ms = new _M0TPB5ArrayGiE([0], 1);
const _M0FP48Duckweed11moon_2dmqtt8examples14browser_2ddemo13g__subscribed = new _M0TPB5ArrayGbE([false], 1);
const _M0MPC16string10StringView4findN6constrS467 = 0;
function _M0MPC15array5Array6bufferGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self) {
  return self.buf;
}
function _M0MPC15array5Array6bufferGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(self) {
  return self.buf;
}
function _M0MPC15array5Array6bufferGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self) {
  return self.buf;
}
function _M0MPC15array5Array6bufferGiE(self) {
  return self.buf;
}
function _M0MPC15array5Array6bufferGbE(self) {
  return self.buf;
}
function _M0MPC16string10StringView12unsafe__view(self, start, end) {
  return new _M0TPC16string10StringView(self.str, self.start + start | 0, self.start + end | 0);
}
function _M0MPB18UninitializedArray6lengthGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self) {
  return self.length;
}
function _M0MPB18UninitializedArray6lengthGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self) {
  return self.length;
}
function _M0MPB18UninitializedArray6lengthGiE(self) {
  return self.length;
}
function _M0MPB18UninitializedArray6lengthGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self) {
  return self.length;
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGRPC16string10StringViewEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGiEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPB18UninitializedArray12unsafe__blitGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGRPC16string10StringViewEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGiE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGiEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGiE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGiE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0FPB11range__fits(offset, len, length) {
  return offset >= 0 && offset <= (length - len | 0);
}
function _M0MPB13StringBuilder13write__objectGiE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGiE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(src, allocate_len, len, src_offset, dst_offset) {
  if (allocate_len >= 0 && (len >= 0 && (_M0FPB11range__fits(src_offset, len, _M0MPB18UninitializedArray6lengthGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(src)) && _M0FPB11range__fits(dst_offset, len, allocate_len)))) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, _M0MPB18UninitializedArray6lengthGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(src));
    return $panic(_M0MPB13StringBuilder10to__string(_string_builder));
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(src, allocate_len, len, src_offset, dst_offset) {
  if (allocate_len >= 0 && (len >= 0 && (_M0FPB11range__fits(src_offset, len, _M0MPB18UninitializedArray6lengthGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(src)) && _M0FPB11range__fits(dst_offset, len, allocate_len)))) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, _M0MPB18UninitializedArray6lengthGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(src));
    return $panic(_M0MPB13StringBuilder10to__string(_string_builder));
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGiE(src, allocate_len, len, src_offset, dst_offset) {
  if (allocate_len >= 0 && (len >= 0 && (_M0FPB11range__fits(src_offset, len, _M0MPB18UninitializedArray6lengthGiE(src)) && _M0FPB11range__fits(dst_offset, len, allocate_len)))) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGiE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, _M0MPB18UninitializedArray6lengthGiE(src));
    return $panic(_M0MPB13StringBuilder10to__string(_string_builder));
  }
}
function _M0MPB18UninitializedArray23make__and__blit_2einnerGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(src, allocate_len, len, src_offset, dst_offset) {
  if (allocate_len >= 0 && (len >= 0 && (_M0FPB11range__fits(src_offset, len, _M0MPB18UninitializedArray6lengthGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(src)) && _M0FPB11range__fits(dst_offset, len, allocate_len)))) {
    return _M0MPB18UninitializedArray23unsafe__make__and__blitGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(src, allocate_len, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, _M0MPB18UninitializedArray6lengthGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(src));
    return $panic(_M0MPB13StringBuilder10to__string(_string_builder));
  }
}
function _M0MPC13int3Int16unsafe__to__char(self) {
  return self;
}
function _M0MPB13StringBuilder21StringBuilder_2einner(size_hint) {
  return size_hint >= 0 ? new _M0TPB13StringBuilder("") : $panic("size_hint must be non-negative");
}
function _M0MPB13StringBuilder10to__string(self) {
  return self.val;
}
function _M0IPB13StringBuilderPB6Logger11write__char(self, ch) {
  self.val = `${self.val}${String.fromCodePoint(ch)}`;
}
function _M0IPB13StringBuilderPB6Logger13write__string(self, str) {
  self.val = `${self.val}${str}`;
}
function _M0MPC16uint166UInt1622is__leading__surrogate(self) {
  return self >= 55296 && self <= 56319;
}
function _M0MPC16uint166UInt1623is__trailing__surrogate(self) {
  return self >= 56320 && self <= 57343;
}
function _M0FPB32code__point__of__surrogate__pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function _M0MPC16uint166UInt1616unsafe__to__char(self) {
  return self;
}
function _M0IP016_24default__implPB2Eq10not__equalGRPC16string10StringViewE(x, y) {
  return !_M0IPC16string10StringViewPB2Eq5equal(x, y);
}
function _M0IP016_24default__implPB2Eq10not__equalGRP38Duckweed11moon_2dmqtt8protocol3QoSE(x, y) {
  return !_M0IP38Duckweed11moon_2dmqtt8protocol3QoSPB2Eq5equal(x, y);
}
function _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPC16string6String21clamped__view_2einner(self, start, end) {
  const len = self.length;
  const lo = start <= 0 ? 0 : start >= len ? len : _M0MPC16uint166UInt1623is__trailing__surrogate(self.charCodeAt(start)) && _M0MPC16uint166UInt1622is__leading__surrogate(self.charCodeAt(start - 1 | 0)) ? start + 1 | 0 : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _e = _Some;
    hi = _e <= 0 ? 0 : _e >= len ? len : _M0MPC16uint166UInt1623is__trailing__surrogate(self.charCodeAt(_e)) && _M0MPC16uint166UInt1622is__leading__surrogate(self.charCodeAt(_e - 1 | 0)) ? _e - 1 | 0 : _e;
  }
  return lo >= hi ? new _M0TPC16string10StringView(self, lo, lo) : new _M0TPC16string10StringView(self, lo, hi);
}
function _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(self, value, start, len) {
  _M0IPB13StringBuilderPB6Logger11write__view(self, _M0MPC16string6String21clamped__view_2einner(value, start, start + len | 0));
}
function _M0MPC16string10StringView4data(self) {
  return self.str;
}
function _M0MPC16string10StringView13start__offset(self) {
  return self.start;
}
function _M0IP016_24default__implPB4Show6outputGiE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC13int3IntPB4Show10to__string(self));
}
function _M0MPB4Iter4nextGRPC16string10StringViewE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === undefined) {
    self.size_hint = _M0MPB4Iter4nextN6constrS315GRPC16string10StringViewE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS314GRPC16string10StringViewE;
    }
  }
  return result;
}
function _M0MPB4Iter4nextGcE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === -1) {
    self.size_hint = _M0MPB4Iter4nextN6constrS323GcE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS322GcE;
    }
  }
  return result;
}
function _M0MPC13int3Int18to__string_2einner(self, radix) {
  return _M0FPB19int__to__string__js(self, radix);
}
function _M0MPB4Iter3newGRPC16string10StringViewE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS332GRPC16string10StringViewE;
  }
  return new _M0TPB4IterGRPC16string10StringViewE(f, size_hint$2);
}
function _M0MPB4Iter3newGcE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS338GcE;
  }
  return new _M0TPB4IterGcE(f, size_hint$2);
}
function _M0MPC16string10StringView9to__owned(self) {
  return self.str.substring(self.start, self.end);
}
function _M0MPC16string10StringView4iter(self) {
  const start = self.start;
  const end = self.end;
  const index = new _M0TPB8MutLocalGiE(start);
  return _M0MPB4Iter3newGcE(() => {
    if (index.val < end) {
      const c1 = self.str.charCodeAt(index.val);
      if (_M0MPC16uint166UInt1622is__leading__surrogate(c1) && (index.val + 1 | 0) < self.end) {
        const c2 = self.str.charCodeAt(index.val + 1 | 0);
        if (_M0MPC16uint166UInt1623is__trailing__surrogate(c2)) {
          index.val = index.val + 2 | 0;
          return _M0FPB32code__point__of__surrogate__pair(c1, c2);
        }
      }
      index.val = index.val + 1 | 0;
      return _M0MPC16uint166UInt1616unsafe__to__char(c1);
    } else {
      return -1;
    }
  }, undefined);
}
function _M0MPC16string6String20unsafe__range__equal(self, start, other, other_start, len) {
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      if (self.charCodeAt(start + i | 0) === other.charCodeAt(other_start + i | 0)) {
      } else {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0IPC16string10StringViewPB2Eq5equal(self, other) {
  const len = self.end - self.start | 0;
  if (len === (other.end - other.start | 0)) {
    if (self.str === other.str && self.start === other.start) {
      return true;
    }
    return _M0MPC16string6String20unsafe__range__equal(self.str, self.start, other.str, other.start, len);
  } else {
    return false;
  }
}
function _M0IPB13StringBuilderPB6Logger11write__view(self, str) {
  self.val = `${self.val}${_M0MPC16string10StringView9to__owned(str)}`;
}
function _M0FPB24find__code__unit__scalar(data, start, end, code) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < end) {
      if (data.charCodeAt(pos) === code) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB30find__code__unit__from__string(data, start, end, code) {
  return (end - start | 0) <= 8 ? _M0FPB24find__code__unit__scalar(data, start, end, code) : _M0FPB13js__index__of(data, start, end, _M0FPB22js__code__unit__string(code));
}
function _M0FPB28find__code__unit__from__view(target, start, end, code) {
  const target_start = _M0MPC16string10StringView13start__offset(target);
  const found = _M0FPB30find__code__unit__from__string(_M0MPC16string10StringView4data(target), target_start + start | 0, target_start + end | 0, code);
  return found < 0 ? -1 : found - target_start | 0;
}
function _M0FPB19kmp__failure__table(pattern) {
  const m = pattern.end - pattern.start | 0;
  const table = $make_array_len_and_init(m, 0);
  let k = 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < m) {
      const c = pattern.str.charCodeAt(pattern.start + i | 0);
      while (true) {
        if (k > 0 && c !== pattern.str.charCodeAt(pattern.start + k | 0)) {
          const _tmp$2 = k - 1 | 0;
          k = _tmp$2 >>> 0 < table.length ? table[_tmp$2] : $oob();
          continue;
        } else {
          break;
        }
      }
      if (c === pattern.str.charCodeAt(pattern.start + k | 0)) {
        k = k + 1 | 0;
      }
      if (i >>> 0 < table.length) {
        table[i] = k;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return table;
}
function _M0FPB24find__pattern__kmp__from(target, pattern, start) {
  const n = target.end - target.start | 0;
  const m = pattern.end - pattern.start | 0;
  const table = _M0FPB19kmp__failure__table(pattern);
  let k = 0;
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < n) {
      const c = target.str.charCodeAt(target.start + i | 0);
      while (true) {
        if (k > 0 && c !== pattern.str.charCodeAt(pattern.start + k | 0)) {
          const _tmp$2 = k - 1 | 0;
          k = _tmp$2 >>> 0 < table.length ? table[_tmp$2] : $oob();
          continue;
        } else {
          break;
        }
      }
      if (c === pattern.str.charCodeAt(pattern.start + k | 0)) {
        k = k + 1 | 0;
      }
      if (k === m) {
        return (i - m | 0) + 1 | 0;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < candidate_end) {
      if (data.charCodeAt(pos) === first && data.charCodeAt(pos + last_offset | 0) === last) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB42find__two__anchor__candidate__from__string(data, start, candidate_end, first, last_offset, last) {
  return _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last);
}
function _M0FPB21string__ranges__equal(left, left_start, right, right_start, length) {
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < length) {
      if (left.charCodeAt(left_start + i | 0) !== right.charCodeAt(right_start + i | 0)) {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FPB29two__anchor__should__fallback(failures, scanned) {
  if (failures > 64) {
    return true;
  } else {
    if (8 === 0) {
      $panic();
    }
    return failures > (4 + (scanned / 8 | 0) | 0);
  }
}
function _M0FPB22find__by__two__anchors(target, pattern) {
  const target_len = target.end - target.start | 0;
  const pattern_len = pattern.end - pattern.start | 0;
  const target_start = _M0MPC16string10StringView13start__offset(target);
  const pattern_start = _M0MPC16string10StringView13start__offset(pattern);
  const last_offset = pattern_len - 1 | 0;
  const candidate_end = ((target_start + target_len | 0) - pattern_len | 0) + 1 | 0;
  const first = pattern.str.charCodeAt(pattern.start);
  const last = pattern.str.charCodeAt(pattern.start + last_offset | 0);
  const middle_len = last_offset - 1 | 0;
  let _tmp = target_start;
  let _tmp$2 = 0;
  while (true) {
    const pos = _tmp;
    const failures = _tmp$2;
    if (pos < candidate_end) {
      const found = _M0FPB42find__two__anchor__candidate__from__string(_M0MPC16string10StringView4data(target), pos, candidate_end, first, last_offset, last);
      if (found < 0) {
        return undefined;
      }
      if (_M0FPB21string__ranges__equal(_M0MPC16string10StringView4data(target), found + 1 | 0, _M0MPC16string10StringView4data(pattern), pattern_start + 1 | 0, middle_len)) {
        return found - target_start | 0;
      }
      const failures$2 = failures + 1 | 0;
      const scanned = found - target_start | 0;
      if (_M0FPB29two__anchor__should__fallback(failures$2, scanned)) {
        return _M0FPB24find__pattern__kmp__from(target, pattern, scanned + 1 | 0);
      }
      _tmp = found + 1 | 0;
      _tmp$2 = failures$2;
      continue;
    } else {
      return undefined;
    }
  }
}
function _M0FPB13find__pattern(target, pattern) {
  if ((pattern.end - pattern.start | 0) <= 250) {
    const target_start = _M0MPC16string10StringView13start__offset(target);
    const pattern_start = _M0MPC16string10StringView13start__offset(pattern);
    const found = _M0FPB13js__index__of(_M0MPC16string10StringView4data(target), target_start, target_start + (target.end - target.start | 0) | 0, _M0FPB13js__substring(_M0MPC16string10StringView4data(pattern), pattern_start, pattern_start + (pattern.end - pattern.start | 0) | 0));
    return found < 0 ? undefined : found - target_start | 0;
  } else {
    return _M0FPB22find__by__two__anchors(target, pattern);
  }
}
function _M0MPC16string10StringView4find(self, str) {
  const pattern_len = str.end - str.start | 0;
  switch (pattern_len) {
    case 0: {
      return _M0MPC16string10StringView4findN6constrS467;
    }
    case 1: {
      const found = _M0FPB28find__code__unit__from__view(self, 0, self.end - self.start | 0, str.str.charCodeAt(str.start));
      return found < 0 ? undefined : found;
    }
    default: {
      return pattern_len > (self.end - self.start | 0) ? undefined : _M0FPB13find__pattern(self, str);
    }
  }
}
function _M0IPC16string6StringPB4Show10to__string(self) {
  return self;
}
function _M0MPC15array5Array13Array_2einnerGRPC16string10StringViewE(capacity) {
  return capacity === 0 ? new _M0TPB5ArrayGRPC16string10StringViewE([], 0) : new _M0TPB5ArrayGRPC16string10StringViewE(new Array(capacity), 0);
}
function _M0MPC15array5Array6lengthGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self) {
  return self.len;
}
function _M0MPC15array5Array6lengthGRPC16string10StringViewE(self) {
  return self.len;
}
function _M0MPC15array5Array6lengthGiE(self) {
  return self.len;
}
function _M0MPC15array5Array6lengthGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self) {
  return self.len;
}
function _M0FPB23array__growth__capacity(current, len, required) {
  if (required < len) {
    $panic("Array capacity overflow");
  }
  const start = current === 0 ? 8 : current;
  let _tmp = start;
  while (true) {
    const space = _tmp;
    if (space < required) {
      const next = Math.imul(space, 2) | 0;
      if (next <= space) {
        return required;
      }
      _tmp = next;
      continue;
    } else {
      return space;
    }
  }
}
function _M0MPC15array5Array8capacityGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self) {
  return _M0MPC15array5Array6bufferGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self).length;
}
function _M0MPC15array5Array8capacityGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self) {
  return _M0MPC15array5Array6bufferGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self).length;
}
function _M0MPC15array5Array8capacityGiE(self) {
  return _M0MPC15array5Array6bufferGiE(self).length;
}
function _M0MPC15array5Array8capacityGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self) {
  return _M0MPC15array5Array6bufferGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(self).length;
}
function _M0MPC15array5Array14resize__bufferGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGiE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGiE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array14resize__bufferGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self, new_capacity) {
  const old_buf = self.buf;
  self.buf = [];
  const len = self.len;
  const copy_len = len < new_capacity ? len : new_capacity;
  const new_buf = _M0MPB18UninitializedArray23make__and__blit_2einnerGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(old_buf, new_capacity, copy_len, 0, 0);
  self.buf = new_buf;
}
function _M0MPC15array5Array7reallocGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self, new_cap);
}
function _M0MPC15array5Array7reallocGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self, new_cap);
}
function _M0MPC15array5Array7reallocGiE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGiE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGiE(self, new_cap);
}
function _M0MPC15array5Array7reallocGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self, required) {
  const old_cap = _M0MPC15array5Array8capacityGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self);
  const new_cap = _M0FPB23array__growth__capacity(old_cap, self.len, required);
  _M0MPC15array5Array14resize__bufferGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self, new_cap);
}
function _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self, value) {
  if (self.len === _M0MPC15array5Array6bufferGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self).length) {
    _M0MPC15array5Array7reallocGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self, value) {
  if (self.len === _M0MPC15array5Array6bufferGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self).length) {
    _M0MPC15array5Array7reallocGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGiE(self, value) {
  if (self.len === _M0MPC15array5Array6bufferGiE(self).length) {
    _M0MPC15array5Array7reallocGiE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0MPC15array5Array4pushGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self, value) {
  if (self.len === _M0MPC15array5Array6bufferGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(self).length) {
    _M0MPC15array5Array7reallocGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self, self.len + 1 | 0);
  }
  const length = self.len;
  self.buf[length] = value;
  self.len = length + 1 | 0;
}
function _M0FPB36string__contains__code__unit__scalar(str, start, end, code) {
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < end) {
      if (str.charCodeAt(i) === code) {
        return true;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FPB28string__contains__code__unit(str, start, end, code) {
  return _M0FPB36string__contains__code__unit__scalar(str, start, end, code);
}
function _M0MPC16string10StringView20contains__code__unit(self, code) {
  return _M0FPB28string__contains__code__unit(self.str, self.start, self.end, code);
}
function _M0MPC16string10StringView8contains(self, str) {
  const _bind = str.end - str.start | 0;
  switch (_bind) {
    case 0: {
      return true;
    }
    case 1: {
      return _M0MPC16string10StringView20contains__code__unit(self, str.str.charCodeAt(str.start));
    }
    default: {
      const _bind$2 = _M0MPC16string10StringView4find(self, str);
      return !(_bind$2 === undefined);
    }
  }
}
function _M0MPC16string6String8contains(self, str) {
  return _M0MPC16string10StringView8contains(new _M0TPC16string10StringView(self, 0, self.length), str);
}
function _M0MPB4Iter3mapGcRPC16string10StringViewE(self, f) {
  return new _M0TPB4IterGRPC16string10StringViewE(() => {
    const _bind = _M0MPB4Iter4nextGcE(self);
    if (_bind === -1) {
      return undefined;
    } else {
      const _Some = _bind;
      const _x = _Some;
      return f(_x);
    }
  }, self.size_hint);
}
function _M0IPC14char4CharPB4Show10to__string(self) {
  return String.fromCodePoint(self);
}
function _M0MPC16string10StringView5split(self, sep) {
  const sep_len = sep.end - sep.start | 0;
  if (sep_len === 0) {
    return _M0MPB4Iter3mapGcRPC16string10StringViewE(_M0MPC16string10StringView4iter(self), (c) => {
      const _bind = _M0IPC14char4CharPB4Show10to__string(c);
      return new _M0TPC16string10StringView(_bind, 0, _bind.length);
    });
  }
  const remaining = new _M0TPB8MutLocalGORPC16string10StringViewE(self);
  return _M0MPB4Iter3newGRPC16string10StringViewE(() => {
    const _bind = remaining.val;
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _view = _Some;
      const _bind$2 = _M0MPC16string10StringView4find(_view, sep);
      if (_bind$2 === undefined) {
        remaining.val = undefined;
        return _view;
      } else {
        const _Some$2 = _bind$2;
        const _end = _Some$2;
        remaining.val = _M0MPC16string10StringView12unsafe__view(_view, _end + sep_len | 0, _view.end - _view.start | 0);
        return _M0MPC16string10StringView12unsafe__view(_view, 0, _end);
      }
    }
  }, undefined);
}
function _M0MPC16string6String5split(self, sep) {
  return _M0MPC16string10StringView5split(new _M0TPC16string10StringView(self, 0, self.length), sep);
}
function _M0MPB4Iter9to__arrayGRPC16string10StringViewE(self) {
  const _bind = self.size_hint;
  let result;
  if (_bind === undefined) {
    result = new _M0TPB5ArrayGRPC16string10StringViewE([], 0);
  } else {
    const _Some = _bind;
    const _n = _Some;
    result = _M0MPC15array5Array13Array_2einnerGRPC16string10StringViewE(_n);
  }
  while (true) {
    const _bind$2 = _M0MPB4Iter4nextGRPC16string10StringViewE(self);
    if (_bind$2 === undefined) {
      break;
    } else {
      const _Some = _bind$2;
      const _x = _Some;
      _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(result, _x);
      continue;
    }
  }
  return result;
}
function _M0IPC13int3IntPB4Show10to__string(self) {
  return _M0MPC13int3Int18to__string_2einner(self, 10);
}
function _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(self, index) {
  const len = self.len;
  return index >= 0 && index < len ? _M0MPC15array5Array6bufferGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(self)[index] : $panic();
}
function _M0MPC15array5Array2atGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self, index) {
  const len = self.len;
  return index >= 0 && index < len ? _M0MPC15array5Array6bufferGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self)[index] : $panic();
}
function _M0MPC15array5Array2atGRPC16string10StringViewE(self, index) {
  const len = self.len;
  return index >= 0 && index < len ? _M0MPC15array5Array6bufferGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self)[index] : $panic();
}
function _M0MPC15array5Array2atGiE(self, index) {
  const len = self.len;
  return index >= 0 && index < len ? _M0MPC15array5Array6bufferGiE(self)[index] : $panic();
}
function _M0MPC15array5Array2atGbE(self, index) {
  const len = self.len;
  return index >= 0 && index < len ? _M0MPC15array5Array6bufferGbE(self)[index] : $panic();
}
function _M0FPB7printlnGsE(input) {
  console.log(_M0IPC16string6StringPB4Show10to__string(input));
}
function _M0MPC15array5Array28unsafe__truncate__to__lengthGiE(self, new_len) {
  if (new_len <= self.len) {
    self.len = new_len;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(self, index, value) {
  const len = self.len;
  if (index >= 0 && index < len) {
    _M0MPC15array5Array6bufferGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(self)[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array3setGiE(self, index, value) {
  const len = self.len;
  if (index >= 0 && index < len) {
    _M0MPC15array5Array6bufferGiE(self)[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array3setGbE(self, index, value) {
  const len = self.len;
  if (index >= 0 && index < len) {
    _M0MPC15array5Array6bufferGbE(self)[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array3setGRP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self, index, value) {
  const len = self.len;
  if (index >= 0 && index < len) {
    _M0MPC15array5Array6bufferGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self)[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array5clearGiE(self) {
  _M0MPC15array5Array28unsafe__truncate__to__lengthGiE(self, 0);
}
function _M0IP38Duckweed11moon_2dmqtt8protocol3QoSPB2Eq5equal(_x_348, _x_349) {
  switch (_x_348) {
    case 0: {
      if (_x_349 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_349 === 1) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_349 === 2) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function _M0FP38Duckweed11moon_2dmqtt8protocol12utf8__encode(s) {
  const out = new _M0TPB5ArrayGiE([], 0);
  const _bind = s.length;
  let _tmp = 0;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$2 = s.charCodeAt(_string_index);
        if (_bind$2 >= 55296 && _bind$2 <= 56319 && (_string_index + 1 | 0) < _bind) {
          const _bind$3 = s.charCodeAt(_string_index + 1 | 0);
          if (_bind$3 >= 56320 && _bind$3 <= 57343) {
            _decoded_next_string_index = _string_index + 2 | 0;
            _decoded_char = _M0MPC13int3Int16unsafe__to__char((((Math.imul(_bind$2 - 55296 | 0, 1024) | 0) + _bind$3 | 0) - 56320 | 0) + 65536 | 0);
            break _L;
          } else {
            _decoded_next_string_index = _string_index + 1 | 0;
            _decoded_char = _M0MPC13int3Int16unsafe__to__char(_bind$2);
            break _L;
          }
        } else {
          _decoded_next_string_index = _string_index + 1 | 0;
          _decoded_char = _M0MPC13int3Int16unsafe__to__char(_bind$2);
          break _L;
        }
      }
      const _next_string_index = _decoded_next_string_index;
      const c = _decoded_char;
      const cp = c;
      if (cp < 128) {
        _M0MPC15array5Array4pushGiE(out, cp);
      } else {
        if (cp < 2048) {
          _M0MPC15array5Array4pushGiE(out, 192 | cp >> 6);
          _M0MPC15array5Array4pushGiE(out, 128 | cp & 63);
        } else {
          if (cp < 65536) {
            _M0MPC15array5Array4pushGiE(out, 224 | cp >> 12);
            _M0MPC15array5Array4pushGiE(out, 128 | cp >> 6 & 63);
            _M0MPC15array5Array4pushGiE(out, 128 | cp & 63);
          } else {
            _M0MPC15array5Array4pushGiE(out, 240 | cp >> 18);
            _M0MPC15array5Array4pushGiE(out, 128 | cp >> 12 & 63);
            _M0MPC15array5Array4pushGiE(out, 128 | cp >> 6 & 63);
            _M0MPC15array5Array4pushGiE(out, 128 | cp & 63);
          }
        }
      }
      _tmp = _next_string_index;
      continue;
    } else {
      break;
    }
  }
  return out;
}
function _M0FP38Duckweed11moon_2dmqtt8protocol21validate__topic__name(topic) {
  const n = _M0MPC15array5Array6lengthGiE(_M0FP38Duckweed11moon_2dmqtt8protocol12utf8__encode(topic));
  if (n === 0) {
    return new _M0DTPB6ResultGusE3Err("empty topic");
  }
  if (n > 65535) {
    return new _M0DTPB6ResultGusE3Err("topic too long (>65535 UTF-8 bytes)");
  }
  if (_M0MPC16string6String8contains(topic, new _M0TPC16string10StringView("\u0000", 0, 1))) {
    return new _M0DTPB6ResultGusE3Err("topic contains NUL");
  }
  if (_M0MPC16string6String8contains(topic, new _M0TPC16string10StringView("+", 0, 1)) || _M0MPC16string6String8contains(topic, new _M0TPC16string10StringView("#", 0, 1))) {
    return new _M0DTPB6ResultGusE3Err("publish topic must not contain wildcards");
  }
  return new _M0DTPB6ResultGusE2Ok(undefined);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol23validate__topic__filter(filter) {
  const n = _M0MPC15array5Array6lengthGiE(_M0FP38Duckweed11moon_2dmqtt8protocol12utf8__encode(filter));
  if (n === 0) {
    return new _M0DTPB6ResultGusE3Err("empty topic filter");
  }
  if (n > 65535) {
    return new _M0DTPB6ResultGusE3Err("topic filter too long (>65535 UTF-8 bytes)");
  }
  if (_M0MPC16string6String8contains(filter, new _M0TPC16string10StringView("\u0000", 0, 1))) {
    return new _M0DTPB6ResultGusE3Err("topic filter contains NUL");
  }
  const parts = _M0MPB4Iter9to__arrayGRPC16string10StringViewE(_M0MPC16string6String5split(filter, new _M0TPC16string10StringView("/", 0, 1)));
  const _bind = 0;
  const _bind$2 = _M0MPC15array5Array6lengthGRPC16string10StringViewE(parts);
  let _tmp = _bind;
  while (true) {
    const i = _tmp;
    if (i < _bind$2) {
      const seg = _M0MPC15array5Array2atGRPC16string10StringViewE(parts, i);
      if (_M0IPC16string10StringViewPB2Eq5equal(seg, new _M0TPC16string10StringView("#", 0, 1))) {
        if (i !== (_M0MPC15array5Array6lengthGRPC16string10StringViewE(parts) - 1 | 0)) {
          return new _M0DTPB6ResultGusE3Err("'#' must be the last level of a filter");
        }
      } else {
        if (_M0MPC16string10StringView8contains(seg, new _M0TPC16string10StringView("#", 0, 1))) {
          return new _M0DTPB6ResultGusE3Err("'#' must occupy an entire level");
        }
      }
      if (_M0IP016_24default__implPB2Eq10not__equalGRPC16string10StringViewE(seg, new _M0TPC16string10StringView("+", 0, 1)) && _M0MPC16string10StringView8contains(seg, new _M0TPC16string10StringView("+", 0, 1))) {
        return new _M0DTPB6ResultGusE3Err("'+' must occupy an entire level");
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPB6ResultGusE2Ok(undefined);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol24is__valid__topic__filter(filter) {
  const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol23validate__topic__filter(filter);
  if (_bind.$tag === 1) {
    return true;
  } else {
    return false;
  }
}
function _M0MP38Duckweed11moon_2dmqtt8protocol12Subscription3new(topic, qos) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol12Subscription(topic, qos);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol15SubscribePacket3new(packet_id, subscriptions) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol15SubscribePacket(packet_id, subscriptions);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol10qos__value(q) {
  switch (q) {
    case 0: {
      return 0;
    }
    case 1: {
      return 1;
    }
    default: {
      return 2;
    }
  }
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(self) {
  return self.bytes;
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new() {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol10ByteWriter(new _M0TPB5ArrayGiE([], 0));
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(self, b) {
  if (b < 0 || b > 255) {
    $panic(`mqtt: byte out of range: ${_M0MPC13int3Int18to__string_2einner(b, 10)}`);
  }
  _M0MPC15array5Array4pushGiE(self.bytes, b);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol25encode__remaining__length(len) {
  if (len < 0 || len > 268435455) {
    $panic(`mqtt: remaining length out of range: ${_M0MPC13int3Int18to__string_2einner(len, 10)}`);
  }
  const out = new _M0TPB5ArrayGiE([], 0);
  const value = new _M0TPB8MutLocalGiE(len);
  const count = new _M0TPB8MutLocalGiE(0);
  while (true) {
    if (value.val > 0 && count.val < 4) {
      if (128 === 0) {
        $panic();
      }
      const digit0 = value.val % 128 | 0;
      if (128 === 0) {
        $panic();
      }
      value.val = value.val / 128 | 0;
      const digit = value.val > 0 ? digit0 | 128 : digit0;
      _M0MPC15array5Array4pushGiE(out, digit);
      count.val = count.val + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (count.val === 0) {
    _M0MPC15array5Array4pushGiE(out, 0);
  }
  return out;
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter23push__remaining__length(self, len) {
  const rl = _M0FP38Duckweed11moon_2dmqtt8protocol25encode__remaining__length(len);
  const _bind = rl.len;
  const _bind$2 = rl.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = _bind$2[_];
      _M0MPC15array5Array4pushGiE(self.bytes, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(self, v) {
  if (v < 0 || v > 65535) {
    $panic(`mqtt: 16-bit field out of range: ${_M0MPC13int3Int18to__string_2einner(v, 10)}`);
  }
  _M0MPC15array5Array4pushGiE(self.bytes, v >> 8 & 255);
  _M0MPC15array5Array4pushGiE(self.bytes, v & 255);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(self, s) {
  const data = _M0FP38Duckweed11moon_2dmqtt8protocol12utf8__encode(s);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(self, _M0MPC15array5Array6lengthGiE(data));
  const _bind = data.len;
  const _bind$2 = data.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = _bind$2[_];
      _M0MPC15array5Array4pushGiE(self.bytes, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP38Duckweed11moon_2dmqtt8protocol17encode__subscribe(pkt) {
  const valid = new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt8protocol12SubscriptionE([], 0);
  const _bind = pkt.subscriptions;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const sub = _bind$3[_];
      if (_M0FP38Duckweed11moon_2dmqtt8protocol24is__valid__topic__filter(sub.topic)) {
        _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(valid, sub);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (_M0MPC15array5Array6lengthGRPC16string10StringViewE(valid) === 0) {
    return new _M0TPB5ArrayGiE([], 0);
  }
  if (pkt.packet_id <= 0 || pkt.packet_id > 65535) {
    $panic(`mqtt: subscribe packet id must be in 1..65535, got ${_M0MPC13int3Int18to__string_2einner(pkt.packet_id, 10)}`);
  }
  const body = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(body, pkt.packet_id);
  const _bind$4 = valid.len;
  const _bind$5 = valid.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$4) {
      const sub = _bind$5[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(body, sub.topic);
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(body, _M0FP38Duckweed11moon_2dmqtt8protocol10qos__value(sub.qos));
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const out = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, 130);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter23push__remaining__length(out, _M0MPC15array5Array6lengthGiE(_M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body)));
  const _bind$6 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body);
  const _bind$7 = _bind$6.len;
  const _bind$8 = _bind$6.buf;
  let _tmp$3 = 0;
  while (true) {
    const _ = _tmp$3;
    if (_ < _bind$7) {
      const b = _bind$8[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, b);
      _tmp$3 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(out);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol23suback__code__from__int(v) {
  switch (v) {
    case 0: {
      return 0;
    }
    case 1: {
      return 1;
    }
    case 2: {
      return 2;
    }
    case 128: {
      return 3;
    }
    default: {
      return undefined;
    }
  }
}
function _M0MP38Duckweed11moon_2dmqtt8protocol6Suback13all__accepted(self) {
  const _bind = self.codes;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const c = _bind$3[_];
      if (c === 3) {
        return false;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0MP38Duckweed11moon_2dmqtt8protocol6Suback5codes(self) {
  return self.codes;
}
function _M0FP38Duckweed11moon_2dmqtt8protocol25decode__remaining__length(data, start) {
  const multiplier = new _M0TPB8MutLocalGiE(1);
  const value = new _M0TPB8MutLocalGiE(0);
  const pos = new _M0TPB8MutLocalGiE(start);
  const count = new _M0TPB8MutLocalGiE(0);
  while (true) {
    if (pos.val >= _M0MPC15array5Array6lengthGiE(data)) {
      return new _M0DTPB6ResultGUiiEsE3Err("remaining length truncated");
    }
    if (count.val >= 4) {
      return new _M0DTPB6ResultGUiiEsE3Err("remaining length exceeds 4 bytes");
    }
    const byte = _M0MPC15array5Array2atGiE(data, pos.val);
    value.val = value.val + (Math.imul(byte & 127, multiplier.val) | 0) | 0;
    if ((byte & 128) === 0) {
      break;
    }
    pos.val = pos.val + 1 | 0;
    multiplier.val = Math.imul(multiplier.val, 128) | 0;
    count.val = count.val + 1 | 0;
    continue;
  }
  return new _M0DTPB6ResultGUiiEsE2Ok({ _0: value.val, _1: pos.val + 1 | 0 });
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader3new(data) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol10ByteReader(data);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader10read__byte(self, start) {
  if (start >= _M0MPC15array5Array6lengthGiE(self.data)) {
    return new _M0DTPB6ResultGUiiEsE3Err("read out of range");
  }
  return new _M0DTPB6ResultGUiiEsE2Ok({ _0: _M0MPC15array5Array2atGiE(self.data, start), _1: start + 1 | 0 });
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader9read__u16(self, start) {
  let h;
  let p1;
  _L: {
    let e;
    _L$2: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader10read__byte(self, start);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$2;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _h = _x._0;
        const _p1 = _x._1;
        h = _h;
        p1 = _p1;
        break _L;
      }
    }
    return new _M0DTPB6ResultGUiiEsE3Err(e);
  }
  let l;
  let p2;
  _L$2: {
    let e;
    _L$3: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader10read__byte(self, p1);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$3;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _l = _x._0;
        const _p2 = _x._1;
        l = _l;
        p2 = _p2;
        break _L$2;
      }
    }
    return new _M0DTPB6ResultGUiiEsE3Err(e);
  }
  return new _M0DTPB6ResultGUiiEsE2Ok({ _0: h << 8 | l, _1: p2 });
}
function _M0FP38Duckweed11moon_2dmqtt8protocol14decode__suback(data) {
  if (_M0MPC15array5Array6lengthGiE(data) < 5) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err("suback too short");
  }
  if (_M0MPC15array5Array2atGiE(data, 0) !== 144) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err("not a suback");
  }
  let rlen;
  let header_end;
  _L: {
    let _bind;
    let e;
    _L$2: {
      _L$3: {
        const _bind$2 = _M0FP38Duckweed11moon_2dmqtt8protocol25decode__remaining__length(data, 1);
        if (_bind$2.$tag === 1) {
          const _Ok = _bind$2;
          const _x = _Ok._0;
          _bind = _x;
        } else {
          const _Err = _bind$2;
          const _e = _Err._0;
          e = _e;
          break _L$3;
        }
        break _L$2;
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err(e);
    }
    const _rlen = _bind._0;
    const _header_end = _bind._1;
    rlen = _rlen;
    header_end = _header_end;
    break _L;
  }
  if (rlen < 3) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err("suback remaining length too small");
  }
  if ((header_end + rlen | 0) !== _M0MPC15array5Array6lengthGiE(data)) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err("suback length mismatch");
  }
  const r = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader3new(data);
  let pid;
  let after_pid;
  _L$2: {
    let e;
    _L$3: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader9read__u16(r, header_end);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$3;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _pid = _x._0;
        const _after_pid = _x._1;
        pid = _pid;
        after_pid = _after_pid;
        break _L$2;
      }
    }
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err(e);
  }
  if (pid === 0) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err("suback packet id must be nonzero");
  }
  const pos = new _M0TPB8MutLocalGiE(after_pid);
  const codes = new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE([], 0);
  while (true) {
    if (pos.val < (header_end + rlen | 0)) {
      let c;
      _L$3: {
        const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol23suback__code__from__int(_M0MPC15array5Array2atGiE(data, pos.val));
        if (_bind === undefined) {
          return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err("suback bad code");
        } else {
          const _Some = _bind;
          const _c = _Some;
          c = _c;
          break _L$3;
        }
      }
      _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(codes, c);
      pos.val = pos.val + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE2Ok(new _M0TP38Duckweed11moon_2dmqtt8protocol6Suback(pid, codes));
}
function _M0FP38Duckweed11moon_2dmqtt8protocol16decode__unsuback(data) {
  if (_M0MPC15array5Array6lengthGiE(data) < 2) {
    return new _M0DTPB6ResultGisE3Err("unsuback too short");
  }
  if (_M0MPC15array5Array2atGiE(data, 0) !== 176) {
    return new _M0DTPB6ResultGisE3Err("not an unsuback");
  }
  let rlen;
  let header_end;
  _L: {
    let e;
    _L$2: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol25decode__remaining__length(data, 1);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$2;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _rlen = _x._0;
        const _header_end = _x._1;
        rlen = _rlen;
        header_end = _header_end;
        break _L;
      }
    }
    return new _M0DTPB6ResultGisE3Err(e);
  }
  if (rlen !== 2) {
    return new _M0DTPB6ResultGisE3Err(`unsuback remaining length must be 2, got ${_M0MPC13int3Int18to__string_2einner(rlen, 10)}`);
  }
  if ((header_end + rlen | 0) !== _M0MPC15array5Array6lengthGiE(data)) {
    return new _M0DTPB6ResultGisE3Err("unsuback length mismatch");
  }
  const r = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader3new(data);
  let pid;
  _L$2: {
    let e;
    _L$3: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader9read__u16(r, header_end);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$3;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _pid = _x._0;
        pid = _pid;
        break _L$2;
      }
    }
    return new _M0DTPB6ResultGisE3Err(e);
  }
  return pid === 0 ? new _M0DTPB6ResultGisE3Err("unsuback packet id must be nonzero") : new _M0DTPB6ResultGisE2Ok(pid);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol14qos__from__int(v) {
  return v === 0 ? 0 : v === 1 ? 1 : v === 2 ? 2 : undefined;
}
function _M0FP38Duckweed11moon_2dmqtt8protocol4qos1() {
  return 1;
}
function _M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket3new(topic, payload, qos, retain, dup, packet_id) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol13PublishPacket(topic, payload, qos, retain, dup, packet_id);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket16with__packet__id(pkt, packet_id) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol13PublishPacket(pkt.topic, pkt.payload, pkt.qos, pkt.retain, pkt.dup, packet_id);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket9with__dup(pkt, dup) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol13PublishPacket(pkt.topic, pkt.payload, pkt.qos, pkt.retain, dup, pkt.packet_id);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol15encode__publish(pkt) {
  if (_M0IP016_24default__implPB2Eq10not__equalGRP38Duckweed11moon_2dmqtt8protocol3QoSE(pkt.qos, 0) && pkt.packet_id === 0) {
    $panic("mqtt: qos1/qos2 publish needs a nonzero packet id");
  }
  let e;
  _L: {
    _L$2: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol21validate__topic__name(pkt.topic);
      if (_bind.$tag === 1) {
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$2;
      }
      break _L;
    }
    $panic(`mqtt: publish topic invalid: ${e}`);
  }
  const body = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(body, pkt.topic);
  if (_M0IP016_24default__implPB2Eq10not__equalGRP38Duckweed11moon_2dmqtt8protocol3QoSE(pkt.qos, 0)) {
    _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(body, pkt.packet_id);
  }
  const _bind = pkt.payload;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const b = _bind$3[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(body, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const flags = new _M0TPB8MutLocalGiE(0);
  if (pkt.retain) {
    flags.val = flags.val | 1;
  }
  flags.val = flags.val | _M0FP38Duckweed11moon_2dmqtt8protocol10qos__value(pkt.qos) << 1 & 6;
  if (pkt.dup) {
    flags.val = flags.val | 8;
  }
  const out = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, 48 | flags.val);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter23push__remaining__length(out, _M0MPC15array5Array6lengthGiE(_M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body)));
  const _bind$4 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body);
  const _bind$5 = _bind$4.len;
  const _bind$6 = _bind$4.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$5) {
      const b = _bind$6[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, b);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(out);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol16char__from__code(cp) {
  if (cp < 0 || cp > 1114111) {
    return "�";
  }
  return _M0IPC14char4CharPB4Show10to__string(cp);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol16is__continuation(b) {
  return (b & 192) === 128;
}
function _M0FP38Duckweed11moon_2dmqtt8protocol12utf8__decode(data, start, len) {
  const sb = new _M0TPB8MutLocalGsE("");
  const i = new _M0TPB8MutLocalGiE(start);
  const end = start + len | 0;
  if (end > _M0MPC15array5Array6lengthGiE(data)) {
    return new _M0DTPB6ResultGssE3Err("utf8 out of range");
  }
  while (true) {
    if (i.val < end) {
      const b0 = _M0MPC15array5Array2atGiE(data, i.val);
      if (b0 < 128) {
        sb.val = `${sb.val}${_M0FP38Duckweed11moon_2dmqtt8protocol16char__from__code(b0)}`;
        i.val = i.val + 1 | 0;
      } else {
        if ((b0 & 224) === 192) {
          if ((i.val + 1 | 0) >= end) {
            return new _M0DTPB6ResultGssE3Err("utf8 truncated 2-byte");
          }
          const b1 = _M0MPC15array5Array2atGiE(data, i.val + 1 | 0);
          if (!_M0FP38Duckweed11moon_2dmqtt8protocol16is__continuation(b1)) {
            return new _M0DTPB6ResultGssE3Err("utf8 invalid continuation");
          }
          const cp = (b0 & 31) << 6 | b1 & 63;
          if (cp < 128) {
            return new _M0DTPB6ResultGssE3Err("utf8 overlong 2-byte");
          }
          sb.val = `${sb.val}${_M0FP38Duckweed11moon_2dmqtt8protocol16char__from__code(cp)}`;
          i.val = i.val + 2 | 0;
        } else {
          if ((b0 & 240) === 224) {
            if ((i.val + 2 | 0) >= end) {
              return new _M0DTPB6ResultGssE3Err("utf8 truncated 3-byte");
            }
            const b1 = _M0MPC15array5Array2atGiE(data, i.val + 1 | 0);
            const b2 = _M0MPC15array5Array2atGiE(data, i.val + 2 | 0);
            if (!_M0FP38Duckweed11moon_2dmqtt8protocol16is__continuation(b1) || !_M0FP38Duckweed11moon_2dmqtt8protocol16is__continuation(b2)) {
              return new _M0DTPB6ResultGssE3Err("utf8 invalid continuation");
            }
            const cp = (b0 & 15) << 12 | (b1 & 63) << 6 | b2 & 63;
            if (cp < 2048) {
              return new _M0DTPB6ResultGssE3Err("utf8 overlong 3-byte");
            }
            if (cp >= 55296 && cp <= 57343) {
              return new _M0DTPB6ResultGssE3Err("utf8 surrogate code point");
            }
            sb.val = `${sb.val}${_M0FP38Duckweed11moon_2dmqtt8protocol16char__from__code(cp)}`;
            i.val = i.val + 3 | 0;
          } else {
            if ((b0 & 248) === 240) {
              if ((i.val + 3 | 0) >= end) {
                return new _M0DTPB6ResultGssE3Err("utf8 truncated 4-byte");
              }
              const b1 = _M0MPC15array5Array2atGiE(data, i.val + 1 | 0);
              const b2 = _M0MPC15array5Array2atGiE(data, i.val + 2 | 0);
              const b3 = _M0MPC15array5Array2atGiE(data, i.val + 3 | 0);
              if (!_M0FP38Duckweed11moon_2dmqtt8protocol16is__continuation(b1) || (!_M0FP38Duckweed11moon_2dmqtt8protocol16is__continuation(b2) || !_M0FP38Duckweed11moon_2dmqtt8protocol16is__continuation(b3))) {
                return new _M0DTPB6ResultGssE3Err("utf8 invalid continuation");
              }
              const cp = (b0 & 7) << 18 | (b1 & 63) << 12 | (b2 & 63) << 6 | b3 & 63;
              if (cp < 65536) {
                return new _M0DTPB6ResultGssE3Err("utf8 overlong 4-byte");
              }
              if (cp > 1114111) {
                return new _M0DTPB6ResultGssE3Err("utf8 code point out of range");
              }
              sb.val = `${sb.val}${_M0FP38Duckweed11moon_2dmqtt8protocol16char__from__code(cp)}`;
              i.val = i.val + 4 | 0;
            } else {
              return new _M0DTPB6ResultGssE3Err("utf8 invalid lead byte");
            }
          }
        }
      }
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPB6ResultGssE2Ok(sb.val);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader12read__binary(self, start) {
  let len;
  let p1;
  _L: {
    let e;
    _L$2: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader9read__u16(self, start);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$2;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _len = _x._0;
        const _p1 = _x._1;
        len = _len;
        p1 = _p1;
        break _L;
      }
    }
    return new _M0DTPB6ResultGURPB5ArrayGiEiEsE3Err(e);
  }
  if ((p1 + len | 0) > _M0MPC15array5Array6lengthGiE(self.data)) {
    return new _M0DTPB6ResultGURPB5ArrayGiEiEsE3Err("binary length exceeds remaining");
  }
  const out = new _M0TPB5ArrayGiE([], 0);
  const _bind = 0;
  let _tmp = _bind;
  while (true) {
    const i = _tmp;
    if (i < len) {
      _M0MPC15array5Array4pushGiE(out, _M0MPC15array5Array2atGiE(self.data, p1 + i | 0));
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPB6ResultGURPB5ArrayGiEiEsE2Ok({ _0: out, _1: p1 + len | 0 });
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader12read__string(self, start) {
  let raw;
  let p;
  _L: {
    let e;
    _L$2: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader12read__binary(self, start);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$2;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _raw = _x._0;
        const _p = _x._1;
        raw = _raw;
        p = _p;
        break _L;
      }
    }
    return new _M0DTPB6ResultGUsiEsE3Err(e);
  }
  let s;
  _L$2: {
    let e;
    _L$3: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol12utf8__decode(raw, 0, _M0MPC15array5Array6lengthGiE(raw));
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$3;
      } else {
        const _Ok = _bind;
        const _s = _Ok._0;
        s = _s;
        break _L$2;
      }
    }
    return new _M0DTPB6ResultGUsiEsE3Err(e);
  }
  return new _M0DTPB6ResultGUsiEsE2Ok({ _0: s, _1: p });
}
function _M0FP38Duckweed11moon_2dmqtt8protocol15decode__publish(data) {
  if (_M0MPC15array5Array6lengthGiE(data) < 2) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err("publish too short");
  }
  const first = _M0MPC15array5Array2atGiE(data, 0);
  if (first >> 4 !== 3) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err("not a publish");
  }
  const flags = first & 15;
  let q;
  _L: {
    const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol14qos__from__int(flags >> 1 & 3);
    if (_bind === undefined) {
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err("publish bad qos");
    } else {
      const _Some = _bind;
      const _q = _Some;
      q = _q;
      break _L;
    }
  }
  if (_M0IP38Duckweed11moon_2dmqtt8protocol3QoSPB2Eq5equal(q, 0) && (flags & 8) !== 0) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err("qos0 publish must not set dup");
  }
  let rlen;
  let p;
  _L$2: {
    let e;
    _L$3: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol25decode__remaining__length(data, 1);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$3;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _rlen = _x._0;
        const _p = _x._1;
        rlen = _rlen;
        p = _p;
        break _L$2;
      }
    }
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err(e);
  }
  const end = p + rlen | 0;
  if (end > _M0MPC15array5Array6lengthGiE(data)) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err("publish length exceeds data");
  }
  const r = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader3new(data);
  let topic;
  let p2;
  _L$3: {
    let e;
    _L$4: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader12read__string(r, p);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$4;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _topic = _x._0;
        const _p2 = _x._1;
        topic = _topic;
        p2 = _p2;
        break _L$3;
      }
    }
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err(e);
  }
  let e;
  _L$4: {
    _L$5: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol21validate__topic__name(topic);
      if (_bind.$tag === 1) {
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$5;
      }
      break _L$4;
    }
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err(`publish: ${e}`);
  }
  const pos = new _M0TPB8MutLocalGiE(p2);
  const pid = new _M0TPB8MutLocalGiE(0);
  if (_M0IP016_24default__implPB2Eq10not__equalGRP38Duckweed11moon_2dmqtt8protocol3QoSE(q, 0)) {
    let id;
    let p3;
    _L$5: {
      let e$2;
      _L$6: {
        const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader9read__u16(r, pos.val);
        if (_bind.$tag === 0) {
          const _Err = _bind;
          const _e = _Err._0;
          e$2 = _e;
          break _L$6;
        } else {
          const _Ok = _bind;
          const _x = _Ok._0;
          const _id = _x._0;
          const _p3 = _x._1;
          id = _id;
          p3 = _p3;
          break _L$5;
        }
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err(e$2);
    }
    if (id === 0) {
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err("qos1/qos2 packet id must be nonzero");
    }
    pid.val = id;
    pos.val = p3;
  }
  const payload = new _M0TPB5ArrayGiE([], 0);
  const _bind = pos.val;
  let _tmp = _bind;
  while (true) {
    const i = _tmp;
    if (i < end) {
      _M0MPC15array5Array4pushGiE(payload, _M0MPC15array5Array2atGiE(data, i));
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE2Ok(new _M0TP38Duckweed11moon_2dmqtt8protocol13PublishPacket(topic, payload, q, (flags & 1) !== 0, (flags & 8) !== 0, pid.val));
}
function _M0FP38Duckweed11moon_2dmqtt8protocol18encode__packet__id(type_byte, packet_id) {
  if (packet_id <= 0) {
    $panic(`mqtt: control packet id must be in 1..65535, got ${_M0MPC13int3Int18to__string_2einner(packet_id, 10)}`);
  }
  const out = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, type_byte);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter23push__remaining__length(out, 2);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(out, packet_id);
  return _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(out);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol14encode__puback(packet_id) {
  return _M0FP38Duckweed11moon_2dmqtt8protocol18encode__packet__id(64, packet_id);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrec(packet_id) {
  return _M0FP38Duckweed11moon_2dmqtt8protocol18encode__packet__id(80, packet_id);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrel(packet_id) {
  return _M0FP38Duckweed11moon_2dmqtt8protocol18encode__packet__id(98, packet_id);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol15encode__pubcomp(packet_id) {
  return _M0FP38Duckweed11moon_2dmqtt8protocol18encode__packet__id(112, packet_id);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol18decode__packet__id(data, type_byte) {
  if (_M0MPC15array5Array6lengthGiE(data) < 4) {
    return new _M0DTPB6ResultGisE3Err("packet id packet too short");
  }
  if (_M0MPC15array5Array2atGiE(data, 0) !== type_byte) {
    return new _M0DTPB6ResultGisE3Err("packet id type mismatch");
  }
  if (_M0MPC15array5Array2atGiE(data, 1) !== 2) {
    return new _M0DTPB6ResultGisE3Err("packet id packet bad remaining length");
  }
  if (_M0MPC15array5Array6lengthGiE(data) !== 4) {
    return new _M0DTPB6ResultGisE3Err("packet id packet has trailing bytes");
  }
  const r = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader3new(data);
  let e;
  _L: {
    let id;
    _L$2: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader9read__u16(r, 2);
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _id = _x._0;
        id = _id;
        break _L$2;
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L;
      }
    }
    if (id === 0) {
      return new _M0DTPB6ResultGisE3Err("packet id must not be zero");
    }
    return new _M0DTPB6ResultGisE2Ok(id);
  }
  return new _M0DTPB6ResultGisE3Err(e);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol15encode__pingreq() {
  return new _M0TPB5ArrayGiE([192, 0], 2);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__binary(self, data) {
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(self, _M0MPC15array5Array6lengthGiE(data));
  const _bind = data.len;
  const _bind$2 = data.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = _bind$2[_];
      _M0MPC15array5Array4pushGiE(self.bytes, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP38Duckweed11moon_2dmqtt8protocol23packet__type__from__int(v) {
  return v === 1 ? 0 : v === 2 ? 1 : v === 3 ? 2 : v === 4 ? 3 : v === 5 ? 4 : v === 6 ? 5 : v === 7 ? 6 : v === 8 ? 7 : v === 9 ? 8 : v === 10 ? 9 : v === 11 ? 10 : v === 12 ? 11 : v === 13 ? 12 : v === 14 ? 13 : undefined;
}
function _M0FP38Duckweed11moon_2dmqtt8protocol21decode__fixed__header(data, start) {
  if (start >= _M0MPC15array5Array6lengthGiE(data)) {
    return new _M0DTPB6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err("empty fixed header");
  }
  const byte0 = _M0MPC15array5Array2atGiE(data, start);
  let t;
  _L: {
    const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol23packet__type__from__int(byte0 >> 4);
    if (_bind === undefined) {
      return new _M0DTPB6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err("reserved packet type");
    } else {
      const _Some = _bind;
      const _t = _Some;
      t = _t;
      break _L;
    }
  }
  const flags = byte0 & 15;
  let len;
  let pos;
  _L$2: {
    let e;
    _L$3: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol25decode__remaining__length(data, start + 1 | 0);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$3;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _len = _x._0;
        const _pos = _x._1;
        len = _len;
        pos = _pos;
        break _L$2;
      }
    }
    return new _M0DTPB6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err(e);
  }
  return new _M0DTPB6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE2Ok({ _0: t, _1: flags, _2: len, _3: pos });
}
function _M0FP38Duckweed11moon_2dmqtt8protocol23return__code__from__int(v) {
  switch (v) {
    case 0: {
      return 0;
    }
    case 1: {
      return 1;
    }
    case 2: {
      return 2;
    }
    case 3: {
      return 3;
    }
    case 4: {
      return 4;
    }
    case 5: {
      return 5;
    }
    default: {
      return undefined;
    }
  }
}
function _M0FP38Duckweed11moon_2dmqtt8protocol15decode__connack(data) {
  if (_M0MPC15array5Array6lengthGiE(data) < 4) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("connack too short");
  }
  if (_M0MPC15array5Array2atGiE(data, 0) !== 32) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("not a connack");
  }
  if (_M0MPC15array5Array2atGiE(data, 1) !== 2) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("connack remaining length != 2");
  }
  const ack_flags = _M0MPC15array5Array2atGiE(data, 2);
  if ((ack_flags & 254) !== 0) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("connack reserved flags must be zero");
  }
  const session_present = (ack_flags & 1) === 1;
  let rc;
  _L: {
    const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol23return__code__from__int(_M0MPC15array5Array2atGiE(data, 3));
    if (_bind === undefined) {
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("unknown connack return code");
    } else {
      const _Some = _bind;
      const _rc = _Some;
      rc = _rc;
      break _L;
    }
  }
  if (rc === 0) {
  } else {
    if (session_present) {
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("connack session present must be 0 when the connection is refused");
    }
  }
  return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE2Ok(new _M0TP38Duckweed11moon_2dmqtt8protocol7Connack(session_present, rc));
}
function _M0FP38Duckweed11moon_2dmqtt8protocol14decode__packet(data) {
  if (_M0MPC15array5Array6lengthGiE(data) < 2) {
    return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err("packet too short");
  }
  const t = _M0MPC15array5Array2atGiE(data, 0) >> 4;
  switch (t) {
    case 2: {
      let e;
      _L: {
        let c;
        _L$2: {
          const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol15decode__connack(data);
          if (_bind.$tag === 1) {
            const _Ok = _bind;
            const _c = _Ok._0;
            c = _c;
            break _L$2;
          } else {
            const _Err = _bind;
            const _e = _Err._0;
            e = _e;
            break _L;
          }
        }
        return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Connack(c));
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e);
    }
    case 3: {
      let e$2;
      _L$2: {
        let p;
        _L$3: {
          const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol15decode__publish(data);
          if (_bind.$tag === 1) {
            const _Ok = _bind;
            const _p = _Ok._0;
            p = _p;
            break _L$3;
          } else {
            const _Err = _bind;
            const _e = _Err._0;
            e$2 = _e;
            break _L$2;
          }
        }
        return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Publish(p));
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$2);
    }
    case 4: {
      let e$3;
      _L$3: {
        let id;
        _L$4: {
          const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol18decode__packet__id(data, 64);
          if (_bind.$tag === 1) {
            const _Ok = _bind;
            const _id = _Ok._0;
            id = _id;
            break _L$4;
          } else {
            const _Err = _bind;
            const _e = _Err._0;
            e$3 = _e;
            break _L$3;
          }
        }
        return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Puback(id));
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$3);
    }
    case 5: {
      let e$4;
      _L$4: {
        let id;
        _L$5: {
          const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol18decode__packet__id(data, 80);
          if (_bind.$tag === 1) {
            const _Ok = _bind;
            const _id = _Ok._0;
            id = _id;
            break _L$5;
          } else {
            const _Err = _bind;
            const _e = _Err._0;
            e$4 = _e;
            break _L$4;
          }
        }
        return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Pubrec(id));
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$4);
    }
    case 6: {
      let e$5;
      _L$5: {
        let id;
        _L$6: {
          const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol18decode__packet__id(data, 98);
          if (_bind.$tag === 1) {
            const _Ok = _bind;
            const _id = _Ok._0;
            id = _id;
            break _L$6;
          } else {
            const _Err = _bind;
            const _e = _Err._0;
            e$5 = _e;
            break _L$5;
          }
        }
        return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Pubrel(id));
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$5);
    }
    case 7: {
      let e$6;
      _L$6: {
        let id;
        _L$7: {
          const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol18decode__packet__id(data, 112);
          if (_bind.$tag === 1) {
            const _Ok = _bind;
            const _id = _Ok._0;
            id = _id;
            break _L$7;
          } else {
            const _Err = _bind;
            const _e = _Err._0;
            e$6 = _e;
            break _L$6;
          }
        }
        return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Pubcomp(id));
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$6);
    }
    case 9: {
      let e$7;
      _L$7: {
        let s;
        _L$8: {
          const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol14decode__suback(data);
          if (_bind.$tag === 1) {
            const _Ok = _bind;
            const _s = _Ok._0;
            s = _s;
            break _L$8;
          } else {
            const _Err = _bind;
            const _e = _Err._0;
            e$7 = _e;
            break _L$7;
          }
        }
        return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Suback(s));
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$7);
    }
    case 11: {
      let e$8;
      _L$8: {
        let id;
        _L$9: {
          const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol16decode__unsuback(data);
          if (_bind.$tag === 1) {
            const _Ok = _bind;
            const _id = _Ok._0;
            id = _id;
            break _L$9;
          } else {
            const _Err = _bind;
            const _e = _Err._0;
            e$8 = _e;
            break _L$8;
          }
        }
        return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8Unsuback(id));
      }
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$8);
    }
    case 13: {
      let len;
      _L$9: {
        let e$9;
        _L$10: {
          const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol25decode__remaining__length(data, 1);
          if (_bind.$tag === 0) {
            const _Err = _bind;
            const _e = _Err._0;
            e$9 = _e;
            break _L$10;
          } else {
            const _Ok = _bind;
            const _x = _Ok._0;
            const _len = _x._0;
            len = _len;
            break _L$9;
          }
        }
        return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$9);
      }
      return _M0MPC15array5Array2atGiE(data, 0) !== 208 ? new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err("pingresp flags mismatch") : len !== 0 ? new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err("pingresp must have zero remaining length") : new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8PingResp__);
    }
    default: {
      return new _M0DTPB6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(`unsupported incoming packet type ${_M0MPC13int3Int18to__string_2einner(t, 10)}`);
    }
  }
}
function _M0MP38Duckweed11moon_2dmqtt8protocol13ConnectPacket3new(client_id) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol13ConnectPacket(client_id, 60, true, undefined, undefined, undefined, undefined, 0, false);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol13ConnectPacket20with__clean__session(self, v) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol13ConnectPacket(self.client_id, self.keep_alive, v, self.username, self.password, self.will_topic, self.will_message, self.will_qos, self.will_retain);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol15encode__connect(pkt) {
  if (pkt.client_id === "" && !pkt.clean_session) {
    $panic("mqtt: empty client id requires clean_session=true");
  }
  const _bind = pkt.username;
  const _bind$2 = pkt.password;
  if (_bind === undefined) {
    if (_bind$2 === undefined) {
    } else {
      $panic("mqtt: password requires username (§3.1.2.11)");
    }
  }
  const _bind$3 = pkt.will_topic;
  const _bind$4 = pkt.will_message;
  if (_bind$3 === undefined) {
    if (_bind$4 === undefined) {
    } else {
      $panic("mqtt: will message requires will topic (§3.1.2.9)");
    }
  }
  let t;
  _L: {
    _L$2: {
      const _bind$5 = pkt.will_topic;
      if (_bind$5 === undefined) {
      } else {
        const _Some = _bind$5;
        const _t = _Some;
        t = _t;
        break _L$2;
      }
      break _L;
    }
    let e;
    _L$3: {
      _L$4: {
        const _bind$5 = _M0FP38Duckweed11moon_2dmqtt8protocol21validate__topic__name(t);
        if (_bind$5.$tag === 1) {
        } else {
          const _Err = _bind$5;
          const _e = _Err._0;
          e = _e;
          break _L$4;
        }
        break _L$3;
      }
      $panic(`mqtt: invalid will topic: ${e}`);
    }
  }
  const vh = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(vh, "MQTT");
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(vh, 4);
  const flags = new _M0TPB8MutLocalGiE(0);
  if (pkt.clean_session) {
    flags.val = flags.val | 2;
  }
  const _bind$5 = pkt.username;
  if (_bind$5 === undefined) {
  } else {
    flags.val = flags.val | 128;
  }
  const _bind$6 = pkt.password;
  if (_bind$6 === undefined) {
  } else {
    flags.val = flags.val | 64;
  }
  const _bind$7 = pkt.will_topic;
  if (_bind$7 === undefined) {
  } else {
    flags.val = flags.val | 4;
    if (pkt.will_retain) {
      flags.val = flags.val | 32;
    }
    flags.val = flags.val | _M0FP38Duckweed11moon_2dmqtt8protocol10qos__value(pkt.will_qos) << 3 & 24;
  }
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(vh, flags.val);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(vh, pkt.keep_alive);
  const pl = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(pl, pkt.client_id);
  let t$2;
  _L$2: {
    _L$3: {
      const _bind$8 = pkt.will_topic;
      if (_bind$8 === undefined) {
      } else {
        const _Some = _bind$8;
        const _t = _Some;
        t$2 = _t;
        break _L$3;
      }
      break _L$2;
    }
    _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(pl, t$2);
    let m;
    _L$4: {
      _L$5: {
        const _bind$8 = pkt.will_message;
        if (_bind$8 === undefined) {
          _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__binary(pl, new _M0TPB5ArrayGiE([], 0));
        } else {
          const _Some = _bind$8;
          const _m = _Some;
          m = _m;
          break _L$5;
        }
        break _L$4;
      }
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__binary(pl, m);
    }
  }
  let u;
  _L$3: {
    _L$4: {
      const _bind$8 = pkt.username;
      if (_bind$8 === undefined) {
      } else {
        const _Some = _bind$8;
        const _u = _Some;
        u = _u;
        break _L$4;
      }
      break _L$3;
    }
    _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(pl, u);
  }
  let p;
  _L$4: {
    _L$5: {
      const _bind$8 = pkt.password;
      if (_bind$8 === undefined) {
      } else {
        const _Some = _bind$8;
        const _p = _Some;
        p = _p;
        break _L$5;
      }
      break _L$4;
    }
    _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__binary(pl, p);
  }
  const body = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  const _bind$8 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(vh);
  const _bind$9 = _bind$8.len;
  const _bind$10 = _bind$8.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$9) {
      const b = _bind$10[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(body, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$11 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(pl);
  const _bind$12 = _bind$11.len;
  const _bind$13 = _bind$11.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$12) {
      const b = _bind$13[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(body, b);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const out = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, 16);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter23push__remaining__length(out, _M0MPC15array5Array6lengthGiE(_M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body)));
  const _bind$14 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body);
  const _bind$15 = _bind$14.len;
  const _bind$16 = _bind$14.buf;
  let _tmp$3 = 0;
  while (true) {
    const _ = _tmp$3;
    if (_ < _bind$15) {
      const b = _bind$16[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, b);
      _tmp$3 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(out);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol21validate__byte__array(bytes) {
  const _bind = bytes.len;
  const _bind$2 = bytes.buf;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const b = _bind$2[i];
      if (b < 0 || b > 255) {
        return new _M0DTPB6ResultGusE3Err(`byte out of range at index ${_M0MPC13int3Int18to__string_2einner(i, 10)}: ${_M0MPC13int3Int18to__string_2einner(b, 10)}`);
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPB6ResultGusE2Ok(undefined);
}
function _M0IP38Duckweed11moon_2dmqtt7session9SendStagePB2Eq5equal(_x_199, _x_200) {
  switch (_x_199) {
    case 0: {
      if (_x_200 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_200 === 1) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_200 === 2) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function _M0MP38Duckweed11moon_2dmqtt7session12SessionStore3new() {
  return new _M0TP38Duckweed11moon_2dmqtt7session12SessionStore(new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt7session13InFlightEntryE([], 0), 1);
}
function _M0FP38Duckweed11moon_2dmqtt7session14next__free__id(store) {
  const candidate = new _M0TPB8MutLocalGiE(store.next_id);
  const _bind = 0;
  const _bind$2 = 65535;
  let _tmp = _bind;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const occupied = new _M0TPB8MutLocalGbE(false);
      const _bind$3 = store.inflight;
      const _bind$4 = _bind$3.len;
      const _bind$5 = _bind$3.buf;
      let _tmp$2 = 0;
      while (true) {
        const _$2 = _tmp$2;
        if (_$2 < _bind$4) {
          const e = _bind$5[_$2];
          if (e.packet_id === candidate.val) {
            occupied.val = true;
          }
          _tmp$2 = _$2 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (!occupied.val) {
        return candidate.val;
      }
      candidate.val = candidate.val >= 65535 ? 1 : candidate.val + 1 | 0;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return 0;
}
function _M0FP38Duckweed11moon_2dmqtt7session16record__outbound(store, pkt) {
  const _bind = pkt.qos;
  if (_bind === 0) {
    return { _0: store, _1: 0 };
  } else {
    const pid = _M0FP38Duckweed11moon_2dmqtt7session14next__free__id(store);
    if (pid === 0) {
      return { _0: store, _1: 0 };
    }
    const next = pid >= 65535 ? 1 : pid + 1 | 0;
    const _bind$2 = pkt.qos;
    let stage;
    if (_bind$2 === 1) {
      stage = 0;
    } else {
      stage = 1;
    }
    const stored = _M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket16with__packet__id(pkt, pid);
    const entry = new _M0TP38Duckweed11moon_2dmqtt7session13InFlightEntry(pid, stored, stage);
    const inflight = new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt7session13InFlightEntryE([], 0);
    const _bind$3 = store.inflight;
    const _bind$4 = _bind$3.len;
    const _bind$5 = _bind$3.buf;
    let _tmp = 0;
    while (true) {
      const _ = _tmp;
      if (_ < _bind$4) {
        const x = _bind$5[_];
        _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(inflight, x);
        _tmp = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(inflight, entry);
    return { _0: new _M0TP38Duckweed11moon_2dmqtt7session12SessionStore(inflight, next), _1: pid };
  }
}
function _M0FP38Duckweed11moon_2dmqtt7session26alloc__control__packet__id(store) {
  const pid = _M0FP38Duckweed11moon_2dmqtt7session14next__free__id(store);
  if (pid === 0) {
    return { _0: store, _1: 0 };
  }
  const next = pid >= 65535 ? 1 : pid + 1 | 0;
  return { _0: new _M0TP38Duckweed11moon_2dmqtt7session12SessionStore(store.inflight, next), _1: pid };
}
function _M0FP38Duckweed11moon_2dmqtt7session18remove__by__id__if(store, packet_id, stage) {
  const out = new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt7session13InFlightEntryE([], 0);
  const _bind = store.inflight;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const e = _bind$3[_];
      _L: {
        if (e.packet_id === packet_id && _M0IP38Duckweed11moon_2dmqtt7session9SendStagePB2Eq5equal(e.stage, stage)) {
          break _L;
        }
        _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(out, e);
        break _L;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP38Duckweed11moon_2dmqtt7session12SessionStore(out, store.next_id);
}
function _M0FP38Duckweed11moon_2dmqtt7session10on__puback(store, packet_id) {
  return _M0FP38Duckweed11moon_2dmqtt7session18remove__by__id__if(store, packet_id, 0);
}
function _M0FP38Duckweed11moon_2dmqtt7session11on__pubcomp(store, packet_id) {
  return _M0FP38Duckweed11moon_2dmqtt7session18remove__by__id__if(store, packet_id, 2);
}
function _M0FP38Duckweed11moon_2dmqtt7session10on__pubrec(store, packet_id) {
  const out = new _M0TPB8MutLocalGRPB5ArrayGiEE(new _M0TPB5ArrayGiE([], 0));
  const new_inflight = new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt7session13InFlightEntryE([], 0);
  const _bind = store.inflight;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const e = _bind$3[_];
      if (e.packet_id === packet_id) {
        const _bind$4 = e.stage;
        switch (_bind$4) {
          case 1: {
            _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(new_inflight, new _M0TP38Duckweed11moon_2dmqtt7session13InFlightEntry(e.packet_id, e.publish, 2));
            out.val = _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrel(packet_id);
            break;
          }
          case 2: {
            _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(new_inflight, e);
            out.val = _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrel(packet_id);
            break;
          }
          default: {
            _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(new_inflight, e);
          }
        }
      } else {
        _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(new_inflight, e);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return { _0: new _M0TP38Duckweed11moon_2dmqtt7session12SessionStore(new_inflight, store.next_id), _1: out.val };
}
function _M0FP38Duckweed11moon_2dmqtt7session6replay(store) {
  const out = new _M0TPB5ArrayGRPB5ArrayGiEE([], 0);
  const _bind = store.inflight;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const e = _bind$3[_];
      _L: {
        _L$2: {
          const _bind$4 = e.stage;
          switch (_bind$4) {
            case 2: {
              _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(out, _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrel(e.packet_id));
              break;
            }
            case 0: {
              break _L$2;
            }
            default: {
              break _L$2;
            }
          }
          break _L;
        }
        _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(out, _M0FP38Duckweed11moon_2dmqtt8protocol15encode__publish(_M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket9with__dup(e.publish, true)));
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return out;
}
function _M0FP38Duckweed11moon_2dmqtt4core12next__action(now_ms, last_ping_ms, pending_pings, keep_alive_secs) {
  if (keep_alive_secs <= 0) {
    return 0;
  }
  if (pending_pings >= _M0FP38Duckweed11moon_2dmqtt4core22max__unanswered__pings) {
    return 2;
  }
  const _tmp = now_ms - last_ping_ms | 0;
  if (2 === 0) {
    $panic();
  }
  if (_tmp >= ((Math.imul(keep_alive_secs, 1000) | 0) / 2 | 0)) {
    return 1;
  }
  return 0;
}
function _M0MP38Duckweed11moon_2dmqtt4core6Framer3new() {
  return new _M0TP38Duckweed11moon_2dmqtt4core6Framer(new _M0TPB5ArrayGiE([], 0), _M0FP38Duckweed11moon_2dmqtt4core17max__frame__bytes);
}
function _M0MP38Duckweed11moon_2dmqtt4core6Framer5reset(self) {
  _M0MPC15array5Array5clearGiE(self.buf);
}
function _M0FP38Duckweed11moon_2dmqtt4core11is__partial(err) {
  return err === "empty fixed header" || err === "remaining length truncated";
}
function _M0MP38Duckweed11moon_2dmqtt4core6Framer4feed(self, bytes) {
  const _bind = bytes.len;
  const _bind$2 = bytes.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = _bind$2[_];
      _M0MPC15array5Array4pushGiE(self.buf, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (_M0MPC15array5Array6lengthGiE(self.buf) > self.limit) {
    _M0MPC15array5Array5clearGiE(self.buf);
    return new _M0DTPB6ResultGRPB5ArrayGRPB5ArrayGiEEsE3Err("framer buffer overflow");
  }
  const frames = new _M0TPB5ArrayGRPB5ArrayGiEE([], 0);
  const offset = new _M0TPB8MutLocalGiE(0);
  const partial = new _M0TPB8MutLocalGbE(false);
  while (true) {
    if (!partial.val && offset.val < _M0MPC15array5Array6lengthGiE(self.buf)) {
      let rlen;
      let _t;
      let _flags;
      let header_end;
      _L: {
        _L$2: {
          let e;
          _L$3: {
            const _bind$3 = _M0FP38Duckweed11moon_2dmqtt8protocol21decode__fixed__header(self.buf, offset.val);
            if (_bind$3.$tag === 0) {
              const _Err = _bind$3;
              const _e = _Err._0;
              e = _e;
              break _L$3;
            } else {
              const _Ok = _bind$3;
              const _x = _Ok._0;
              const __t = _x._0;
              const __flags = _x._1;
              const _rlen = _x._2;
              const _header_end = _x._3;
              rlen = _rlen;
              _t = __t;
              _flags = __flags;
              header_end = _header_end;
              break _L$2;
            }
          }
          if (_M0FP38Duckweed11moon_2dmqtt4core11is__partial(e)) {
            partial.val = true;
          } else {
            _M0MPC15array5Array5clearGiE(self.buf);
            return new _M0DTPB6ResultGRPB5ArrayGRPB5ArrayGiEEsE3Err(`framer fatal: ${e}`);
          }
          break _L;
        }
        const total = (header_end - offset.val | 0) + rlen | 0;
        if (total > self.limit) {
          _M0MPC15array5Array5clearGiE(self.buf);
          return new _M0DTPB6ResultGRPB5ArrayGRPB5ArrayGiEEsE3Err(`framer: frame exceeds limit ${_M0MPC13int3Int18to__string_2einner(self.limit, 10)}`);
        }
        if ((_M0MPC15array5Array6lengthGiE(self.buf) - offset.val | 0) < total) {
          partial.val = true;
        } else {
          const frame = new _M0TPB5ArrayGiE([], 0);
          const _bind$3 = offset.val;
          const _bind$4 = offset.val + total | 0;
          let _tmp$2 = _bind$3;
          while (true) {
            const i = _tmp$2;
            if (i < _bind$4) {
              _M0MPC15array5Array4pushGiE(frame, _M0MPC15array5Array2atGiE(self.buf, i));
              _tmp$2 = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(frames, frame);
          offset.val = offset.val + total | 0;
        }
      }
      continue;
    } else {
      break;
    }
  }
  if (offset.val > 0) {
    const remaining = new _M0TPB5ArrayGiE([], 0);
    const i = new _M0TPB8MutLocalGiE(offset.val);
    while (true) {
      if (i.val < _M0MPC15array5Array6lengthGiE(self.buf)) {
        _M0MPC15array5Array4pushGiE(remaining, _M0MPC15array5Array2atGiE(self.buf, i.val));
        i.val = i.val + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MPC15array5Array5clearGiE(self.buf);
    const _bind$3 = remaining.len;
    const _bind$4 = remaining.buf;
    let _tmp$2 = 0;
    while (true) {
      const _ = _tmp$2;
      if (_ < _bind$3) {
        const b = _bind$4[_];
        _M0MPC15array5Array4pushGiE(self.buf, b);
        _tmp$2 = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  }
  return new _M0DTPB6ResultGRPB5ArrayGRPB5ArrayGiEEsE2Ok(frames);
}
function _M0FP38Duckweed11moon_2dmqtt4core11plan__event(event) {
  let e;
  _L: {
    let reason;
    _L$2: {
      let t;
      _L$3: {
        let s;
        _L$4: {
          let p;
          _L$5: {
            let c;
            _L$6: {
              switch (event.$tag) {
                case 0: {
                  const _ConnackReceived = event;
                  const _c = _ConnackReceived._0;
                  c = _c;
                  break _L$6;
                }
                case 1: {
                  const _PublishReceived = event;
                  const _p = _PublishReceived._0;
                  p = _p;
                  break _L$5;
                }
                case 2: {
                  const _SubackReceived = event;
                  const _s = _SubackReceived._0;
                  s = _s;
                  break _L$4;
                }
                case 3: {
                  return _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction6Ignore__;
                }
                case 4: {
                  const _UnknownPacketType = event;
                  const _t = _UnknownPacketType._0;
                  t = _t;
                  break _L$3;
                }
                case 5: {
                  const _MalformedFrame = event;
                  const _reason = _MalformedFrame._1;
                  reason = _reason;
                  break _L$2;
                }
                default: {
                  const _FramerError = event;
                  const _e = _FramerError._0;
                  e = _e;
                  break _L;
                }
              }
            }
            let other;
            _L$7: {
              const _bind = c.return_code;
              if (_bind === 0) {
                return new _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction9Connected(c.session_present);
              } else {
                other = _bind;
                break _L$7;
              }
            }
            return new _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction7Refused(other);
          }
          return new _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction7Deliver(p.topic, p.payload);
        }
        return _M0MP38Duckweed11moon_2dmqtt8protocol6Suback13all__accepted(s) ? _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction8Subacked__ : new _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction14SubackRejected(_M0MP38Duckweed11moon_2dmqtt8protocol6Suback5codes(s));
      }
      return new _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction7Unknown(t);
    }
    return new _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction5Fatal(reason);
  }
  return new _M0DTP38Duckweed11moon_2dmqtt4core14DispatchAction5Fatal(e);
}
function _M0FP38Duckweed11moon_2dmqtt4core18return__code__name(code) {
  switch (code) {
    case 0: {
      return "accepted";
    }
    case 1: {
      return "unacceptable protocol version";
    }
    case 2: {
      return "identifier rejected";
    }
    case 3: {
      return "server unavailable";
    }
    case 4: {
      return "bad username or password";
    }
    default: {
      return "not authorized";
    }
  }
}
function _M0FP38Duckweed11moon_2dmqtt4core18return__code__byte(code) {
  switch (code) {
    case 0: {
      return 0;
    }
    case 1: {
      return 1;
    }
    case 2: {
      return 2;
    }
    case 3: {
      return 3;
    }
    case 4: {
      return 4;
    }
    default: {
      return 5;
    }
  }
}
function _M0FP38Duckweed11moon_2dmqtt4core22inbound__pid__contains(pids, pid) {
  const _bind = pids.len;
  const _bind$2 = pids.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const p = _bind$2[_];
      if (p === pid) {
        return true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FP38Duckweed11moon_2dmqtt4core21inbound__pid__without(pids, pid) {
  const kept = new _M0TPB5ArrayGiE([], 0);
  const _bind = pids.len;
  const _bind$2 = pids.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const p = _bind$2[_];
      if (p !== pid) {
        _M0MPC15array5Array4pushGiE(kept, p);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return kept;
}
function _M0FP38Duckweed11moon_2dmqtt4core17is__inbound__type(t) {
  return t === 2 || (t === 3 || (t === 4 || (t === 5 || (t === 6 || (t === 7 || (t === 9 || (t === 11 || t === 13)))))));
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore3new(opts) {
  return new _M0TP38Duckweed11moon_2dmqtt4core10ClientCore(opts, 1, _M0MP38Duckweed11moon_2dmqtt4core6Framer3new(), 0, _M0MP38Duckweed11moon_2dmqtt7session12SessionStore3new(), new _M0TPB5ArrayGiE([], 0), new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt8protocol12SubscriptionE([], 0), new _M0TPB5ArrayGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE([], 0));
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore5state(self) {
  return self.state;
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore14pending__pings(self) {
  return self.pending_pings;
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore5start(self) {
  return _M0FP38Duckweed11moon_2dmqtt8protocol15encode__connect(self.opts);
}
function _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(out, src) {
  const _bind = src.len;
  const _bind$2 = src.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = _bind$2[_];
      _M0MPC15array5Array4pushGiE(out, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore20record__subscription(self, topic, qos) {
  const _bind = 0;
  const _bind$2 = _M0MPC15array5Array6lengthGRPC16string10StringViewE(self.subscriptions);
  let _tmp = _bind;
  while (true) {
    const i = _tmp;
    if (i < _bind$2) {
      if (_M0MPC15array5Array2atGRPC16string10StringViewE(self.subscriptions, i).topic === topic) {
        _M0MPC15array5Array3setGRP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(self.subscriptions, i, _M0MP38Duckweed11moon_2dmqtt8protocol12Subscription3new(topic, qos));
        return undefined;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(self.subscriptions, _M0MP38Duckweed11moon_2dmqtt8protocol12Subscription3new(topic, qos));
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore26commit__pending__subscribe(self, pid, codes) {
  const found = new _M0TPB8MutLocalGRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEE(new _M0TPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE([], 0));
  const kept = new _M0TPB5ArrayGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE([], 0);
  const _bind = self.pending_subscribes;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const entry = _bind$3[_];
      if (entry._0 === pid) {
        found.val = entry._1;
      } else {
        _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(kept, entry);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  self.pending_subscribes = kept;
  if (_M0MPC15array5Array6lengthGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(codes) !== _M0MPC15array5Array6lengthGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(found.val)) {
    return undefined;
  }
  const _bind$4 = 0;
  const _bind$5 = _M0MPC15array5Array6lengthGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(found.val);
  let _tmp$2 = _bind$4;
  while (true) {
    const i = _tmp$2;
    if (i < _bind$5) {
      let sub;
      _L: {
        _L$2: {
          const _bind$6 = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(found.val, i);
          if (_bind$6 === undefined) {
          } else {
            const _Some = _bind$6;
            const _sub = _Some;
            sub = _sub;
            break _L$2;
          }
          break _L;
        }
        const _bind$6 = _M0MPC15array5Array2atGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(codes, i);
        let _tmp$3;
        if (_bind$6 === 3) {
          _tmp$3 = true;
        } else {
          _tmp$3 = false;
        }
        if (!_tmp$3) {
          _M0MP38Duckweed11moon_2dmqtt4core10ClientCore20record__subscription(self, sub.topic, sub.qos);
        }
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore14reset__session(self) {
  self.session = _M0MP38Duckweed11moon_2dmqtt7session12SessionStore3new();
  self.inbound_qos2 = new _M0TPB5ArrayGiE([], 0);
  self.pending_subscribes = new _M0TPB5ArrayGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE([], 0);
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore29allocate__control__packet__id(self) {
  let store;
  let pid;
  _L: {
    const _bind = _M0FP38Duckweed11moon_2dmqtt7session26alloc__control__packet__id(self.session);
    const _store = _bind._0;
    const _pid = _bind._1;
    store = _store;
    pid = _pid;
    break _L;
  }
  self.session = store;
  return pid;
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore18resubscribe__bytes(self) {
  if (_M0MPC15array5Array6lengthGRPC16string10StringViewE(self.subscriptions) === 0) {
    return new _M0TPB5ArrayGiE([], 0);
  }
  const pid = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore29allocate__control__packet__id(self);
  if (pid === 0) {
    return new _M0TPB5ArrayGiE([], 0);
  }
  const pkt = _M0MP38Duckweed11moon_2dmqtt8protocol15SubscribePacket3new(pid, self.subscriptions);
  return _M0FP38Duckweed11moon_2dmqtt8protocol17encode__subscribe(pkt);
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore4feed(self, bytes) {
  const events = new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt4core9CoreEventE([], 0);
  const outgoing = new _M0TPB5ArrayGiE([], 0);
  let frames;
  let e;
  _L: {
    _L$2: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt4core6Framer4feed(self.framer, bytes);
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _f = _Ok._0;
        frames = _f;
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$2;
      }
      break _L;
    }
    _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent11FramerError(e));
    self.state = 0;
    return { _0: events, _1: outgoing };
  }
  const _bind = frames.len;
  const _bind$2 = frames.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const frame = _bind$2[_];
      let pkt;
      _L$2: {
        _L$3: {
          let e$2;
          _L$4: {
            const _bind$3 = _M0FP38Duckweed11moon_2dmqtt8protocol14decode__packet(frame);
            if (_bind$3.$tag === 0) {
              const _Err = _bind$3;
              const _e = _Err._0;
              e$2 = _e;
              break _L$4;
            } else {
              const _Ok = _bind$3;
              const _pkt = _Ok._0;
              pkt = _pkt;
              break _L$3;
            }
          }
          if (_M0FP38Duckweed11moon_2dmqtt4core17is__inbound__type(_M0MPC15array5Array2atGiE(frame, 0) >> 4)) {
            _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent14MalformedFrame(_M0MPC15array5Array2atGiE(frame, 0) >> 4, e$2));
            self.state = 0;
            return { _0: events, _1: outgoing };
          } else {
            _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent17UnknownPacketType(_M0MPC15array5Array2atGiE(frame, 0) >> 4));
          }
          break _L$2;
        }
        let pid;
        _L$4: {
          _L$5: {
            let pid$2;
            _L$6: {
              _L$7: {
                let pid$3;
                _L$8: {
                  _L$9: {
                    let pid$4;
                    _L$10: {
                      _L$11: {
                        let s;
                        _L$12: {
                          _L$13: {
                            let p;
                            _L$14: {
                              _L$15: {
                                let c;
                                _L$16: {
                                  _L$17: {
                                    switch (pkt.$tag) {
                                      case 0: {
                                        const _Connack = pkt;
                                        const _c = _Connack._0;
                                        c = _c;
                                        break _L$17;
                                      }
                                      case 1: {
                                        const _Publish = pkt;
                                        const _p = _Publish._0;
                                        p = _p;
                                        break _L$15;
                                      }
                                      case 6: {
                                        const _Suback = pkt;
                                        const _s = _Suback._0;
                                        s = _s;
                                        break _L$13;
                                      }
                                      case 8: {
                                        if (self.pending_pings > 0) {
                                          self.pending_pings = self.pending_pings - 1 | 0;
                                        }
                                        _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(events, _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent16PingRespReceived__);
                                        break;
                                      }
                                      case 2: {
                                        const _Puback = pkt;
                                        const _pid = _Puback._0;
                                        pid$4 = _pid;
                                        break _L$11;
                                      }
                                      case 3: {
                                        const _Pubrec = pkt;
                                        const _pid$2 = _Pubrec._0;
                                        pid$3 = _pid$2;
                                        break _L$9;
                                      }
                                      case 4: {
                                        const _Pubrel = pkt;
                                        const _pid$3 = _Pubrel._0;
                                        pid$2 = _pid$3;
                                        break _L$7;
                                      }
                                      case 5: {
                                        const _Pubcomp = pkt;
                                        const _pid$4 = _Pubcomp._0;
                                        pid = _pid$4;
                                        break _L$5;
                                      }
                                    }
                                    break _L$16;
                                  }
                                  const _bind$3 = c.return_code;
                                  let _tmp$2;
                                  if (_bind$3 === 0) {
                                    _tmp$2 = 2;
                                  } else {
                                    _tmp$2 = 0;
                                  }
                                  self.state = _tmp$2;
                                  const _bind$4 = c.return_code;
                                  if (_bind$4 === 0) {
                                    if (!c.session_present) {
                                      _M0MP38Duckweed11moon_2dmqtt4core10ClientCore14reset__session(self);
                                      _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(outgoing, _M0MP38Duckweed11moon_2dmqtt4core10ClientCore18resubscribe__bytes(self));
                                    }
                                  }
                                  _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent15ConnackReceived(c));
                                }
                                break _L$14;
                              }
                              const deliver = new _M0TPB8MutLocalGbE(true);
                              const _bind$3 = p.qos;
                              switch (_bind$3) {
                                case 1: {
                                  _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(outgoing, _M0FP38Duckweed11moon_2dmqtt8protocol14encode__puback(p.packet_id));
                                  break;
                                }
                                case 2: {
                                  if (_M0FP38Duckweed11moon_2dmqtt4core22inbound__pid__contains(self.inbound_qos2, p.packet_id)) {
                                    deliver.val = false;
                                  } else {
                                    _M0MPC15array5Array4pushGiE(self.inbound_qos2, p.packet_id);
                                  }
                                  _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(outgoing, _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrec(p.packet_id));
                                  break;
                                }
                              }
                              if (deliver.val) {
                                _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent15PublishReceived(p));
                              }
                            }
                            break _L$12;
                          }
                          _M0MP38Duckweed11moon_2dmqtt4core10ClientCore26commit__pending__subscribe(self, s.packet_id, _M0MP38Duckweed11moon_2dmqtt8protocol6Suback5codes(s));
                          _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent14SubackReceived(s));
                        }
                        break _L$10;
                      }
                      self.session = _M0FP38Duckweed11moon_2dmqtt7session10on__puback(self.session, pid$4);
                    }
                    break _L$8;
                  }
                  let s;
                  let pubrel;
                  _L$10: {
                    const _bind$3 = _M0FP38Duckweed11moon_2dmqtt7session10on__pubrec(self.session, pid$3);
                    const _s = _bind$3._0;
                    const _pubrel = _bind$3._1;
                    s = _s;
                    pubrel = _pubrel;
                    break _L$10;
                  }
                  self.session = s;
                  _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(outgoing, pubrel);
                }
                break _L$6;
              }
              self.inbound_qos2 = _M0FP38Duckweed11moon_2dmqtt4core21inbound__pid__without(self.inbound_qos2, pid$2);
              _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(outgoing, _M0FP38Duckweed11moon_2dmqtt8protocol15encode__pubcomp(pid$2));
            }
            break _L$4;
          }
          self.session = _M0FP38Duckweed11moon_2dmqtt7session11on__pubcomp(self.session, pid);
        }
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return { _0: events, _1: outgoing };
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore7publish(self, topic, payload, qos) {
  const _bind = self.state;
  if (_bind === 2) {
  } else {
    return new _M0TPB5ArrayGiE([], 0);
  }
  const _bind$2 = _M0FP38Duckweed11moon_2dmqtt8protocol21validate__topic__name(topic);
  if (_bind$2.$tag === 1) {
  } else {
    return new _M0TPB5ArrayGiE([], 0);
  }
  const pkt = _M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket3new(topic, payload, qos, false, false, 0);
  if (qos === 0) {
    return _M0FP38Duckweed11moon_2dmqtt8protocol15encode__publish(pkt);
  } else {
    let store;
    let pid;
    _L: {
      const _bind$3 = _M0FP38Duckweed11moon_2dmqtt7session16record__outbound(self.session, pkt);
      const _store = _bind$3._0;
      const _pid = _bind$3._1;
      store = _store;
      pid = _pid;
      break _L;
    }
    self.session = store;
    if (pid === 0) {
      return new _M0TPB5ArrayGiE([], 0);
    }
    const with_pid = _M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket16with__packet__id(pkt, pid);
    return _M0FP38Duckweed11moon_2dmqtt8protocol15encode__publish(with_pid);
  }
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore27record__outbound__subscribe(self, pid, subs) {
  const kept = new _M0TPB5ArrayGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE([], 0);
  const _bind = self.pending_subscribes;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const entry = _bind$3[_];
      if (entry._0 !== pid) {
        _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(kept, entry);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const pending = new _M0TPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE([], 0);
  const _bind$4 = subs.len;
  const _bind$5 = subs.buf;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$4) {
      const sub = _bind$5[_];
      _M0MPC15array5Array4pushGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionE(pending, sub);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(kept, { _0: pid, _1: pending });
  self.pending_subscribes = kept;
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore13subscriptions(self) {
  const out = new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt8protocol12SubscriptionE([], 0);
  const _bind = self.subscriptions;
  const _bind$2 = _bind.len;
  const _bind$3 = _bind.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const sub = _bind$3[_];
      _M0MPC15array5Array4pushGUiRPB5ArrayGORP38Duckweed11moon_2dmqtt8protocol12SubscriptionEEE(out, sub);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return out;
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore13replay__bytes(self) {
  return _M0FP38Duckweed11moon_2dmqtt7session6replay(self.session);
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore7pingreq(self) {
  self.pending_pings = self.pending_pings + 1 | 0;
  return _M0FP38Duckweed11moon_2dmqtt8protocol15encode__pingreq();
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore20on__transport__close(self) {
  self.state = 0;
  self.pending_pings = 0;
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore16reconnect__bytes(self) {
  self.state = 1;
  self.pending_pings = 0;
  _M0MP38Duckweed11moon_2dmqtt4core6Framer5reset(self.framer);
  return _M0FP38Duckweed11moon_2dmqtt8protocol15encode__connect(self.opts);
}
function _M0MP38Duckweed11moon_2dmqtt7browser6Client3new() {}
function _M0FP38Duckweed11moon_2dmqtt7browser16to__fixed__array(arr) {
  const out = $make_array_len_and_init(_M0MPC15array5Array6lengthGiE(arr), 0);
  const _bind = 0;
  const _bind$2 = _M0MPC15array5Array6lengthGiE(arr);
  let _tmp = _bind;
  while (true) {
    const i = _tmp;
    if (i < _bind$2) {
      if (i >>> 0 < out.length) {
        out[i] = _M0MPC15array5Array2atGiE(arr, i);
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return out;
}
function _M0FP38Duckweed11moon_2dmqtt7browser8open__ws(url, connect_bytes) {
  _M0FP38Duckweed11moon_2dmqtt7browser13open__ws__ffi(url, _M0FP38Duckweed11moon_2dmqtt7browser16to__fixed__array(connect_bytes));
}
function _M0FP38Duckweed11moon_2dmqtt7browser13connect__opts(host, port, opts) {
  const url = `wss://${host}:${_M0MPC13int3Int18to__string_2einner(port, 10)}/mqtt`;
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__opts, 0, opts);
  const core = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore3new(opts);
  const connect_bytes = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore5start(core);
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser10g__handler, 0, undefined);
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser10g__connect, 0, undefined);
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser9g__suback, 0, undefined);
  _M0FP38Duckweed11moon_2dmqtt7browser8open__ws(url, connect_bytes);
  _M0MP38Duckweed11moon_2dmqtt7browser6Client3new();
}
function _M0FP38Duckweed11moon_2dmqtt7browser7connect(host, port, client_id) {
  _M0FP38Duckweed11moon_2dmqtt7browser13connect__opts(host, port, _M0MP38Duckweed11moon_2dmqtt8protocol13ConnectPacket3new(client_id));
}
function _M0FP38Duckweed11moon_2dmqtt7browser19connect__persistent(host, port, client_id) {
  _M0FP38Duckweed11moon_2dmqtt7browser13connect__opts(host, port, _M0MP38Duckweed11moon_2dmqtt8protocol13ConnectPacket20with__clean__session(_M0MP38Duckweed11moon_2dmqtt8protocol13ConnectPacket3new(client_id), false));
}
function _M0FP38Duckweed11moon_2dmqtt7browser11on__message(_client, handler) {
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser10g__handler, 0, handler);
}
function _M0FP38Duckweed11moon_2dmqtt7browser11on__connect(_client, handler) {
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser10g__connect, 0, handler);
}
function _M0FP38Duckweed11moon_2dmqtt7browser10on__suback(_client, handler) {
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser9g__suback, 0, handler);
}
function _M0FP38Duckweed11moon_2dmqtt7browser13report__error(msg) {
  _M0FPB7printlnGsE(`[browser] ${msg}`);
  let h;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser8g__error, 0);
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _h = _Some;
      h = _h;
      break _L;
    }
  }
  h(msg);
}
function _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(bytes) {
  _M0FP38Duckweed11moon_2dmqtt7browser18browser__send__ffi(_M0FP38Duckweed11moon_2dmqtt7browser16to__fixed__array(bytes));
}
function _M0FP38Duckweed11moon_2dmqtt7browser9subscribe(_client, topic, qos) {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _core = _Some;
      core = _core;
      break _L;
    }
  }
  let e;
  _L$2: {
    _L$3: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol23validate__topic__filter(topic);
      if (_bind.$tag === 1) {
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$3;
      }
      break _L$2;
    }
    _M0FP38Duckweed11moon_2dmqtt7browser13report__error(`subscribe rejected: ${e}`);
    return undefined;
  }
  const pid = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore29allocate__control__packet__id(core);
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
  if (pid === 0) {
    _M0FPB7printlnGsE("[browser] subscribe: out of packet ids");
    return undefined;
  }
  const sub = _M0MP38Duckweed11moon_2dmqtt8protocol12Subscription3new(topic, qos);
  _M0MP38Duckweed11moon_2dmqtt4core10ClientCore27record__outbound__subscribe(core, pid, new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt8protocol12SubscriptionE([sub], 1));
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
  const pkt = _M0MP38Duckweed11moon_2dmqtt8protocol15SubscribePacket3new(pid, new _M0TPB5ArrayGRP38Duckweed11moon_2dmqtt8protocol12SubscriptionE([sub], 1));
  _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(_M0FP38Duckweed11moon_2dmqtt8protocol17encode__subscribe(pkt));
}
function _M0FP38Duckweed11moon_2dmqtt7browser7publish(_client, topic, payload, qos) {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _core = _Some;
      core = _core;
      break _L;
    }
  }
  let e;
  _L$2: {
    _L$3: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol21validate__topic__name(topic);
      if (_bind.$tag === 1) {
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$3;
      }
      break _L$2;
    }
    _M0FP38Duckweed11moon_2dmqtt7browser13report__error(`publish rejected: ${e}`);
    return undefined;
  }
  let e$2;
  _L$3: {
    _L$4: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol21validate__byte__array(payload);
      if (_bind.$tag === 1) {
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e$2 = _e;
        break _L$4;
      }
      break _L$3;
    }
    _M0FP38Duckweed11moon_2dmqtt7browser13report__error(`publish rejected: ${e$2}`);
    return undefined;
  }
  const bytes = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore7publish(core, topic, payload, qos);
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
  _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(bytes);
}
function _M0FP38Duckweed11moon_2dmqtt7browser20browser__on__message(bytes) {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _core = _Some;
      core = _core;
      break _L;
    }
  }
  let events;
  let outgoing;
  _L$2: {
    const _bind = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore4feed(core, bytes);
    const _events = _bind._0;
    const _outgoing = _bind._1;
    events = _events;
    outgoing = _outgoing;
    break _L$2;
  }
  const _bind = events.len;
  const _bind$2 = events.buf;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = _bind$2[_];
      let t;
      _L$3: {
        _L$4: {
          let codes;
          _L$5: {
            _L$6: {
              let topic;
              let payload;
              _L$7: {
                _L$8: {
                  let msg;
                  _L$9: {
                    _L$10: {
                      let code;
                      _L$11: {
                        _L$12: {
                          let session_present;
                          _L$13: {
                            _L$14: {
                              const _bind$3 = _M0FP38Duckweed11moon_2dmqtt4core11plan__event(e);
                              switch (_bind$3.$tag) {
                                case 1: {
                                  const _Connected = _bind$3;
                                  const _session_present = _Connected._0;
                                  session_present = _session_present;
                                  break _L$14;
                                }
                                case 2: {
                                  const _Refused = _bind$3;
                                  const _code = _Refused._0;
                                  code = _code;
                                  break _L$12;
                                }
                                case 3: {
                                  const _Fatal = _bind$3;
                                  const _msg = _Fatal._0;
                                  msg = _msg;
                                  break _L$10;
                                }
                                case 4: {
                                  const _Deliver = _bind$3;
                                  const _topic = _Deliver._0;
                                  const _payload = _Deliver._1;
                                  topic = _topic;
                                  payload = _payload;
                                  break _L$8;
                                }
                                case 5: {
                                  _M0FPB7printlnGsE("[browser] suback");
                                  let h;
                                  _L$15: {
                                    _L$16: {
                                      const _bind$4 = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser9g__suback, 0);
                                      if (_bind$4 === undefined) {
                                      } else {
                                        const _Some = _bind$4;
                                        const _h = _Some;
                                        h = _h;
                                        break _L$16;
                                      }
                                      break _L$15;
                                    }
                                    h();
                                  }
                                  break;
                                }
                                case 6: {
                                  const _SubackRejected = _bind$3;
                                  const _codes = _SubackRejected._0;
                                  codes = _codes;
                                  break _L$6;
                                }
                                case 7: {
                                  const _Unknown = _bind$3;
                                  const _t = _Unknown._0;
                                  t = _t;
                                  break _L$4;
                                }
                              }
                              break _L$13;
                            }
                            if (!session_present) {
                              _M0MP38Duckweed11moon_2dmqtt4core10ClientCore14reset__session(core);
                              const subs = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore13subscriptions(core);
                              _M0FPB7printlnGsE(`[browser] session_present=0, resubscribe ${_M0MPC13int3Int18to__string_2einner(_M0MPC15array5Array6lengthGRPC16string10StringViewE(subs), 10)} topic(s)`);
                            } else {
                              const frames = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore13replay__bytes(core);
                              const _bind$3 = frames.len;
                              const _bind$4 = frames.buf;
                              let _tmp$2 = 0;
                              while (true) {
                                const _$2 = _tmp$2;
                                if (_$2 < _bind$3) {
                                  const f = _bind$4[_$2];
                                  _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(f);
                                  _tmp$2 = _$2 + 1 | 0;
                                  continue;
                                } else {
                                  break;
                                }
                              }
                              _M0FPB7printlnGsE(`[browser] session_present=1, replay ${_M0MPC13int3Int18to__string_2einner(_M0MPC15array5Array6lengthGRPC16string10StringViewE(frames), 10)} frame(s)`);
                            }
                            _M0MPC15array5Array3setGiE(_M0FP38Duckweed11moon_2dmqtt7browser17g__last__ping__ms, 0, 0);
                            let h;
                            _L$15: {
                              _L$16: {
                                const _bind$3 = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser10g__connect, 0);
                                if (_bind$3 === undefined) {
                                } else {
                                  const _Some = _bind$3;
                                  const _h = _Some;
                                  h = _h;
                                  break _L$16;
                                }
                                break _L$15;
                              }
                              h();
                            }
                          }
                          break _L$11;
                        }
                        _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
                        _M0FP38Duckweed11moon_2dmqtt7browser13report__error(`CONNACK refused: ${_M0FP38Duckweed11moon_2dmqtt4core18return__code__name(code)} (${_M0MPC13int3Int18to__string_2einner(_M0FP38Duckweed11moon_2dmqtt4core18return__code__byte(code), 10)})`);
                        _M0FP38Duckweed11moon_2dmqtt7browser24mark__manual__close__ffi();
                        _M0FP38Duckweed11moon_2dmqtt7browser14close__ws__ffi();
                        return undefined;
                      }
                      break _L$9;
                    }
                    _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
                    _M0FP38Duckweed11moon_2dmqtt7browser13report__error(`fatal framing error: ${msg}`);
                    _M0FP38Duckweed11moon_2dmqtt7browser14close__ws__ffi();
                    return undefined;
                  }
                  break _L$7;
                }
                let h;
                _L$9: {
                  _L$10: {
                    const _bind$3 = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser10g__handler, 0);
                    if (_bind$3 === undefined) {
                    } else {
                      const _Some = _bind$3;
                      const _h = _Some;
                      h = _h;
                      break _L$10;
                    }
                    break _L$9;
                  }
                  h(topic, payload);
                }
              }
              break _L$5;
            }
            const rejected = new _M0TPB8MutLocalGiE(0);
            const i = new _M0TPB8MutLocalGiE(0);
            while (true) {
              if (i.val < _M0MPC15array5Array6lengthGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(codes)) {
                const _bind$3 = _M0MPC15array5Array2atGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(codes, i.val);
                if (_bind$3 === 3) {
                  rejected.val = rejected.val + 1 | 0;
                }
                i.val = i.val + 1 | 0;
                continue;
              } else {
                break;
              }
            }
            _M0FP38Duckweed11moon_2dmqtt7browser13report__error(`suback rejected: broker refused ${_M0MPC13int3Int18to__string_2einner(rejected.val, 10)} of ${_M0MPC13int3Int18to__string_2einner(_M0MPC15array5Array6lengthGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(codes), 10)} item(s)`);
          }
          break _L$3;
        }
        _M0FPB7printlnGsE(`[browser] unknown packet type ${_M0MPC13int3Int18to__string_2einner(t, 10)}`);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (_M0MPC15array5Array6lengthGiE(outgoing) > 0) {
    _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(outgoing);
  }
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
}
function _M0FP38Duckweed11moon_2dmqtt7browser18browser__on__close() {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _core = _Some;
      core = _core;
      break _L;
    }
  }
  _M0MP38Duckweed11moon_2dmqtt4core10ClientCore20on__transport__close(core);
  _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
}
function _M0FP38Duckweed11moon_2dmqtt7browser13browser__tick(now_ms) {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _core = _Some;
      core = _core;
      break _L;
    }
  }
  const _bind = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore5state(core);
  if (_bind === 2) {
    let ka;
    let o;
    _L$2: {
      _L$3: {
        const _bind$2 = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__opts, 0);
        if (_bind$2 === undefined) {
          ka = 60;
        } else {
          const _Some = _bind$2;
          const _o = _Some;
          o = _o;
          break _L$3;
        }
        break _L$2;
      }
      ka = o.keep_alive;
    }
    if (_M0MPC15array5Array2atGiE(_M0FP38Duckweed11moon_2dmqtt7browser17g__last__ping__ms, 0) === 0) {
      _M0MPC15array5Array3setGiE(_M0FP38Duckweed11moon_2dmqtt7browser17g__last__ping__ms, 0, now_ms);
    }
    const action = _M0FP38Duckweed11moon_2dmqtt4core12next__action(now_ms, _M0MPC15array5Array2atGiE(_M0FP38Duckweed11moon_2dmqtt7browser17g__last__ping__ms, 0), _M0MP38Duckweed11moon_2dmqtt4core10ClientCore14pending__pings(core), ka);
    switch (action) {
      case 2: {
        _M0FPB7printlnGsE("[browser] keepalive timeout, closing socket");
        _M0MP38Duckweed11moon_2dmqtt4core10ClientCore20on__transport__close(core);
        _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
        _M0MPC15array5Array3setGiE(_M0FP38Duckweed11moon_2dmqtt7browser17g__last__ping__ms, 0, 0);
        _M0FP38Duckweed11moon_2dmqtt7browser14close__ws__ffi();
        return;
      }
      case 1: {
        const bytes = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore7pingreq(core);
        _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
        _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(bytes);
        _M0MPC15array5Array3setGiE(_M0FP38Duckweed11moon_2dmqtt7browser17g__last__ping__ms, 0, now_ms);
        return;
      }
      default: {
        _M0MPC15array5Array3setGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
        return;
      }
    }
  } else {
    return;
  }
}
function _M0FP38Duckweed11moon_2dmqtt7browser25browser__reconnect__bytes() {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt8protocol13ConnectPacketE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
    if (_bind === undefined) {
      return new _M0TPB5ArrayGiE([], 0);
    } else {
      const _Some = _bind;
      const _core = _Some;
      core = _core;
      break _L;
    }
  }
  return _M0MP38Duckweed11moon_2dmqtt4core10ClientCore16reconnect__bytes(core);
}
function _M0FP38Duckweed11moon_2dmqtt7browser23__browser__dce__protect() {
  _M0FP38Duckweed11moon_2dmqtt7browser20browser__on__message(new _M0TPB5ArrayGiE([], 0));
  _M0FP38Duckweed11moon_2dmqtt7browser18browser__on__close();
  _M0FP38Duckweed11moon_2dmqtt7browser25browser__reconnect__bytes();
  _M0FP38Duckweed11moon_2dmqtt7browser13browser__tick(0);
}
(() => {
  _M0FP38Duckweed11moon_2dmqtt7browser23__browser__dce__protect();
  const client_id = _M0FP48Duckweed11moon_2dmqtt8examples14browser_2ddemo16demo__client__id();
  const autotest = _M0FP48Duckweed11moon_2dmqtt8examples14browser_2ddemo12is__autotest();
  _M0FPB7printlnGsE(`[demo] client_id=${client_id}`);
  if (autotest) {
    _M0FPB7printlnGsE("[demo] connecting to broker.emqx.io:8084 (clean_session=true, autotest) ...");
  } else {
    _M0FPB7printlnGsE("[demo] connecting to broker.emqx.io:8084 (clean_session=false) ...");
  }
  let client;
  if (autotest) {
    _M0FP38Duckweed11moon_2dmqtt7browser7connect("broker.emqx.io", 8084, client_id);
  } else {
    _M0FP38Duckweed11moon_2dmqtt7browser19connect__persistent("broker.emqx.io", 8084, client_id);
  }
  _M0FP38Duckweed11moon_2dmqtt7browser11on__message(client, (topic, payload) => {
    _M0FPB7printlnGsE(`[demo] recv topic=${topic} payload=${_M0MPC13int3Int18to__string_2einner(_M0MPC15array5Array6lengthGiE(payload), 10)} bytes`);
  });
  _M0FP38Duckweed11moon_2dmqtt7browser11on__connect(client, () => {
    if (_M0MPC15array5Array2atGbE(_M0FP48Duckweed11moon_2dmqtt8examples14browser_2ddemo13g__subscribed, 0)) {
      _M0FPB7printlnGsE("[demo] reconnected, rely on core auto-resubscribe");
      return;
    } else {
      _M0MPC15array5Array3setGbE(_M0FP48Duckweed11moon_2dmqtt8examples14browser_2ddemo13g__subscribed, 0, true);
      _M0FPB7printlnGsE("[demo] connected, subscribing sensors/# QoS1");
      _M0FP38Duckweed11moon_2dmqtt7browser9subscribe(client, "sensors/#", _M0FP38Duckweed11moon_2dmqtt8protocol4qos1());
      return;
    }
  });
  _M0FP38Duckweed11moon_2dmqtt7browser10on__suback(client, () => {
    _M0FPB7printlnGsE("[demo] suback, publishing QoS1 sensors/hello");
    _M0FP38Duckweed11moon_2dmqtt7browser7publish(client, "sensors/hello", new _M0TPB5ArrayGiE([104, 105], 2), _M0FP38Duckweed11moon_2dmqtt8protocol4qos1());
  });
  _M0FPB7printlnGsE("[demo] running... (close browser tab to disconnect)");
})();
//# sourceMappingURL=browser-demo.js.map

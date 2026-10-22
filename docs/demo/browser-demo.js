const _M0FPB19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
const _M0MPB7JSArray4push = (arr, val) => { arr.push(val); };
const _M0MPB7JSArray11set__length = (arr, len) => { arr.length = len; };
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
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
function _M0TPB8MutLocalGiE(param0) {
  this.val = param0;
}
function _M0TP38Duckweed11moon_2dmqtt8protocol10ByteReader(param0) {
  this.data = param0;
}
function _M0DTPC16result6ResultGUiiEsE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGUiiEsE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGUiiEsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGUiiEsE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE2Ok.prototype.$tag = 1;
function _M0TP38Duckweed11moon_2dmqtt8protocol6Suback(param0, param1) {
  this.packet_id = param0;
  this.codes = param1;
}
function _M0DTPC16result6ResultGisE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGisE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGisE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGisE2Ok.prototype.$tag = 1;
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
function _M0DTPC16result6ResultGssE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGssE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGssE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGssE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGURPB5ArrayGiEiEsE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGURPB5ArrayGiEiEsE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGURPB5ArrayGiEiEsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGURPB5ArrayGiEiEsE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGUsiEsE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGUsiEsE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGUsiEsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGUsiEsE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE2Ok.prototype.$tag = 1;
function _M0TP38Duckweed11moon_2dmqtt8protocol7Connack(param0, param1) {
  this.session_present = param0;
  this.return_code = param1;
}
function _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok.prototype.$tag = 1;
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
function _M0DTPC16option6OptionGRPB5ArrayGiEE4None() {}
_M0DTPC16option6OptionGRPB5ArrayGiEE4None.prototype.$tag = 0;
const _M0DTPC16option6OptionGRPB5ArrayGiEE4None__ = new _M0DTPC16option6OptionGRPB5ArrayGiEE4None();
function _M0DTPC16option6OptionGRPB5ArrayGiEE4Some(param0) {
  this._0 = param0;
}
_M0DTPC16option6OptionGRPB5ArrayGiEE4Some.prototype.$tag = 1;
function _M0TP38Duckweed11moon_2dmqtt7session12SessionStore(param0, param1) {
  this.inflight = param0;
  this.next_id = param1;
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
function _M0TP38Duckweed11moon_2dmqtt4core6Framer(param0) {
  this.buf = param0;
}
function _M0TP38Duckweed11moon_2dmqtt4core10ClientCore(param0, param1, param2, param3, param4) {
  this.opts = param0;
  this.state = param1;
  this.framer = param2;
  this.pending_pings = param3;
  this.session = param4;
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
const _M0FP38Duckweed11moon_2dmqtt7browser13open__ws__ffi = (url, connectBytes) => {
  let ws = null;
  let reconnectAttempts = 0;
  const MAX_RECONNECT = 3;
  function open() {
    console.log("[browser] connecting to " + url);
    ws = new WebSocket(url, "mqtt");
    ws.binaryType = "arraybuffer";
    // 暴露给 browser_send 用
    if (typeof globalThis !== "undefined") { globalThis.moonMQTTWs = ws; }
    ws.onopen = function() {
      let bytes = connectBytes;
      if (reconnectAttempts > 0) {
        bytes = _M0FP38Duckweed11moon_2dmqtt7browser25browser__reconnect__bytes();
      }
      const u8 = new Uint8Array(bytes.length);
      for (let i = 0; i < bytes.length; i++) u8[i] = bytes[i];
      ws.send(u8.buffer);
    };
    ws.onmessage = function(ev) {
      const u8 = new Uint8Array(ev.data);
      const arr = [];
      for (let j = 0; j < u8.length; j++) arr.push(u8[j]);
      _M0FP38Duckweed11moon_2dmqtt7browser20browser__on__message(arr);
    };
    ws.onclose = function() {
      _M0FP38Duckweed11moon_2dmqtt7browser18browser__on__close();
      if (reconnectAttempts < MAX_RECONNECT) {
        reconnectAttempts = reconnectAttempts + 1;
        console.log("[browser] reconnect attempt #" + reconnectAttempts + " in 1s");
        setTimeout(open, 1000);
      }
    };
  }
  open();
};
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
function $oob() {
  throw new Error("Index out of bounds");
}
const _M0FP38Duckweed11moon_2dmqtt7browser18browser__send__ffi = (bytes) => {
  if (typeof globalThis !== "undefined" && globalThis.moonMQTTWs) {
    const u8 = new Uint8Array(bytes.length);
    for (let i = 0; i < bytes.length; i++) u8[i] = bytes[i];
    globalThis.moonMQTTWs.send(u8.buffer);
  }
};
const _M0FP48Duckweed11moon_2dmqtt8examples14browser_2ddemo16demo__client__id = () => "moon-demo-" + Math.random().toString(36).slice(2, 8);
const _M0FP38Duckweed11moon_2dmqtt7browser7g__core = [undefined];
const _M0FP38Duckweed11moon_2dmqtt7browser7g__opts = [undefined];
const _M0FP38Duckweed11moon_2dmqtt7browser10g__handler = [undefined];
const _M0FP38Duckweed11moon_2dmqtt7browser10g__connect = [undefined];
const _M0FP38Duckweed11moon_2dmqtt7browser9g__suback = [undefined];
const _M0FP38Duckweed11moon_2dmqtt7browser12g__next__pid = [1];
function _M0MPC13int3Int16unsafe__to__char(self) {
  return self;
}
function _M0IP016_24default__implPB2Eq10not__equalGRP38Duckweed11moon_2dmqtt8protocol3QoSE(x, y) {
  return !_M0IP38Duckweed11moon_2dmqtt8protocol3QoSPB2Eq5equal(x, y);
}
function _M0MPC13int3Int18to__string_2einner(self, radix) {
  return _M0FPB19int__to__string__js(self, radix);
}
function _M0IPC16string6StringPB4Show10to__string(self) {
  return self;
}
function _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGiE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGRPB5ArrayGiEE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0IPC14char4CharPB4Show10to__string(self) {
  return String.fromCodePoint(self);
}
function _M0FPB7printlnGsE(input) {
  console.log(_M0IPC16string6StringPB4Show10to__string(input));
}
function _M0MPC15array5Array28unsafe__truncate__to__lengthGiE(self, new_len) {
  _M0MPB7JSArray11set__length(self, new_len);
}
function _M0MPC15array5Array2atGiE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt4core10ClientCoreE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array3setGiE(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array5clearGiE(self) {
  _M0MPC15array5Array28unsafe__truncate__to__lengthGiE(self, 0);
}
function _M0IP38Duckweed11moon_2dmqtt8protocol3QoSPB2Eq5equal(_x_278, _x_279) {
  switch (_x_278) {
    case 0: {
      if (_x_279 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_279 === 1) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_279 === 2) {
        return true;
      } else {
        return false;
      }
    }
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
  return new _M0TP38Duckweed11moon_2dmqtt8protocol10ByteWriter([]);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(self, b) {
  _M0MPC15array5Array4pushGiE(self.bytes, b);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol25encode__remaining__length(len) {
  const out = [];
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
  const _bind = rl.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = rl[_];
      _M0MPC15array5Array4pushGiE(self.bytes, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP38Duckweed11moon_2dmqtt8protocol12utf8__encode(s) {
  const out = [];
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
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(self, v) {
  _M0MPC15array5Array4pushGiE(self.bytes, v >> 8 & 255);
  _M0MPC15array5Array4pushGiE(self.bytes, v & 255);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(self, s) {
  const data = _M0FP38Duckweed11moon_2dmqtt8protocol12utf8__encode(s);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(self, data.length);
  const _bind = data.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = data[_];
      _M0MPC15array5Array4pushGiE(self.bytes, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP38Duckweed11moon_2dmqtt8protocol17encode__subscribe(pkt) {
  const body = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(body, pkt.packet_id);
  const _bind = pkt.subscriptions;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const sub = _bind[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(body, sub.topic);
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(body, _M0FP38Duckweed11moon_2dmqtt8protocol10qos__value(sub.qos));
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const out = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, 130);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter23push__remaining__length(out, _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body).length);
  const _bind$3 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body);
  const _bind$4 = _bind$3.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$4) {
      const b = _bind$3[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, b);
      _tmp$2 = _ + 1 | 0;
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
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader3new(data) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol10ByteReader(data);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader10read__byte(self, start) {
  if (start >= self.data.length) {
    return new _M0DTPC16result6ResultGUiiEsE3Err("read out of range");
  }
  return new _M0DTPC16result6ResultGUiiEsE2Ok({ _0: _M0MPC15array5Array2atGiE(self.data, start), _1: start + 1 | 0 });
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
    return new _M0DTPC16result6ResultGUiiEsE3Err(e);
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
    return new _M0DTPC16result6ResultGUiiEsE3Err(e);
  }
  return new _M0DTPC16result6ResultGUiiEsE2Ok({ _0: h << 8 | l, _1: p2 });
}
function _M0FP38Duckweed11moon_2dmqtt8protocol14decode__suback(data) {
  if (data.length < 4) {
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err("suback too short");
  }
  if (_M0MPC15array5Array2atGiE(data, 0) !== 144) {
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err("not a suback");
  }
  const r = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader3new(data);
  let pid;
  let p;
  _L: {
    let e;
    _L$2: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader9read__u16(r, 2);
      if (_bind.$tag === 0) {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L$2;
      } else {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _pid = _x._0;
        const _p = _x._1;
        pid = _pid;
        p = _p;
        break _L;
      }
    }
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err(e);
  }
  const pos = new _M0TPB8MutLocalGiE(p);
  const codes = [];
  while (true) {
    if (pos.val < data.length) {
      let c;
      _L$2: {
        const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol23suback__code__from__int(_M0MPC15array5Array2atGiE(data, pos.val));
        if (_bind === undefined) {
          return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE3Err("suback bad code");
        } else {
          const _Some = _bind;
          const _c = _Some;
          c = _c;
          break _L$2;
        }
      }
      _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt8protocol10SubAckCodeE(codes, c);
      pos.val = pos.val + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol6SubacksE2Ok(new _M0TP38Duckweed11moon_2dmqtt8protocol6Suback(pid, codes));
}
function _M0FP38Duckweed11moon_2dmqtt8protocol16decode__unsuback(data) {
  if (data.length < 4) {
    return new _M0DTPC16result6ResultGisE3Err("unsuback too short");
  }
  if (_M0MPC15array5Array2atGiE(data, 0) !== 176) {
    return new _M0DTPC16result6ResultGisE3Err("not an unsuback");
  }
  const r = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader3new(data);
  let e;
  _L: {
    let pid;
    _L$2: {
      const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader9read__u16(r, 2);
      if (_bind.$tag === 1) {
        const _Ok = _bind;
        const _x = _Ok._0;
        const _pid = _x._0;
        pid = _pid;
        break _L$2;
      } else {
        const _Err = _bind;
        const _e = _Err._0;
        e = _e;
        break _L;
      }
    }
    return new _M0DTPC16result6ResultGisE2Ok(pid);
  }
  return new _M0DTPC16result6ResultGisE3Err(e);
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
  const body = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(body, pkt.topic);
  if (_M0IP016_24default__implPB2Eq10not__equalGRP38Duckweed11moon_2dmqtt8protocol3QoSE(pkt.qos, 0)) {
    _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(body, pkt.packet_id);
  }
  const _bind = pkt.payload;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const b = _bind[_];
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
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter23push__remaining__length(out, _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body).length);
  const _bind$3 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body);
  const _bind$4 = _bind$3.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$4) {
      const b = _bind$3[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, b);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(out);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol25decode__remaining__length(data, start) {
  const multiplier = new _M0TPB8MutLocalGiE(1);
  const value = new _M0TPB8MutLocalGiE(0);
  const pos = new _M0TPB8MutLocalGiE(start);
  const count = new _M0TPB8MutLocalGiE(0);
  while (true) {
    if (pos.val >= data.length) {
      return new _M0DTPC16result6ResultGUiiEsE3Err("remaining length truncated");
    }
    if (count.val >= 4) {
      return new _M0DTPC16result6ResultGUiiEsE3Err("remaining length exceeds 4 bytes");
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
  return new _M0DTPC16result6ResultGUiiEsE2Ok({ _0: value.val, _1: pos.val + 1 | 0 });
}
function _M0FP38Duckweed11moon_2dmqtt8protocol16char__from__code(cp) {
  if (cp < 0 || cp > 1114111) {
    return "�";
  }
  return _M0IPC14char4CharPB4Show10to__string(cp);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol12utf8__decode(data, start, len) {
  const sb = new _M0TPB8MutLocalGsE("");
  const i = new _M0TPB8MutLocalGiE(start);
  const end = start + len | 0;
  if (end > data.length) {
    return new _M0DTPC16result6ResultGssE3Err("utf8 out of range");
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
            return new _M0DTPC16result6ResultGssE3Err("utf8 truncated 2-byte");
          }
          const b1 = _M0MPC15array5Array2atGiE(data, i.val + 1 | 0);
          const cp = (b0 & 31) << 6 | b1 & 63;
          sb.val = `${sb.val}${_M0FP38Duckweed11moon_2dmqtt8protocol16char__from__code(cp)}`;
          i.val = i.val + 2 | 0;
        } else {
          if ((b0 & 240) === 224) {
            if ((i.val + 2 | 0) >= end) {
              return new _M0DTPC16result6ResultGssE3Err("utf8 truncated 3-byte");
            }
            const b1 = _M0MPC15array5Array2atGiE(data, i.val + 1 | 0);
            const b2 = _M0MPC15array5Array2atGiE(data, i.val + 2 | 0);
            const cp = (b0 & 15) << 12 | (b1 & 63) << 6 | b2 & 63;
            sb.val = `${sb.val}${_M0FP38Duckweed11moon_2dmqtt8protocol16char__from__code(cp)}`;
            i.val = i.val + 3 | 0;
          } else {
            if ((b0 & 248) === 240) {
              if ((i.val + 3 | 0) >= end) {
                return new _M0DTPC16result6ResultGssE3Err("utf8 truncated 4-byte");
              }
              const b1 = _M0MPC15array5Array2atGiE(data, i.val + 1 | 0);
              const b2 = _M0MPC15array5Array2atGiE(data, i.val + 2 | 0);
              const b3 = _M0MPC15array5Array2atGiE(data, i.val + 3 | 0);
              const cp = (b0 & 7) << 18 | (b1 & 63) << 12 | (b2 & 63) << 6 | b3 & 63;
              sb.val = `${sb.val}${_M0FP38Duckweed11moon_2dmqtt8protocol16char__from__code(cp)}`;
              i.val = i.val + 4 | 0;
            } else {
              return new _M0DTPC16result6ResultGssE3Err("utf8 invalid lead byte");
            }
          }
        }
      }
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGssE2Ok(sb.val);
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
    return new _M0DTPC16result6ResultGURPB5ArrayGiEiEsE3Err(e);
  }
  if ((p1 + len | 0) > self.data.length) {
    return new _M0DTPC16result6ResultGURPB5ArrayGiEiEsE3Err("binary length exceeds remaining");
  }
  const out = [];
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
  return new _M0DTPC16result6ResultGURPB5ArrayGiEiEsE2Ok({ _0: out, _1: p1 + len | 0 });
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
    return new _M0DTPC16result6ResultGUsiEsE3Err(e);
  }
  let s;
  _L$2: {
    let e;
    _L$3: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol12utf8__decode(raw, 0, raw.length);
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
    return new _M0DTPC16result6ResultGUsiEsE3Err(e);
  }
  return new _M0DTPC16result6ResultGUsiEsE2Ok({ _0: s, _1: p });
}
function _M0FP38Duckweed11moon_2dmqtt8protocol15decode__publish(data) {
  if (data.length < 2) {
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err("publish too short");
  }
  const first = _M0MPC15array5Array2atGiE(data, 0);
  if (first >> 4 !== 3) {
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err("not a publish");
  }
  const flags = first & 15;
  let q;
  _L: {
    const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol14qos__from__int(flags >> 1 & 3);
    if (_bind === undefined) {
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err("publish bad qos");
    } else {
      const _Some = _bind;
      const _q = _Some;
      q = _q;
      break _L;
    }
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
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err(e);
  }
  const end = p + rlen | 0;
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
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err(e);
  }
  const pos = new _M0TPB8MutLocalGiE(p2);
  const pid = new _M0TPB8MutLocalGiE(0);
  if (_M0IP016_24default__implPB2Eq10not__equalGRP38Duckweed11moon_2dmqtt8protocol3QoSE(q, 0)) {
    let id;
    let p3;
    _L$4: {
      let e;
      _L$5: {
        const _bind = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteReader9read__u16(r, pos.val);
        if (_bind.$tag === 0) {
          const _Err = _bind;
          const _e = _Err._0;
          e = _e;
          break _L$5;
        } else {
          const _Ok = _bind;
          const _x = _Ok._0;
          const _id = _x._0;
          const _p3 = _x._1;
          id = _id;
          p3 = _p3;
          break _L$4;
        }
      }
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE3Err(e);
    }
    pid.val = id;
    pos.val = p3;
  }
  const payload = [];
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
  return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol13PublishPacketsE2Ok(new _M0TP38Duckweed11moon_2dmqtt8protocol13PublishPacket(topic, payload, q, (flags & 1) !== 0, (flags & 8) !== 0, pid.val));
}
function _M0FP38Duckweed11moon_2dmqtt8protocol18encode__packet__id(type_byte, packet_id) {
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
  if (data.length < 4) {
    return new _M0DTPC16result6ResultGisE3Err("packet id packet too short");
  }
  if (_M0MPC15array5Array2atGiE(data, 0) !== type_byte) {
    return new _M0DTPC16result6ResultGisE3Err("packet id type mismatch");
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
    return new _M0DTPC16result6ResultGisE2Ok(id);
  }
  return new _M0DTPC16result6ResultGisE3Err(e);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__binary(self, data) {
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter9push__u16(self, data.length);
  const _bind = data.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = data[_];
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
  if (start >= data.length) {
    return new _M0DTPC16result6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err("empty fixed header");
  }
  const byte0 = _M0MPC15array5Array2atGiE(data, start);
  let t;
  _L: {
    const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol23packet__type__from__int(byte0 >> 4);
    if (_bind === undefined) {
      return new _M0DTPC16result6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err("reserved packet type");
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
    return new _M0DTPC16result6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE3Err(e);
  }
  return new _M0DTPC16result6ResultGURP38Duckweed11moon_2dmqtt8protocol10PacketTypeiiiEsE2Ok({ _0: t, _1: flags, _2: len, _3: pos });
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
  if (data.length < 4) {
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("connack too short");
  }
  if (_M0MPC15array5Array2atGiE(data, 0) !== 32) {
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("not a connack");
  }
  if (_M0MPC15array5Array2atGiE(data, 1) !== 2) {
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("connack remaining length != 2");
  }
  const ack_flags = _M0MPC15array5Array2atGiE(data, 2);
  const session_present = (ack_flags & 1) === 1;
  let rc;
  _L: {
    const _bind = _M0FP38Duckweed11moon_2dmqtt8protocol23return__code__from__int(_M0MPC15array5Array2atGiE(data, 3));
    if (_bind === undefined) {
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE3Err("unknown connack return code");
    } else {
      const _Some = _bind;
      const _rc = _Some;
      rc = _rc;
      break _L;
    }
  }
  return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol7ConnacksE2Ok(new _M0TP38Duckweed11moon_2dmqtt8protocol7Connack(session_present, rc));
}
function _M0FP38Duckweed11moon_2dmqtt8protocol14decode__packet(data) {
  if (data.length < 2) {
    return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err("packet too short");
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
        return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Connack(c));
      }
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e);
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
        return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Publish(p));
      }
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$2);
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
        return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Puback(id));
      }
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$3);
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
        return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Pubrec(id));
      }
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$4);
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
        return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Pubrel(id));
      }
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$5);
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
        return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket7Pubcomp(id));
      }
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$6);
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
        return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket6Suback(s));
      }
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$7);
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
        return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(new _M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8Unsuback(id));
      }
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(e$8);
    }
    case 13: {
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE2Ok(_M0DTP38Duckweed11moon_2dmqtt8protocol14IncomingPacket8PingResp__);
    }
    default: {
      return new _M0DTPC16result6ResultGRP38Duckweed11moon_2dmqtt8protocol14IncomingPacketsE3Err(`unsupported incoming packet type ${_M0MPC13int3Int18to__string_2einner(t, 10)}`);
    }
  }
}
function _M0MP38Duckweed11moon_2dmqtt8protocol13ConnectPacket3new(client_id) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol13ConnectPacket(client_id, 60, true, undefined, _M0DTPC16option6OptionGRPB5ArrayGiEE4None__, undefined, _M0DTPC16option6OptionGRPB5ArrayGiEE4None__, 0, false);
}
function _M0MP38Duckweed11moon_2dmqtt8protocol13ConnectPacket20with__clean__session(self, v) {
  return new _M0TP38Duckweed11moon_2dmqtt8protocol13ConnectPacket(self.client_id, self.keep_alive, v, self.username, self.password, self.will_topic, self.will_message, self.will_qos, self.will_retain);
}
function _M0FP38Duckweed11moon_2dmqtt8protocol15encode__connect(pkt) {
  const vh = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(vh, "MQTT");
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(vh, 4);
  const flags = new _M0TPB8MutLocalGiE(0);
  if (pkt.clean_session) {
    flags.val = flags.val | 2;
  }
  const _bind = pkt.username;
  if (_bind === undefined) {
  } else {
    flags.val = flags.val | 128;
  }
  const _bind$2 = pkt.password;
  if (_bind$2.$tag === 1) {
    flags.val = flags.val | 64;
  }
  const _bind$3 = pkt.will_topic;
  if (_bind$3 === undefined) {
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
  let t;
  _L: {
    _L$2: {
      const _bind$4 = pkt.will_topic;
      if (_bind$4 === undefined) {
      } else {
        const _Some = _bind$4;
        const _t = _Some;
        t = _t;
        break _L$2;
      }
      break _L;
    }
    _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(pl, t);
    let m;
    _L$3: {
      _L$4: {
        const _bind$4 = pkt.will_message;
        if (_bind$4.$tag === 1) {
          const _Some = _bind$4;
          const _m = _Some._0;
          m = _m;
          break _L$4;
        } else {
          _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__binary(pl, []);
        }
        break _L$3;
      }
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__binary(pl, m);
    }
  }
  let u;
  _L$2: {
    _L$3: {
      const _bind$4 = pkt.username;
      if (_bind$4 === undefined) {
      } else {
        const _Some = _bind$4;
        const _u = _Some;
        u = _u;
        break _L$3;
      }
      break _L$2;
    }
    _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__string(pl, u);
  }
  let p;
  _L$3: {
    _L$4: {
      const _bind$4 = pkt.password;
      if (_bind$4.$tag === 1) {
        const _Some = _bind$4;
        const _p = _Some._0;
        p = _p;
        break _L$4;
      }
      break _L$3;
    }
    _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter12push__binary(pl, p);
  }
  const body = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  const _bind$4 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(vh);
  const _bind$5 = _bind$4.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$5) {
      const b = _bind$4[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(body, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$6 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(pl);
  const _bind$7 = _bind$6.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$7) {
      const b = _bind$6[_];
      _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(body, b);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const out = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter3new();
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter10push__byte(out, 16);
  _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter23push__remaining__length(out, _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body).length);
  const _bind$8 = _M0MP38Duckweed11moon_2dmqtt8protocol10ByteWriter5bytes(body);
  const _bind$9 = _bind$8.length;
  let _tmp$3 = 0;
  while (true) {
    const _ = _tmp$3;
    if (_ < _bind$9) {
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
function _M0MP38Duckweed11moon_2dmqtt7session12SessionStore3new() {
  return new _M0TP38Duckweed11moon_2dmqtt7session12SessionStore([], 1);
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
      const _bind$4 = _bind$3.length;
      let _tmp$2 = 0;
      while (true) {
        const _$2 = _tmp$2;
        if (_$2 < _bind$4) {
          const e = _bind$3[_$2];
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
    const inflight = [];
    const _bind$3 = store.inflight;
    const _bind$4 = _bind$3.length;
    let _tmp = 0;
    while (true) {
      const _ = _tmp;
      if (_ < _bind$4) {
        const x = _bind$3[_];
        _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(inflight, x);
        _tmp = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(inflight, entry);
    return { _0: new _M0TP38Duckweed11moon_2dmqtt7session12SessionStore(inflight, next), _1: pid };
  }
}
function _M0FP38Duckweed11moon_2dmqtt7session14remove__by__id(store, packet_id) {
  const out = [];
  const _bind = store.inflight;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const e = _bind[_];
      if (e.packet_id !== packet_id) {
        _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(out, e);
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
  return _M0FP38Duckweed11moon_2dmqtt7session14remove__by__id(store, packet_id);
}
function _M0FP38Duckweed11moon_2dmqtt7session11on__pubcomp(store, packet_id) {
  return _M0FP38Duckweed11moon_2dmqtt7session14remove__by__id(store, packet_id);
}
function _M0FP38Duckweed11moon_2dmqtt7session10on__pubrec(store, packet_id) {
  const out = new _M0TPB8MutLocalGRPB5ArrayGiEE([]);
  const new_inflight = [];
  const _bind = store.inflight;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const e = _bind[_];
      if (e.packet_id === packet_id) {
        const _bind$3 = e.stage;
        switch (_bind$3) {
          case 1: {
            _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(new_inflight, new _M0TP38Duckweed11moon_2dmqtt7session13InFlightEntry(e.packet_id, e.publish, 2));
            out.val = _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrel(packet_id);
            break;
          }
          case 2: {
            _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(new_inflight, e);
            out.val = _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrel(packet_id);
            break;
          }
          default: {
            _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(new_inflight, e);
          }
        }
      } else {
        _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(new_inflight, e);
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
  const out = [];
  const _bind = store.inflight;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const e = _bind[_];
      _L: {
        _L$2: {
          const _bind$3 = e.stage;
          switch (_bind$3) {
            case 2: {
              _M0MPC15array5Array4pushGRPB5ArrayGiEE(out, _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrel(e.packet_id));
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
        _M0MPC15array5Array4pushGRPB5ArrayGiEE(out, _M0FP38Duckweed11moon_2dmqtt8protocol15encode__publish(_M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket9with__dup(e.publish, true)));
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return out;
}
function _M0MP38Duckweed11moon_2dmqtt4core6Framer3new() {
  return new _M0TP38Duckweed11moon_2dmqtt4core6Framer([]);
}
function _M0MP38Duckweed11moon_2dmqtt4core6Framer5reset(self) {
  _M0MPC15array5Array5clearGiE(self.buf);
}
function _M0MP38Duckweed11moon_2dmqtt4core6Framer4feed(self, bytes) {
  const _bind = bytes.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = bytes[_];
      _M0MPC15array5Array4pushGiE(self.buf, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const frames = [];
  const partial = new _M0TPB8MutLocalGbE(false);
  while (true) {
    if (!partial.val && self.buf.length > 0) {
      let rlen;
      let _t;
      let _flags;
      let header_end;
      _L: {
        _L$2: {
          const _bind$2 = _M0FP38Duckweed11moon_2dmqtt8protocol21decode__fixed__header(self.buf, 0);
          if (_bind$2.$tag === 0) {
            partial.val = true;
          } else {
            const _Ok = _bind$2;
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
          break _L;
        }
        const total = header_end + rlen | 0;
        if (self.buf.length < total) {
          partial.val = true;
        } else {
          const frame = [];
          const _bind$2 = 0;
          let _tmp$2 = _bind$2;
          while (true) {
            const i = _tmp$2;
            if (i < total) {
              _M0MPC15array5Array4pushGiE(frame, _M0MPC15array5Array2atGiE(self.buf, i));
              _tmp$2 = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          _M0MPC15array5Array4pushGRPB5ArrayGiEE(frames, frame);
          const remaining = [];
          const _bind$3 = self.buf.length;
          let _tmp$3 = total;
          while (true) {
            const i = _tmp$3;
            if (i < _bind$3) {
              _M0MPC15array5Array4pushGiE(remaining, _M0MPC15array5Array2atGiE(self.buf, i));
              _tmp$3 = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          _M0MPC15array5Array5clearGiE(self.buf);
          const _bind$4 = remaining.length;
          let _tmp$4 = 0;
          while (true) {
            const _ = _tmp$4;
            if (_ < _bind$4) {
              const b = remaining[_];
              _M0MPC15array5Array4pushGiE(self.buf, b);
              _tmp$4 = _ + 1 | 0;
              continue;
            } else {
              break;
            }
          }
        }
      }
      continue;
    } else {
      break;
    }
  }
  return frames;
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore3new(opts) {
  return new _M0TP38Duckweed11moon_2dmqtt4core10ClientCore(opts, 1, _M0MP38Duckweed11moon_2dmqtt4core6Framer3new(), 0, _M0MP38Duckweed11moon_2dmqtt7session12SessionStore3new());
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore5start(self) {
  return _M0FP38Duckweed11moon_2dmqtt8protocol15encode__connect(self.opts);
}
function _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(out, src) {
  const _bind = src.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = src[_];
      _M0MPC15array5Array4pushGiE(out, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore4feed(self, bytes) {
  const frames = _M0MP38Duckweed11moon_2dmqtt4core6Framer4feed(self.framer, bytes);
  const events = [];
  const outgoing = [];
  const _bind = frames.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const frame = frames[_];
      let pkt;
      _L: {
        _L$2: {
          const _bind$2 = _M0FP38Duckweed11moon_2dmqtt8protocol14decode__packet(frame);
          if (_bind$2.$tag === 0) {
            _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent17UnknownPacketType(0));
          } else {
            const _Ok = _bind$2;
            const _pkt = _Ok._0;
            pkt = _pkt;
            break _L$2;
          }
          break _L;
        }
        let pid;
        _L$3: {
          _L$4: {
            let pid$2;
            _L$5: {
              _L$6: {
                let pid$3;
                _L$7: {
                  _L$8: {
                    let pid$4;
                    _L$9: {
                      _L$10: {
                        let s;
                        _L$11: {
                          _L$12: {
                            let p;
                            _L$13: {
                              _L$14: {
                                let c;
                                _L$15: {
                                  _L$16: {
                                    switch (pkt.$tag) {
                                      case 0: {
                                        const _Connack = pkt;
                                        const _c = _Connack._0;
                                        c = _c;
                                        break _L$16;
                                      }
                                      case 1: {
                                        const _Publish = pkt;
                                        const _p = _Publish._0;
                                        p = _p;
                                        break _L$14;
                                      }
                                      case 6: {
                                        const _Suback = pkt;
                                        const _s = _Suback._0;
                                        s = _s;
                                        break _L$12;
                                      }
                                      case 8: {
                                        if (self.pending_pings > 0) {
                                          self.pending_pings = self.pending_pings - 1 | 0;
                                        }
                                        _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(events, _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent16PingRespReceived__);
                                        break;
                                      }
                                      case 2: {
                                        const _Puback = pkt;
                                        const _pid = _Puback._0;
                                        pid$4 = _pid;
                                        break _L$10;
                                      }
                                      case 3: {
                                        const _Pubrec = pkt;
                                        const _pid$2 = _Pubrec._0;
                                        pid$3 = _pid$2;
                                        break _L$8;
                                      }
                                      case 4: {
                                        const _Pubrel = pkt;
                                        const _pid$3 = _Pubrel._0;
                                        pid$2 = _pid$3;
                                        break _L$6;
                                      }
                                      case 5: {
                                        const _Pubcomp = pkt;
                                        const _pid$4 = _Pubcomp._0;
                                        pid = _pid$4;
                                        break _L$4;
                                      }
                                    }
                                    break _L$15;
                                  }
                                  self.state = 2;
                                  _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent15ConnackReceived(c));
                                }
                                break _L$13;
                              }
                              _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent15PublishReceived(p));
                              const _bind$2 = p.qos;
                              switch (_bind$2) {
                                case 1: {
                                  _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(outgoing, _M0FP38Duckweed11moon_2dmqtt8protocol14encode__puback(p.packet_id));
                                  break;
                                }
                                case 2: {
                                  _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(outgoing, _M0FP38Duckweed11moon_2dmqtt8protocol14encode__pubrec(p.packet_id));
                                  break;
                                }
                              }
                            }
                            break _L$11;
                          }
                          _M0MPC15array5Array4pushGRP38Duckweed11moon_2dmqtt4core9CoreEventE(events, new _M0DTP38Duckweed11moon_2dmqtt4core9CoreEvent14SubackReceived(s));
                        }
                        break _L$9;
                      }
                      self.session = _M0FP38Duckweed11moon_2dmqtt7session10on__puback(self.session, pid$4);
                    }
                    break _L$7;
                  }
                  let s;
                  let pubrel;
                  _L$9: {
                    const _bind$2 = _M0FP38Duckweed11moon_2dmqtt7session10on__pubrec(self.session, pid$3);
                    const _s = _bind$2._0;
                    const _pubrel = _bind$2._1;
                    s = _s;
                    pubrel = _pubrel;
                    break _L$9;
                  }
                  self.session = s;
                  _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(outgoing, pubrel);
                }
                break _L$5;
              }
              _M0FP38Duckweed11moon_2dmqtt4core13append__bytes(outgoing, _M0FP38Duckweed11moon_2dmqtt8protocol15encode__pubcomp(pid$2));
            }
            break _L$3;
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
  const pkt = _M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket3new(topic, payload, qos, false, false, 0);
  if (qos === 0) {
    return _M0FP38Duckweed11moon_2dmqtt8protocol15encode__publish(pkt);
  } else {
    let store;
    let pid;
    _L: {
      const _bind = _M0FP38Duckweed11moon_2dmqtt7session16record__outbound(self.session, pkt);
      const _store = _bind._0;
      const _pid = _bind._1;
      store = _store;
      pid = _pid;
      break _L;
    }
    self.session = store;
    const with_pid = _M0MP38Duckweed11moon_2dmqtt8protocol13PublishPacket16with__packet__id(pkt, pid);
    return _M0FP38Duckweed11moon_2dmqtt8protocol15encode__publish(with_pid);
  }
}
function _M0MP38Duckweed11moon_2dmqtt4core10ClientCore13replay__bytes(self) {
  return _M0FP38Duckweed11moon_2dmqtt7session6replay(self.session);
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
  const out = $make_array_len_and_init(arr.length, 0);
  const _bind = 0;
  const _bind$2 = arr.length;
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
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser7g__opts, 0, opts);
  const core = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore3new(opts);
  const connect_bytes = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore5start(core);
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser10g__handler, 0, undefined);
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser10g__connect, 0, undefined);
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser9g__suback, 0, undefined);
  _M0MPC15array5Array3setGiE(_M0FP38Duckweed11moon_2dmqtt7browser12g__next__pid, 0, 1);
  _M0FP38Duckweed11moon_2dmqtt7browser8open__ws(url, connect_bytes);
  _M0MP38Duckweed11moon_2dmqtt7browser6Client3new();
}
function _M0FP38Duckweed11moon_2dmqtt7browser19connect__persistent(host, port, client_id) {
  _M0FP38Duckweed11moon_2dmqtt7browser13connect__opts(host, port, _M0MP38Duckweed11moon_2dmqtt8protocol13ConnectPacket20with__clean__session(_M0MP38Duckweed11moon_2dmqtt8protocol13ConnectPacket3new(client_id), false));
}
function _M0FP38Duckweed11moon_2dmqtt7browser11on__message(_client, handler) {
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser10g__handler, 0, handler);
}
function _M0FP38Duckweed11moon_2dmqtt7browser11on__connect(_client, handler) {
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser10g__connect, 0, handler);
}
function _M0FP38Duckweed11moon_2dmqtt7browser10on__suback(_client, handler) {
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser9g__suback, 0, handler);
}
function _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(bytes) {
  _M0FP38Duckweed11moon_2dmqtt7browser18browser__send__ffi(_M0FP38Duckweed11moon_2dmqtt7browser16to__fixed__array(bytes));
}
function _M0FP38Duckweed11moon_2dmqtt7browser9subscribe(_client, topic, qos) {
  const pid = _M0MPC15array5Array2atGiE(_M0FP38Duckweed11moon_2dmqtt7browser12g__next__pid, 0);
  _M0MPC15array5Array3setGiE(_M0FP38Duckweed11moon_2dmqtt7browser12g__next__pid, 0, pid + 1 | 0);
  const sub = _M0MP38Duckweed11moon_2dmqtt8protocol12Subscription3new(topic, qos);
  const pkt = _M0MP38Duckweed11moon_2dmqtt8protocol15SubscribePacket3new(pid, [sub]);
  _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(_M0FP38Duckweed11moon_2dmqtt8protocol17encode__subscribe(pkt));
}
function _M0FP38Duckweed11moon_2dmqtt7browser7publish(_client, topic, payload, qos) {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt4core10ClientCoreE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
    if (_bind === undefined) {
      return;
    } else {
      const _Some = _bind;
      const _core = _Some;
      core = _core;
      break _L;
    }
  }
  const bytes = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore7publish(core, topic, payload, qos);
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
  _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(bytes);
}
function _M0FP38Duckweed11moon_2dmqtt7browser20browser__on__message(bytes) {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt4core10ClientCoreE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
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
  const _bind = events.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = events[_];
      let p;
      _L$3: {
        _L$4: {
          let c;
          _L$5: {
            _L$6: {
              switch (e.$tag) {
                case 0: {
                  const _ConnackReceived = e;
                  const _c = _ConnackReceived._0;
                  c = _c;
                  break _L$6;
                }
                case 1: {
                  const _PublishReceived = e;
                  const _p = _PublishReceived._0;
                  p = _p;
                  break _L$4;
                }
                case 2: {
                  _M0FPB7printlnGsE("[browser] suback");
                  let h;
                  _L$7: {
                    _L$8: {
                      const _bind$2 = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt4core10ClientCoreE(_M0FP38Duckweed11moon_2dmqtt7browser9g__suback, 0);
                      if (_bind$2 === undefined) {
                      } else {
                        const _Some = _bind$2;
                        const _h = _Some;
                        h = _h;
                        break _L$8;
                      }
                      break _L$7;
                    }
                    h();
                  }
                  break;
                }
              }
              break _L$5;
            }
            if (c.session_present) {
              const frames = _M0MP38Duckweed11moon_2dmqtt4core10ClientCore13replay__bytes(core);
              const _bind$2 = frames.length;
              let _tmp$2 = 0;
              while (true) {
                const _$2 = _tmp$2;
                if (_$2 < _bind$2) {
                  const f = frames[_$2];
                  _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(f);
                  _tmp$2 = _$2 + 1 | 0;
                  continue;
                } else {
                  break;
                }
              }
              _M0FPB7printlnGsE(`[browser] session_present=1, replay ${_M0MPC13int3Int18to__string_2einner(frames.length, 10)} frame(s)`);
            } else {
              _M0FPB7printlnGsE("[browser] session_present=0");
            }
            let h;
            _L$7: {
              _L$8: {
                const _bind$2 = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt4core10ClientCoreE(_M0FP38Duckweed11moon_2dmqtt7browser10g__connect, 0);
                if (_bind$2 === undefined) {
                } else {
                  const _Some = _bind$2;
                  const _h = _Some;
                  h = _h;
                  break _L$8;
                }
                break _L$7;
              }
              h();
            }
          }
          break _L$3;
        }
        let h;
        _L$5: {
          _L$6: {
            const _bind$2 = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt4core10ClientCoreE(_M0FP38Duckweed11moon_2dmqtt7browser10g__handler, 0);
            if (_bind$2 === undefined) {
            } else {
              const _Some = _bind$2;
              const _h = _Some;
              h = _h;
              break _L$6;
            }
            break _L$5;
          }
          h(p.topic, p.payload);
        }
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (outgoing.length > 0) {
    _M0FP38Duckweed11moon_2dmqtt7browser13browser__send(outgoing);
  }
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
}
function _M0FP38Duckweed11moon_2dmqtt7browser18browser__on__close() {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt4core10ClientCoreE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
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
  _M0MPC15array5Array3setGOWsRPB5ArrayGiEEuE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0, core);
}
function _M0FP38Duckweed11moon_2dmqtt7browser25browser__reconnect__bytes() {
  let core;
  _L: {
    const _bind = _M0MPC15array5Array2atGORP38Duckweed11moon_2dmqtt4core10ClientCoreE(_M0FP38Duckweed11moon_2dmqtt7browser7g__core, 0);
    if (_bind === undefined) {
      return [];
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
  _M0FP38Duckweed11moon_2dmqtt7browser20browser__on__message([]);
  _M0FP38Duckweed11moon_2dmqtt7browser18browser__on__close();
  _M0FP38Duckweed11moon_2dmqtt7browser25browser__reconnect__bytes();
}
(() => {
  _M0FP38Duckweed11moon_2dmqtt7browser23__browser__dce__protect();
  const client_id = _M0FP48Duckweed11moon_2dmqtt8examples14browser_2ddemo16demo__client__id();
  _M0FPB7printlnGsE(`[demo] client_id=${client_id}`);
  _M0FPB7printlnGsE("[demo] connecting to broker.emqx.io:8084 (clean_session=false) ...");
  const client = _M0FP38Duckweed11moon_2dmqtt7browser19connect__persistent("broker.emqx.io", 8084, client_id);
  _M0FP38Duckweed11moon_2dmqtt7browser11on__message(client, (topic, payload) => {
    _M0FPB7printlnGsE(`[demo] recv topic=${topic} payload=${_M0MPC13int3Int18to__string_2einner(payload.length, 10)} bytes`);
  });
  _M0FP38Duckweed11moon_2dmqtt7browser11on__connect(client, () => {
    _M0FPB7printlnGsE("[demo] connected, subscribing sensors/# QoS1");
    _M0FP38Duckweed11moon_2dmqtt7browser9subscribe(client, "sensors/#", _M0FP38Duckweed11moon_2dmqtt8protocol4qos1());
  });
  _M0FP38Duckweed11moon_2dmqtt7browser10on__suback(client, () => {
    _M0FPB7printlnGsE("[demo] suback, publishing QoS1 sensors/hello");
    _M0FP38Duckweed11moon_2dmqtt7browser7publish(client, "sensors/hello", [104, 105], _M0FP38Duckweed11moon_2dmqtt8protocol4qos1());
  });
  _M0FPB7printlnGsE("[demo] running... (close browser tab to disconnect)");
})();
//# sourceMappingURL=browser-demo.js.map

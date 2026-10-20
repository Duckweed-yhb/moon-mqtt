/// examples/ws-spike — Day 0 spike：MQTT over WebSocket (wss) 握手验证
///
/// 目标：跑通 MoonBit js 后端 + extern "js" 调 WebSocket，连 EMQX 公共 broker，
/// 发 MQTT 3.1.1 CONNECT，收到 CONNACK 并打印 hex。
///
/// A 方案：MoonBit 用 extern "js" 持有 WebSocket，回调里直接打 hex。
/// 本 spike 先按 A 方案写；若 FFI 闭包/全局对象支持有限，再降级为 B
/// （JS 持有 WebSocket，MoonBit 导出纯函数 feed(bytes)/build_connect()）。

// 构造 MQTT 3.1.1 CONNECT 帧（clientId = "ws-spike"，clean session，keepalive=60）。
// 固定头 0x10，剩余长度 0x14（20），可变头 00 04 4D 51 54 54 04 02 00 3C，
// payload 00 08 + ASCII "ws-spike"（8 字节：77 73 2D 73 70 69 6B 65）。
// 完整帧：10 14 00 04 4D 51 54 54 04 02 00 3C 00 08 77 73 2D 73 70 69 6B 65
// （注：原始任务描述给的是 00 09 / 0x15，但 "ws-spike" 只有 8 字节，
//   0x09 与实际字节数不符会导致 broker 直接断连；已修正为 0x08 / 0x14。）
fn build_connect() -> Array[Int] {
  [
    0x10, 0x14,
    0x00, 0x04, 0x4D, 0x51, 0x54, 0x54, 0x04, 0x02, 0x00, 0x3C,
    0x00, 0x08,
    0x77, 0x73, 0x2D, 0x73, 0x70, 0x69, 0x6B, 0x65,
  ]
}

// extern "js"：在 JS 侧持有 WebSocket，发送 CONNECT，收 CONNACK 打 hex。
// connect_bytes 是 MoonBit Array[Int]，在 js 后端表现为 JS number 数组。
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
  #|    for (let j = 0; j < u8.length; j++) {
  #|      let h = u8[j].toString(16).toUpperCase();
  #|      if (h.length < 2) { h = "0" + h; }
  #|      parts.push(h);
  #|    }
  #|    console.log("[spike] onmessage hex: " + parts.join(" "));
  #|  };
  #|  ws.onerror = function() {
  #|    console.log("[spike] onerror");
  #|  };
  #|  ws.onclose = function(ev) {
  #|    console.log("[spike] onclose code=" + ev.code + " reason=" + ev.reason);
  #|  };
  #|}

fn main() -> Unit {
  let bytes = build_connect()
  println("[spike] built CONNECT, " + bytes.length().to_string() + " bytes")
  run_ws_spike(bytes)
}

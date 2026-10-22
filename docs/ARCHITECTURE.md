# 架构

moon-mqtt 分五层，自下而上三个纯计算包 + 两个 native 包：

```
┌──────────────────────────────────────────────────────────┐
│  client/    MqttClient（阻塞式高层 API）      native only │
│  connect / publish / subscribe / poll_loop / reconnect   │
├──────────────────────────────────────────────────────────┤
│  core/      ClientCore 连接状态机              四后端可测 │
│  start() / feed() 纯函数，自动 QoS1/2 握手应答            │
├──────────────────────────────────────────────────────────┤
│  session/   SessionStore（QoS 状态机）         四后端可测 │
│  inflight 表 / packet_id 分配 / replay / snapshot         │
├──────────────────────────────────────────────────────────┤
│  protocol/  报文编解码                          四后端可测 │
│  CONNECT/PUBLISH/SUBSCRIBE/PINGREQ/...                    │
├──────────────────────────────────────────────────────────┤
│  transport/ TcpClient（C FFI socket）         native only │
│  connect / read_some / write / wait_read                  │
└──────────────────────────────────────────────────────────┘
```

两条运行路径共用 `protocol/` 与 `session/`：

- **native 路径**：`client/` 直接组合 `protocol/` + `session/` + `transport/`，走 C FFI TCP，不经过 `core/`。
- **浏览器 / Node 路径**：`client/` 不参与，JS 胶水层持有 WebSocket，调 `core/` 的 `start()/feed()` 纯函数。

## 分层职责

### `protocol/`（纯计算，四后端）

只做报文字节数组 ↔ 结构体的转换。不持有状态，不做 I/O。

- `connect.mbt`：CONNECT 编码 / CONNACK 解码
- `publish.mbt`：PUBLISH 编解码
- `subscribe.mbt`：SUBSCRIBE/SUBACK/UNSUBSCRIBE/UNSUBACK 编解码
- `ping.mbt`：PINGREQ/PINGRESP/DISCONNECT 编解码
- `fixed_header.mbt`：固定头 + 剩余长度变长编码
- `topic.mbt`：topic filter 匹配（`+` / `#`）
- `decode.mbt`：统一入站分发 `decode_packet`
- `bytes_util.mbt`：字节读写辅助

### `session/`（纯计算，四后端）

持有会话状态，但不做 I/O。所有函数都是 `(store, input) -> (new_store, output)` 形式，方便单测。

- `SessionStore`：在途 QoS1/2 PUBLISH 表
  - `record_outbound(pkt)`：分配 packet_id，记录到 inflight
  - `on_puback/pubrec/pubcomp`：推进状态机
  - `replay()`：断线重连时产出待重发字节序列
  - `snapshot()/restore()`：字节级落盘快照
- packet_id 分配器：1..65535 循环，跳过 inflight 已占用 id

### `core/`（纯计算，四后端）

连接状态机，是 B 方案的核心：胶水层（JS WebSocket 或 C FFI）持有 socket，`core/` 只导出纯函数。

- `ClientCore::new(opts)` / `with_session(opts, store)`：初始状态 = Connecting
- `start() -> Array[Int]`：socket 打开后调用，返回 CONNECT 帧字节
- `feed(bytes) -> (Array[CoreEvent], Array[Int])`：喂入 broker 字节，返回事件列表 + 需要回发的出站字节
  - 收到 CONNACK → 状态切 Connected，抛 `ConnackReceived`
  - 收到 PUBLISH → 抛 `PublishReceived`；QoS1 自动追加 PUBACK，QoS2 自动追加 PUBREC
  - 收到 PUBREL → 自动追加 PUBCOMP
  - 收到 PUBACK/PUBREC/PUBCOMP → 推进内部 `SessionStore`（出站在途 QoS 握手）
- `on_transport_close()` / `reconnect_bytes()`：断线时状态切 Disconnected、SessionStore 保留；重连时重置状态、清 framer 残留缓冲、重新编码 CONNECT
- `Framer`：把 socket 推过来的字节流拆成完整 MQTT 帧，处理半包 / 粘包

`core/` 不 import 任何 WebSocket / socket 依赖，同一份代码在 native（C FFI TCP）和 js/wasm（WebSocket）下零改动编译。

### `transport/`（native only）

C FFI 原生 socket。Windows 用 winsock2，Linux/macOS 用 POSIX socket。

- `connect(host, port)`：阻塞连接
- `read_some(max)` / `write(bytes)`：读写原始字节
- `wait_read(timeout_ms)`：select 等待可读，用于 poll_once 超时
- `close()`：关闭 socket

字节经 MoonBit `String` 的 UTF-16 单元承载（每个单元存一个 0-255 字节值），避免 C 侧构造/返回数组。

### `client/`（native only）

把 `protocol/` + `session/` + `transport/` 组装成 `MqttClient`。阻塞式单线程。注意：native 路径不经过 `core/`，读帧与握手由 `client/` 自身完成。

- `connect_opts(host, port, ConnectPacket)`：握手 CONNECT/CONNACK
- `publish(topic, payload, qos)`：QoS0 直发 / QoS1 等 PUBACK / QoS2 三段握手
- `subscribe_with_handler(filter, qos, handler)`：注册回调
- `poll_once(timeout_ms)`：读一帧并派发
- `poll_loop(rounds, timeout_ms)`：连调 poll_once，自动心跳
- `reconnect()`：重连 + 带旧 store + 自动 replay
- `disconnect()`：发 DISCONNECT 并关 socket

## 数据流

### native 入站 PUBLISH 派发

```
broker ──bytes──► transport.read_some
                      │
                      ▼
              client.read_frame（拼帧：固定头 + 剩余长度变长）
                      │
                      ▼
              protocol.decode_packet
                      │
            ┌─────────┼─────────┐
            ▼         ▼         ▼
         PUBLISH   PUBACK/...  PINGRESP/SUBACK/...
            │         │         │
            ▼         ▼         ▼
       回 PUBACK/  推进 store   静默消化
       PUBREC+
            │
            ▼
       按 topic filter 匹配 subs 表，调 handler(topic, payload)
```

### 浏览器 / Node 入站（core.feed 循环）

```
broker ──WebSocket──► JS onmessage
                          │
                          ▼
                  core.feed(bytes)
                   │            │
                   ▼            ▼
              events[]     outgoing[]
              (给应用)    (胶水层写回 socket)
```

## 测试矩阵

| 包 | wasm | wasm-gc | js | native |
|---|---|---|---|---|
| `protocol/` | ✅ | ✅ | ✅ | ✅ |
| `session/` | ✅ | ✅ | ✅ | ✅ |
| `core/` | ✅ | ✅ | ✅ | ✅ |
| `transport/` | - | - | - | ✅ |
| `client/` | - | - | - | ✅（无独立单测，由示例 + 纯层测试保障） |
| `examples/pubsub` | - | ✅ | - | ✅ |
| `examples/resume` | - | ✅ | - | ✅ |

纯计算层（protocol/session/core）四后端可测，证明"可移植的库"是构建期可验证的事实；native 层（transport/client）依赖 C FFI，只在 native 后端编译。

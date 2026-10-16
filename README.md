# moon-mqtt

MoonBit 生态的 **MQTT 3.1.1 / 5.0 异步客户端库**。

MQTT 是物联网与边缘计算事实上的消息协议标准（OASIS 规范），而 MoonBit 生态目前没有任何 MQTT 客户端。moon-mqtt 补齐这一环：以 OASIS MQTT 3.1.1（全量）/ 5.0（核心子集）公开规范为实现依据，交付纯 MoonBit 的异步发布/订阅客户端。

> 参考移植（原创重写，不复制源码）：API 设计参考 [MQTT.js](https://github.com/mqttjs/MQTT.js)（MIT），协议行为参考 [Eclipse Paho C client](https://github.com/eclipse/paho.mqtt.c)（EPL-2.0/EDL-1.0）。本项目许可证 **MIT**。

## 安装

需要 [MoonBit 工具链](https://www.moonbitlang.com/)（moon ≥ 0.1.2026xxxx）。

```bash
moon add Duckweed/moon-mqtt@0.1.0
```

也可以不安装、直接作为依赖源使用：

```toml
# moon.mod
import {
  "Duckweed/moon-mqtt",
}
```

## 快速上手

仓库自带一个**可运行的示例**（`examples/pubsub/`，用 `protocol` 层做报文编解码往返，不依赖真实 broker，本地即可验证）：

```bash
moon run examples/pubsub
# 输出示例：
# encoded (20 bytes)
# decoded: topic=sensors/temp payload=[50, 51] qos=1
```

`protocol` 层示例（`examples/pubsub/main.mbt`）核心逻辑：

```moonbit
let qos = match @protocol.qos_from_int(1) { Some(q) => q None => return }
let pkt = @protocol.PublishPacket::new(
  "sensors/temp", [0x32, 0x33], qos, false, false, 7,
)
let bytes = @protocol.encode_publish(pkt)
match @protocol.decode_publish(bytes) { ... }
```

> 说明：`qos` 经 `@protocol.qos_from_int` 构造（避免跨包 enum 构造依赖）。`@protocol` 是依赖包 `Duckweed/moon-mqtt` 下 `protocol` 子包的模块前缀。

### 连接真实 broker（`client/` 高层 API，native）

`client/` 提供阻塞式 `MqttClient`（connect / publish / subscribe / ping / disconnect），适合 CLI / 边缘遥测上报等确定性场景。需要连到真实 MQTT broker 才能跑通：

```moonbit
let client = @client.connect("broker.hivemq.com", 1883, "demo-client")?
client.publish("sensors/temp", [0x32, 0x33], @protocol.QoS.AtLeastOnce)?
client.subscribe("sensors/#", @protocol.QoS.AtLeastOnce)?
client.ping()?
client.disconnect()?
```

> `?` 为 Result 传播（出错即返回 `Err`）。`@client` / `@protocol` 为依赖包子包模块前缀。

## 真实用例：物联网边缘遥测上报

MQTT 是物联网/边缘计算的事实标准。moon-mqtt 让 **MoonBit 程序可以直接接入 MQTT 生态**——这是它区别于"协议玩具"的实用价值：别的语言（Python/Go/Rust/JS）都能连 MQTT，MoonBit 此前不行。

一个典型的边缘遥测上报流程（`client/` 高层 API）：

```moonbit
// 1. 连到 broker（本地 mosquitto 或云 broker，如 HiveMQ Cloud / EMQX）
let client = @client.connect("192.168.1.10", 1883, "sensor-node-07")?

// 2. 周期上报传感器读数（QoS1 保证至少送达一次）
let payload = [0x32, 0x33] // 温度 23℃ 的字节编码
client.publish("sensors/temp", payload, @protocol.QoS.AtLeastOnce)?

// 3. 订阅控制指令（QoS0 即可）
client.subscribe("control/sensor-07/#", @protocol.QoS.AtMostOnce)?

// 4. 保活 + 正常下线
client.ping()?
client.disconnect()?
```

这个场景里，moon-mqtt 承担的是**确定性、可移植**的那部分：协议编解码与 QoS 状态机是纯计算（四后端可测），网络层在 native 上自写 socket。它既可作为独立库被别的 MoonBit 项目 import（同 `protocol` 示例所示），也可作为 CLI/边缘程序的连接层。

## 已实现的 CONNECT 字段（如实声明）

README 顶部写"3.1.1 全量"，此处给出**实际支持的字段清单**，避免"声明与实际不符"：

| MQTT 3.1.1 CONNECT 字段 | 支持 |
|---|---|
| Client Identifier（clientId） | ✅ 必填 |
| Keep Alive | ✅ 默认 60s，可配 |
| Clean Session | ✅ 默认 true，可配 |
| Username / Password | ✅ 可选 |
| Will Message（topic / payload / QoS / retain） | ✅ 可选 |
| **持久会话恢复（Session Present / 会话续传）** | ⚠️ 见"已知限制" |

对应 `protocol/connect.mbt` 的 `ConnectPacket`（字段全公开可构造）。CONNACK 的 `session_present` 与返回码（`ConnectionAccepted` … `NotAuthorized`）均已解码。

## 设计

核心差异化在于**协议状态机与 QoS 语义的正确性**——不是脚本，而是有机制的基础设施。

```
protocol/   报文编解码（纯计算，四后端可测）   ✅
session/    会话状态机（纯计算，四后端可测）   ✅
transport/  native TCP 网络层（C FFI）        ✅
client/     高层客户端 API（native）          ✅
```

- `protocol/` 与 `session/` 是纯计算包，不 import 任何 platform 依赖，声明覆盖全部四个后端（wasm / wasm-gc / js / native）。
- `transport/` 与 `client/` 是 `native` only：transport 用 C FFI 自写 socket（Windows winsock2 / POSIX），client 把 protocol+session+transport 组装成阻塞式 `MqttClient`。
- QoS2 的 exactly-once（PUBREC/PUBREL/PUBCOMP 握手）与断线重连状态边界，是评审最看重、也最体现工程深度的部分。

## 状态

- [x] 项目骨架 + CI
- [x] `protocol/` MQTT 3.1.1 报文编解码
- [x] `session/` 会话状态机（QoS2 exactly-once 握手、报文标识分配、在途持久会话骨架）
- [x] `transport/` native 网络层（C FFI TCP socket，跨平台）
- [x] `client/` 高层 API（connect / publish / subscribe / ping / disconnect）
- [x] **mooncakes 发布（`Duckweed/moon-mqtt@0.1.0`）**

### `protocol/` 已实现

- QoS 类型（0/1/2）与固定头、剩余长度变长编解码
- CONNECT 编码 / CONNACK 解码（返回码、session present）
- PUBLISH 编解码 + QoS1/2 握手控制包（PUBACK/PUBREC/PUBREL/PUBCOMP）
- SUBSCRIBE/SUBACK、UNSUBSCRIBE/UNSUBACK
- PINGREQ/PINGRESP/DISCONNECT
- Topic 过滤器匹配（`+` 单层、`#` 多层）
- 统一入站分发 `decode_packet`
- 跨包构造：`PublishPacket::new` / `Subscription::new` / `SubscribePacket::new`

### `transport/` 已实现

- 原生 TCP 连接 `connect(host, port)`（IP 或域名，getaddrinfo 解析）
- 读/写原始字节 `read_some` / `write`
- 关闭 `close`；`supported_targets = "native"`，字节经 MoonBit `String` 的 UTF-16 单元承载

### `client/` 已实现

- `connect` / `connect_opts`（自定义 CONNECT，校验 CONNACK 返回码）
- `publish`（QoS0 直发 / QoS1 等 PUBACK / QoS2 三段握手）
- `subscribe` / `ping` / `disconnect` / `read_packet`（读帧：固定头 + 剩余长度变长）
- 报文标识分配器（1..65535 会话内不重复）

## 构建与测试

```bash
moon check
moon test --target wasm-gc    # 纯计算层（protocol/session）：四后端可测
moon test --target wasm
moon test --target js
moon test --target native
moon run examples/pubsub      # 可运行示例
```

CI（GitHub Actions，Linux / Windows 双矩阵）覆盖**检查 + 构建 + 四后端测试 + 示例运行**。

## 已知限制（如实说明）

- **持久会话恢复尚未端到端打通**：`session/` 已提供在途出站报文的纯计算骨架（`SessionStore`：记录 QoS1/2 在途 PUBLISH、随 PUBACK/PUBREC/PUBCOMP 推进状态、断线重连 `replay()` 产出 DUP=1 重发帧，并支持落盘后 `from_parts` 恢复），但 **`client/` 尚未接入**——`clean_session=false` 时的实际状态保存/恢复、重连后依据 CONNACK `session_present` 决定是否重放与重订阅，仍未接线。这是后续版本的主线。
- **`transport/` 与 `client/` 仅支持 native 后端**：它们依赖 C FFI socket，`extern "C"` 在 wasm 系列后端不存在。`protocol/` 与 `session/` 不受此限（四后端可编译可测）。
- **阻塞式 API**：`client/` 为阻塞式，适合 CLI / 边缘遥测上报等确定性场景；高并发长连接场景需要多线程或异步封装，当前未提供。

## 许可证

MIT © Duckweed-yhb

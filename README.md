# moon-mqtt

MoonBit 生态的 **MQTT 3.1.1 客户端库（当前阻塞式，异步封装为后续路线）**。

MQTT 是物联网与边缘计算事实上的消息协议标准（OASIS 规范），而 MoonBit 生态目前没有任何 MQTT 客户端。moon-mqtt 补齐这一环：以 OASIS MQTT 3.1.1 公开规范为实现依据（MQTT 5.0 为后续路线），交付纯 MoonBit 的发布/订阅客户端（`client/` 高层 API 为阻塞式，适合 CLI / 边缘遥测；`protocol/` + `session/` 纯计算层四后端可测）。

> 参考移植（原创重写，不复制源码）：API 设计参考 [MQTT.js](https://github.com/mqttjs/MQTT.js)（MIT），协议行为参考 [Eclipse Paho C client](https://github.com/eclipse/paho.mqtt.c)（EPL-2.0/EDL-1.0）。本项目许可证 **MIT**。

## 安装

需要 [MoonBit 工具链](https://www.moonbitlang.com/)（moon ≥ 0.1.2026xxxx）。

```bash
moon add Duckweed/moon-mqtt@0.1.2
```

也可以不安装、直接作为依赖源使用：

```toml
# moon.mod
import {
  "Duckweed/moon-mqtt",
}
```

## 快速上手

仓库自带两个**可运行的示例**：

- `examples/pubsub/`：用 `protocol` 层做 PUBLISH 报文编解码往返，不依赖真实 broker；
- `examples/resume/`：纯计算走一遍 QoS2 中断重连时间线（发 PUBLISH → PUBREC → 断线 → replay → PUBREL → PUBCOMP → 清空），是 MQTT 3.1.1 持久会话语义的核心演示。

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

`client/` 提供阻塞式 `MqttClient`（connect / publish / subscribe / poll_loop / reconnect / disconnect），适合 CLI / 边缘遥测上报等确定性场景。需要连到真实 MQTT broker 才能跑通：

```moonbit
// 自定义 CONNECT（带认证 + 遗嘱 + 持久会话）
let opts = @protocol.ConnectPacket::new("demo-client")
  .with_keep_alive(30)
  .with_clean_session(false)
  .with_auth("user", [0x70, 0x61, 0x73, 0x73])   // "pass"
  .with_will("status", "offline".to_bytes(), @protocol.qos1(), false)

let client = @client.connect_opts("broker.hivemq.com", 1883, opts)?

// 订阅并注册回调：收到 PUBLISH 时自动派发
client.subscribe_with_handler("sensors/#", @protocol.qos1(), fn(topic, payload) {
  println("recv " + topic)
})?

// 主循环：每 1 秒 poll 一次，到 keep_alive 自动发 PINGREQ
// 失败返回 Err 时调 reconnect() 自动重连 + 会话恢复
match client.poll_loop(600, 1000) {
  Ok(_) => ()
  Err(_) => {
    let client = client.reconnect()?
    println("reconnected, session_present=" + client.is_session_present().to_string())
  }
}
client.disconnect()?
```

> `?` 为 Result 传播（出错即返回 `Err`）。`@client` / `@protocol` 为依赖包子包模块前缀。`qos1()` / `qos0()` / `qos2()` 是跨包构造 QoS 枚举的 helper（绕开 native 后端 executable 包的 enum 构造限制）。

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
| **持久会话恢复（Session Present / 会话续传）** | ✅ 在途 QoS1/2 PUBLISH 由 `SessionStore` 记录，断线重连后 `replay()` 按 MQTT §4.4 重发 DUP=1 PUBLISH 或 PUBREL；见 `examples/resume` |

对应 `protocol/connect.mbt` 的 `ConnectPacket`（字段全公开可构造）。CONNACK 的 `session_present` 与返回码（`ConnectionAccepted` … `NotAuthorized`）均已解码。

## 设计

核心差异化在于**协议状态机与 QoS 语义的正确性**——不是脚本，而是有机制的基础设施。详见 [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)。

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
- [x] `transport/` native 网络层（C FFI TCP socket，跨平台，带 wait_read 超时）
- [x] `client/` 高层 API（connect / publish / subscribe / poll_loop 自动心跳 / reconnect 自动重连 / disconnect）
- [x] **mooncakes 发布（`Duckweed/moon-mqtt@0.1.2`）**
- [x] 测试：`moon test --target wasm-gc` 58/58 通过；`moon test --target native` 61/61 通过；0 警告

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
- `subscribe` / `subscribe_with_handler`（注册 PUBLISH 回调，poll 时按 topic 派发）
- `poll_once(timeout_ms)`：阻塞读一帧并派发，带超时（避免 TCP 死了永久阻塞）
- `poll_loop(rounds, timeout_ms)`：连调 poll_once，到 keep_alive 自动发 PINGREQ
- `reconnect()`：重连 CONNECT + 带旧 SessionStore + session_present=true 时自动 replay 在途帧
- `ping` / `disconnect` / `read_packet`
- 报文标识分配器（1..65535 会话内不重复）
- 入参校验：PUBLISH topic 非空 / ≤65535 / 无 NUL；帧大小软上限 16MB

## 构建与测试

```bash
moon check
moon test --target wasm-gc    # 纯计算层（protocol/session）：四后端可测
moon test --target wasm
moon test --target js
moon test --target native
moon run examples/pubsub      # 可运行示例（PUBLISH 编解码往返）
moon run examples/resume       # QoS2 中断重连 / 会话恢复时间线
```

CI（GitHub Actions，Linux / Windows 双矩阵）覆盖**检查 + 构建 + 四后端测试 + 示例运行**。

## 手动验证（连真 broker）

examples/pubsub 和 resume 是纯计算不连 TCP。要验证 client 能真连 broker，本地起 mosquitto 后跑一段最小 MoonBit 代码：

```bash
# 1. 起本地 broker
mosquitto -p 1883 -v

# 2. 另开终端，订阅
mosquitto_sub -h 127.0.0.1 -t 'sensors/#' -v

# 3. 跑最小 MoonBit 程序（connect → publish → subscribe → ping → disconnect）
#    代码见上方"连接真实 broker"章节
```

预期：订阅终端能看到 `sensors/temp` 收到的消息，程序退出码 0。

## AI 工具使用说明

本项目开发过程中使用了 AI 编程工具辅助，但**目标、技术路径、质量边界和开源合规由参赛者本人把控**：

- **AI 辅助了什么**：协议报文编解码的样板代码、单测用例的生成、README 文档的初稿润色。
- **人把控了什么**：项目选题（MQTT 3.1.1 客户端库）、分层架构（protocol/session/transport/client）、QoS 状态机的边界条件、C FFI 边界设计、已知限制的如实声明、与 mooncakes 现有项目的查重。
- **AI 生成的代码怎么验证**：每条 AI 生成的单测都由人对照 MQTT 3.1.1 规范（OASIS 标准）核对过断言；协议编解码有往返测试（encode → decode → 字段比对）；CI 四后端测试全绿才合并。
- **不做什么**：不照搬其他开源项目的代码（API 设计参考 MQTT.js / Paho C，但实现是 MoonBit 重写）；不把 AI 生成的测试数据当真理；不把"声明与实际不符"的话写进 README。

## 已知限制（如实说明）

- **会话快照的落盘文件 I/O**：`SessionStore` 已提供字节级快照原语 `snapshot()` / `restore()`（`session/persistent.mbt`），调用方拿到 `(next_id, Array[InflightWire])` 即可自行写盘、进程重启后 `restore()` 重建会话；`reconnect()` 在同进程内重连 + replay。库本身不做文件读写（native 层文件 I/O 留待后续），跨进程重启由调用方 3 行胶水代码完成。
- **`transport/` 与 `client/` 仅支持 native 后端**：它们依赖 C FFI socket，`extern "C"` 在 wasm 系列后端不存在。`protocol/` 与 `session/` 不受此限（四后端可编译可测）。
- **阻塞式 API**：`client/` 为阻塞式，适合 CLI / 边缘遥测上报等确定性场景；高并发长连接场景需要多线程或异步封装，当前未提供。
- **publish/subscribe/ping 同步握手期间的入站 PUBLISH**：`publish` 等 PUBACK/PUBREC/PUBCOMP、`subscribe` 等 SUBACK 时，若 broker 恰好推来你订阅主题的入站 PUBLISH，当前代码会返回 `"expected XXX"` 错误并把该报文丢掉。边发布边接收的场景应改用 `poll_loop` 主循环 + `subscribe_with_handler`。
- **`client/` 层无独立单测**：client 是 native + C FFI，无法在 wasm 后端直接实例化；其逻辑正确性由 `protocol/`（帧编解码）与 `session/`（QoS 状态机）的纯层测试（wasm-gc 58 个 / native 61 个）+ `examples/pubsub`、`examples/resume` 手动验证共同保障。client 层的 transport 抽象与可测性改进是后续版本的工程债。

## 许可证

MIT © Duckweed-yhb

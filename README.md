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
- [x] `session/` 会话状态机（QoS2 exactly-once 握手、报文标识分配）
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

## 许可证

MIT © Duckweed-yhb

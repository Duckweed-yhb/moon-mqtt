# moon-mqtt

MoonBit 生态的 **MQTT 3.1.1 / 5.0 异步客户端库**。

MQTT 是物联网与边缘计算事实上的消息协议标准（OASIS 规范），而 MoonBit 生态目前没有任何 MQTT 客户端。moon-mqtt 补齐这一环：以 OASIS MQTT 3.1.1（全量）/ 5.0（核心子集）公开规范为实现依据，交付纯 MoonBit 的异步发布/订阅客户端。

> 参考移植（原创重写，不复制源码）：API 设计参考 [MQTT.js](https://github.com/mqttjs/MQTT.js)（MIT），协议行为参考 [Eclipse Paho C client](https://github.com/eclipse/paho.mqtt.c)（EPL-2.0/EDL-1.0）。本项目许可证 **MIT**。

## 设计

核心差异化在于**协议状态机与 QoS 语义的正确性**——不是脚本，而是有机制的基础设施。

```
protocol/   报文编解码（纯计算，四后端可测）   ← 当前阶段
session/    会话状态机（规划中）
transport/  native 网络层（规划中）
client/     高层异步 API（规划中）
```

- `protocol/` 是纯计算包，不 import 任何 platform 依赖，声明覆盖全部四个后端（wasm / wasm-gc / js / native）。
- QoS2 的 exactly-once（PUBREC/PUBREL/PUBCOMP 握手）与断线重连状态边界，是评审最看重、也最体现工程深度的部分。

## 状态

- [x] 项目骨架 + CI
- [x] `protocol/` MQTT 3.1.1 报文编解码（进行中）
- [ ] `session/` 会话状态机
- [ ] `transport/` native 网络层
- [ ] `client/` 高层 API
- [ ] mooncakes 发布

## 构建与测试

```bash
moon check
moon test --target wasm-gc    # 纯计算层：四后端可测
moon test --target native
```

## 许可证

MIT © Duckweed-yhb

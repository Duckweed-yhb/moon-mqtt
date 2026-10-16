# Changelog

本项目遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 与 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added

- `session/` `SessionStore::record_outbound` 现在按 MQTT §2.3.1 跳过 inflight 中已占用的 packet_id（原简单递增循环在非阻塞/重连场景会复用未完成握手的 id）；新增单测 `"next id skips inflight occupied"`（总测试 52 → 53）。

### Changed

- **措辞修正：移除"异步"宣传语**。README 顶部、`moon.mod` description 与 keywords 原称"异步客户端库 / async"，但 `client/` 实际为阻塞式（异步封装为 11-1 月季度维护路线 Q1）。统一改为"当前阻塞式，异步为后续路线"，避免"声明与实际不符"（MoonProof 当年被驳的同类问题）。
- README「已知限制」新增三条如实说明：①publish/subscribe/ping 调用期间收到的入站 PUBLISH 会被丢弃（阻塞单线程结构性问题）；②read_frame 无超时；③`client/` 层无独立单测（native + C FFI 限制），由 protocol/session 纯层测试 + examples/pubsub 保障。

- `session/` 新增持久会话在途存储纯计算骨架 `SessionStore`（clean_session=false 断线续传的第一步）：记录出站 QoS1/2 PUBLISH 的在途状态（`SendStage`: WaitingPuback/WaitPubrec/WaitPubcomp），收到 PUBACK/PUBREC/PUBCOMP 推进状态，断线重连时 `replay()` 按发送序产出 DUP=1 的 PUBLISH 与待重发的 PUBREL；`from_parts`/`inflight_entries` 支持落盘后恢复。四后端可测，共新增 8 个单测。配套在 `protocol/` 新增 `PublishPacket::with_packet_id` / `with_dup` 不可变副本辅助方法。
- 新增 `examples/pubsub` 可运行示例：用 `protocol` 层做 PUBLISH 编解码往返，不依赖真实 broker，本地即可运行（验收"至少一个可运行示例"）。CI 新增 `moon run examples/pubsub` 步骤。

### Changed

- `transport/`：移除 `@string.from_iter` 弃用调用，改用 `@string.from_array(chars.exact_view())`，构建 0 警告。
- README：补「安装方式」与「快速上手/可运行示例」章节，勾选 mooncakes 发布状态。
- README：新增「真实用例：物联网边缘遥测上报」（回应"无实用价值"评审教训）、「已实现的 CONNECT 字段清单」（如实声明支持范围）、「已知限制」（如实说明持久会话恢复尚未实现、native-only、阻塞式）。

## [0.1.0] - 2026-10-15

### Added

- 项目骨架（`moon.mod` / `moon.pkg` / CI / LICENSE / README）。
- `protocol/` 包：MQTT 3.1.1 报文编解码（纯计算，四后端），包括：
  - QoS 类型与固定头、剩余长度变长编解码
  - CONNECT 编码 / CONNACK 解码（返回码、session present）
  - PUBLISH 编解码 + QoS1/2 握手控制包（PUBACK/PUBREC/PUBREL/PUBCOMP）
  - SUBSCRIBE/SUBACK、UNSUBSCRIBE/UNSUBACK
  - PINGREQ/PINGRESP/DISCONNECT
  - Topic 过滤器匹配（`+` 单层、`#` 多层）
  - 统一入站分发 `decode_packet`
- `session/` 包：QoS2 exactly-once 会话状态机（纯计算，四后端）：
  - 报文标识分配器（1..65535 循环）
  - 发布侧 / 接收侧 QoS2 握手（PUBREC/PUBREL/PUBCOMP）
  - 重复 PUBREC 重发 PUBREL、乱序 PUBREL 忽略等边界
- `transport/` 包（`native` only）：C FFI 原生 TCP socket，跨平台：
  - `connect(host, port)`（IP 或域名，getaddrinfo 解析）
  - 读/写原始字节 `read_some` / `write`、关闭 `close`
  - 字节经 MoonBit `String` 的 UTF-16 单元承载
- `client/` 包（`native` only）：阻塞式 MQTT 客户端：
  - `connect` / `connect_opts`（校验 CONNACK 返回码）
  - `publish`（QoS0 直发 / QoS1 等 PUBACK / QoS2 三段握手）、`subscribe` / `ping` / `disconnect`
  - 读帧（固定头 + 剩余长度变长）、报文标识分配器
- `protocol/` 补充跨包构造函数：`PublishPacket::new` / `Subscription::new` / `SubscribePacket::new`

### Published

- 发布至 mooncakes.io：`Duckweed/moon-mqtt@0.1.0`。

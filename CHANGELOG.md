# Changelog

本项目遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 与 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

## [0.3.1] - 2026-10-22

### Changed

- 文档与版本号对齐：安装命令、README 状态、CHANGELOG 更新到 0.3.1。0.3.0 发布包内的 README 仍写着 0.2.1，本次修正。
- 版本 0.3.0 → 0.3.1。

## [0.3.0] - 2026-10-22

### Added

- `browser/` 包补齐高层 API：`connect` / `connect_opts` / `connect_persistent`，`on_connect` / `on_suback` / `on_message` 三个回调，`subscribe` / `publish` / `disconnect`。
- `browser/publish` 出站 QoS1/2 交给 `core.publish`：packet_id 自动分配并记入在途，PUBACK / PUBREC→PUBREL→PUBCOMP 由 `core.feed()` 自动推进，应用层不碰握手包。
- `browser/connect_persistent`：clean_session=false，CONNACK 带 `session_present=1` 时把在途帧 replay 出去。回调顺序按 CONNACK → SUBACK → PUBLISH 触发。
- `docs/demo/` 静态页面与 `scripts/build-demo.ps1`：浏览器 demo 从 `docs/` 直接打开，不再依赖 `_build` 路径。

### Changed

- 版本 0.2.0 → 0.3.0。
- `browser/` 的 JS FFI 边界改用 `FixedArray[Int]` 传字节，`moon check --target js --deny-warn` 通过，0 警告。
- README 改成浏览器优先叙述：开头讲 WebSocket 宿主与 QoS0/1/2，新增「在线 demo」小节和无头 Chrome 实测日志；Node 运行降到「命令行验证」一节。安装版本同步 0.3.0。
- 申报书压到一页，浏览器证据换成无头 Chrome 日志，测试数改为 wasm-gc 77/77、native 80/80。

## [0.2.0] - 2026-10-20

### Added

- `core/` 新包：`ClientCore` 连接状态机（纯计算，四后端可测），`start()` 生成 CONNECT 帧字节，`feed(bytes)` 返回 `(Array[CoreEvent], Array[Int] 出站字节)`。
- `core/` 自动处理 QoS1/2 入站握手：收到 QoS1 PUBLISH 自动回 PUBACK，QoS2 PUBLISH 自动回 PUBREC，收到 PUBREL 自动回 PUBCOMP；`SessionStore` 接入 `ClientCore` 字段，`on_puback/on_pubrec/on_pubcomp` 推进在途状态；新增 `with_session(opts, store)` 构造器供断线重连恢复。
- `examples/ws-spike/`：端到端打通 MQTT over WebSocket（js 后端 + Node 22 内置 WebSocket），连公共 EMQX broker `wss://broker.emqx.io:8084/mqtt`，收 CONNACK → 自动 SUBSCRIBE → 收 SUBACK → 渲染 PUBLISH topic + payload hex。
- `core/ClientCore` 断线重连：`on_transport_close()` 切 Disconnected 状态（SessionStore 保留），`reconnect_bytes()` 重置状态、清 framer 残留缓冲、重新编码 CONNECT；`Framer::reset()` 清半包字节。
- `examples/ws-spike/` JS 胶水层：WebSocket close 事件后延迟 1s 自动重连（最多 3 次），重连后自动重发 CONNECT + SUBSCRIBE。
- `core/` 新增 8 个单测（wasm-gc 66 → 74，native 69 → 77）。

### Changed

- 版本 0.1.2 → 0.2.0。
- README 新增"浏览器 / Node WebSocket 连接"章节，补 B 方案架构说明与端到端实测输出。
- 架构图补 `core/` 层；已知限制更新为"transport/ client/ 仅 native，core/ 四后端可测，浏览器场景经 WebSocket 胶水层已验证"。

## [0.1.2] - 2026-10-18

### Added

- `client/` 新增 `poll_loop(rounds, timeout_ms)`：连调 `poll_once`，累计等待时长到 `keep_alive` 自动发 PINGREQ，用户无需手动调 `ping()`。
- `client/` 新增 `reconnect()`：重连 CONNECT + 带旧 `SessionStore` + `session_present=true` 时自动 replay 在途 QoS1/2 帧。
- `client/` `MqttClient` 保存 host/port/opts，新增 `last_ping_ms` 字段用于自动心跳累计。
- `protocol/ConnectPacket` 新增链式 builder：`with_keep_alive` / `with_clean_session` / `with_auth` / `with_will`。
- `protocol/QoS` 新增 `qos0()` / `qos1()` / `qos2()` helper，绕开 native 后端 executable 包跨包构造 enum variant 的限制。

### Changed

- 版本 0.1.1 → 0.1.2，`moon.mod` description 同步新特性。
- README 快速上手示例改成 `poll_loop + reconnect + with_will` 链式调用。
- README 已知限制删掉已解决的两条：读帧无超时、重连需应用层接管。

## [0.1.1] - 2026-10-17

### Added

- `client/` `poll_once(timeout_ms)`：阻塞读一帧并派发 PUBLISH 到注册回调，带超时（`wait_read`）。
- `client/` `subscribe_with_handler`：注册 PUBLISH 回调，poll 时按 topic filter 匹配派发。
- `client/` 入参校验：`validate_publish_topic`（非空 / ≤65535 / 无 NUL）；帧大小软上限 16MB。
- `session/` `SessionStore` 字节级可落盘快照闭环：`snapshot()` 导出 `(next_id, Array[InflightWire])`，`restore()` 还原；新增 5 个单测（wasm-gc 53 → 58）。
- `session/` `record_outbound` 按 MQTT §2.3.1 跳过 inflight 中已占用的 packet_id。

### Fixed

- `transport/transport.mbt:90` 弃用警告：`@string.from_iter` → `String::from_array`。
- socket fd 在错误路径泄漏 + partial write 处理。
- native 后端编译错（CI 红）。

### Changed

- 全仓库移除"MQTT 5.0"声明，统一为"3.1.1 全量；5.0 为后续路线"。
- 移除"异步客户端"宣传语，统一为"阻塞式"。
- CI 在 check 之后加四后端 `moon build` 矩阵。

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

# moon-mqtt 评审反馈与 Roadmap

> 来源：2026-10-16 audit-codebase full 模式评审（AI-Readiness 18/21，Bug 78/100）
> 更新：2026-10-19，对照官网 6 条验收标准复审

---

## 总评

- 结构已经够好，不需要大动
- 真正的风险在 client 层：入站 PUBLISH 接收、read 超时、自动心跳三件事缺
- 先修 bug 不修结构

## Phase 1 — 10/31 前冲复审（已完成 ✅）

- [x] client 加 `subscribe_with_handler()` + `poll_once()` 入站派发（2026-10-16）
- [x] QoS1/2 入站 PUBLISH 自动回 PUBACK / PUBREC+PUBREL+PUBCOMP
- [x] 删掉不可变的 `connected` 字段（代码异味）

## Phase 2 — 10/31 前补完（已完成 ✅）

- [x] C 层 `read` 加 `SO_RCVTIMEO`（2026-10-17）—— `wait_read` 超时
- [x] 自动 keep alive 心跳（2026-10-18）—— `poll_loop` 累计等待到 keep_alive 自动发 PINGREQ
- [x] 自动重连（2026-10-18）—— `reconnect()` 带旧 SessionStore + session_present=true 自动 replay
- [x] README 加 roadmap 段（2026-10-19）
- [x] docs/ARCHITECTURE.md 一张图 + 分层职责 + 入站数据流 + 测试矩阵（2026-10-19）
- [x] 手动验证步骤（连真 broker）+ AI 工具使用说明（2026-10-19）
- [ ] client 层 mock 单测（工具链限制，做不了）
  - MoonBit native 后端 blackbox test 跨包链接 transport C FFI 报 LNK2019
  - 等 MoonBit 工具链支持跨包 C FFI 链接后再做

## Phase 3 — 11 月轮 / 后续（正常迭代）

- [ ] client.mbt 的 `Array[Bool]`/`Array[SessionStore]` workaround 重构（等 MoonBit 支持可变 struct 字段）
- [ ] MQTT 5.0 CONNACK reason code 完整字段
- [ ] TLS 接入
- [ ] 入站 QoS2 PUBLISH 的去重（packet_id 记忆窗口）
- [ ] will message 遗嘱测试
- [ ] 会话快照落盘文件 I/O（native 层）
- [ ] 异步封装（基于回调或 fiber）

## 已确认死路 / 不做

- 不做自动重连循环（让调用方自己写，避免黑盒）
- 不做异步/回调 IO（保持阻塞式，跟定位一致）
- 不做 MQTT 5.0 的所有 reason code（先 3.1.1 打透）

## 评审时发现的已修 bug

- `set_session_store` 缺 `-> Unit`（wasm-gc 宽松没报，native 严格报）
- `qos != AtMostOnce` 不能直接比较 enum variant（要 match）
- `Array[Bool]` workaround 是因为 struct 字段不可变

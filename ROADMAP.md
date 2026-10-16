# moon-mqtt 评审反馈与 Roadmap

> 来源：2026-10-16 audit-codebase full 模式评审（AI-Readiness 18/21，Bug 78/100）
> 评审时间：2026-10-16
> 评审范围：全仓库 ~2170 行（protocol/session/transport/client/examples）

---

## 总评

- 结构已经够好，不需要大动
- 真正的风险在 client 层：入站 PUBLISH 接收、read 超时、自动心跳三件事缺
- 先修 bug 不修结构

## Phase 1 — 10/31 前冲复审（已完成 ✅）

- [x] client 加 `subscribe_with_handler()` + `poll_once()` 入站派发（2026-10-16）
- [x] QoS1/2 入站 PUBLISH 自动回 PUBACK / PUBREC+PUBREL+PUBCOMP
- [x] 删掉不可变的 `connected` 字段（代码异味）

## Phase 2 — 下季度（冲季度优秀评选）

- [ ] C 层 `read` 加 `SO_RCVTIMEO`（2 小时）
  - 现在 TCP 死了会永久阻塞在 read 上，keep alive 也发不出去
- [ ] 自动 keep alive 心跳（4 小时）
  - publish/subscribe/poll 里检查距上次 write 是否超过 keep_alive*90%，是就发 PINGREQ
- [ ] client 层 mock 单测 5-8 个（1 天）
  - 现在 53 个测试全在 protocol/session，client 0 个
  - 把 transport mock 成内存字节对，测 subscribe/publish/poll_once 错误路径
- [ ] README 加 roadmap 段（1 小时）
- [ ] docs/ARCHITECTURE.md 一张图 + 30 行说明四层依赖（1 小时）

## Phase 3 — 后续（正常迭代）

- [ ] client.mbt 的 `Array[Bool]`/`Array[SessionStore]` workaround 重构（等 MoonBit 支持可变 struct 字段）
- [ ] MQTT 5.0 CONNACK reason code 完整字段
- [ ] TLS 接入
- [ ] 入站 QoS2 PUBLISH 的去重（packet_id 记忆窗口）
- [ ] will message 遗嘱测试

## 已确认死路 / 不做

- 不做自动重连循环（让调用方自己写，避免黑盒）
- 不做异步/回调 IO（保持阻塞式，跟定位一致）
- 不做 MQTT 5.0 的所有 reason code（先 3.1.1 打透）

## 评审时发现的已修 bug

- `set_session_store` 缺 `-> Unit`（wasm-gc 宽松没报，native 严格报）
- `qos != AtMostOnce` 不能直接比较 enum variant（要 match）
- `Array[Bool]` workaround 是因为 struct 字段不可变

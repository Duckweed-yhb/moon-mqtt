# moon-mqtt Roadmap

> 更新：2026-10-22
> 当前版本：0.3.2（mooncakes latest）
> 状态：对照官网验收 9 条自检通过；浏览器 demo 已上线

## 总评

结构已经稳定，后续以补边界和补生态为主，不再动分层。

现在的分层：

- 纯计算：`protocol/` `session/` `core/`，四后端可测
- 浏览器宿主：`browser/`（js 后端，WebSocket 胶水层）
- native 宿主：`client/` + `transport/`（C FFI TCP）

## 已完成

### 0.1.x

- 报文编解码、QoS2 状态机、native TCP、阻塞式 client、CI、mooncakes 发布

### 0.2.x

- 出站 QoS1/2 在途追踪 + `replay()`
- `core/` 抽成纯计算连接状态机，浏览器路径由它驱动；native 仍由 `client/` 自持读帧与握手
- `docs/ARCHITECTURE.md`、测试矩阵、手动验证步骤、AI 工具说明

### 0.3.x（2026-10-22）

- `browser/` 高层 API：`connect` / `connect_opts` / `connect_persistent`，`on_connect` / `on_suback` / `on_message`，`subscribe` / `publish` / `disconnect`
- `browser.publish` 支持 QoS0/1/2，QoS1/2 走 `core.publish()`，握手由 `core.feed()` 推进
- `session_present=1` 时重放在途帧；浏览器 demo 实测 connect → suback → publish QoS1 → recv → 强制断开 → 重连
- `docs/demo/` 静态页面 + `scripts/build-demo.ps1` + GitHub Pages
- 架构图换成 SVG/PNG；README 改成浏览器优先，去掉竞品表
- 0.3.1 对齐 README / CHANGELOG / `moon.mod`，修复 0.3.0 发布包内 README 仍写 `@0.2.1` 的问题

### 0.3.2（2026-10-22 修复）

- `client.poll_once` 入站 QoS2 不再嵌套阻塞等 PUBREL；PUBREL 由后续 poll 回 PUBCOMP
- 入站 QoS2 按 packet_id 去重（core + client），重复 PUBLISH 不重复派发
- CONNACK 拒绝码不再切 Connected；browser 的 `on_connect` 只在 Accepted 触发
- reconnect 在 `session_present=false` 时清空本地在途；重连前关闭旧 socket，避免 fd 泄漏
- 单次 socket 读加 5 秒超时；PUBLISH topic 按 UTF-8 字节长度校验；`decode_publish` 越界返回 Err
- SUBACK 0x80 返回 Err；`UnknownPacketType` 报真实类型；通配符不匹配 `$SYS`
- browser `disconnect` 不自动重连；发送前检查 `readyState`；subscribe packet_id 与 core 共享

### 工程质量

- `moon test --target wasm-gc` 82/82
- `moon test --target native` 85/85
- `moon check --target js --deny-warn` 通过，0 警告
- CI：check + 四后端 build/test + 两个浏览器 demo 构建

## 下一阶段（11 月–1 月）

- [ ] MQTT 5.0 基础字段（CONNECT/PUBLISH properties、CONNACK reason code）：11–1 月先做基础字段，完整 5.0 后续评估
- [ ] native TLS 接入：视工具链在 2027 评估
- [ ] Will message 的端到端测试
- [ ] 会话快照落盘（native 层文件 I/O）
- [ ] 异步 / 回调封装（保持 native 阻塞式 API 不变，另起一层）
- [ ] `client/` 层 mock 单测：等 MoonBit 支持跨包 C FFI 链接后再做
- [ ] 浏览器 demo 增加手动 publish 输入框（当前是 SUBACK 后自动发一条）

## 不做

- native `client/` 不做后台自动重连循环：调用方在 `poll_loop` 失败后自己调 `reconnect()`，避免黑盒
  - 浏览器 `browser/` 是高层的，内置最多 3 次、每次间隔 1 秒的自动重连
- native 不做异步 / 回调 IO：保持阻塞式，定位是 CLI 与边缘遥测
- 不做 MQTT 5.0 的全量 reason code：先把 3.1.1 打透

## 历史 bug 修复

- `set_session_store` 缺 `-> Unit`（wasm-gc 宽松没报，native 严格报）
- `qos != AtMostOnce` 不能直接比较 enum variant（要 match）
- `Array[Bool]` workaround 是因为 struct 字段不可变
- JS FFI 边界从 `Array[Int]` 改成 `FixedArray[Int]`，消除 3 条弃用警告

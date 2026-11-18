# 交付说明（DELIVERY）

这份文件给 mqtt 一个**单一事实来源**：项目现在到哪一步、哪条证据支撑哪句宣称、
哪块是空白。它的申报与验收走的是 10 月轮，材料归档在
`12-知识库/03-竞赛/01-MoonBit黑客松/2026-11/moon-mqtt-11月续维护说明.md`。

## 一、验收条款 vs 证据

| 条款 | 状态 | 证据（可复现） |
|---|---|---|
| MoonBit 为主 | ✅ | 全部 MoonBit；`transport/` 依赖薄 C FFI socket，仅此一处 |
| 仓库公开、提交清晰 | ✅ | 提交数以 `git log` 为准，按 protocol / session / core / client / browser / async 分层 |
| 能够运行 | ✅ | `moon run examples/scripted-broker --target native` 一行跑完 CONNECT→…→DISCONNECT |
| 工作有效（本期实质新增） | ✅ | 本轮新增事件→动作决策表、退订 API、可插拔 `Conn`、畸形帧与错误上报等 |
| 开源合规 | ✅ | MIT + `PROVENANCE.md`（代码来源、第三方参考、AI 使用范围） |
| AI 可解释 | ✅ | README「AI 工具使用说明」；测试断言逐条对照 OASIS 规范核过 |

## 二、验证证据

```bash
moon check --deny-warn --target native   # 四个目标逐个跑
moon test --target native                # 217/217
moon test --target wasm-gc               # 177/177
moon run examples/scripted-broker --target native   # 端到端时序，末行 8 帧对账
moon run examples/reject_demo --target native       # 每条拒绝路径
```

结构化证据分三层，强度不同，不要混着说：

1. **纯计算层**（`protocol/` `session/` `core/`）：wasm / wasm-gc / js / native 四后端可测，
   当前各 177 条（native 另含 client/transport 用例，共 217）。
2. **浏览器层**（`browser/` + JS 胶水）：**没有自动化测试**。端到端证据是 2026-11-04 用
   无头 Chrome 手工跑过一次（首连订阅、publish QoS1、收消息、强制断开、重连后自动重订），
   记录在 README 与 `docs/CASES.md`。
3. **native IO 层**（`transport/` `client/`）：**没有自动化测试**。端到端证据是
   `examples/scripted-broker`——用可插拔 `Conn` trait 跑真实协议时序但不碰 socket。
4. **命令行客户端**（`cmd/moon-mqtt/`，native 可执行）：没有单元测试，参数解析与拒绝路径
   是 2026-11-18 实跑的（`--help`、参数个数不足、端口越界、发布主题带通配符，均按预期
   打印原因并以 1 退出）；README 里两个终端收发一条消息的流程本机没有 broker，未跑。

## 三、已知空白（主动写出来）

- `browser/` 整包 0 测试：它是 js 专属 FFI 胶水，只能靠浏览器跑，CI 目前不覆盖。
- `transport/` `client/` 0 测试：真实 TCP 需要外部 broker，CI 不覆盖。
- 没有与真实 broker 的自动化互通测试（mosquitto / EMQX 均为手工验证）。
- MQTT 5.0、TLS、真实非阻塞 IO 运行时未做，属于路线图。

## 四、发布状态

- mooncakes：`Duckweed/moon-mqtt@0.3.15`（Latest，18 个版本）。
- GitHub 远程 tag 仍只到 **v0.3.5**；本地已打 `v0.3.15`，等本人 push 后远程才对齐。**以 mooncakes 上的版本为准**。

## 五、工具链

最低 moon 0.1.20261104（源码用 `#derive(...)` 前缀写法）。CI 与本地同版本；
官方只对外提供 `binaries/latest`，按版本号取产物一律 403，所以无法钉版本。

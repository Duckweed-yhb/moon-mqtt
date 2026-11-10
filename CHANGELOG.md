# Changelog

本项目遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 与 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added

- `client/connect_with_conn` + `pub(open) trait Conn`：允许调用方自带传输层（QUIC / 串口 / 进程内回环 / 测试夹具）。生产路径仍是 `connect_opts` 的真实 TCP，握手语义完全一致。trait 以前是只读的，外部包无法实现，`pub(open)` 把这条接缝打开。
- `examples/scripted-broker`：进程内脚本化 broker，按 MQTT 3.1.1 应答，端到端跑完 CONNECT/CONNACK → SUBSCRIBE/SUBACK → PUBLISH QoS1/PUBACK → PUBLISH QoS2/PUBREC-PUBREL-PUBCOMP → PINGREQ/PINGRESP → UNSUBSCRIBE/UNSUBACK → DISCONNECT。不需要 broker 进程与网络，CI 会跑它。

### Added

- `protocol/roundtrip_test.mbt`：PUBLISH 编解码的随机往返测试。固定种子 LCG 生成 200 组 topic / payload / QoS / retain / dup 组合，逐字段比对 decode(encode(x)) == x；另测中文 topic 的字节长度前缀、以及 QoS0+DUP 必须被拒。失败可复现（种子写死）。

## [0.3.13] - 2026-11-11

### Fixed

- `session/SessionStore::restore` 校验在途快照：重复 packet_id 与 QoS0 条目现在都按坏数据拒绝。重复 pid 会让后续 PUBACK/PUBCOMP 一次清掉两条，重放也会用同一个 id 发两份不同内容；QoS0 没有握手，本就不该出现在在途表里。

### Changed

- 测试数 139/178 → 141/180（重复 pid、QoS0 在途）。

### Added

- `scripts/check-release.ps1` + CI 的 `release-meta` job：校验 `moon.mod` 的 version、CHANGELOG 最新版本段标题、README 里所有 `<模块>@x.y.z` 与 `Latest x.y.z` 三处一致，并拒绝重复的版本段。发布时漏改任何一处都不会报错，只会让文档慢慢变成谎话；现在它们对不上就红。

## [0.3.12] - 2026-11-11

### Added

- `client/MqttClient::unsubscribe`：native 阻塞式客户端此前只能订阅、没有退订（`browser` 与 `async` 都有）。现在发 UNSUBSCRIBE 并等匹配的 UNSUBACK，确认后才删本地 handler——先删的话 UNSUBACK 失败会让本地少 handler、broker 那头还在推，两边状态不一致且本地看不出来。UNSUBACK 的 packet id 不匹配时报错且保留 handler。

### Changed

- 测试数 139/175 → 139/178（退订写帧 + 删 handler、UNSUBACK 不匹配保留 handler、非法过滤器不发帧）。


## [0.3.11] - 2026-11-11

### Fixed

- 退订时的竞态：`subscribe` 发出后、SUBACK 还没回来就 `unsubscribe`，`forget_subscription` 只清了已落库的订阅表，挂起的 SUBSCRIBE 仍在；SUBACK 一到 `commit_pending_subscribe` 就把刚退订的 topic 补记回来，之后重连还会替它重订。现在退订同时把该 topic 从 `pending_subscribes` 里摘掉（同帧的其它订阅保留）。

### Changed

- 测试数 134/173 → 139/175（退订竞态、同帧兄弟订阅）。

## [0.3.10] - 2026-11-11

### Added

- `browser/unsubscribe`：浏览器层此前只能订阅不能退订（native 与 async 都有）。退订会同步删掉本地订阅表——不删的话重连时的自动重订会把已经退订的 topic 订回来。
- `core/ClientCore::unsubscribe`：把「分配控制报文 id → 校验过滤器 → 编 UNSUBSCRIBE → 忘掉本地订阅」收进 core，browser / async 只负责把字节送出去。此前这段组帧逻辑只写在 async 里，browser 没有。

### Changed

- `async/unsubscribe` 改为调用 `core.unsubscribe`，删掉重复的组帧代码。
- 计数 134/170 → 137/173（退订编帧、未知 topic 仍发帧、未连接 / 非法过滤器拒绝）。

## [0.3.9] - 2026-11-11

### Fixed

- `client/` 读到半帧失败后连接不再继续使用：`read_frame` 没有跨次残留缓冲，超时那一刻已吃掉的字节找不回来，帧边界丢失；继续读会把载荷字节当报文头解出垃圾。现在读帧失败（已消费 ≥1 字节）会把客户端标记成 `desynced`，`read_packet` 与 `poll_once` 立刻报「reconnect required」，而不是假装空闲。
- `client/poll_loop` 心跳计时只累计**真正空等**的轮次：此前有数据的轮次也按 `timeout_ms` 累加，busy 连接上 PINGREQ 会提前几倍发出。

### Changed

- 测试数 134/168 → 134/170（半帧污染连接、心跳只计空等）。

## [0.3.8] - 2026-11-10

### Fixed

- `core/` SUBACK 失败时挂起条目不再泄漏：旧实现只在 `all_accepted()` 时摘 `pending_subscribes`，被拒那次永久挂着；之后同一个 pid 再来一个成功 SUBACK 会把这条被拒的订阅补记进本地订阅表，于是每次重连都替它重订、broker 每次都拒绝。
- `core/ClientCore::subscriptions()` 返回拷贝：文档写着「只读副本」，实现却直接返回内部数组（`Array` 是引用语义）。
- `protocol/ByteWriter::push_u16` 越界不再静默截断（16 位字段写入 >65535 直接失败）：它是 `push_string` / `push_binary` 的长度前缀，截断后 broker 按错长度解析，整条报文错位。
- `protocol/encode_remaining_length` 越界不再静默丢高位（>268435455 直接失败）。

### Changed

- 测试数 132/166 → 134/168（SUBACK 失败不泄漏、订阅表访问器返回拷贝）。

## [0.3.7] - 2026-11-10

### Fixed

- `browser/publish` 与 `async/publish` 遇到非法 topic 不再静默丢帧：core 会挡下并返回空字节，此前调用方看到「没报错」就以为发出去了。现在编码前先校验，拒绝原因分别走上报回调（`browser.on_error`）与控制台。
- `browser` 收到拒绝 CONNACK 后标记主动关闭：拒绝码是终局错误，重连配额留着没用；此前 JS 侧还会再重试 3 次。

### Changed

- 测试数 131/165 → 132/166。
## [0.3.6] - 2026-11-10

### Added

- `protocol/validate_topic_name` / `validate_topic_filter` / `is_valid_topic_name` / `is_valid_topic_filter`：主题规则统一到 protocol 层，四后端共用。topic name 拒绝空串、>65535 UTF-8 字节、U+0000 与通配符（§3.3.2.1）；过滤器按 §4.7.1.2 校验（`'#'` 必须独占且收尾、`'+'` 必须独占一层）。`topic_matches` 改为复用同一份过滤器规则，删掉第二套判断。
- 入站 `decode_publish` 同样校验 topic：broker 发来带通配符或 NUL 的 PUBLISH 按坏帧拒绝（§4.7.3），不再原样交给应用层。
- `encode_subscribe` 剔除非法过滤器，全部非法时返回空帧；`browser/` 与 `async/` 的 `subscribe` 在编码前先校验并打印/上报原因。此前 `a/#/b` 会被原样编进 SUBSCRIBE，broker 当协议错误断连，调用方看不到任何线索。
- `core/` 新增 `plan_event`：事件 → 胶水层动作的纯决策表（`DispatchAction`：`Connected(session_present)` / `Refused(code)` / `Fatal(msg)` / `Deliver` / `Subacked` / `Unknown` / `Ignore`），配套 `DispatchAction::needs_close`、`return_code_name`、`return_code_byte`。`browser/` 与 `async/` 共用这一张表，不再各写一份 `match`。补 7 条单测（`core/dispatch_wbtest.mbt`），CONNACK 事件由真实字节走 `decode_packet` 产出。
- `browser/on_error`：连接级错误回调（CONNACK 拒绝 / 畸形帧），注册一次对后续重连同样生效。未注册时错误仍打到 console，不再静默。
- `async/AsyncClient::fatal()`：不可恢复错误原因（`None` 表示连接仍可用）。

### Fixed

- `client/` 的 `subscribe` 此前用 `validate_publish_topic` 校验：订阅的是过滤器，`sensors/#` 这种合法过滤器会被误拒。改用 `validate_topic_filter`，同时把 `validate_publish_topic` 收敛成 `@protocol.validate_topic_name` 的别名（公共 API 名不变），于是 native 侧也开始拒绝带通配符的 publish topic。
- `browser/` 吞掉致命事件：`browser_on_message` 的 `_ => ()` 会把 `FramerError` 与拒绝 CONNACK 一并忽略，连接留在「开着但收不到正确报文」的状态，与 README「收到 FramerError 应断开」的约定相反。现在两条路径都会关 WebSocket 并上报。
- `async/` 畸形帧后继续吃字节：`feed_bytes` 在 `FramerError` 之后仍继续解析（帧边界已丢，后续字节会被解成垃圾帧）。现在落成 `fatal` 并冻结实例。
- `browser_tick` 首帧多发 PINGREQ：`g_last_ping_ms` 初值 0 会让连接建立后的第一次 tick 立刻判成「早该发」，白白多发一记 PINGREQ；现在以首次 tick 为基准，断开时归零。

### Changed

- 测试数 118/151 → 131/165；js 后端本机缺 node 未跑，交给 CI。
- `core/` 新增 `next_action`：保活决策（禁用 / 等待 / 发 PINGREQ / 判定死链）抽成纯函数，`browser_tick` 改为调用它；补 5 条单测，覆盖禁用、未到点、到点、连续未应答。
- `client/` 新增 `plan_resume`：重连的会话语义（清空 / 重放 / 重订）抽成纯函数，`reconnect` 改为按计划执行；补 2 条单测。

## [0.3.5] - 2026-11-10

### Fixed

- `async/AsyncClient::on_transport_close` 清空尚未交给 socket 的待发字节队列：此前断线时未落网的出站字节会被保留，重连后可能夹带到新连接，并与会话重连 `session_present=1` 时由 `replay_bytes()` 产出的 DUP 在途帧重复出站。SessionStore 保留，权威重发仍由 `replay_bytes()` 负责；已收到的入站事件队列不受影响。补 2 条 `async/` 回归用例（Connected 出站 QoS1 排队；断线清空待发队列、重连只发新 CONNECT）。
- `client/` 重连保留入站 QoS2 去重表：`session_present=1` 时沿用旧客户端的 `inbound_qos2`，broker 重发「已派发、PUBREL 未完成」的 PUBLISH 不再被重复派发；`session_present=0` 时清空。
- `client/` 会话丢失自动重订阅：`SubscriptionReg` 记录订阅 QoS，`session_present=0` 时重连会重发 SUBSCRIBE，调用方不再需要手动重订。
- `protocol/` UTF-8 解码严格化：拒绝非法续字节、过长编码（overlong）、代理区码点与超出 U+10FFFF 的值；此前只检查截断。
- `protocol/` packet-id 应答帧校验：Remaining Length 必须为 2、总长必须为 4、packet identifier 不得为 0，多余字节按坏帧拒绝。
- `core/Framer` 畸形头处理：保留报文类型、剩余长度超 4 字节或缓冲超过协议最大帧时清空缓冲并返回 `Err`，`ClientCore::feed` 转为 `FramerError` 事件；此前这类帧会永久卡在缓冲里，后续帧出不来。

### Changed

- `core/Framer::feed` 改用游标读缓冲、最后只裁剪一次：一轮喂进 N 帧时从 O(n²) 降到 O(n)。补「一次 feed 多帧」与「整帧 + 半帧混合」两条用例。
- 测试数 105/131 → 105/135；`client/` 补 2 条 QoS2 握手插帧回归用例（等 PUBREC 期间消化入站 QoS1 PUBLISH 并回 PUBACK；等 PUBCOMP 期间消化入站 PUBREL 并回 PUBCOMP），`client_wbtest.mbt` 共 28 条。未改动公开 API 与生产逻辑。
- 测试数 105/135 → 113/144；`async/` 补 2 条回归用例并收敛 `on_transport_close` 待发队列语义；`client/` 补重订阅 QoS 用例，`protocol/` 补严格 UTF-8 与 packet-id 校验用例，`core/` 补 Framer 畸形帧与多帧切分用例；公开 API 签名不变。

## [0.3.4] - 2026-11-07

### Added

- `core/` 会话恢复纯计算层：本地订阅表记录 topic filter 与 QoS；CONNACK 带 `session_present=0` 时自动把已记录订阅打包成 SUBSCRIBE 帧重发，`session_present=1` 信任 broker 侧保留。`browser/` 胶水层在 subscribe 时把待确认订阅登记进 Core，SUBACK 通过后由 Core 自动落库；浏览器 demo 用 `clean_session=true` 实测重连后自动重订 1 个 topic 并收到 SUBACK。
- `async/` 非阻塞外观骨架：`AsyncClient` 持有 `ClientCore`，提供 `feed_bytes` / `drain_pending` / `drain_events` 非阻塞接口，以及 `subscribe` / `unsubscribe` / `publish` / `pingreq` / `disconnect` / `reconnect` 方法。收 SUBACK accepted 时 Core 自动落库订阅，退订时从本地表删除。
- `browser/` MQTT 保活：新增 `browser_tick(now_ms)`，由 JS 每秒驱动，`Connected` 状态下每 `keep_alive/2` 秒发一次 PINGREQ；连续 3 个 PINGREQ 没有 PINGRESP 判定链路已死，主动关闭 WebSocket 走正常重连。此前浏览器长连会被 broker 的 keep-alive 静默踢掉（WebSocket 还开着，MQTT 会话已经死了）。

### Fixed

- `transport/moon.pkg` 登记 `native-stub`，`tcp_stub.c` 用 MSVC `#pragma comment(lib, "ws2_32.lib")` 带上 Winsock 库：真实 native 消费者（`examples`、外部 `connect_opts` 调用）不再报 LNK2019 `unresolved external symbol mqtt_tcp_connect`。
- `async/` 会话语义：CONNACK 之前调用 `subscribe` / `unsubscribe` 不再产生报文；收到 `session_present=1` 的成功 CONNACK 后自动重发在途 QoS1/2 报文（此前待发队列为空，断线前未确认的消息永久丢失）；`session_present=0` 时清空本地在途。
- `tcp_stub.c`：Winsock 初始化提前到域名解析之前（此前 `getaddrinfo` 早于 `WSAStartup`）；POSIX 分支 `FD_SET` 改用 `int`（此前套用 Windows 的 `SOCKET` 类型，POSIX 下编译不过）。
- `client/` 同步握手期间不再丢入站 PUBLISH：`publish`（等 PUBACK/PUBREC/PUBCOMP）、`subscribe`（等 SUBACK）、`ping`（等 PINGRESP）统一走 `read_control`，途中到达的业务 PUBLISH 照常按订阅表派发、入站 PUBREL 照常回 PUBCOMP。此前这些等待把非目标帧当 `"expected XXX"` 错误返回，消息被读出 socket 后丢弃，`poll` 也补不回来——这是十月轮验收未通过的直接原因。
- `protocol/` PUBLISH 解码收紧：拒绝 QoS0 报文带 DUP=1（QoS0 无重传语义，§3.3.2.3），拒绝 QoS1/2 报文 packet_id=0（§2.3.1）；QoS 大于 0 的合法 DUP 重传不受影响，并补对应回归测试。

### Changed

- 测试数 100/125 → 102/128；`async/` 两条审查反例与 `client/` 一条插帧派发用例转成正式回归测试（CONNACK 前订阅不产帧、重连后重发在途 QoS1、等 PUBACK 时插 PUBLISH 不丢）。
- 测试数 102/128 → 105/131；`protocol/` 补 3 条畸形 PUBLISH 帧回归测试（QoS0 置 DUP、QoS1 零 packet_id 应拒绝，QoS1 带非零 id 的 DUP 应放行）。
- `moon.mod` keywords：`blocking` → `websocket` / `browser` / `wasm`，与浏览器事件驱动的现定位对齐。
- 版本 0.3.3 → 0.3.4；发布到 mooncakes `Duckweed/moon-mqtt@0.3.4`。

## [0.3.3] - 2026-10-26

### Added

- `client/` 层引入 `Conn` 接缝（`impl Conn for @transport.TcpClient` 转发原实现）与脚本化假连接，补 22 条主路径单测：CONNECT/CONNACK 各分支、QoS0/1/2 发布握手、SUBACK、poll 派发与 QoS2 去重、自动心跳、断开、分帧上下限；`client_wbtest.mbt` 共 25 条。对外签名不变。

### Fixed

- `browser/` 自动重连成功后没有归零失败计数，`MAX_RECONNECT=3` 实际退化为「整个页面生命周期总共 3 次」；`onopen` 先记录是否重连再归零，语义改为「连续失败最多 3 次」，`docs/demo/browser-demo.js` 同步重建。

### Changed

- 测试数 82/85 → 82/107；README / ROADMAP / `docs/ARCHITECTURE.md` / 申报书同步口径。
- 版本 0.3.2 → 0.3.3。

## [0.3.2] - 2026-10-22

### Fixed

- `client.poll_once` 处理入站 QoS2 不再嵌套阻塞等 PUBREL：PUBREC 后立即返回并派发，PUBREL 由后续 poll 回 PUBCOMP，避免插帧丢消息和 broker 无限重传。
- 入站 QoS2 按 packet_id 去重（`core/` 与 `client/`），重复 PUBLISH 不再重复派发。
- CONNACK 拒绝码不再切 Connected；`browser/` 的 `on_connect` 只在 Accepted 时触发。
- `reconnect` 在 `session_present=false` 时清空本地在途；重连前关闭旧 socket，修掉 fd 泄漏。
- 单次 socket 读加 5 秒超时，CONNACK/PUBACK/PINGRESP 不再永久挂起。
- PUBLISH topic 按 UTF-8 字节长度校验；`decode_publish` 对越界长度返回 Err，不再 panic。
- SUBACK 0x80 返回 Err，不再注册永远不会触发的 handler。
- `UnknownPacketType` 上报真实报文类型；topic 过滤器拒绝非法写法，通配符不匹配 `$SYS`。
- browser `disconnect` 不再触发自动重连；发送前检查 `readyState`；subscribe packet_id 与 `core/session` 共享。

### Changed

- 测试数 77/80 → 82/85。
- 版本 0.3.1 → 0.3.2。

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
- 测试数随 `core/` 新增用例增至 wasm-gc 77/77、native 80/80（74→77 / 77→80）。
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

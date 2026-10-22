# 初始 Spike：MQTT over WebSocket (wss) 握手验证

## 基本信息

- 日期：2026-10-20
- 仓库：`Duckweed/moon-mqtt`（MoonBit 0.10.15）
- 工具链：`moon 0.1.20261012`（moonc v0.10.15+943464bfa）
- 运行环境：Node.js v22.23.2（Windows 11，PowerShell 5.1）
- 目标 broker：`wss://broker.emqx.io:8084/mqtt`（EMQX 公共 MQTT over WebSocket，子协议 `mqtt`）
- 验证目标：发 MQTT 3.1.1 CONNECT，收到 CONNACK，打印 hex

## 执行命令

```powershell
# 在仓库根目录
moon build --target js examples/ws-spike
# 输出：Finished. moon: ran 2 tasks, now up to date (1 warnings, 0 errors)

# 用 Node 跑生成的 js bundle
node "_build\js\debug\build\examples\ws-spike\ws-spike.js"
```

## Console 输出（原文）

```
[spike] built CONNECT, 22 bytes
[spike] connecting to wss://broker.emqx.io:8084/mqtt (subprotocol mqtt)
[spike] onopen, sending CONNECT, 22 bytes
[spike] onmessage hex: 20 02 00 00
```

- `20 02 00 00` = CONNACK 类型（0x20），剩余长度 2，flags=0x00（无 session present），return code=0x00（连接已接受）。
- 未出现 `onerror`，未出现异常 `onclose`（连接保持在 Node 事件循环中等待）。

## 踩过的坑

1. **core.core bundle 缺失**：js 后端首次 `moon build --target js` 报 `core.core missing`。原因是 MoonBit 0.10.15 的 js core 只构建了 `build/` 目录（per-package `.core`），没有自动生成 `bundle/core.core`（native 后端有）。修复：手动用 `moonc bundle-core` 把 80 个 per-package `.core` 合并成 `core.core`，并把 `build/` 目录复制为 `bundle/`。
2. **extern "js" 语法**：MoonBit 0.10.15 的多行 JS FFI 不是 `#| ... |#` 包裹，而是每行 JS 代码前加 `#|` 前缀，首行是 `#|(args) => {`，末行是 `#|}`。用 `#|` ... `|#` 会直接报 Parse error。
3. **Array 在 JS FFI 中 deprecated**：`Array[Int]` 作为 extern "js" 参数会触发 deprecated warning，建议用 `FixedArray[Byte]`（映射到 JS Uint8Array）。spike 阶段保留 `Array[Int]` 能跑通，后续切 FixedArray。
4. **client ID 长度字段与实际字节数不符**：原始任务描述给的是 `00 09`（长度=9），但 `"ws-spike"` 只有 8 字节。broker 收到后会在 onopen 发完 CONNECT 后直接 close code=1000，不回 CONNACK。修正为 `00 08`（长度=8）+ 剩余长度 `0x14`（20）后，broker 正常回 CONNACK。
5. **MoonBit String 无 char_at**：最初想用 MoonBit 写 hex 转换函数，`String.char_at()` 不存在。spike 阶段把 hex 打印全部放在 JS 侧（`Uint8Array.toString(16)`），不在 MoonBit 里做字符串处理。
6. **Node WebSocket**：Node 22 内置全局 `WebSocket`，无需 `ws` npm 包；`ws.binaryType = "arraybuffer"` 后 `onmessage` 的 `ev.data` 是 ArrayBuffer，直接 `new Uint8Array(ev.data)` 即可。

## A/B 接法判定

本 spike 实际按 **A 方案**（MoonBit 用 `extern "js"` 持有 WebSocket，回调在 JS 闭包里直接打 hex）跑通。验证了 A 方案的可行性：FFI 边界没问题，`Array[Int]` 在 js 后端就是 JS number 数组，直接 `new Uint8Array()` 喂给 `ws.send()` 即可。

**选择 B 方案**：JS（或 native C）胶水持有 WebSocket/socket，MoonBit 导出纯函数 `build_connect() -> FixedArray[Byte]` 和 `feed(bytes : FixedArray[Byte]) -> Unit`（或返回事件枚举）。

三条理由：

1. **开发体验**：A 方案把整个 WebSocket 逻辑塞进 `.mbt` 里的 `#|` 字符串，编辑器无 JS 语法高亮/格式化/类型检查，调试时要在 MoonBit 源码和生成 JS 之间来回对照。B 方案把胶水放在独立的 `.mjs`（或 `.c`）里，用正常 JS 工具链写，MoonBit 侧只写纯函数，两边各用各的工具。
2. **core 可测试性**：A 方案的 onmessage 回调在 JS 闭包里直接打 hex，MoonBit 侧拿不到收到的字节，无法对状态机做单元测试。B 方案下 MoonBit 导出 `feed(bytes)`，单测里可以直接喂构造好的 CONNACK/PUBLISH 字节，断言状态机迁移和输出字节，不需要真实 WebSocket。
3. **未来 native 后端复用性**：A 方案的 `extern "js"` 块只在 js 后端编译，native 后端要另写一套 `extern "C"` 的 WebSocket 逻辑，两套胶水代码。B 方案下 MoonBit core 是纯计算（无 WebSocket 引用），js 后端写一个 `.mjs` 胶水，native 后端写一个 `.c` 胶水，两者都调同一组 MoonBit 纯函数，core 状态机零改动。

## 下一步建议

1. 在 MoonBit core 里写纯函数 `handle_incoming(bytes : FixedArray[Byte]) -> List[OutboundEvent]`，输入 broker 收到的字节，输出要发的字节和状态迁移。
2. 胶水层（js 用 `.mjs`，native 用 `.c`）负责：建 socket、把收到的字节喂给 `handle_incoming`、把返回的字节发出去。
3. CONNECT 帧构造从 `build_connect()` 泛化为 `encode_connect(client_id, keepalive, clean_session)`，走 protocol 层已有的编解码（不重复造轮子）。
4. 把 `Array[Int]` 全部换成 `FixedArray[Byte]`，消除 deprecated warning，顺便让 js 侧直接拿到 Uint8Array 不用手动拷贝。
5. 用 `moon test` 给 core 状态机写单测：构造 CONNACK 字节喂进去，断言状态从 `SentConnect` 迁移到 `Connected`，且无 outbound 字节。

---

## 后续：从"手写字节"迁移到"core/ 驱动"（2026-10-20）

### 改了什么

`examples/ws-spike/main.mbt` 不再手写 CONNECT 帧字节，改用 `@core.ClientCore`：

- **连接建立**：`ClientCore::new(ConnectPacket::new("ws-spike"))` → `core.start()` 生成 CONNECT 字节（22 字节，与最初手写版一致）。
- **收包处理**：`onmessage` 收到 broker 字节后，调用 `spike_on_bytes(arr)` 喂给 `core.feed(bytes)`，MoonBit 侧 match 出 `CoreEvent` 并格式化打印。
- **JS 胶水**：`extern "js" run_ws_spike(connect_bytes)` 仍持有 WebSocket；onmessage 里先打 hex，再把字节数组传给 MoonBit 回调。

`examples/ws-spike/moon.pkg` 新增依赖：`@core` 和 `@protocol`。

### Console 输出（原文）

```
[spike] core start() generated CONNECT, 22 bytes
[spike] connecting to wss://broker.emqx.io:8084/mqtt (subprotocol mqtt)
[spike] onopen, sending CONNECT, 22 bytes
[spike] onmessage hex: 20 02 00 00
[spike] core feed() events: [Connack(session_present=0, return_code=Accepted)]
```

### 新踩的坑

1. **extern "js" 不支持函数类型作参数**：`run_ws_spike(connect_bytes, on_bytes : Array[Int] -> Unit)` 直接 Parse error。MoonBit 0.10.15 的 extern "js" 参数列表不接受 `->` 函数类型。解法：用包级变量 + 顶层函数代替闭包传参。
2. **MoonBit 顶层不支持 `let mut`**：`let mut g_core : ClientCore? = None` 报 Parse error。解法：用单元素数组 `let g_core : Array[ClientCore?] = [None]` 作为可变容器（Array 是引用类型，元素可赋值）。
3. **Dead Code Elimination 会干掉只被 extern "js" 引用的函数**：`spike_on_bytes` 是 `pub fn`，但编译器只从 main() 做可达性分析，extern "js" 块里的 JS 字符串不被分析为引用，导致 `spike_on_bytes` 及其整条调用链（`core.feed` → `format_events` → `format_event`）都不生成 JS 函数。解法：在 main() 开头实际调用一次 `spike_on_bytes([])`（此时 g_core 为 None，静默返回），强制编译器生成整条链。
4. **extern "js" 里调用 MoonBit 函数必须用 mangled 名**：MoonBit js 后端把函数编译成 `_M0FP...<pkg_path><len><name>` 形式的 mangled 名。`spike_on_bytes` 编译后是 `_M0FP48Duckweed11moon_2dmqtt8examples10ws_2dspike16spike__on__bytes`。在 extern "js" 的 JS 代码里必须用这个 mangled 名调用，不能用原始函数名。
5. **CoreEvent 未 derive Debug**：此前注释里说 CoreEvent 不 derive(Eq, Debug)（因为 protocol 的 Connack/PublishPacket 没有实现）。spike 里需要手动写 `format_event()` 用 match 解构每个 variant 拼字符串，不能直接 `println(event)`。

### 回归验证

- `moon build --target js examples/ws-spike`：成功（1 个既有 Array FFI deprecated warning，按要求不动）
- `moon check --target wasm-gc`：0 警告 0 错误
- `moon test --target wasm-gc`：66/66 通过
- `moon test --target native`：全部通过

---

## QoS2 发布 + 断线自动重连（2026-10-22）

在原有 CONNECT → CONNACK → SUBSCRIBE → SUBACK → 收 PUBLISH 基础上，补了两个端到端能力：

1. **QoS2 出站 PUBLISH 完整握手**：浏览器侧发 QoS2 PUBLISH，core 自动完成 PUBREC → PUBREL → PUBCOMP 三段握手。
2. **断线恢复**：WebSocket 关闭后 1 秒自动重连，重新发 CONNECT → CONNACK → SUBSCRIBE → 继续收 PUBLISH，最多重连 3 次。

### 实测输出（Node 22，连公共 EMQX broker）

```
[spike] QoS2 PUBLISH prepared: pid=1 topic=sensors/qos2 payload=qos2 (1 bytes)
[spike] core start() generated CONNECT, 22 bytes
[spike] onopen, sending CONNECT, 22 bytes
[spike] onmessage hex: 20 02 00 00          # CONNACK accepted
[spike] core feed() events: [Connack(session_present=0, return_code=Accepted)]
[spike] sending SUBSCRIBE pid=1 sensors/# QoS1
[spike] sending QoS2 PUBLISH sensors/qos2 (22 bytes)
[spike] sending outgoing 38 bytes back to broker
[spike] onmessage hex: 90 03 00 01 01     # SUBACK pid=1
[spike] core feed() events: [Suback(subscribed to sensors/#)]
[spike] onmessage hex: 50 02 00 01         # PUBREC pid=1
[spike] core feed() events: []
[spike] sending outgoing 4 bytes back to broker   # ← core 自动产出 PUBREL (0x62 0x02 0x00 0x01)
[spike] onmessage hex: 32 14 00 0C 73 65 6E 73 6F 72 73 2F 71 6F 73 32 00 01 71 6F 73 32
[spike] core feed() events: [Publish(topic=sensors/qos2, payload=71 6F 73 32)]
[spike] sending outgoing 4 bytes back to broker   # ← core 自动回 PUBACK（broker 按订阅 QoS1 回传）
[spike] onmessage hex: 70 02 00 01         # PUBCOMP pid=1
[spike] core feed() events: []             # ← 在途 QoS2 清空，握手完成
```

QoS2 握手闭环：`发 PUBLISH → broker 回 PUBREC → core.feed() 自动产出 PUBREL → 发 PUBREL → broker 回 PUBCOMP → core.feed() 清在途`。全程没有手写握手字节，全由 `core/ClientCore` 纯函数驱动。

### 断线自动重连（12 秒后主动 close 模拟网络断开）

```
[spike] === 模拟网络断开，主动 close ===
[spike] onclose code=1005 reason=
[spike] core.on_transport_close() → state=Disconnected
[spike] reconnect attempt #1 scheduled in 1s (max 3)
[spike] connecting to wss://broker.emqx.io:8084/mqtt (subprotocol mqtt)
[spike] reconnect attempt #1 onopen, fetching fresh CONNECT
[spike] core.reconnect_bytes() → 22 bytes (state=Connecting, session preserved)
[spike] onopen, sending CONNECT, 22 bytes
[spike] onmessage hex: 20 02 00 00          # 新 CONNACK
[spike] core feed() events: [Connack(session_present=0, return_code=Accepted)]
[spike] sending SUBSCRIBE pid=2 sensors/# QoS1
[spike] sending QoS2 PUBLISH sensors/qos2 (22 bytes)
[spike] onmessage hex: 90 03 00 02 01      # SUBACK pid=2
[spike] onmessage hex: 50 02 00 01          # PUBREC pid=1（新一轮 QoS2 握手）
[spike] sending outgoing 4 bytes back to broker
```

重连闭环：`onclose → on_transport_close() 切 Disconnected → 1s 后新建 WebSocket → onopen 调 reconnect_bytes() 拿新 CONNECT → 新 CONNACK → 自动 SUBSCRIBE + QoS2 PUBLISH`。pid 计数器从 1 递增到 2、3（最多 3 次重连）。

### 实现方式

- QoS2 出站：`main()` 里用 `@session.record_outbound(empty_store, qos2_pkt)` 预分配 pid 并记录到 SessionStore，再 `@core.ClientCore::with_session(opts, store)` 构造 core。CONNACK 后 MoonBit 侧把预编码的 QoS2 PUBLISH 字节和 SUBSCRIBE 字节一起 prepend 给 JS 发出。
- 断线重连：JS 胶水层 `onclose` 回调调 `spike_on_transport_close()`，然后 `setTimeout(openWs, 1000)` 重连；新 `onopen` 调 `spike_reconnect_bytes()` 重新编码 CONNECT。


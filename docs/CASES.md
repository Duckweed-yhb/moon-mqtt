# 端到端 I/O 案例

> 环境：Windows 11，`moon 0.1.20261012`，无头 Chrome，公共 EMQX `broker.emqx.io:8084`（WebSocket，子协议 `mqtt`）。
> 日期：2026-10-22。
> 在线页面：https://duckweed-yhb.github.io/moon-mqtt/docs/demo/

三份记录分别覆盖：首连 + 订阅 + 发布 QoS1 + 收到自己的消息；强制断开 + 自动重连 + `session_present=1`；QoS2 三段握手。

## 案例 1：浏览器连接、订阅、发布 QoS1、收到自己的消息

输入：

- `clean_session=false`，随机 `client_id`
- `SUBSCRIBE sensors/#`，QoS1
- 收到 SUBACK 后 `PUBLISH sensors/hello`，payload `hi`，QoS1

输出（页面控制台原文，2026-10-22 17:36 +08:00）：

```
[demo] client_id=moon-demo-bsd19a
[demo] connecting to broker.emqx.io:8084 (clean_session=false) ...
[browser] connecting to wss://broker.emqx.io:8084/mqtt
[browser] session_present=0
[demo] connected, subscribing sensors/# QoS1
[browser] suback
[demo] suback, publishing QoS1 sensors/hello
[demo] recv topic=sensors/hello payload=2 bytes
```

对应的关键报文（同轮 Node 记录里的标准帧）：

- CONNACK：`20 02 00 00`（`session_present=0`，Accepted）
- SUBACK：`90 03 00 01 01`（pid=1，QoS1 授予）
- 自己发出去的 QoS1 PUBLISH 被 broker 回投，页面收到 `sensors/hello`，payload 2 字节

截图：`demo/screenshot-browser.png`

## 案例 2：强制断开后自动重连，`session_present=1`

输入：点页面「强制断开（测试重连）」，触发 `globalThis.moonMQTTWs.close()`。

输出：

```
[browser] reconnect attempt #1 in 1s
[browser] connecting to wss://broker.emqx.io:8084/mqtt
[browser] session_present=1, replay 0 frame(s)
[demo] connected, subscribing sensors/# QoS1
[browser] suback
[demo] suback, publishing QoS1 sensors/hello
[demo] recv topic=sensors/hello payload=2 bytes
```

说明：

- `session_present=1` 表示 broker 保留了 `clean_session=false` 的会话
- `replay 0 frame(s)` 表示断开那一刻没有在途 QoS1/2 帧要重发；replay 路径本身由 `examples/resume` 和 `session/` 单测覆盖
- 重连成功后 `on_connect` 重新订阅，`on_suback` 再发一条，形成闭环

截图：`demo/screenshot-reconnect.png`

## 案例 3：QoS2 三段握手（js 后端 + Node 22）

输入：`examples/ws-spike` 在 CONNACK 后自动 `SUBSCRIBE sensors/# QoS1`，并发出预先记录的 `PUBLISH sensors/qos2`（QoS2，pid=1）。

输出（节选，原文）：

```
[spike] QoS2 PUBLISH prepared: pid=1 topic=sensors/qos2 payload=qos2 (1 bytes)
[spike] core start() generated CONNECT, 22 bytes
[spike] onopen, sending CONNECT, 22 bytes
[spike] onmessage hex: 20 02 00 00
[spike] core feed() events: [Connack(session_present=0, return_code=Accepted)]
[spike] sending SUBSCRIBE pid=1 sensors/# QoS1
[spike] sending QoS2 PUBLISH sensors/qos2 (22 bytes)
[spike] onmessage hex: 90 03 00 01 01
[spike] onmessage hex: 50 02 00 01
[spike] sending outgoing 4 bytes back to broker
```

握手链路：

- PUBLISH（QoS2，pid=1）→ broker 回 `PUBREC`：`50 02 00 01`
- `core.feed()` 自动产出 `PUBREL`：`62 02 00 01`，由胶水层写回
- broker 回 `PUBCOMP`：`70 02 00 01`，`SessionStore` 清掉在途
- 全程没有手写握手字节，状态迁移在 `session/`，字节编排在 `core/`

## 复现

浏览器：

```powershell
pwsh scripts/build-demo.ps1
python -m http.server 8765
# 打开 http://127.0.0.1:8765/docs/demo/
```

命令行（QoS2 日志）：

```powershell
moon build --target js examples/ws-spike
node "_build\js\debug\build\examples\ws-spike\ws-spike.js"
```

公共 broker 偶尔限流或超时，刷新页面重试即可。

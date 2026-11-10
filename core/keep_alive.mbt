// core/keep_alive.mbt — 保活决策（纯计算）。
//
// MQTT §3.1.2.10：客户端必须在 keep_alive 周期内发出任意报文，否则 broker
// 会断开连接。这里只回答两个问题：现在该不该发 PINGREQ、链路是不是已经死了。
// 真正发字节、关 socket 由调用方（browser / client）做，所以这段可以脱离
// WebSocket / TCP 单测。

///|
/// 保活动作。
pub enum KeepAliveAction {
  /// 还没到点，继续等。
  Wait
  /// 该发 PINGREQ 了。
  SendPing
  /// 连续多次没有 PINGRESP，判定链路已死，调用方应断开。
  Close
}

///|
/// 连续多少个 PINGREQ 没有 PINGRESP 就判定链路已死。
let max_unanswered_pings = 3

///|
/// 根据当前时间、上次发 PINGREQ 的时间、未应答计数与 keep_alive 决定下一步。
///
/// - `keep_alive_secs <= 0`：不保活，永远 `Wait`；
/// - `pending_pings >= 3`：链路已死，`Close`；
/// - 距上次发包已过 `keep_alive/2`：`SendPing`；
/// - 其余：`Wait`。
pub fn next_action(
  now_ms : Int32,
  last_ping_ms : Int32,
  pending_pings : Int32,
  keep_alive_secs : Int32,
) -> KeepAliveAction {
  if keep_alive_secs <= 0 {
    return Wait
  }
  if pending_pings >= max_unanswered_pings {
    return Close
  }
  if now_ms - last_ping_ms >= keep_alive_secs * 1000 / 2 {
    return SendPing
  }
  Wait
}

/// 连接状态机。
///
/// 最小连接状态机：
/// - Disconnected：未连接 / 已断开。
/// - Connecting：已 start() 发出 CONNECT，等 CONNACK。
/// - Connected：已收到 CONNACK(ConnectionAccepted)，可收发 PUBLISH / PING。
/// - Disconnecting：已发 DISCONNECT，等对端关闭。
///
/// 注：MoonBit enum variant 不能直接 == 比较，必须按仓库现有写法
/// 显式 extend Eq::{not_equal, equal} 与 Debug::{to_repr}。

pub enum CoreState {
  Disconnected
  Connecting
  Connected
  Disconnecting
} derive(Eq, Debug)

pub extend CoreState with Eq::{not_equal, equal}
pub extend CoreState with @moonbitlang/core/debug.Debug::{to_repr}

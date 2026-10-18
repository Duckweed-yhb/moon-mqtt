/// QoS（服务质量等级），见 OASIS MQTT 3.1.1 §4.3。
///
/// 0 = 至多一次（at most once）
/// 1 = 至少一次（at least once）
/// 2 = 恰好一次（exactly once）——PUBREC/PUBREL/PUBCOMP 握手
pub enum QoS {
  AtMostOnce
  AtLeastOnce
  ExactlyOnce
} derive(Eq, Debug)

// 显式声明 trait 方法提升，避免新版工具链 implicit_impl_as_method 弃用警告
pub extend QoS with Eq::{not_equal, equal}
pub extend QoS with @moonbitlang/core/debug.Debug::{to_repr}

/// QoS 到协议字节值（0/1/2）。
pub fn qos_value(q : QoS) -> Int {
  match q {
    QoS::AtMostOnce => 0
    QoS::AtLeastOnce => 1
    QoS::ExactlyOnce => 2
  }
}

/// 协议字节值（0..=2）到 QoS；非法值返回 None。
pub fn qos_from_int(v : Int) -> Option[QoS] {
  if v == 0 {
    Some(QoS::AtMostOnce)
  } else if v == 1 {
    Some(QoS::AtLeastOnce)
  } else if v == 2 {
    Some(QoS::ExactlyOnce)
  } else {
    None
  }
}

/// 以下常量函数用于 executable 包（examples 等）在 native 后端
/// 跨包引用 enum variant，避开 "Cannot create values of the read-only type"
/// 的工具链限制。
pub fn qos0() -> QoS { QoS::AtMostOnce }
pub fn qos1() -> QoS { QoS::AtLeastOnce }
pub fn qos2() -> QoS { QoS::ExactlyOnce }

test "qos_value" {
  assert_eq(qos_value(QoS::AtMostOnce), 0)
  assert_eq(qos_value(QoS::AtLeastOnce), 1)
  assert_eq(qos_value(QoS::ExactlyOnce), 2)
}

test "qos_from_int" {
  assert_eq(qos_from_int(0), Some(QoS::AtMostOnce))
  assert_eq(qos_from_int(2), Some(QoS::ExactlyOnce))
  assert_eq(qos_from_int(3), None)
  assert_eq(qos_from_int(-1), None)
}

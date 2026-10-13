/// 会话状态机：QoS 语义与握手边界。
///
/// QoS2 exactly-once 通过 PUBREC/PUBREL/PUBCOMP 三段握手保证恰好一次
/// （OASIS MQTT 3.1.1 §4.3.3）。本包以不可变函数式推进状态，四后端一致。

/// 报文标识分配器（1..65535 循环），保证同一会话内未完成握手不重复。
pub struct PacketIdAllocator {
  next : Int
}

pub fn PacketIdAllocator::new() -> PacketIdAllocator {
  return { next: 1 }
}

/// 分配一个标识，返回 (id, 新分配器)。
pub fn allocate(a : PacketIdAllocator) -> (Int, PacketIdAllocator) {
  let id = a.next
  let next = if id >= 0xFFFF { 1 } else { id + 1 }
  return (id, { next: next })
}

/// 发布侧 QoS2 握手状态。
pub enum Qos2Send {
  WaitPubrec // PUBLISH(qos2) 已发，等 PUBREC
  WaitPubcomp // PUBREL 已发，等 PUBCOMP
  Complete // 握手完成
} derive(Eq, Debug)

pub extend Qos2Send with Eq::{not_equal, equal}
pub extend Qos2Send with @moonbitlang/core/debug.Debug::{to_repr}

/// PUBLISH(qos2) 发出后进入等待 PUBREC。
pub fn qos2_send_started() -> Qos2Send {
  return Qos2Send::WaitPubrec
}

/// 收到 PUBREC：进入等待 PUBCOMP 并需发 PUBREL；重复 PUBREC 则重发 PUBREL。
pub fn qos2_on_pubrec(s : Qos2Send, packet_id : Int) -> (Qos2Send, Array[Int]) {
  match s {
    Qos2Send::WaitPubrec => (Qos2Send::WaitPubcomp, @protocol.encode_pubrel(packet_id))
    Qos2Send::WaitPubcomp => (s, @protocol.encode_pubrel(packet_id))
    Qos2Send::Complete => (s, [])
  }
}

/// 收到 PUBCOMP：握手完成。
pub fn qos2_on_pubcomp(s : Qos2Send, _packet_id : Int) -> Qos2Send {
  match s {
    Qos2Send::WaitPubcomp => Qos2Send::Complete
    _ => s
  }
}

/// 接收侧 QoS2 握手状态。
pub enum Qos2Recv {
  Idle
  WaitPubrel // 已回 PUBREC，等 PUBREL
  Complete // 已回 PUBCOMP
} derive(Eq, Debug)

pub extend Qos2Recv with Eq::{not_equal, equal}
pub extend Qos2Recv with @moonbitlang/core/debug.Debug::{to_repr}

/// 收到 PUBLISH(qos2)：回 PUBREC，进入等待 PUBREL。
pub fn qos2_on_publish(s : Qos2Recv, packet_id : Int) -> (Qos2Recv, Array[Int]) {
  match s {
    Qos2Recv::Idle => (Qos2Recv::WaitPubrel, @protocol.encode_pubrec(packet_id))
    _ => (s, [])
  }
}

/// 收到 PUBREL：回 PUBCOMP，握手完成。
pub fn qos2_on_pubrel(s : Qos2Recv, packet_id : Int) -> (Qos2Recv, Array[Int]) {
  match s {
    Qos2Recv::WaitPubrel => (Qos2Recv::Complete, @protocol.encode_pubcomp(packet_id))
    _ => (s, [])
  }
}

test "packet id allocator" {
  let a = PacketIdAllocator::new()
  match allocate(a) {
    (id, a2) => {
      assert_eq(id, 1)
      match allocate(a2) {
        (id2, _) => assert_eq(id2, 2)
      }
    }
  }
}

test "qos2 send handshake" {
  let s0 = qos2_send_started()
  assert_eq(s0, Qos2Send::WaitPubrec)
  match qos2_on_pubrec(s0, 10) {
    (s1, pubrel) => {
      assert_eq(s1, Qos2Send::WaitPubcomp)
      assert_eq(pubrel, [0x62, 0x02, 0x00, 0x0A])
      assert_eq(qos2_on_pubcomp(s1, 10), Qos2Send::Complete)
    }
  }
}

test "qos2 send duplicate pubrec" {
  let s = Qos2Send::WaitPubcomp
  match qos2_on_pubrec(s, 10) {
    (s2, pubrel) => {
      assert_eq(s2, Qos2Send::WaitPubcomp)
      assert_eq(pubrel, [0x62, 0x02, 0x00, 0x0A]) // 重发 PUBREL
    }
  }
}

test "qos2 recv handshake" {
  match qos2_on_publish(Qos2Recv::Idle, 5) {
    (s, pubrec) => {
      assert_eq(s, Qos2Recv::WaitPubrel)
      assert_eq(pubrec, [0x50, 0x02, 0x00, 0x05])
      match qos2_on_pubrel(s, 5) {
        (s2, pubcomp) => {
          assert_eq(s2, Qos2Recv::Complete)
          assert_eq(pubcomp, [0x70, 0x02, 0x00, 0x05])
        }
      }
    }
  }
}

test "qos2 recv out of order" {
  // 未收到 PUBLISH 前直接收到 PUBREL，应忽略（不破坏状态）
  match qos2_on_pubrel(Qos2Recv::Idle, 5) {
    (s, out) => {
      assert_eq(s, Qos2Recv::Idle)
      assert_eq(out, [])
    }
  }
}

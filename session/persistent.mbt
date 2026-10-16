/// 持久会话骨架（clean_session=false）：在途出站报文的保存与重连重放。
///
/// MQTT 3.1.1 §4.4：客户端断线后以 clean_session=false 重连，若 broker
/// 保留会话（CONNACK session_present=1），客户端必须重发所有尚未完成
/// QoS 握手的出站报文——PUBLISH 置 DUP=1；已发出 PUBREL 的重发 PUBREL。
///
/// 本模块只维护这份"在途清单"的纯计算状态，不触碰网络；实际落盘与
/// 读盘由 client/transport 层在 native 后端完成。四后端可编译可测。
/// 接收侧（入站 QoS2 未完成）的持久化留待后续。

/// 在途出站报文的发送阶段。
pub enum SendStage {
  WaitingPuback // QoS1：PUBLISH 已发，待 PUBACK
  WaitPubrec // QoS2：PUBLISH 已发，待 PUBREC
  WaitPubcomp // QoS2：PUBREL 已发，待 PUBCOMP
} derive(Eq, Debug)

pub extend SendStage with Eq::{not_equal, equal}
pub extend SendStage with @moonbitlang/core/debug.Debug::{to_repr}

/// 一条在途出站报文。`publish` 保留首次发送时的内容（含已分配的
/// packet_id、dup=false），重放时据此重编码并置 DUP=1。
pub struct InFlightEntry {
  packet_id : Int
  publish : @protocol.PublishPacket
  stage : SendStage
}

pub fn InFlightEntry::new(
  packet_id : Int, publish : @protocol.PublishPacket, stage : SendStage,
) -> InFlightEntry {
  return { packet_id, publish, stage }
}

pub fn InFlightEntry::packet_id(e : InFlightEntry) -> Int {
  return e.packet_id
}

pub fn InFlightEntry::stage(e : InFlightEntry) -> SendStage {
  return e.stage
}

pub fn InFlightEntry::publish(e : InFlightEntry) -> @protocol.PublishPacket {
  return e.publish
}

/// 持久会话存储：在途出站报文清单 + 报文标识游标。
///
/// 字段本身即"可保存的结构"：落盘层只需遍历 `inflight_entries` 与
/// `next_id`，恢复时用 `from_parts` 重建。
pub struct SessionStore {
  inflight : Array[InFlightEntry]
  next_id : Int
}

/// 空会话（新连接 clean_session=true，或首次以 clean_session=false 连接）。
pub fn SessionStore::new() -> SessionStore {
  return { inflight: [], next_id: 1 }
}

/// 从落盘数据重建会话（恢复路径）。next_id 越界时夹回合法范围。
pub fn SessionStore::from_parts(
  next_id : Int, entries : Array[InFlightEntry],
) -> SessionStore {
  let n = if next_id < 1 || next_id > 0xFFFF { 1 } else { next_id }
  return { inflight: entries, next_id: n }
}

/// 下一个待分配的报文标识游标（落盘时保存）。
pub fn SessionStore::next_id(s : SessionStore) -> Int {
  return s.next_id
}

/// 全部在途条目（返回拷贝，落盘层遍历用）。
pub fn SessionStore::inflight_entries(s : SessionStore) -> Array[InFlightEntry] {
  let out : Array[InFlightEntry] = []
  for e in s.inflight {
    out.push(e)
  }
  return out
}

pub fn SessionStore::inflight_count(s : SessionStore) -> Int {
  return s.inflight.length()
}

/// 扫描 next_id 起的 1..65535 范围，找第一个未被 inflight 占用的 packet_id。
/// MQTT §2.3.1：未完成握手期间的 packet_id 必须保留，不能复用。
/// 全部占用时返回 0（调用方应报"out of packet ids"错误）。
fn next_free_id(store : SessionStore) -> Int {
  // 从游标开始扫描一圈（最多 65535 次）
  let mut candidate = store.next_id
  for _ in 0..<65535 {
    let mut occupied = false
    for e in store.inflight {
      if e.packet_id == candidate {
        occupied = true
      }
    }
    if !occupied {
      return candidate
    }
    candidate = if candidate >= 0xFFFF { 1 } else { candidate + 1 }
  }
  return 0
}

/// 记录一次出站 PUBLISH 并分配报文标识。
/// QoS0 不入在途（握手无确认），返回 id=0 且不改变存储。
/// QoS1 → WaitingPuback；QoS2 → WaitPubrec。
/// 分配时跳过 inflight 已占用的 id（MQTT §2.3.1）；65535 个全部占用时 id=0 表示错误。
pub fn record_outbound(
  store : SessionStore, pkt : @protocol.PublishPacket,
) -> (SessionStore, Int) {
  match pkt.qos {
    @protocol.QoS::AtMostOnce => return (store, 0)
    _ => {
      let pid = next_free_id(store)
      if pid == 0 {
        return (store, 0) // 全部 id 已占用，调用方应处理
      }
      let next = if pid >= 0xFFFF { 1 } else { pid + 1 }
      let stage = match pkt.qos {
        @protocol.QoS::AtLeastOnce => SendStage::WaitingPuback
        _ => SendStage::WaitPubrec
      }
      let stored = pkt.with_packet_id(pid)
      let entry = { packet_id: pid, publish: stored, stage }
      // 拷贝一份再追加，避免别名污染入参 store
      let inflight : Array[InFlightEntry] = []
      for x in store.inflight {
        inflight.push(x)
      }
      inflight.push(entry)
      return ({ inflight, next_id: next }, pid)
    }
  }
}

fn remove_by_id(store : SessionStore, packet_id : Int) -> SessionStore {
  let out : Array[InFlightEntry] = []
  for e in store.inflight {
    if e.packet_id != packet_id {
      out.push(e)
    }
  }
  return { inflight: out, next_id: store.next_id }
}

/// 收到 PUBACK（QoS1 握手完成）：移除对应在途报文。
pub fn on_puback(store : SessionStore, packet_id : Int) -> SessionStore {
  return remove_by_id(store, packet_id)
}

/// 收到 PUBCOMP（QoS2 握手完成）：移除对应在途报文。
pub fn on_pubcomp(store : SessionStore, packet_id : Int) -> SessionStore {
  return remove_by_id(store, packet_id)
}

/// 收到 PUBREC：WaitPubrec→WaitPubcomp 并产出 PUBREL；
/// 重复 PUBREC（已在 WaitPubcomp）仍重发 PUBREL。
pub fn on_pubrec(
  store : SessionStore, packet_id : Int,
) -> (SessionStore, Array[Int]) {
  let mut out : Array[Int] = []
  let new_inflight : Array[InFlightEntry] = []
  for e in store.inflight {
    if e.packet_id == packet_id {
      match e.stage {
        SendStage::WaitPubrec => {
          new_inflight.push({ packet_id: e.packet_id, publish: e.publish, stage: SendStage::WaitPubcomp })
          out = @protocol.encode_pubrel(packet_id)
        }
        SendStage::WaitPubcomp => {
          new_inflight.push(e)
          out = @protocol.encode_pubrel(packet_id)
        }
        SendStage::WaitingPuback => new_inflight.push(e)
      }
    } else {
      new_inflight.push(e)
    }
  }
  return ({ inflight: new_inflight, next_id: store.next_id }, out)
}

/// 断线重连后需重发的报文序列（按原始发送序）。
/// - WaitingPuback / WaitPubrec：重编码 PUBLISH，DUP=1
/// - WaitPubcomp：重发 PUBREL
pub fn replay(store : SessionStore) -> Array[Array[Int]] {
  let out : Array[Array[Int]] = []
  for e in store.inflight {
    match e.stage {
      SendStage::WaitPubcomp => out.push(@protocol.encode_pubrel(e.packet_id))
      SendStage::WaitingPuback | SendStage::WaitPubrec =>
        out.push(@protocol.encode_publish(e.publish.with_dup(true)))
    }
  }
  return out
}

/// clean_session=true 或会话正式结束：清空在途状态。
pub fn reset(_store : SessionStore) -> SessionStore {
  return { inflight: [], next_id: 1 }
}

// ---------- 测试 ----------

// 注意：跨包不能直接构造 @protocol.QoS::Xxx（read-only type），
// 一律经 qos_from_int 构造、qos_value 比较，与 examples/pubsub 一致。
fn mk_publish(qos_val : Int) -> @protocol.PublishPacket {
  let qos = @protocol.qos_from_int(qos_val).unwrap()
  return @protocol.PublishPacket::new("t", [0x00], qos, false, false, 0)
}

test "record qos1 tracks inflight and assigns id" {
  let s0 = SessionStore::new()
  match record_outbound(s0, mk_publish(1)) {
    (s1, pid) => {
      assert_eq(pid, 1)
      assert_eq(s1.inflight_count(), 1)
      assert_eq(s1.next_id(), 2)
    }
  }
}

test "qos0 not tracked" {
  let s0 = SessionStore::new()
  match record_outbound(s0, mk_publish(0)) {
    (s1, pid) => {
      assert_eq(pid, 0)
      assert_eq(s1.inflight_count(), 0)
    }
  }
}

test "qos1 puback clears inflight" {
  let s0 = SessionStore::new()
  match record_outbound(s0, mk_publish(1)) {
    (s1, pid) => {
      let s2 = on_puback(s1, pid)
      assert_eq(s2.inflight_count(), 0)
      assert_eq(replay(s2).length(), 0)
    }
  }
}

test "replay qos1 publish sets dup flag" {
  let s0 = SessionStore::new()
  match record_outbound(s0, mk_publish(1)) {
    (s1, _pid) => {
      let frames = replay(s1)
      assert_eq(frames.length(), 1)
      // qos1=0x02, dup=0x08 → 首字节 0x3A
      assert_eq(frames[0][0], 0x3A)
      // 解码回的 PUBLISH 应带 dup=true、packet_id=1
      match @protocol.decode_publish(frames[0]) {
        Ok(p) => {
          assert_eq(p.dup, true)
          assert_eq(p.packet_id, 1)
          assert_eq(@protocol.qos_value(p.qos), 1)
        }
        Err(e) => fail(e)
      }
    }
  }
}

test "qos2 full handshake transitions and clears" {
  let s0 = SessionStore::new()
  match record_outbound(s0, mk_publish(2)) {
    (s1, pid) => {
      assert_eq(pid, 1)
      // 重连重放：WaitPubrec 阶段应重发 PUBLISH(dup=1, qos2)
      let frames = replay(s1)
      assert_eq(frames.length(), 1)
      assert_eq(frames[0][0], 0x3C) // qos2=0x04 | dup=0x08 | 0x30
      // PUBREC → WaitPubcomp + 产出 PUBREL
      match on_pubrec(s1, pid) {
        (s2, pubrel) => {
          assert_eq(pubrel, [0x62, 0x02, 0x00, 0x01])
          // 此时重放应发 PUBREL 而非 PUBLISH
          let frames2 = replay(s2)
          assert_eq(frames2.length(), 1)
          assert_eq(frames2[0], [0x62, 0x02, 0x00, 0x01])
          // 重复 PUBREC 仍重发 PUBREL，状态不变
          match on_pubrec(s2, pid) {
            (s3, pubrel2) => {
              assert_eq(pubrel2, [0x62, 0x02, 0x00, 0x01])
              assert_eq(s3.inflight_count(), 1)
            }
          }
          // PUBCOMP → 清空
          let s4 = on_pubcomp(s2, pid)
          assert_eq(s4.inflight_count(), 0)
          assert_eq(replay(s4).length(), 0)
        }
      }
    }
  }
}

test "replay preserves send order" {
  let s0 = SessionStore::new()
  let (s1, _) = record_outbound(s0, mk_publish(1))
  let (s2, _) = record_outbound(s1, mk_publish(1))
  let frames = replay(s2)
  assert_eq(frames.length(), 2)
  // 两帧均为 PUBLISH，packet_id 依次 1、2
  match @protocol.decode_publish(frames[0]) {
    Ok(p) => assert_eq(p.packet_id, 1)
    Err(e) => fail(e)
  }
  match @protocol.decode_publish(frames[1]) {
    Ok(p) => assert_eq(p.packet_id, 2)
    Err(e) => fail(e)
  }
}

test "reset clears session" {
  let s0 = SessionStore::new()
  let (s1, _) = record_outbound(s0, mk_publish(1))
  let s2 = reset(s1)
  assert_eq(s2.inflight_count(), 0)
  assert_eq(s2.next_id(), 1)
}

test "snapshot roundtrip via from_parts" {
  let s0 = SessionStore::new()
  let (s1, _) = record_outbound(s0, mk_publish(1))
  // 模拟落盘 → 读盘：取出 entries 与 next_id 后重建
  let restored = SessionStore::from_parts(s1.next_id(), s1.inflight_entries())
  assert_eq(restored.inflight_count(), 1)
  // 重放内容与原存储一致
  assert_eq(replay(restored), replay(s1))
}

test "next id skips inflight occupied" {
  // 第一次 publish 分配 id=1 并在途（未 ACK）
  let s0 = SessionStore::new()
  let (s1, pid1) = record_outbound(s0, mk_publish(1))
  assert_eq(pid1, 1)
  // 第二次 publish 时 id=1 仍被占用，应跳到 id=2（游标单调前进）
  let (s2, pid2) = record_outbound(s1, mk_publish(1))
  assert_eq(pid2, 2)
  // PUBACK 清掉 id=1 后，游标已前进到 3；id=2 仍在途，下次拿 3（不是复用 1）
  let s3 = on_puback(s2, pid1)
  match record_outbound(s3, mk_publish(1)) {
    (_s4, pid3) => assert_eq(pid3, 3)
  }
}

/// 异步非阻塞 MQTT 客户端外观。
///
/// 不持有任何 socket / 定时器 / 运行时句柄，纯粹是 @core.ClientCore
/// 外面套一层「待发字节队列 + 事件队列」。调用方典型用法：
/// ```moonbit
/// let client = @async.AsyncClient::new(@protocol.ConnectPacket::new("async-demo"))
/// // 取走首字节（CONNECT 帧）交给自己的 socket 写出去
/// let first = client.drain_pending()
/// // ... 事件循环里：socket 收到字节就喂进来
/// client.feed_bytes(socket_recv_bytes)
/// // 把新事件分发给自己的 handler
/// for e in client.drain_events() { handle(e) }
/// // 把待发字节写回 socket
/// socket_send(client.drain_pending())
/// ```
pub struct AsyncClient {
  core : @core.ClientCore
  /// 待发出站字节（CONNECT 启动帧 / PUBACK / PUBREC / PUBREL / PUBCOMP
  /// / 业务 PUBLISH 编码结果）。由调用方在事件循环里 drain 走。
  mut pending : Array[Int]
  /// 待派发事件（CONNACK / PUBLISH / SUBACK / PINGRESP ...）。
  mut events_buf : Array[@core.CoreEvent]
}

/// 构造一个异步客户端：内部立刻调用 `core.start()`，把首条 CONNECT
/// 帧塞进待发队列——调用方拿到实例后第一件事通常就是 `drain_pending()`
/// 把它写进 socket。
pub fn AsyncClient::new(opts : @protocol.ConnectPacket) -> AsyncClient {
  let core = @core.ClientCore::new(opts)
  let connect_bytes = core.start()
  return {
    core,
    pending: connect_bytes,
    events_buf: [],
  }
}

/// 把 socket 收到的字节喂给底层 core。core.feed 产出的事件与出站字节
/// 分别累加进 `events_buf` 与 `pending`，由调用方稍后 drain。
///
/// 收到成功 CONNACK 时补上会话语义：
/// - `session_present=true`：broker 保留了会话，按 SessionStore 重发在途
///   QoS1/2 报文（PUBLISH DUP=1 / PUBREL），否则断线前的未确认消息永远丢失；
/// - `session_present=false`：broker 已丢会话，清空本地在途，避免下次重连
///   把僵尸报文重放给新会话。
pub fn AsyncClient::feed_bytes(self : AsyncClient, bytes : Array[Int]) -> Unit {
  match self.core.feed(bytes) {
    (events, outgoing) => {
      for b in outgoing {
        self.pending.push(b)
      }
      for e in events {
        match e {
          @core.CoreEvent::ConnackReceived(c) => {
            match c.return_code {
              @protocol.ConnectReturnCode::ConnectionAccepted => {
                if c.session_present {
                  for frame in self.core.replay_bytes() {
                    for b in frame {
                      self.pending.push(b)
                    }
                  }
                } else {
                  self.core.reset_session()
                }
              }
              _ => ()
            }
          }
          _ => ()
        }
        self.events_buf.push(e)
      }
    }
  }
}

/// 取走当前待发出站字节并清空队列。调用方应把返回的字节原样写回自己
/// 的 socket / WebSocket / 串口。
pub fn AsyncClient::drain_pending(self : AsyncClient) -> Array[Int] {
  let out = self.pending
  self.pending = []
  return out
}

/// 取走当前待派发事件并清空队列。调用方按 @core.CoreEvent 的 variant
/// 分发给自己的 handler（on_connect / on_message / on_suback ...）。
pub fn AsyncClient::drain_events(self : AsyncClient) -> Array[@core.CoreEvent] {
  let evs = self.events_buf
  self.events_buf = []
  return evs
}

/// 当前连接状态（只读透传）。
pub fn AsyncClient::state(self : AsyncClient) -> @core.CoreState {
  return self.core.state()
}

/// 发布消息：透传 core.publish，把编码结果（若有）塞进待发队列。
/// QoS0/1/2 语义与 @core.ClientCore::publish 一致：未 Connected 时返回
/// 空，QoS1/2 由 core 自动分配 packet_id 并记入在途。
pub fn AsyncClient::publish(
  self : AsyncClient, topic : String, payload : Array[Int], qos : @protocol.QoS,
) -> Unit {
  let bytes = self.core.publish(topic, payload, qos)
  for b in bytes {
    self.pending.push(b)
  }
}

/// 发出 PINGREQ：透传 core.pingreq，把字节塞进待发队列。
pub fn AsyncClient::pingreq(self : AsyncClient) -> Unit {
  let bytes = self.core.pingreq()
  for b in bytes {
    self.pending.push(b)
  }
}

/// 主动断开：透传 core.disconnect，把 DISCONNECT 帧塞进待发队列，
/// 调用方 drain_pending 后写回 socket 即可。
pub fn AsyncClient::disconnect(self : AsyncClient) -> Unit {
  let bytes = self.core.disconnect()
  for b in bytes {
    self.pending.push(b)
  }
}

/// 订阅一个 topic：分配 packet_id、编码 SUBSCRIBE 帧、塞进待发队列，
/// 同时在 Core 的 pending_subscribes 里登记 (pid, subs)。后续收到 SUBACK
/// 且 `all_accepted()` 时 Core 会自动把这条订阅写入本地订阅表，重连后自动重订。
///
/// **只在 Connected 状态下生效**：CONNECT 发出后到 CONNACK 回来之前调用会被
/// 静默忽略（不产生任何字节），避免在 MQTT 连接建立前发出 SUBSCRIBE。
pub fn AsyncClient::subscribe(
  self : AsyncClient, topic : String, qos : @protocol.QoS,
) -> Unit {
  match self.core.state() {
    @core.CoreState::Connected => ()
    _ => return
  }
  let pid = self.core.allocate_control_packet_id()
  if pid == 0 {
    return
  }
  let subs = [@protocol.Subscription::new(topic, qos)]
  self.core.record_outbound_subscribe(pid, subs)
  let frame = @protocol.encode_subscribe(@protocol.SubscribePacket::new(pid, subs))
  for b in frame {
    self.pending.push(b)
  }
}

/// 退订一个 topic：编码 UNSUBSCRIBE 帧塞进待发队列，同时从本地订阅表删除。
/// 这样断线重连后不会把已经退订的 topic 自动重订回去。
///
/// 与 `subscribe` 一样，只在 Connected 状态下生效。
pub fn AsyncClient::unsubscribe(self : AsyncClient, topic : String) -> Unit {
  match self.core.state() {
    @core.CoreState::Connected => ()
    _ => return
  }
  let pid = self.core.allocate_control_packet_id()
  if pid == 0 {
    return
  }
  let pkt = @protocol.UnsubscribePacket::new(pid, [topic])
  let frame = @protocol.encode_unsubscribe(pkt)
  for b in frame {
    self.pending.push(b)
  }
  self.core.forget_subscription(topic)
}

/// 通知底层 transport 已断开（对端关闭 / 网络异常），状态切回
/// Disconnected。SessionStore 保留，供重连后 replay。
pub fn AsyncClient::on_transport_close(self : AsyncClient) -> Unit {
  self.core.on_transport_close()
}

/// 重连：复用同一 ConnectPacket 重新编码 CONNECT，塞进待发队列，
/// 状态切回 Connecting。在途消息在收到 session_present=1 的 CONNACK 时
/// 由 `feed_bytes` 自动重发。
pub fn AsyncClient::reconnect(self : AsyncClient) -> Unit {
  let bytes = self.core.reconnect_bytes()
  for b in bytes {
    self.pending.push(b)
  }
}

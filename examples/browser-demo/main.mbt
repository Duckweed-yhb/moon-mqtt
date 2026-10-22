/// examples/browser-demo — 浏览器 MQTT 客户端演示
///
/// 用 @browser 高层 API 连接 EMQX broker，订阅主题、发布消息、接收回调。

fn main() -> Unit {
  // DCE 防护
  let _ = @browser._browser_dce_protect()

  let client_id = demo_client_id()
  println("[demo] client_id=" + client_id)
  println("[demo] connecting to broker.emqx.io:8084 (clean_session=false) ...")
  let client = @browser.connect_persistent("broker.emqx.io", 8084, client_id)

  // 注册消息回调
  @browser.on_message(client, fn(topic, payload) {
    println(
      "[demo] recv topic=" + topic + " payload=" +
      payload.length().to_string() + " bytes",
    )
  })

  // 连接成功后订阅
  @browser.on_connect(client, fn() {
    println("[demo] connected, subscribing sensors/# QoS1")
    @browser.subscribe(client, "sensors/#", @protocol.qos1())
  })

  // SUBACK 之后再发布，保证 broker 已建立订阅，能收到自己发的消息
  @browser.on_suback(client, fn() {
    println("[demo] suback, publishing QoS1 sensors/hello")
    @browser.publish(client, "sensors/hello", [0x68, 0x69], @protocol.qos1())
  })

  println("[demo] running... (close browser tab to disconnect)")
}

/// 每个页面实例一个随机 client_id：clean_session=false 时重连能拿回同一个会话，
/// 同时避免多个观众用同一个 id 互相踢下线。
extern "js" fn demo_client_id() -> String =
  #|() => "moon-demo-" + Math.random().toString(36).slice(2, 8)

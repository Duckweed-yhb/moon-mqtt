/// examples/browser-demo — 浏览器 MQTT 客户端演示
///
/// 用 @browser 高层 API 连接 EMQX broker，订阅主题、发布消息、接收回调。

fn main() -> Unit {
  // DCE 防护
  let _ = @browser._browser_dce_protect()

  println("[demo] connecting to broker.emqx.io:8084 ...")
  let client = @browser.connect("broker.emqx.io", 8084, "browser-demo")

  // 注册消息回调
  @browser.on_message(client, fn(topic, payload) {
    println("[demo] recv topic=" + topic + " payload=" + payload.length().to_string() + " bytes")
  })

  // 连接成功后再订阅和发布
  @browser.on_connect(client, fn() {
    println("[demo] connected, subscribing sensors/# QoS1")
    @browser.subscribe(client, "sensors/#", @protocol.qos1())
    println("[demo] published sensors/hello payload=hi")
    @browser.publish(client, "sensors/hello", [0x68, 0x69], @protocol.qos0())
  })

  println("[demo] running... (close browser tab to disconnect)")
}

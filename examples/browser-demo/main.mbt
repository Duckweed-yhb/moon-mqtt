/// examples/browser-demo — 浏览器 MQTT 客户端演示
///
/// 用 @browser 高层 API 连接 EMQX broker，订阅主题、发布消息、接收回调。
///
/// 两种模式：
/// - 普通打开：clean_session=false，演示「持久会话」——重连后 broker 回
///   session_present=1，订阅还在，客户端只需重放在途报文。
/// - `?autotest=1`：clean_session=true，演示「应用层会话恢复」——重连后
///   broker 一定回 session_present=0，由 core 自动把本地记录的订阅重订一遍。

// 是否已经手动订阅过：重连时不重复订阅，把重订交给 core 自己做。
let g_subscribed : Array[Bool] = [false]

fn main() -> Unit {
  // DCE 防护
  let _ = @browser._browser_dce_protect()

  let client_id = demo_client_id()
  let autotest = is_autotest()
  println("[demo] client_id=" + client_id)
  if autotest {
    println("[demo] connecting to broker.emqx.io:8084 (clean_session=true, autotest) ...")
  } else {
    println("[demo] connecting to broker.emqx.io:8084 (clean_session=false) ...")
  }
  let client = if autotest {
    @browser.connect("broker.emqx.io", 8084, client_id)
  } else {
    @browser.connect_persistent("broker.emqx.io", 8084, client_id)
  }

  // 注册消息回调
  @browser.on_message(client, fn(topic, payload) {
    println(
      "[demo] recv topic=" + topic + " payload=" +
      payload.length().to_string() + " bytes",
    )
  })

  // 连接成功后订阅。只在首次连接时手动订阅一次：重连后不再重复订阅，
  // 这样 autotest 里看到的第二次 SUBACK 才是 core 自动重订的结果。
  @browser.on_connect(client, fn() {
    if g_subscribed[0] {
      println("[demo] reconnected, rely on core auto-resubscribe")
    } else {
      g_subscribed[0] = true
      println("[demo] connected, subscribing sensors/# QoS1")
      @browser.subscribe(client, "sensors/#", @protocol.qos1())
    }
  })

  // SUBACK 之后再发布，保证 broker 已建立订阅，能收到自己发的消息
  @browser.on_suback(client, fn() {
    println("[demo] suback, publishing QoS1 sensors/hello")
    @browser.publish(client, "sensors/hello", [0x68, 0x69], @protocol.qos1())
  })

  println("[demo] running... (close browser tab to disconnect)")
}

/// 读 URL 上的 ?autotest 参数：页面自检模式用 clean_session=true。
extern "js" fn is_autotest() -> Bool =
  #|() => {
  #|  if (typeof location === "undefined") return false;
  #|  return new URLSearchParams(location.search).has("autotest");
  #|}

/// 每个页面实例一个随机 client_id：clean_session=false 时重连能拿回同一个会话，
/// 同时避免多个观众用同一个 id 互相踢下线。
extern "js" fn demo_client_id() -> String =
  #|() => "moon-demo-" + Math.random().toString(36).slice(2, 8)

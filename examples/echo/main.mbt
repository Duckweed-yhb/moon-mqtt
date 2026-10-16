/// echo 示例：订阅 topic，收到 PUBLISH 后回发 echo/<topic>。
///
/// 演示 subscribe_with_handler + poll_once 的典型用法：
/// 主循环反复调 poll_once()，收到 broker 推来的 PUBLISH 时触发回调。
///
/// 本地起 mosquitto 后：
///   moon run examples/echo
/// 另开一个终端：
///   mosquitto_pub -t test/1 -m hello
/// 会看到本程序打印并回发 echo/test/1。

async fn run() -> Unit {
  let cli = match @client.connect("127.0.0.1", 1883, "moonbit-echo-demo") {
    Ok(c) => c
    Err(e) => {
      @debug.log("connect failed: " + e)
      return
    }
  }
  match cli.subscribe_with_handler(
    "test/#", @protocol.QoS::AtLeastOnce,
    fn(topic, payload) {
      @debug.log("recv [" + topic + "] len=" + payload.length().to_string())
      // 回发 echo/<topic>
      let echo_topic = "echo/" + topic
      match cli.publish(echo_topic, payload, @protocol.QoS::AtMostOnce) {
        Ok(_) => ()
        Err(e) => @debug.log("echo publish failed: " + e)
      }
    },
  ) {
    Ok(_) => @debug.log("subscribed test/#, polling...")
    Err(e) => @debug.log("subscribe failed: " + e)
  }
  // 主循环：反复 poll_once，每次处理一帧
  loop {
    match cli.poll_once() {
      Ok(_) => ()
      Err(e) => {
        @debug.log("poll ended: " + e)
        break
      }
    }
  }
  match cli.disconnect() {
    Ok(_) => ()
    Err(e) => @debug.log("disconnect: " + e)
  }
}

fn main {
  run()
}

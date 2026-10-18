/// reconnect 演示：poll_loop 失败就 reconnect，最多重试 5 次。
///
/// 验证方法：起 mosquitto 后跑本示例；中途 stop/start mosquitto，
/// 观察日志里 reconnect 成功后能继续收到 sensors/+ 的 PUBLISH。
/// clean_session=false 时 broker 保留订阅，重连后无需重发 SUBSCRIBE；
/// 本示例 opts 用 clean_session=false 演示这一行为。

fn main() -> Unit {
  let opts = @protocol.ConnectPacket::new("reconnect-demo")
    .with_keep_alive(30)
    .with_clean_session(false)

  // 首次连接
  let mut c = match @client.connect_opts("127.0.0.1", 1883, opts) {
    Ok(x) => x
    Err(e) => {
      println("initial connect failed: " + e)
      return
    }
  }
  // 订阅 sensors/+，收到消息打印
  match c.subscribe_with_handler(
    "sensors/+",
    @protocol.QoS::AtLeastOnce,
    fn(topic, payload) {
      let s = String::from_array(payload.map(fn(b) { b.to_char().unwrap() }))
      println("recv " + topic + " = " + s)
    },
  ) {
    Ok(_) => ()
    Err(e) => println("subscribe failed: " + e)
  }

  // 主循环：poll_loop 10 秒，失败就 reconnect，最多 5 次
  let mut retries = 0
  let mut done = false
  while !done {
    match c.poll_loop(10, 1000) {
      Ok(_) => {
        println("poll_loop clean return, exiting.")
        done = true
      }
      Err(e) => {
        println("poll_loop error: " + e + " -- reconnecting...")
        retries = retries + 1
        if retries > 5 {
          println("too many retries, giving up.")
          done = true
        } else {
          match c.reconnect() {
            Ok(new_c) => {
              c = new_c
              println("reconnected. session_present=" + c.is_session_present().to_string())
            }
            Err(e2) => {
              println("reconnect failed: " + e2)
              done = true
            }
          }
        }
      }
    }
  }
  match c.disconnect() {
    Ok(_) => ()
    Err(_) => ()
  }
}

/// will 演示：CONNECT 带 will 字段。
///
/// 连 localhost:1883，client_id=will-demo，will_topic=status，
/// will_message=offline。正常 disconnect 不会发 will；直接杀进程、
/// 网络断开、或 broker 判定心跳超时，broker 才会向 status 发 will。
///
/// 验证：另开终端 `mosquitto_sub -h localhost -t status -v`，
/// 然后 `./will.exe`，Ctrl+C 正常退出看不到 will；
/// 改成 kill -9 或断网，就能在订阅端看到 `status offline`。

fn main() -> Unit {
  let opts = @protocol.ConnectPacket::new("will-demo")
    .with_keep_alive(30)
    .with_clean_session(true)
    .with_will(
      "status",
      [0x6F, 0x66, 0x66, 0x6C, 0x69, 0x6E, 0x65], // "offline"
      @protocol.QoS::AtLeastOnce,
      false,
    )
  println("connecting localhost:1883 with will on topic 'status'...")
  match @client.connect_opts("127.0.0.1", 1883, opts) {
    Ok(c) => {
      println("connected. sending online message, then sleep 10s...")
      // 先在同一个 topic 发一条 online，方便对照
      match c.publish(
        "status",
        [0x6F, 0x6E, 0x6C, 0x69, 0x6E, 0x65], // "online"
        @protocol.QoS::AtLeastOnce,
      ) {
        Ok(_) => ()
        Err(e) => println("publish failed: " + e)
      }
      // sleep 10 秒；这期间 kill -9 本进程就会触发 will
      // （MoonBit 没有 sleep，用 poll_loop 占住 10 秒）
      match c.poll_loop(10, 1000) {
        Ok(_) => ()
        Err(e) => println("poll_loop ended: " + e)
      }
      match c.disconnect() {
        Ok(_) => println("clean disconnect, will NOT fire.")
        Err(e) => println("disconnect: " + e)
      }
    }
    Err(e) => println("connect failed: " + e)
  }
}

///|
let usage = "moon-mqtt pub HOST PORT TOPIC MESSAGE\nmoon-mqtt sub HOST PORT FILTER [--once]\nMQTT 3.1.1 / TCP / QoS 1"

///|
fn run(args : Array[String]) -> Result[Unit, String] {
  if args.length() == 2 && args[1] == "--help" {
    println(usage)
    return Ok(())
  }
  if args.length() < 5 {
    return Err(usage)
  }
  let once = args.length() == 6 && args[5] == "--once"
  match args[1] {
    "pub" if args.length() == 6 => ()
    "sub" if args.length() == 5 || once => ()
    _ => return Err(usage)
  }
  let port = @string.parse_int(args[3]) catch {
    _ => return Err("invalid port")
  }
  if port < 1 || port > 65535 {
    return Err("port must be in 1..65535")
  }
  let topic = args[4]
  let validation = if args[1] == "pub" {
    @client.validate_publish_topic(topic)
  } else {
    @protocol.validate_topic_filter(topic)
  }
  if validation is Err(reason) {
    return Err(reason)
  }
  let client = match
    @client.connect(args[2], port, "m" + @env.now().to_string() + args[1]) {
    Ok(client) => client
    Err(reason) => return Err(reason)
  }
  let result = if args[1] == "pub" {
    let result = client.publish(
      topic,
      @protocol.utf8_encode(args[5]),
      @protocol.qos1(),
    )
    if result is Ok(_) {
      println("PUBACK " + topic)
    }
    result
  } else {
    subscribe(client, topic, once)
  }
  let closed = client.disconnect()
  match result {
    Err(_) => result
    Ok(_) => closed
  }
}

///|
fn subscribe(
  client : @client.MqttClient,
  topic : String,
  once : Bool,
) -> Result[Unit, String] {
  let mut received = false
  let result = client.subscribe_with_handler(topic, @protocol.qos1(), fn(
    name,
    payload,
  ) {
    let body = match @protocol.utf8_decode(payload, 0, payload.length()) {
      Ok(value) => value
      Err(_) => "<binary: " + payload.length().to_string() + " bytes>"
    }
    println(name + " " + body)
    received = true
  })
  if result is Err(reason) {
    return Err(reason)
  }
  println("SUBACK " + topic)
  while !once || !received {
    if client.poll_loop(1, 1000) is Err(reason) {
      return Err(reason)
    }
  }
  Ok(())
}

///|
fn main {
  if run(@env.args()) is Err(reason) {
    println(reason)
    @env.exit(1)
  }
}

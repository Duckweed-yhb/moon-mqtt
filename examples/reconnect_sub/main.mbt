///|
fn main {
  let port = @string.parse_int(@env.args()[1]) catch {
    _ => abort("invalid port")
  }
  let opts = @protocol.ConnectPacket::new("resume-sub").with_clean_session(
    false,
  )
  let first = @client.connect_opts("127.0.0.1", port, opts).unwrap()
  ignore(
    first
    .subscribe_with_handler("demo/temperature", @protocol.qos2(), fn(
      _,
      payload,
    ) {
      println("delivery " + payload[0].to_string())
    })
    .unwrap(),
  )
  ignore(first.poll_once(5000).unwrap())
  guard first.poll_once(5000) is Err(_) else { abort("expected disconnect") }
  let next = first.reconnect().unwrap()
  if !next.is_session_present() {
    ignore(next.poll_once(5000).unwrap())
  }
  ignore(next.poll_once(5000).unwrap())
  ignore(next.poll_once(5000).unwrap())
  ignore(next.disconnect().unwrap())
}

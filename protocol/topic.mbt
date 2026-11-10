///|
/// 主题名称校验（3.1.1 §4.7.1 + §3.3.2.1）：非空、UTF-8 字节长度 ≤65535、
/// 不含 U+0000，**且不含通配符**——PUBLISH 的 topic name 里出现 `+` / `#`
/// 是协议错误，broker 会直接断连。
///
/// 这条以前只写在 `client/`（native）里，而且没查通配符；`core/`（浏览器与
/// async 走的路径）完全没有校验。现在统一到 protocol，三处共用。
pub fn validate_topic_name(topic : String) -> Result[Unit, String] {
  let n = utf8_encode(topic).length()
  if n == 0 {
    return Err("empty topic")
  }
  if n > 65535 {
    return Err("topic too long (>65535 UTF-8 bytes)")
  }
  if topic.contains("\u{0000}") {
    return Err("topic contains NUL")
  }
  if topic.contains("+") || topic.contains("#") {
    return Err("publish topic must not contain wildcards")
  }
  Ok(())
}

///|
/// 主题过滤器校验（3.1.1 §4.7.1.2）：非空、长度合规、不含 U+0000，
/// `+` 必须独占一层，`#` 必须独占一层且只能是最后一层。
///
/// SUBSCRIBE 里塞进 `a/#/b` 这种过滤器，broker 会当协议错误断连，
/// 而客户端拿不到任何线索——所以要在编码前挡住。
pub fn validate_topic_filter(filter : String) -> Result[Unit, String] {
  let n = utf8_encode(filter).length()
  if n == 0 {
    return Err("empty topic filter")
  }
  if n > 65535 {
    return Err("topic filter too long (>65535 UTF-8 bytes)")
  }
  if filter.contains("\u{0000}") {
    return Err("topic filter contains NUL")
  }
  let parts = filter.split("/").to_array()
  for i in 0..<parts.length() {
    let seg = parts[i]
    if seg == "#" {
      if i != parts.length() - 1 {
        return Err("'#' must be the last level of a filter")
      }
    } else if seg.contains("#") {
      return Err("'#' must occupy an entire level")
    }
    if seg != "+" && seg.contains("+") {
      return Err("'+' must occupy an entire level")
    }
  }
  Ok(())
}

///|
/// 是否是可以发布到 broker 的主题名（见 `validate_topic_name`）。
pub fn is_valid_topic_name(topic : String) -> Bool {
  match validate_topic_name(topic) {
    Ok(_) => true
    Err(_) => false
  }
}

///|
/// 是否是可以用于订阅的主题过滤器（见 `validate_topic_filter`）。
pub fn is_valid_topic_filter(filter : String) -> Bool {
  match validate_topic_filter(filter) {
    Ok(_) => true
    Err(_) => false
  }
}

///|
/// Topic 过滤器匹配（3.1.1 §4.7）。
///
/// - '+' 匹配单层任意名称
/// - '#' 必须为过滤器最后一级，匹配 0 或多层
/// - 其余层级按字面精确匹配
pub fn topic_matches(filter : String, topic : String) -> Bool {
  // §4.7.2：通配符不匹配 $ 开头的系统主题（$SYS/...）。
  if topic.has_prefix("$") && (filter.has_prefix("#") || filter.has_prefix("+")) {
    return false
  }
  // 过滤器本身不合法就永不匹配（规则集中在 validate_topic_filter，避免两套）。
  if !is_valid_topic_filter(filter) {
    return false
  }
  let f = filter.split("/").to_array()
  let t = topic.split("/").to_array()
  let mut fi = 0
  let mut ti = 0
  while fi < f.length() {
    let fp = f[fi]
    if fp == "#" {
      return true
    }
    if ti >= t.length() {
      return false
    }
    if fp == "+" {
      ti = ti + 1
      fi = fi + 1
    } else {
      if fp != t[ti] {
        return false
      }
      fi = fi + 1
      ti = ti + 1
    }
  }
  return ti == t.length()
}

///|
test "exact match" {
  assert_eq(topic_matches("a/b/c", "a/b/c"), true)
  assert_eq(topic_matches("a/b/c", "a/b/d"), false)
  assert_eq(topic_matches("a/b", "a/b/c"), false)
  assert_eq(topic_matches("a/b/c", "a/b"), false)
}

///|
test "single level plus" {
  assert_eq(topic_matches("a/+/c", "a/x/c"), true)
  assert_eq(topic_matches("a/+/c", "a/x/y"), false)
  assert_eq(topic_matches("+/+/+", "a/b/c"), true)
}

///|
test "multi level hash" {
  assert_eq(topic_matches("a/#", "a"), true)
  assert_eq(topic_matches("a/#", "a/b/c"), true)
  assert_eq(topic_matches("#", "x/y/z"), true)
  assert_eq(topic_matches("a/#", "b/x"), false)
}

///|
test "combined plus and hash" {
  assert_eq(topic_matches("a/+/b/#", "a/x/b/y/z"), true)
  assert_eq(topic_matches("a/+/b/#", "a/x/c/y"), false)
}

///|
test "wildcards do not match $ topics" {
  assert_eq(topic_matches("#", "$SYS/broker"), false)
  assert_eq(topic_matches("+/broker", "$SYS/broker"), false)
  assert_eq(topic_matches("$SYS/#", "$SYS/broker"), true)
}

///|
test "invalid filters are rejected" {
  assert_eq(topic_matches("a/#/b", "a/x/b"), false)
  assert_eq(topic_matches("a/x+", "a/xy"), false)
}

///|
test "topic name: wildcards are not allowed in publish topics" {
  assert_true(is_valid_topic_name("sensors/temp"))
  assert_true(is_valid_topic_name("/a/b"))
  assert_false(is_valid_topic_name(""))
  // §3.3.2.1：PUBLISH 的 topic name 不许带通配符，带了 broker 直接断连。
  assert_false(is_valid_topic_name("a/+"))
  assert_false(is_valid_topic_name("a/#"))
  assert_false(is_valid_topic_name("abc\u{0000}def"))
  match validate_topic_name("a/+") {
    Ok(_) => fail("wildcard topic should be rejected")
    Err(e) => assert_true(e.contains("wildcard"))
  }
}

///|
test "topic filter: wildcard placement rules" {
  assert_true(is_valid_topic_filter("a/b/c"))
  assert_true(is_valid_topic_filter("a/+/c"))
  assert_true(is_valid_topic_filter("a/#"))
  assert_true(is_valid_topic_filter("#"))
  assert_true(is_valid_topic_filter("+"))
  assert_true(is_valid_topic_filter("/"))
  assert_false(is_valid_topic_filter(""))
  assert_false(is_valid_topic_filter("a/#/b"))
  assert_false(is_valid_topic_filter("a/x+"))
  assert_false(is_valid_topic_filter("a/++"))
  assert_false(is_valid_topic_filter("a/b#"))
  match validate_topic_filter("a/#/b") {
    Ok(_) => fail("'#' in the middle should be rejected")
    Err(e) => assert_true(e.contains("last level"))
  }
}

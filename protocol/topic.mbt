/// Topic 过滤器匹配（3.1.1 §4.7）。
///
/// - '+' 匹配单层任意名称
/// - '#' 必须为过滤器最后一级，匹配 0 或多层
/// - 其余层级按字面精确匹配

pub fn topic_matches(filter : String, topic : String) -> Bool {
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

test "exact match" {
  assert_eq(topic_matches("a/b/c", "a/b/c"), true)
  assert_eq(topic_matches("a/b/c", "a/b/d"), false)
  assert_eq(topic_matches("a/b", "a/b/c"), false)
  assert_eq(topic_matches("a/b/c", "a/b"), false)
}

test "single level plus" {
  assert_eq(topic_matches("a/+/c", "a/x/c"), true)
  assert_eq(topic_matches("a/+/c", "a/x/y"), false)
  assert_eq(topic_matches("+/+/+", "a/b/c"), true)
}

test "multi level hash" {
  assert_eq(topic_matches("a/#", "a"), true)
  assert_eq(topic_matches("a/#", "a/b/c"), true)
  assert_eq(topic_matches("#", "x/y/z"), true)
  assert_eq(topic_matches("a/#", "b/x"), false)
}

test "combined plus and hash" {
  assert_eq(topic_matches("a/+/b/#", "a/x/b/y/z"), true)
  assert_eq(topic_matches("a/+/b/#", "a/x/c/y"), false)
}

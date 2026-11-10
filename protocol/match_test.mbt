///|
/// `topic_matches` 的性质测试（固定种子生成输入）。
///
/// 手写用例只能覆盖想得到的形状；这里用生成器造「层级 + 通配符」的组合，
/// 断言几条与具体取值无关的性质：
///   1. 合法过滤器至少匹配它展开后的字面主题（`+`/`#` 各替换成一层）；
///   2. 匹配成立 ⇒ 过滤器合法（非法过滤器一律不匹配）；
///   3. 带 `#` 的过滤器匹配其前缀下的任意深度；
///   4. `$` 开头的主题不被通配符过滤器匹配（§4.7.2）。

///|
fn match_lcg(state : Int32) -> Int32 {
  (state * 1103515245 + 12345) & 0x7FFFFFFF
}

///|
/// 生成一个最多 4 层的过滤器：每层是字面、`+`，末尾可能是 `#`。
///
/// 只生成**合法**形状（`+` 独占一层、`#` 只出现在最后），
/// 是否合法交给被测函数判断。
fn gen_filter(state : Int32) -> (String, Int32) {
  let mut s = match_lcg(state)
  let levels = s % 4 + 1
  let mut filter = ""
  let mut i = 0
  while i < levels {
    s = match_lcg(s)
    if i > 0 {
      filter = filter + "/"
    }
    let pick = s % 3
    if pick == 0 {
      filter = filter + "+"
    } else {
      filter = filter + "l" + (s % 10).to_string()
    }
    i += 1
  }
  // 三分之一概率以 # 收尾
  s = match_lcg(s)
  if s % 3 == 0 {
    filter = filter + "/#"
  }
  (filter, s)
}

///|
/// 把过滤器里的 `+` 替换成一层字面、`#` 替换成任意两层，造一个「应当匹配」的主题。
fn realise(filter : String) -> String {
  let parts = filter.split("/").to_array()
  let out : Array[String] = []
  for seg in parts {
    let s = seg.to_owned()
    if s == "+" {
      out.push("x")
    } else if s == "#" {
      out.push("deep")
      out.push("er")
    } else {
      out.push(s)
    }
  }
  out.join("/")
}

///|
test "a realised topic always matches its filter" {
  let mut seed = 20261111
  let mut i = 0
  while i < 200 {
    let (filter, s) = gen_filter(seed)
    seed = s
    let topic = realise(filter)
    assert_true(@protocol.is_valid_topic_filter(filter))
    assert_eq(@protocol.topic_matches(filter, topic), true)
    // 主题自己也必须是一个合法主题名（无通配符）
    assert_true(@protocol.is_valid_topic_name(topic))
    i += 1
  }
}

///|
test "invalid filters never match anything" {
  for bad in ["a/#/b", "a/x+", "#/a", "a/++", ""] {
    assert_eq(@protocol.topic_matches(bad, "a/b"), false)
    assert_eq(@protocol.topic_matches(bad, "x"), false)
  }
}

///|
test "hash filter matches arbitrary depth but not $ topics" {
  let mut seed = 424242
  let mut i = 0
  while i < 100 {
    let (filter, s) = gen_filter(seed)
    seed = s
    if filter.split("/").to_array()[filter.split("/").to_array().length() - 1] ==
      "#" {
      let prefix = realise(filter)
      // 前缀本身与更深一层都应当匹配
      assert_eq(@protocol.topic_matches(filter, prefix), true)
      assert_eq(@protocol.topic_matches(filter, prefix + "/tail"), true)
      // $ 开头的主题不被通配符过滤器匹配（§4.7.2）
      if filter.has_prefix("#") || filter.has_prefix("+") {
        assert_eq(@protocol.topic_matches(filter, "$SYS/broker"), false)
      }
    }
    i += 1
  }
}

///|
test "exact filters match only themselves" {
  assert_eq(@protocol.topic_matches("a/b/c", "a/b/c"), true)
  assert_eq(@protocol.topic_matches("a/b/c", "a/b/c/d"), false)
  assert_eq(@protocol.topic_matches("a/b/c", "a/b"), false)
  // 空层是有效的一层：'a/' 与 'a' 不是同一个过滤器
  assert_eq(@protocol.topic_matches("a/", "a/"), true)
  assert_eq(@protocol.topic_matches("a/", "a"), false)
}

import unittest

include clip

suite "clip":
  test "unsafe":
    assert unsafe("a") == false
    assert unsafe("a'") == true
    assert unsafe(" ") == true

  test "reassemble":
    assert reassemble(@["foo"]) == "foo"
    assert reassemble(@["foo", "bar"]) == "foo bar"
    assert reassemble(@["", ""]) == "'' ''"
    assert reassemble(@["Hello World", "what"]) == "'Hello World' what"
    assert reassemble(@["Hello \"World", "wh'at"]) == "'Hello \"World' 'wh\"'\"at'"

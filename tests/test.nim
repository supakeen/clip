import unittest

include clip

suite "clip":
  test "unsafe":
    assert unsafe("a") == false
    assert unsafe("a'") == true
    assert unsafe(" ") == true
    assert unsafe("\"") == true
    assert unsafe("$IFS") == true
    assert unsafe("${IFS}") == true
    assert unsafe(";") == true

  test "reassemble":
    assert reassemble(@["foo"]) == "foo"
    assert reassemble(@["foo", "bar"]) == "foo bar"
    assert reassemble(@["", ""]) == "'' ''"
    assert reassemble(@["Hello World", "what"]) == "'Hello World' what"
    assert reassemble(@["Hello \"World", "wh'at"]) == "'Hello \"World' 'wh\"'\"at'"

  test "quote":
    assert quote("") == "''"
    assert quote("abc") == "abc"
    assert quote("a b") == "'a b'"

  test "parse/DefaultParser":
    assert parse(DefaultParser, @["-a", "b"]) == {"-a": @["b"]}.toTable
    assert parse(DefaultParser, @["-a", "b", "-a", "c"]) == {"-a": @["b", "c"]}.toTable
    assert parse(DefaultParser, @["--long", "long", "--long", "other"]) == {"--long": @["long", "other"]}.toTable

    assert parse(DefaultParser, @["-b", "with a space"]) == {"-b": @["'with a space'"]}.toTable

    # TODO fix parsing of these testcases
    # assert parse(DefaultParser, @["-b=\"with a space\""]) == {"-b": @["'with a space'"]}.toTable
    # assert parse(DefaultParser, @["--long=\"with a space\""]) == {"--long": @["'with a space'"]}.toTable

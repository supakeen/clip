import os
import re
import sequtils
import strutils

proc unsafe(arg: TaintedString): bool =
  find(arg, re"[^\w@%+=:,./-]") == -1

proc quote(arg: TaintedString): string =
  if len(arg) == 0:
    "''"
  elif unsafe(arg):
    arg.string
  else:
    "'" & arg.replace("'", "\"'\"") & "'"

proc reassemble(args: seq[TaintedString]): string =
  map(args, quote).join(" ")

echo reassemble(commandLineParams())

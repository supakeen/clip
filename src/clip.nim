import os
import sequtils
import strutils

proc quote(arg: TaintedString): string =
  "\"" & arg & "\""

proc reassemble(args: seq[TaintedString]): string =
  return map(args, quote).join(" ")

echo reassemble(commandLineParams())

import os
import re
import sequtils
import strutils

proc unsafe(arg: TaintedString): bool =
  # See if any characters that should be quoted are in an argument
  find(arg, re"[^\w@%+=:,./-]") != -1

proc quote(arg: TaintedString): string =
  # Quote a single argument. Empty strings get turned into '', strings that
  # have unsafe characters in them get wrapped in single quotes and single
  # quotes inside them put inside double quotes. If none of those apply the
  # original argument is returned.
  if len(arg) == 0:
    "''"
  elif unsafe(arg):
    "'" & arg.replace("'", "\"'\"") & "'"
  else:
    arg.string

proc reassemble(args: seq[TaintedString]): string =
  # Turn the argv as given to us by ``commandLineParams()`` back into an
  # escaped string. Note that this isn't necessarily the command line used to
  # invoke the program.
  map(args, quote).join(" ")

proc parse(args: seq[TaintedString]) =
  echo reassemble(args)

parse(commandLineParams())

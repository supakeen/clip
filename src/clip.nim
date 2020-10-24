import os
import re

import sequtils
import strutils

import tables

import npeg
import npeg/codegen

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

type ValueDict = Table[string, seq[string]]

# The DefaultParser follows the POSIX standard argument syntax very closely
# with the noteworthy exception that short options directly followed by a
# value are not allowed. Long options, a GNU extension, are also supported.
#
# See GNU documentation at: https://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html
let DefaultParser* = peg("Pairs", values: ValueDict):
  Pairs <- Pair * *(' ' * Pair) * !1
  SingleQuote <- '\''
  ShortOption <- Alnum
  LongOption <- +Alnum
  ShortPrefix <- '-'
  LongPrefix <- "--"
  Separator <- (Blank | '=')
  Key <- (ShortPrefix * ShortOption) | (LongPrefix * LongOption)
  UnquotedValue <- +Alnum
  QuotedValue <- SingleQuote * +(Alnum | Space) * SingleQuote
  Value <- (UnquotedValue | QuotedValue)
  Pair <- >Key * Separator * >Value:
    if values.hasKey($1):
      values[$1].add($2)
    else:
      values[$1] = @[$2]

proc parse*(parser: Parser, args: seq[TaintedString]): Table[string, seq[string]] =
  let input = reassemble(args)

  var
    values: Table[string, seq[string]]

  discard parser.match(input, values).ok

  return values

when isMainModule:
  echo parse(DefaultParser, commandLineParams())

# clip

Command-line parsing for [Nim](https://nim-lang.org/) with PEGs powered
by [npeg](https://github.com/zevv/npeg). `clip` lets you use your favorite
style of command line options.  

## TODO

- [ ] Support GNU parsing (mostly).
- [ ] `-d="foo bar"` -> `'-d=foo bar'` is currently not parsed correctly.
- [ ] Constraints on the output (exclusivity, etc).
- [ ] High level API to build CLI options.

## Installation

You can use [nimble](https://github.com/nim-lang/nimble) for installation.

```
nimble install clip
```

## Usage

```nim
import os
import clip

let cli = parse(DefaultParser, commandLineParams())
echo cli
```

## Bindings

Experimental Python bindings are being developed in the [vitani](https://github.com/supakeen/vitani)
project.

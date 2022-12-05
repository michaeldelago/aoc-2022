# Advent of Code 2022


## Building

If you don't have Roswell or a Common Lisp toolchain installed, the easiest way is with `earthly`:

`earthly +build`

Using GNU `make`:

`make`

As a Docker container:

`docker build -t michaeldelago/aoc-2022 .`

In a repl

```
rlwrap sbcl \
  --eval "(asdf:load-asd #P\"$(shell pwd)/aoc-2022.asd\")" \
  --eval '(ql:quickload :aoc-2022)'
[...]
* '(asdf:make :aoc-2022 :force t)'
```

## Usage

View help with `aoc-2022 -h`

```
mike@lorkhan $ build/aoc-2022 -h
Advent of Code 2022

Usage: aoc-2022 [-h|--help] [-d|--day DAY] [-a|--all] [-s|--sample] [--tz ARG]
                [-l|--latest]

Available options:
  -h, --help    display this help text
  -d, --day DAY day to execute
  -a, --all     run all days
  -s, --sample  use sample inputs
  --tz ARG      your timezone (if your machine doesn't use the local timezone)
  -l, --latest  execute the most recently completed day
```

View the results of a specific day with `aoc-2022 -d DAY`

```
mike@lorkhan $ build/aoc-2022 -d 2
====== Day  2 =======
Part one: 12156
Part two: 10835
```

Get all days that have been completed with `aoc-2022 -a`

```
mike@lorkhan $ build/aoc-2022 -a 
====== Day  1 =======
Part one: 71924
Part two: 2104
[...]
====== Day  4 =======
Part one: 580
Part two: 895
```

Get the latest day with `aoc-2022 -l`

```
mike@lorkhan $ build/aoc-2022 -l 
====== Day  4 =======
Part one: 580
Part two: 895
```

Use sample input with `aoc-2022 -s -l`

```
mike@lorkhan $ build/aoc-2022 -l -s
========== Day  4 ===========
Part one sample: 2
Part two sample: 4
```

## Running tests

Tests can be run with `make test`

## Questions that nobody asked

### Why common lisp?

I like it more than most other languages. I like the repl-based development more than the "1. write 2. compile" loop that so many languages use. I like the "multi-paradigm while leaning into functional programming" feel to the language. I like the quirky standard library, and it's documentation. I like the dynamic, simple, strong (with SBCL) types. The compiled code is fast (comparable to Go) and most compilers compile to a single, relatively portable binary. I really like that you can grab code from 2008 and it'll probably work just fine without any problems.

Alternatives considered, in order:

- Rust: I'd like to learn rust sooner or later :shrug:
- Elixir: I love elixir and I feel incredibly productive in it. The tooling is sublime and the standard library is well curated. Additionally, there's great support for it in the development environments that I use. 
- F#: An oddball language that I wish I could hack in more. Tooling in vim is *meh*, to my memory and I haven't written enough of it to feel effective.

### Why so much effort past getting the puzzles complete?

I don't get to write a lot as much Common Lisp (or code in general) as I like, as coming up with *unique* ideas that don't get stale is difficult for me. 

Writing out a CLI, using features like CLOS, and automatic input downloading give me "extra" challenges that can be really fun. 

### Why didn't you use X algorithm on Day Y?

I didn't think of it, I couldn't figure out how to make it readable, or the naive/less efficient implementation was good enough.

### Can I use any of your code?

Sure, Be aware it's 0BSD and the terms that come with that. I wrote this code for free in my personal time and even though most is probably fine, none of it should be considered production ready. 

### Can I contribute to this code?

No. These are my solutions to Advent of Code 2022, not yours ;)

If someone has a better hand at documenting than I do, I might take those. 

### You didn't use this super idiomatic common lisp technique!

Please shoot me an email (see GitHub bio), I'd love to chat and get better at the language

## Author

* Mike Delago

## Copyright

Copyright (c) 2022 Mike Delago

## License

Licensed under the 0BSD License.

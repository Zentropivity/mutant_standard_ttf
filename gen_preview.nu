#!/usr/bin/env nu
open ./out/meta.json | reduce -f [] {|it,acc| try { $acc | append (($it.code | char --integer ...$in))} catch { $acc } } | grid -s " " | save -f preview.txt

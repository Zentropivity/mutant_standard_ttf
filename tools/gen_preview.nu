#!/usr/bin/env nu

# Generate a text file with all the Mutant Standard emoji in a grid.
def main [out_path="./preview.txt"] {
  open ./out/meta.json | reduce -f [] {|it,acc| try { $acc | append (($it.code | char --integer ...$in))} catch { $acc } } | grid -s " " | save -f $out_path
}

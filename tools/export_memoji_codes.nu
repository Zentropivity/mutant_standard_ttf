#!/usr/bin/env nu

# Generate an easy to fuzzy find table text file for the Mutant Standard emoji characters
def main [out_path="./mutant_table.txt"] {
  open out/meta.json | reduce -f [] {|it,acc| try { $acc | append ([($it.code | char --integer ...$in), $it.short] | str join " " )} catch { $acc } } | str join "\n" | save -f $out_path
}

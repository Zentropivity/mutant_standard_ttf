#!/usr/bin/nu

# It is recommended to name the glyphs so here we go taking the short names. Undefined codepoints don't make it into the font unfortunately.
# according some page on the internet: http://silnrsi.github.io/FDBP/en-US/Glyph_Naming.html
# nanoemoji needs the generator to output csv like: filename,codepoints,glyphname
#TODO? this may need to be python? why no docs on glyphmap generator usage? I will keep searching...

#NOTE conversion from/to hex is like this
# ❯ 128488 | fmt | $in.lowerhex | str substring 2..
# 1f5e8
# ❯ "1f5e8" | into int --radix 16
# 128488

def main [...files] {
  let codes_req = $files | par-each {|fp| $fp | split row "/" | last 1 | get 0 | split row "." | get 0 | {path: $fp, code: $in} }
  let map = open "./out/unicode_map.json"
  return ($codes_req | par-each {|e| $"($e.path),($e.code | str replace --all "-" ","),($map | get $e.code | get glyph_name)"} | str join "\n")
}

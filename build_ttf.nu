#!/usr/bin/nu

# you should be running this from some venv...

#install deps
pip install -r orxporter/requirements.txt
pip install -e nanoemoji

#NOTE conversion from/to hex is like this
# ❯ 128488 | fmt | $in.lowerhex | str substring 2..
# 1f5e8
# ❯ "1f5e8" | into int --radix 16
# 128488

mkdir out
python ./orxporter/orxport.py -m ./mutant_standard/manifest/out.orx -i ../input -q 32x32 -o ./out/font_sources -F svg -t 8 -f %f/%u
python ./orxporter/orxport.py -m ./mutant_standard/manifest/out.orx -i ../input -j ./out/meta.json
open ./out/meta.json | reduce -f {} {|it, acc| try { let emoji = char --integer ...($it.code); $acc |
  insert ($it.code | each {|i| $i | fmt | $in.lowerhex | str substring 2..} | str join "-") {
    name: $it.short,
    glyph_name: (if 0 < ($it.short | find -r "^[0-9]" | length) { "_" | append $it.short | str join } else { $it.short })
  } } catch { $acc }} | to json | save -f ./out/unicode_map.json

# remove px from lengths as picosvg (used by nanoemoji) dies from it and its fine without px probably
ls ./out/font_sources/svg/ | get name | par-each {|fp| open $fp | str replace --all -r "(:[0-9.]+)px" "$1" | save -f $fp}

let version = open ./mutant_standard/manifest/font/manifest.json | $in.metadata.version | split row "."
let version_major = $version | get 0
let version_minor = $version | get 1

cd out
#TODO figure out glyphmap generation for glyph names in ttf
# nanoemoji --color_format glyf_colr_1 --glyphmap_generator ../glyphmap_generator.nu --family "Mutant Standard" --output_file MutantStandard-Regular.ttf --version_major $version_major --version_minor $version_minor ./font_sources/svg/*.svg
nanoemoji --color_format glyf_colr_1 --family "Mutant Standard" --output_file MutantStandard-Regular.ttf --version_major $version_major --version_minor $version_minor ./font_sources/svg/*.svg

#!/usr/bin/nu

# Build ttf font file for Mutant Standard.
# you should be running this from some venv...
def main [
  --install_deps (-i) # install the deps of orxporter and nanoemoji
  --all_formats (-a) # build all the formats that nanoemoji supports! (this may take a while)
  --no_generate (-n) # do not generate svg from the input files (may save you a few seconds when repeatedly building)
  format="cbdt" # cbdt|cff2_colr_0|cff2_colr_1|cff_colr_0|cff_colr_1|glyf|glyf_colr_0|glyf_colr_1|picosvg|picosvgz|sbix|untouchedsvg|untouchedsvgz
] {
  if $install_deps {
    pip install -r orxporter/requirements.txt
    pip install -e nanoemoji
  }

  if $all_formats {
    if (not $no_generate) {
      generate
    }
    [
      "cbdt",
      "cff2_colr_0",
      "cff2_colr_1",
      "cff_colr_0",
      "cff_colr_1",
      "glyf",
      "glyf_colr_0",
      "glyf_colr_1",
      "picosvg",
      "picosvgz",
      "sbix",
      "untouchedsvg",
      "untouchedsvgz",
    ] | each {|p| build_format $p e>| print -e | print}
    return null
  } else {
    if (not $no_generate) {
      generate
    }
    build_format $format
  }
}

def build_format [format] {
  if $format == "cbdt" {
    do_build "cbdt" "CBDT"
  } else if $format == "cff2_colr_0" {
    do_build "cff2_colr_0" "CFF2-COLR-0"
  } else if $format == "cff2_colr_1" {
    do_build "cff2_colr_1" "CFF2-COLR-1"
  } else if $format == "cff_colr_0" {
    do_build "cff_colr_0" "CFF-COLR-0"
  } else if $format == "cff_colr_1" {
    do_build "cff_colr_1" "CFF-COLR-1"
  } else if $format == "glyf" {
    do_build "glyf" "GLYF"
  } else if $format == "glyf_colr_0" {
    do_build "glyf_colr_0" "GLYF-COLR-0"
  } else if $format == "glyf_colr_1" {
    do_build "glyf_colr_1" "GLYF-COLR-1"
  } else if $format == "picosvg" {
    do_build "picosvg" "PICOSVG"
  } else if $format == "picosvgz" {
    do_build "picosvgz" "PICOSVGZ"
  } else if $format == "sbix" {
    do_build "sbix" "SBIX"
  } else if $format == "untouchedsvg" {
    do_build "untouchedsvg" "UNTOUCHEDSVG"
  } else if $format == "untouchedsvgz" {
    do_build "untouchedsvgz" "UNTOUCHEDSVGZ"
  } else {
    print $"Unrecognized format: ($format)"
    exit 1
  }
}

#NOTE conversion from/to hex is like this
# ❯ 128488 | fmt | $in.lowerhex | str substring 2..
# 1f5e8
# ❯ "1f5e8" | into int --radix 16
# 128488

# Generate output using orxporter
def generate [] {
  mkdir out
  python ./orxporter/orxport.py -m ./mutant_standard/manifest/out.orx -i ../input -q 32x32 -o ./out/font_sources -F svg -t 8 -f %f/%u
  python ./orxporter/orxport.py -m ./mutant_standard/manifest/out.orx -i ../input -j ./out/meta.json

  #TODO? use this for glyphmap name generation?
  open ./out/meta.json | reduce -f {} {|it, acc| try { let emoji = char --integer ...($it.code); $acc |
    insert ($it.code | each {|i| $i | fmt | $in.lowerhex | str substring 2..} | str join "-") {
      name: $it.short,
      glyph_name: (if 0 < ($it.short | find -r "^[0-9]" | length) { "_" | append $it.short | str join } else { $it.short })
    } } catch { $acc }} | to json | save -f ./out/unicode_map.json

  # remove px from lengths as picosvg (used by nanoemoji) dies from it and its fine without px probably
  ls ./out/font_sources/svg/ | get name | par-each {|fp| open $fp | str replace --all -r "(:[0-9.]+)px" "$1" | save -f $fp}
}

# Build it for real!
def do_build [
  color_format # nanoemoji color_format
  file_ext # text added to base ttf file name after "-" (no "-" if empty)
] {
  let version = open ./mutant_standard/manifest/font/manifest.json | $in.metadata.version | split row "."
  let version_major = $version | get 0
  let version_minor = $version | get 1

  let file_name = if $file_ext == "" { "MutantStandardEmoji.ttf" } else { $"MutantStandardEmoji-($file_ext).ttf" }
  # let build_dir = if $file_ext == "" { "./out/build/" } else { $"./out/TTF-($file_ext)/" }
  let build_dir = "./out/build/"
  mkdir $build_dir

  #TODO figure out glyphmap generation for glyph names in ttf
  # --glyphmap_generator ../glyphmap_generator.nu
  nanoemoji --color_format $color_format --family "Mutant Standard Emoji" --build_dir $build_dir --output_file $file_name --version_major $version_major --version_minor $version_minor ./out/font_sources/svg/*.svg
}

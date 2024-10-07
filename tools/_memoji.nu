#!/usr/bin/env nu

# Interactively pick an emoji then return it
# - returns null on a failed pick
# (uses sk from skim for fuzzy picking)
export def memoji []: nothing -> any {
  # let table_dir = $"($env.HOME)/.config/nushell/share"
  let table_dir = $"."
  let mutant_table = $"($table_dir)/mutant_table.txt"

  # sk may exit on cancel
  try {
    let moji = cat $mutant_table | sk | split row " " | get 0
    if (0 < ($moji | str length)) {
      $moji
    } else {
      null
    }
  }
}

# Copy an emoji to clipboard
# (uses wl-copy from wl-clipboard)
export def "memoji copy" [] {
  let moji = memoji
  if ($moji != null) {
    $moji | wl-copy
  }
}

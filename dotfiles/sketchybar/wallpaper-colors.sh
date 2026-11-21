#!/bin/bash
# Derive the sketchybar accent from the current wallpaper, then reload the bar.
set -euo pipefail

INDEX="$HOME/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
OUT="$HOME/.cache/sketchybar/colors.sh"

wallpaper_path() {
  if [ -f "$INDEX" ]; then
    local cfg url
    cfg=$(mktemp)
    if plutil -extract 'AllSpacesAndDisplays.Desktop.Content.Choices.0.Configuration' raw -o - "$INDEX" 2>/dev/null \
      | base64 -D > "$cfg" 2>/dev/null; then
      url=$(plutil -extract 'url.relative' raw -o - "$cfg" 2>/dev/null) || url=
      rm -f "$cfg"
      if [ -n "$url" ]; then
        printf '%s\n' "${url#file://}" | sed 's/%20/ /g'
        return 0
      fi
    else
      rm -f "$cfg"
    fi
  fi
  osascript -e 'tell application "Finder" to get POSIX path of (desktop picture as alias)' 2>/dev/null
}

if img=$(wallpaper_path) && [ -f "$img" ] \
  && matugen image "$img" -c "$HOME/.config/matugen/config.toml" \
       --prefer saturation >/dev/null 2>&1; then
  :
else
  rm -f "$OUT" # unsupported wallpaper: fall back to the static Flexoki accent
fi

sketchybar --reload >/dev/null 2>&1 || true

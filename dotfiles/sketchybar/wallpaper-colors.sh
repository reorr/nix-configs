#!/bin/bash
# Apply the wallpaper palette to sketchybar and the OmniWM focus border.
set -euo pipefail
export PATH="$PATH:/etc/profiles/per-user/$(id -un)/bin:/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin"

INDEX="$HOME/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
OUT="$HOME/.cache/sketchybar/colors.sh"
OMNI_SETTINGS="$HOME/.config/omniwm/settings.toml"

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

rgb_floats() { # 0xAARRGGBB -> "r g b" in 0..1
  local h=${1#0x}
  h=${h:2:6}
  awk -v r=$((16#${h:0:2})) -v g=$((16#${h:2:2})) -v b=$((16#${h:4:2})) \
    'BEGIN { printf "%.6f %.6f %.6f", r / 255, g / 255, b / 255 }'
}

patch_border() {
  local lr lg lb dr dg db tmp
  read -r lr lg lb <<< "$(rgb_floats "$ACCENT_LIGHT")"
  read -r dr dg db <<< "$(rgb_floats "$ACCENT_DARK")"
  tmp=$(mktemp)
  awk -v lr="$lr" -v lg="$lg" -v lb="$lb" -v dr="$dr" -v dg="$dg" -v db="$db" '
    BEGIN { light = 0; dark = 0; saw_dark = 0 }
    /^\[borders\.color\]$/ { light = 1; dark = 0; print; next }
    /^\[borders\.darkColor\]$/ { light = 0; dark = 1; saw_dark = 1; print; next }
    /^\[borders\.glow\]$/ {
      if (!saw_dark) {
        saw_dark = 1
        print "[borders.darkColor]"
        print "alpha = 1.0"
        print "red = " dr
        print "green = " dg
        print "blue = " db
        print ""
      }
      light = 0; dark = 0; print; next
    }
    /^\[/ { light = 0; dark = 0 }
    light && /^[ \t]*red[ \t]*=/ { print "red = " lr; next }
    light && /^[ \t]*green[ \t]*=/ { print "green = " lg; next }
    light && /^[ \t]*blue[ \t]*=/ { print "blue = " lb; next }
    dark && /^[ \t]*red[ \t]*=/ { print "red = " dr; next }
    dark && /^[ \t]*green[ \t]*=/ { print "green = " dg; next }
    dark && /^[ \t]*blue[ \t]*=/ { print "blue = " db; next }
    { print }
    END {
      if (!saw_dark) {
        print ""
        print "[borders.darkColor]"
        print "alpha = 1.0"
        print "red = " dr
        print "green = " dg
        print "blue = " db
      }
    }
  ' "$OMNI_SETTINGS" > "$tmp"
  mv "$tmp" "$OMNI_SETTINGS"
}

if img=$(wallpaper_path) && [ -f "$img" ] \
  && matugen image "$img" -c "$HOME/.config/matugen/config.toml" \
       --prefer saturation >/dev/null 2>&1; then
  source "$OUT"
  if [ -f "$OMNI_SETTINGS" ] && grep -q '^\[borders\.color\]$' "$OMNI_SETTINGS"; then
    patch_border
  fi
else
  rm -f "$OUT" # unsupported wallpaper: fall back to the static Flexoki accent
fi

sketchybar --reload >/dev/null 2>&1 || true

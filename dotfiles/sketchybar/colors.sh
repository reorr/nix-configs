#!/usr/bin/env bash

# Wallpaper-derived accent (matugen). Absent for unsupported wallpapers.
[ -f "$HOME/.cache/sketchybar/colors.sh" ] && source "$HOME/.cache/sketchybar/colors.sh"

# Flexoki light/dark palette, follows macOS appearance.
if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  MODE=Dark
  BASE=0xff1c1b1a
  SURFACE=0xff343331
  TEXT=0xffe6e4d9
  SUBTEXT=0xffb7b5ac
  DIM=0xff575653
  ACCENT=${ACCENT_DARK:-0xffbc5215}
  ACCENT_TEXT=${ACCENT_TEXT_DARK:-0xfffffcf0}
else
  MODE=Light
  BASE=0xfffffcf0
  SURFACE=0xffe6e4d9
  TEXT=0xff100f0f
  SUBTEXT=0xff6f6e69
  DIM=0xffb7b5ac
  ACCENT=${ACCENT_LIGHT:-0xffda702c}
  ACCENT_TEXT=${ACCENT_TEXT_LIGHT:-0xfffffcf0}
fi

RED=0xffaf3029
GREEN=0xff879a39
YELLOW=0xffd0a215

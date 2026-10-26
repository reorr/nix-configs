#!/usr/bin/env bash

# Flexoki light/dark palette, follows macOS appearance.
if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  MODE=Dark
  BASE=0xff1c1b1a
  SURFACE=0xff343331
  TEXT=0xffe6e4d9
  SUBTEXT=0xffb7b5ac
  DIM=0xff575653
  ACCENT=0xffbc5215
  ACCENT_TEXT=0xfffffcf0
else
  MODE=Light
  BASE=0xfffffcf0
  SURFACE=0xffe6e4d9
  TEXT=0xff100f0f
  SUBTEXT=0xff6f6e69
  DIM=0xffb7b5ac
  ACCENT=0xffda702c
  ACCENT_TEXT=0xfffffcf0
fi

RED=0xffaf3029
GREEN=0xff879a39
YELLOW=0xffd0a215

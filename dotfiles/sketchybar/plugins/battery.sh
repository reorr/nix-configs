#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

batt=$(pmset -g batt)
pct=$(printf '%s\n' "$batt" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
[ -z "$pct" ] && pct=0

if printf '%s\n' "$batt" | grep -q 'AC Power'; then
  if [ "$pct" -ge 100 ]; then
    icon=$'\xEF\x89\x80'
  else
    icon=$'\xEF\x83\xA7'
  fi
elif [ "$pct" -ge 90 ]; then
  icon=$'\xEF\x89\x80'
elif [ "$pct" -ge 65 ]; then
  icon=$'\xEF\x89\x81'
elif [ "$pct" -ge 35 ]; then
  icon=$'\xEF\x89\x82'
elif [ "$pct" -ge 10 ]; then
  icon=$'\xEF\x89\x83'
else
  icon=$'\xEF\x89\x84'
fi

sketchybar --set battery icon="$icon" icon.color="$ACCENT" label="${pct}%"

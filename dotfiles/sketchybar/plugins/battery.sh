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
  color="$TEXT"
elif [ "$pct" -ge 90 ]; then
  icon=$'\xEF\x89\x80'
  color="$TEXT"
elif [ "$pct" -ge 65 ]; then
  icon=$'\xEF\x89\x81'
  color="$TEXT"
elif [ "$pct" -ge 35 ]; then
  icon=$'\xEF\x89\x82'
  color="$TEXT"
elif [ "$pct" -ge 10 ]; then
  icon=$'\xEF\x89\x83'
  color="$TEXT"
else
  icon=$'\xEF\x89\x84'
  color="$RED"
fi

sketchybar --set battery icon="$icon" icon.color="$color" label="${pct}%"

#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"
export PATH="/etc/profiles/per-user/ulatbulu/bin:/run/current-system/sw/bin:/usr/bin:/bin"

# Reload the whole config once when macOS appearance flips.
cache="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar_theme"
mkdir -p "$(dirname "$cache")"
prev=$(cat "$cache" 2>/dev/null)
if [ "$MODE" != "$prev" ]; then
  printf '%s' "$MODE" > "$cache"
  if [ -n "$prev" ]; then
    sketchybar --reload
    exit 0
  fi
fi

json=$(omniwmctl query workspace-bar --format json 2>/dev/null) || exit 0
[ -z "$json" ] && exit 0

mon=$(printf '%s' "$json" | jq -r 'if .ok then .result.payload.interactionMonitorId else empty end')
[ -z "$mon" ] && exit 0

# Visible workspaces for the active monitor: number, displayName, focused apps.
while IFS=$'\t' read -r num name apps; do
  [ -z "$num" ] && continue
  if [ -n "$apps" ]; then
    sketchybar --set "ws.$num" drawing=on label="$name  $apps" label.color="$ACCENT_TEXT" \
      background.drawing=on background.color="$ACCENT"
  else
    sketchybar --set "ws.$num" drawing=on label="$name" label.color="$SUBTEXT" \
      background.drawing=off
  fi
done < <(printf '%s' "$json" | jq -r --arg mon "$mon" '
  .result.payload.monitors[] | select(.id == $mon) | .workspaces[] |
  [ (.number | tostring),
    .displayName,
    (if .isFocused then ([.windows[].appName] | unique | join(" · ")) else "" end)
  ] | @tsv')

# Hide workspace items that do not exist on this monitor.
present=" $(printf '%s' "$json" | jq -r --arg mon "$mon" '.result.payload.monitors[] | select(.id == $mon) | .workspaces[].number' | paste -sd ' ' -) "
for i in 1 2 3 4 5 6 7 8 9; do
  case "$present" in
    *" $i "*) ;;
    *) sketchybar --set "ws.$i" drawing=off ;;
  esac
done

# Front app = focused window in the active workspace.
app=$(printf '%s' "$json" | jq -r --arg mon "$mon" '
  [ .result.payload.monitors[] | select(.id == $mon) | .workspaces[] | select(.isFocused) |
    .windows[] | select(.isFocused) | .appName ] | first // empty')
[ -n "$app" ] && sketchybar --set front_app label="$app"

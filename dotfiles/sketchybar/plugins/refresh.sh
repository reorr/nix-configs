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

# Workspaces of the interaction monitor: number, displayName, focused.
while IFS=$'\t' read -r num name focused; do
  [ -z "$num" ] && continue
  if [ "$focused" = true ]; then
    sketchybar --set "ws.$num" drawing=on label="$name" label.color="$ACCENT_TEXT" \
      background.drawing=on background.color="$ACCENT"
  else
    sketchybar --set "ws.$num" drawing=on label="$name" label.color="$SUBTEXT" \
      background.drawing=off
  fi
done < <(printf '%s' "$json" | jq -r --arg mon "$mon" '
  .result.payload.monitors[] | select(.id == $mon) | .workspaces[] |
  [ (.number | tostring), .displayName, (.isFocused | tostring) ] | @tsv')

# Hide workspace items that do not exist on this monitor.
present=" $(printf '%s' "$json" | jq -r --arg mon "$mon" '.result.payload.monitors[] | select(.id == $mon) | .workspaces[].number' | paste -sd ' ' -) "
for i in 1 2 3 4 5 6 7 8 9; do
  case "$present" in
    *" $i "*) ;;
    *) sketchybar --set "ws.$i" drawing=off ;;
  esac
done

# Apps of the focused workspace, in window order, one row per app.
i=0
while IFS=$'\t' read -r app focused; do
  [ -z "$app" ] && continue
  i=$((i + 1))
  [ "$i" -gt 9 ] && break
  if [ "$focused" = true ]; then
    sketchybar --set "app.$i" drawing=on label="$app" label.color="$ACCENT" label.padding_left=0 \
      icon.drawing=on icon.color="$ACCENT" icon.padding_left=4 icon.padding_right=6
  else
    sketchybar --set "app.$i" drawing=on label="$app" label.color="$SUBTEXT" label.padding_left=4 \
      icon.drawing=off icon.padding_left=0 icon.padding_right=0
  fi
done < <(printf '%s' "$json" | jq -r --arg mon "$mon" '
  .result.payload.monitors[] | select(.id == $mon) | .workspaces[] | select(.isFocused) |
  .windows[] | [.appName, (.isFocused | tostring)] | @tsv' | awk -F'\t' '
    { if (!seen[$1]++) order[++n] = $1
      if ($2 == "true") focused[$1] = 1 }
    END { for (i = 1; i <= n; i++) print order[i] "\t" (order[i] in focused ? "true" : "false") }')

# Hide unused app slots.
i=$((i + 1))
while [ "$i" -le 9 ]; do
  sketchybar --set "app.$i" drawing=off
  i=$((i + 1))
done

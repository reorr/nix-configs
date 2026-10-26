#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

ICON=$'\xEF\x87\xAB' # nf-fa-wifi

rssi=$(system_profiler SPAirPortDataType -json 2>/dev/null |
  jq -r '.SPAirPortDataType[0].spairport_airport_interfaces[0].spairport_current_network_information.spairport_signal_noise // empty' |
  grep -Eo '^-?[0-9]+' | head -1)

if [ -z "$rssi" ]; then
  color="$DIM"
elif [ "$rssi" -ge -55 ]; then
  color="$GREEN"
elif [ "$rssi" -ge -65 ]; then
  color="$TEXT"
elif [ "$rssi" -ge -75 ]; then
  color="$YELLOW"
else
  color="$RED"
fi

sketchybar --set wifi icon="$ICON" icon.color="$color"

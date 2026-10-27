#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

ICON=$'\xEF\x87\xAB' # nf-fa-wifi

rssi=$(system_profiler SPAirPortDataType -json 2>/dev/null |
  jq -r '.SPAirPortDataType[0].spairport_airport_interfaces[0].spairport_current_network_information.spairport_signal_noise // empty' |
  grep -Eo '^-?[0-9]+' | head -1)

iface=$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2; exit}')
ssid=$(networksetup -getairportnetwork "$iface" 2>/dev/null | sed -n 's/^Current Wi-Fi Network: //p')

label="$ssid"
[ -z "$label" ] && [ -n "$rssi" ] && label="${rssi} dBm"
[ -z "$rssi" ] && [ -z "$ssid" ] && label=""

sketchybar --set wifi icon="$ICON" icon.color="$ACCENT" label="$label"

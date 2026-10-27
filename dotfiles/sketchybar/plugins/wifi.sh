#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

ICON=$'\xEF\x87\xAB' # nf-fa-wifi

iface=$(networksetup -listallhardwareports 2>/dev/null | awk '/Wi-Fi/{getline; print $2; exit}')
ip=$(ipconfig getifaddr "$iface" 2>/dev/null)
[ -z "$ip" ] && ip="--"

sketchybar --set wifi icon="$ICON" icon.color="$ACCENT" label="$ip"

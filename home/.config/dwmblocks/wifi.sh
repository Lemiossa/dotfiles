#!/bin/sh

INFO=$(nmcli -t -f active,ssid,signal dev wifi | grep -E '^(yes|sim):')

SSID=$(echo "$INFO" | cut -d: -f2)
SIGNAL=$(echo "$INFO" | cut -d: -f3)

[ -z "$SSID" ] && echo "󰤭 N/A" && exit

if [ "$SIGNAL" -lt 25 ]; then
	ICON="󰤟"
elif [ "$SIGNAL" -lt 50 ]; then
	ICON="󰤢"
elif [ "$SIGNAL" -lt 75 ]; then
	ICON="󰤥"
else ICON="󰤨"; fi

echo "$ICON $SSID"

#!/bin/sh
BAT="/sys/class/power_supply/BAT0"
[ ! -d "$BAT" ] && exit # Sai se não houver bateria
STATUS=$(cat "$BAT/status")
CAP=$(cat "$BAT/capacity")

if [ "$STATUS" = "Charging" ]; then
	ICON=""
elif [ "$CAP" -ge 80 ]; then
	ICON=""
elif [ "$CAP" -ge 60 ]; then
	ICON=""
elif [ "$CAP" -ge 40 ]; then
	ICON=""
elif [ "$CAP" -ge 20 ]; then
	ICON=""
else ICON="󰀦"; fi

echo "$ICON $CAP%"

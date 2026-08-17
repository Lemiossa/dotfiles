#!/bin/sh

GREEN="#a3be8c"
YELLOW="#ebcb8b"
RED="#bf616a"

bat_path="/sys/class/power_supply/BAT0"

if [ ! -d "$bat_path" ]; then
    exit 0
fi

capacity=$(cat "$bat_path/capacity" 2>/dev/null)
status=$(cat "$bat_path/status" 2>/dev/null)

[ -n "$capacity" ] || exit 0

if [ "$status" = "Charging" ]; then
    icon=""
    color="#a3be8c"
elif [ "$capacity" -le 20 ]; then
    icon=""
    color="#bf616a"
elif [ "$capacity" -le 50 ]; then
    icon=""
    color="#ebcb8b"
else
    icon=""
    color="#a3be8c"
fi

printf "%%{F${color}} %%%{F-} %s%%" "$icon" "$capacity" \
    > "/tmp/lemonbar-blocks/30-battery-right"

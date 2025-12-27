#!/bin/bash

BAT="/sys/class/power_supply/BAT0"
STATUS=$(cat $BAT/status)
CAP=$(cat $BAT/capacity)

# escolha do icone
if [ "$STATUS" = "Charging" ]; then
    ICON=""   # plug
elif [ "$CAP" -ge 80 ]; then
    ICON=""   # cheio
elif [ "$CAP" -ge 60 ]; then
    ICON=""
elif [ "$CAP" -ge 40 ]; then
    ICON=""
elif [ "$CAP" -ge 20 ]; then
    ICON=""
else
    ICON="⚡"   # crítico
fi

echo "${ICON} ${CAP}%"

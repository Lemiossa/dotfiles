#!/bin/sh
if command -v pactl >/dev/null 2>&1; then
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk '/Volume:/ { gsub(/%/, "", $5); print $5; exit }')
    mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{ print $2; exit }')
    if [ "$mute" = "yes" ]; then
        printf '󰖁 muted '
    elif [ -n "$vol" ]; then
        printf '󰕾 %s%% ' "$vol"
    else
        printf '󰖀 ? '
    fi
else
    printf '󰖀 ? '
fi

#!/bin/sh
bat=/sys/class/power_supply/BAT0
if [ -r "$bat/capacity" ]; then
    cap=$(cat "$bat/capacity")
    status=$(cat "$bat/status" 2>/dev/null)
    case "$status" in
        Charging) printf '󰂄 %s%% ' "$cap" ;;
        Discharging)
            if [ "$cap" -le 20 ] 2>/dev/null; then
                printf '󰂃 %s%% ' "$cap"
            else
                printf '󰂆 %s%% ' "$cap"
            fi
            ;;
        Full) printf '󰁹 %s%% ' "$cap" ;;
        *)    printf '󰁹 %s%% ' "$cap" ;;
    esac
else
    printf '󰁹 N/A '
fi

#!/bin/bash

IFACE=$(ip route | awk '/default/ {print $5; exit}')

SSID=$(iw dev $IFACE link | awk -F': ' '/SSID/ {print $2}')
RSSI=$(iw dev $IFACE link | awk '/signal:/ {print int($2+100)}')  

ICON_OUTLINE="󰤯"
ICON_DISABLED="󰤭"
ICON_WEAK="󰤟"
ICON_MEDIUM="󰤢"
ICON_STRONG="󰤥"
ICON_MAX="󰤥"

if [ -z "$SSID" ]; then
    ICON=$ICON_DISABLED
    SSID="N/A"
else
    if [ "$RSSI" -lt 25 ]; then
        ICON=$ICON_WEAK
    elif [ "$RSSI" -lt 50 ]; then
        ICON=$ICON_MEDIUM
    elif [ "$RSSI" -lt 75 ]; then
        ICON=$ICON_STRONG
    else
        ICON=$ICON_MAX
    fi
fi

echo "${ICON} $SSID"

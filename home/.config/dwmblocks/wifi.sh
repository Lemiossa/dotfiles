#!/bin/sh
# Pega a interface ativa automaticamente
IFACE=$(ip route | awk '/default/ {print $5; exit}')

if [ -z "$IFACE" ]; then
    echo "󰤭 N/A"
    exit
fi

SSID=$(iw dev "$IFACE" link | awk -F': ' '/SSID/ {print $2}')
RSSI=$(iw dev "$IFACE" link | awk '/signal:/ {print int($2+100)}')

if [ -z "$SSID" ]; then
    ICON="󰤭"
    SSID="N/A"
else
    if [ "$RSSI" -lt 25 ]; then ICON="󰤟"
    elif [ "$RSSI" -lt 50 ]; then ICON="󰤢"
    elif [ "$RSSI" -lt 75 ]; then ICON="󰤥"
    else ICON="󰤨"; fi
fi

echo "$ICON $SSID"

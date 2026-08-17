#!/bin/sh

ACCENT="#88c0d0"
RED="#bf616a"

interface=""
icon=""

# Check ethernet
if [ -d "/sys/class/net/eth0" ] && [ "$(cat /sys/class/net/eth0/operstate 2>/dev/null)" = "up" ]; then
    interface="eth0"
    icon=""
fi

# Check wifi (try common interface names)
for wifidev in wlp2s0 wlp3s0 wlan0 wlo1; do
    if [ -d "/sys/class/net/$wifidev" ] && [ "$(cat /sys/class/net/$wifidev/operstate 2>/dev/null)" = "up" ]; then
        interface="$wifidev"
        icon=""
        break
    fi
done

if [ -n "$interface" ]; then
    printf "%%{F${ACCENT}} %%%{F-} %s" "$icon" \
        > "/tmp/lemonbar-blocks/40-network-right"
else
    printf "%%{F${RED}} %%%{F-} Offline" \
        > "/tmp/lemonbar-blocks/40-network-right"
fi

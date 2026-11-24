#!/bin/sh
mem=$(free -m 2>/dev/null | awk '/^Mem:/ { printf "%d", $3 * 100 / $2 }')
[ -n "$mem" ] || mem='?'
printf ' %s%%' "$mem"

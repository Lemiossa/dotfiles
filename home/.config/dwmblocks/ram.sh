#!/bin/sh
ICON=""
RAM=$(free | awk '/^Mem/ {printf "%d", ($2 - $7)/$2 * 100}')
echo "$ICON $RAM%"

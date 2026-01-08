#!/bin/sh
ICON=""
RAM=$(free | awk 'NR==2 {printf "%.0f", ($2-$7)*100/$2}')
echo "$ICON $RAM%"

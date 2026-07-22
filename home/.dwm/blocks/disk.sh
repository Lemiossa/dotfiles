#!/bin/sh

USAGE=$(df / | awk 'NR==2 { printf "%.1f%%\n", ($3 / $2) * 100 }')

echo "Disk: $USAGE"

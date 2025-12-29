#!/bin/sh
ICON=""
DISK=$(df -h / | awk 'NR==2 {print $5}')
echo "$ICON $DISK"

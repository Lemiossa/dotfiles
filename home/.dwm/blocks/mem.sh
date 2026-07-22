#!/bin/sh

MEM=$(free -h | awk 'NR==2 { print $3 "/" $2 }' | sed 's/i//g')

echo "Mem: $MEM"

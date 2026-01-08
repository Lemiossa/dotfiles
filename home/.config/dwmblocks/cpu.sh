#!/bin/sh
ICON=""

CPU_USAGE=$(
	grep 'cpu ' /proc/stat | awk '{u=$2+$4; t=$2+$4+$5; print u, t}'
	sleep 0.5
	grep 'cpu ' /proc/stat | awk '{u=$2+$4; t=$2+$4+$5; print u, t}'
)
CPU_PERC=$(echo "$CPU_USAGE" | awk '{u[NR]=$1; t[NR]=$2} END {printf "%d", (u[2]-u[1]) * 100 / (t[2]-t[1])}')

CPU=${CPU_PERC}

echo "$ICON $CPU%"

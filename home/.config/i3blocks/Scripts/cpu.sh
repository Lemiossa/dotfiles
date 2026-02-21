#!/bin/sh
ICON=""

CPU_USAGE=$(
	grep 'cpu ' /proc/stat | awk '{u=$2+$4; t=$2+$4+$5; print u, t}'
	sleep 0.5
	grep 'cpu ' /proc/stat | awk '{u=$2+$4; t=$2+$4+$5; print u, t}'
)
CPU_PERC=$(echo "$CPU_USAGE" | awk '{u[NR]=$1; t[NR]=$2} END {printf "%d", (u[2]-u[1]) * 100 / (t[2]-t[1])}')

CPU=${CPU_PERC}

TEMP_RAW=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)

if [ -n "$TEMP_RAW" ]; then
	TEMP=$(echo "$TEMP_RAW" | awk '{printf "%.0f", $1/1000}')
else
	TEMP="N/A"
fi

echo "$ICON $CPU% $TEMP°C"

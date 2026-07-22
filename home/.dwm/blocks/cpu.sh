#!/bin/sh

CPU_SAMPLE1=$(cat /proc/stat | awk 'NR==1 { print $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10 + $11}')
CPU_IDLE1=$(cat /proc/stat | awk 'NR==1 { print $5 }')
sleep 1
CPU_SAMPLE2=$(cat /proc/stat | awk 'NR==1 { print $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10 + $11}')
CPU_IDLE2=$(cat /proc/stat | awk 'NR==1 { print $5 }') 

CPU_USE=$(awk -v s1="$CPU_SAMPLE1" -v s2="$CPU_SAMPLE2" \
               -v i1="$CPU_IDLE1"   -v i2="$CPU_IDLE2" '
BEGIN {
    diff_total = s2 - s1
    diff_idle  = i2 - i1

    if (diff_total <= 0) {
        print 0
        exit
    }

    usage = ((diff_total - diff_idle) / diff_total) * 100

    if (usage < 0) usage = 0
    if (usage > 100) usage = 100

    printf "%.0f", usage
}')

echo "CPU: ${CPU_USE}%"

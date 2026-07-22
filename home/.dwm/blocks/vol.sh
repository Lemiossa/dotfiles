#!/bin/sh

VOL=$(amixer sget Master 2>/dev/null | awk '
match($0, /\[[0-9]+%\]/) {
    print substr($0, RSTART + 1, RLENGTH - 2)
    exit
}')

[ -n "$VOL" ] || VOL="N/A"

echo "Vol: $VOL"

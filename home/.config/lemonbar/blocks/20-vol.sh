#!/bin/sh

ACCENT="#88c0d0"
YELLOW="#ebcb8b"

vol_info=$(amixer sget Master 2>/dev/null)
vol=$(printf "%s" "$vol_info" | awk '
match($0, /\[[0-9]+%\]/) {
    print substr($0, RSTART + 1, RLENGTH - 2)
    exit
}')

muted=$(printf "%s" "$vol_info" | grep -o '\[off\]' 2>/dev/null)

if [ -n "$muted" ]; then
    printf "%%{F${YELLOW}} %%%{F-} MUTE" \
        > "/tmp/lemonbar-blocks/20-vol-right"
elif [ -n "$vol" ]; then
    printf "%%{F${ACCENT}} %%%{F-} %s" "$vol" \
        > "/tmp/lemonbar-blocks/20-vol-right"
else
    printf "%%{F${ACCENT}} %%%{F-} N/A" \
        > "/tmp/lemonbar-blocks/20-vol-right"
fi

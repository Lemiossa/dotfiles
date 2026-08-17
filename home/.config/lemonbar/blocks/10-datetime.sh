#!/bin/sh

ACCENT="#88c0d0"

datetime=$(date "+%b %d (%a) %I:%M%p")
printf "%%{F${ACCENT}} %%%{F-} %s" "$datetime" \
    > "/tmp/lemonbar-blocks/10-datetime-right"

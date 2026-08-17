#!/bin/sh

ACCENT="#88c0d0"
DIM="#4c566a"
DIR="/tmp/lemonbar-blocks"

mkdir -p "$DIR"

update() {
    output=""
    desktops=$(bspc query -D --names 2>/dev/null)
    focused=$(bspc query -D -d focused --names 2>/dev/null)

    for d in $desktops; do
        if [ "$d" = "$focused" ]; then
            output="${output} %{F${ACCENT}}${d}%{F-}"
        else
            output="${output} %{F${DIM}}${d}%{F-}"
        fi
    done

    printf "%s" "$output" > "$DIR/00-workspaces-left"
}

update

bspc subscribe desktop_focus 2>/dev/null | while read -r _; do
    update
done

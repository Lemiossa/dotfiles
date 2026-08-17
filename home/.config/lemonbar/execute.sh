#!/bin/sh

# Nord colors
BG="#2e3440"
FG="#d8dee9"
DIM="#4c566a"
ACCENT="#88c0d0"
GREEN="#a3be8c"
RED="#bf616a"
YELLOW="#ebcb8b"

export LEMONBAR_DIR="/tmp/lemonbar-blocks"
mkdir -p "$LEMONBAR_DIR"

cleanup() { rm -rf "$LEMONBAR_DIR"; }
trap cleanup EXIT

"$HOME/.config/lemonbar/blocks/00-workspaces.sh" &

while :; do
    left=""
    center=""
    right=""

    for f in "$LEMONBAR_DIR"/*; do
        [ -f "$f" ] || continue
        case "$(basename "$f")" in
            *-left)   left="$(cat "$f")" ;;
            *-center) center="$(cat "$f")" ;;
            *-right)  right="$right$(cat "$f") " ;;
        esac
    done

    right="${right% }"

    printf "%s%%{l}%s%%{c}%s%%{r}%s\n" \
        "$left" "$center" "$right"

    sleep 1
done | lemonbar -p \
    -B "$BG" -F "$FG" \
    -f "JetBrains Mono:size=10" \
    -f "Symbols Nerd Font Mono:size=10" &

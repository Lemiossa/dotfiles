#!/bin/sh

WALLPAPERS="$(ls "$HOME/Pictures/wallpapers")"
wallpaper=$(echo "$WALLPAPERS" | tr ' ' '\n' | dmenu)

rm -f "$HOME/.dwm/wallpaper.png"
ln -s "$HOME/Pictures/wallpapers/$wallpaper" "$HOME/.dwm/wallpaper.png"
feh --bg-scale "$HOME/.dwm/wallpaper.png"

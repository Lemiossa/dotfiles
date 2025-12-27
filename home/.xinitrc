#!/bin/sh

setxkbmap br

WALLPAPER=gruvbox1

picom &
$HOME/.dwmbar.sh &

feh --bg-scale $HOME/Pictures/Wallpapers/$WALLPAPER.png

exec dwm

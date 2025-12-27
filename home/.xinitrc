#!/bin/sh

setxkbmap br

THEME=mocha
WALLPAPER=catppuccin-mocha

picom &
$HOME/.dwmbar.sh &

feh --bg-scale $HOME/Pictures/Wallpapers/$WALLPAPER.png

exec dwm

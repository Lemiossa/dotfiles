#!/bin/sh

setxkbmap br

WALLPAPER=gruvbox1

picom &
dwmblocks &

feh --bg-scale $HOME/Pictures/Wallpapers/$WALLPAPER.png

exec dwm

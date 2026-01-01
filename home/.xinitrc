#!/bin/sh

setxkbmap br

WALLPAPER=od_gargantua

picom &
dwmblocks &

feh --bg-scale $HOME/Pictures/Wallpapers/$WALLPAPER.png

exec dwm

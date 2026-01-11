#!/bin/sh

setxkbmap br

WALLPAPER=od_
dwmblocks &

feh --bg-scale $HOME/Pictures/Wallpapers/$WALLPAPER.png

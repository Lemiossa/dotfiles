#!/bin/sh

setxkbmap br

WALLPAPER=main
dwmblocks &

feh --bg-scale $HOME/Pictures/Wallpapers/$WALLPAPER.png


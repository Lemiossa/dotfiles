#!/bin/sh

setxkbmap br

WALLPAPER=gruvbox3

dwmblocks &

feh --bg-scale $HOME/Pictures/Wallpapers/$WALLPAPER.png

exec dwm

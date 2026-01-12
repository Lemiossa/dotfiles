#!/bin/sh

setxkbmap br

WALLPAPER=pacman_ghosts
dwmblocks &

feh --bg-scale $HOME/Pictures/Wallpapers/$WALLPAPER.png

#!/bin/sh

setxkbmap br
feh --bg-scale "$HOME/.dwm/wallpaper.png"
# picom --backend=glx &
dwmblocks &
mpd --no-daemon &
dunst &
pipewire &
pipewire-pulse &
wireplumber &


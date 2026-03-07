#/bin/sh

setxkbmap br

WALLPAPER=paisagem
dwmblocks &

feh --bg-scale $HOME/Pictures/Wallpapers/$WALLPAPER.png

xrdb -merge ~/.Xresources
exec dbus-run-session i3

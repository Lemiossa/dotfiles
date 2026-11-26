#!/bin/sh
# Empty (e outros login managers) não carregam .bashrc/.profile: garanta o PATH
# onde os binários do suckless são instalados antes de iniciar os serviços.
PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin${PATH:+:$PATH}"
export PATH

feh --bg-fill "$HOME/.local/share/wallpaper" &
picom &
dunst &
dwmblocks &
pipewire &
wireplumber &
pipewire-pulse &
setxkbmap br

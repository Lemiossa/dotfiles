#!/bin/sh
# pkg/void.sh — Void Linux: xbps + runit.

DISTRO_NAME="Void Linux"
SUDO=sudo

PM_PACKAGES="
alacritty
blueman
alsa-utils
bash
bash-completion
base-devel
brightnessctl
cmake
dunst
eza
feh
fontconfig-devel
freetype-devel
git
gvim
harfbuzz-devel
imlib2-devel
libX11-devel
libXft-devel
libXinerama-devel
fastfetch
make
mpd
mpc
ncurses
ncurses-devel
NetworkManager
picom
pipewire
pkg-config
perl
playerctl
rmpc
seatd
shadow
Thunar
thunar-archive-plugin
thunar-volman
wireplumber
xinit
xorg
bspwm
sxhkd
rofi
polybar
"

REMOVE_ELOGIND=1

pkg_sync() {
	$SUDO xbps-install -S
}

pkg_install() {
	$SUDO xbps-install -y "$@"
}

pkg_remove() {
	$SUDO xbps-remove -y "$@"
}

setup_services() {
	$SUDO ln -sf /etc/sv/seatd /var/service/
	$SUDO ln -sf /etc/sv/NetworkManager /var/service/
}

setup_groups() {
	$SUDO usermod -aG video,input "$USER"
}

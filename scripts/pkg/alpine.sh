#!/bin/sh
# pkg/alpine.sh — Alpine Linux: apk + OpenRC.

DISTRO_NAME="Alpine Linux"
SUDO=doas

PM_PACKAGES="
alsa-utils
bash
bash-completion
build-base
brightnessctl
cmake
dunst
feh
fontconfig-dev
freetype-dev
git
gvim
harfbuzz-dev
libx11-dev
libxft-dev
libxinerama-dev
fastfetch
make
mpd
mpc
eza
networkmanager
networkmanager-bash-completion
networkmanager-tui
picom
pipewire
pipewire-pulse
pkgconf
playerctl
rmpc
seatd
setxkbmap
thunar
thunar-archive-plugin
thunar-volman
wireplumber
xinit
imlib2-dev
shadow
ncurses
ncurses-dev
"

REMOVE_ELOGIND=1

pkg_sync() {
	$SUDO setup-xorg-base
}

pkg_install() {
	$SUDO apk add "$@"
}

pkg_remove() {
	$SUDO apk del "$@"
}

setup_services() {
	$SUDO rc-update add seatd default
	$SUDO rc-service seatd start
	$SUDO rc-update del wpa_supplicant boot
	$SUDO rc-update del networking boot
	$SUDO rc-update add dbus
	$SUDO rc-update add bluetooth
	$SUDO rc-service wpa_supplicant stop
	$SUDO rc-update add networkmanager default
	$SUDO rc-service networkmanager start
}

setup_groups() {
	$SUDO adduser "$USER" plugdev
}

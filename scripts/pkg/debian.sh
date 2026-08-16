#!/bin/sh
# pkg/debian.sh — Debian / Ubuntu: apt + systemd.

DISTRO_NAME="Debian / Ubuntu"
SUDO=sudo

PM_PACKAGES="
alsa-utils
bash
bash-completion
build-essential
brightnessctl
cmake
dunst
eza
feh
git
gvim
imlib2-dev
libfontconfig1-dev
libfreetype6-dev
libharfbuzz-dev
libncurses-dev
libx11-dev
libxft-dev
libxinerama-dev
fastfetch
make
mpd
mpc
network-manager
network-manager-gnome
picom
pipewire
pipewire-pulse
pkg-config
playerctl
rmpc
seatd
thunar
thunar-archive-plugin
thunar-volman
wireplumber
x11-xkb-utils
xinit
"

pkg_sync() {
	$SUDO apt update
}

pkg_install() {
	$SUDO apt install -y "$@"
}

pkg_remove() {
	$SUDO apt remove -y "$@"
}

setup_services() {
	$SUDO systemctl enable --now seatd
	$SUDO systemctl enable --now NetworkManager
}

setup_groups() {
	$SUDO adduser "$USER" plugdev
}

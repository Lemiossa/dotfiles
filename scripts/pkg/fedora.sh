#!/bin/sh
# pkg/fedora.sh — Fedora: dnf + systemd.

DISTRO_NAME="Fedora"
SUDO=sudo

PM_PACKAGES="
alacritty
blueman
alsa-utils
bash
bash-completion
brightnessctl
cmake
curl
dunst
eza
feh
fontconfig-devel
freetype-devel
gcc
git
gh
gvim
harfbuzz-devel
imlib2-devel
jq
libX11-devel
libXft-devel
libXinerama-devel
fastfetch
make
mpd
mpd-mpc
ncurses
ncurses-devel
NetworkManager
NetworkManager-tui
picom
pipewire
pipewire-pulse
pkg-config
perl-utils
playerctl
rmpc
seatd
shadow-utils
thunar
thunar-archive-plugin
thunar-volman
wget
wireplumber
xinit
xorg-x11-setxkbmap
xorg-x11-server-Xorg
xorg-x11-fonts-misc
xorg-x11-fonts-100dpi
xorg-x11-fonts-75dpi
bspwm
sxhkd
rofi
polybar
"

REMOVE_ELOGIND=1

pkg_sync() {
	: # dnf resolves the metadata automatically
}

pkg_install() {
	$SUDO dnf install -y "$@"
}

pkg_remove() {
	$SUDO dnf remove -y "$@"
}

setup_services() {
	$SUDO systemctl enable --now seatd
	$SUDO systemctl enable --now NetworkManager
}

setup_groups() {
	$SUDO usermod -aG video,input "$USER"
}

#!/bin/sh
# pkg/arch.sh — Arch Linux: pacman + systemd.

DISTRO_NAME="Arch Linux"
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
fontconfig
freetype2
git
gvim
harfbuzz
imlib2
libx11
libxft
libxinerama
fastfetch
make
mpd
mpc
ncurses
networkmanager
nm-connection-editor
picom
pipewire
pipewire-pulse
playerctl
perl-utils
pkgconf
rmpc
seatd
shadow
thunar
thunar-archive-plugin
thunar-volman
wireplumber
xorg-setxkbmap
xorg-xinit
xorg
bspwm
sxhkd
rofi
polybar
"

pkg_sync() {
	: # pacman fetches the metadata during install
}

pkg_install() {
	$SUDO pacman -S --needed --noconfirm "$@"
}

pkg_remove() {
	$SUDO pacman -R --noconfirm "$@"
}

setup_services() {
	$SUDO systemctl enable --now seatd
	$SUDO systemctl enable --now NetworkManager
}

setup_groups() {
	$SUDO usermod -aG video,input "$USER"
}

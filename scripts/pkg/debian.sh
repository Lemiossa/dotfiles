#!/bin/sh
# pkg/debian.sh — Debian / Ubuntu: apt + systemd.

DISTRO_NAME="Debian / Ubuntu"
SUDO=sudo

PM_PACKAGES="
kitty
blueman
alsa-utils
bash
bash-completion
build-essential
brightnessctl
cmake
curl
dunst
eza
feh
git
gh
gvim
imlib2-dev
jq
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
nodejs
npm
picom
pipewire
pipewire-pulse
pkg-config
perl-utils
playerctl
rmpc
seatd
thunar
thunar-archive-plugin
thunar-volman
wget
wireplumber
x11-xkb-utils
xinit
xorg
bspwm
sxhkd
rofi
polybar
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
	case " $(id -nG "$USER") " in
		*\ plugdev\ *)
			: # already a member
			;;
		*)
			$SUDO adduser "$USER" plugdev
			;;
	esac
}

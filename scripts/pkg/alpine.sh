#!/bin/sh
# pkg/alpine.sh — Alpine Linux: apk + OpenRC.

DISTRO_NAME="Alpine Linux"
SUDO=doas

PM_PACKAGES="
alacritty
blueman
alsa-utils
bash
bash-completion
build-base
brightnessctl
cmake
curl
dunst
feh
fontconfig-dev
freetype-dev
git
github-cli
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
nodejs
npm
picom
pipewire
pipewire-pulse
pkgconf
perl-utils
playerctl
rmpc
seatd
setxkbmap
thunar
thunar-archive-plugin
thunar-volman
wget
wireplumber
xinit
imlib2-dev
jq
shadow
ncurses
ncurses-dev
bspwm
sxhkd
rofi
polybar
xorg-server
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
	$SUDO rc-update del wpa_supplicant boot || true
	$SUDO rc-update del networking boot || true
	$SUDO rc-update add dbus
	$SUDO rc-update add bluetooth
	$SUDO rc-service wpa_supplicant stop || true
	$SUDO rc-update add networkmanager default
	$SUDO rc-service networkmanager start
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

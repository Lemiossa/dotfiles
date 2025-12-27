#!/bin/sh

set -e 

echo "Instalando configurações..."

mkdir -p "${HOME}"
cp -rv home/. "${HOME}/"

sudo xbps-install -S 

sudo xbps-install -y \
xorg \
xinit \
xrandr \
xsetroot \
xprop \
xev \
mesa 

sudo xbps-install -y \
base-devel \
pkg-config \
git \
curl

sudo xbps-install -y \
libX11-devel \
libXinerama-devel \
libXft-devel \
fontconfig-devel \
imlib2-devel

sudo xbps-install -y \
picom \
vim-x11 \
fastfetch \
cava \
bash \
nerd-fonts \
pavucontrol \
xclip \
nodejs \
feh \
luakit \
dbus \
NetworkManager \
elogind \
polkit

# Serviços
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/elogind /var/service
sudo ln -s /etc/sv/udevd /var/service
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/polkitd /var/service

# Serviços que geralmente vem com void
sudo rm /var/service/dhcpcd
sudo rm /var/service/wpa_supplicant

echo "Concluído."


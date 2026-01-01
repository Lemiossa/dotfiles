#!/bin/sh

set -e

echo "Instalando configurações..."

mkdir -p "${HOME}"
cp -rv home/. "${HOME}/"

echo "Instalando pacotes"
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
vim-x11 \
pfetch \
cava \
bash \
pavucontrol \
xclip \
nodejs \
feh \
luakit \
dbus \
NetworkManager \
elogind \
polkit \
unzip \
clang \
picom \
clang-tools-extra

echo "Configurando serviços..."

# Serviços
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/elogind /var/service
sudo ln -s /etc/sv/udevd /var/service
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/polkitd /var/service

# Serviços que geralmente vem com void
sudo rm /var/service/dhcpcd
sudo rm /var/service/wpa_supplicant

echo "Instalando colorscript..."
sudo git clone https://github.com/charitarthchugh/shell-color-scripts.git /opt/shell-color-scripts
sudo ln -s /opt/shell-color-scripts/colorscript.sh /usr/local/bin/colorscript
sudo chmod +x /usr/local/bin/colorscript

echo "Instalando pipes.sh"
sudo git clone https://github.com/pipeseroni/pipes.sh /opt/pipes.sh
sudo ln -s /opt/pipes.sh/pipes.sh /usr/local/bin/pipes
sudo chmod +x /usr/local/bin/pipes

echo "Instalando FiraCode Nerd Font..."
mkdir -p FiraCodeNerd
unzip FiraCode.zip -d FiraCodeNerd

sudo mkdir -p /usr/share/fonts/TTF/FiraCodeNerd
sudo cp FiraCodeNerd/*.ttf /usr/share/fonts/TTF/FiraCodeNerd

echo "Configurando vim..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall

echo "Concluído."


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
alacritty \
luakit \
dbus \
NetworkManager \
elogind \
polkit \
unzip \
clang \
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

echo "Instalando FiraCode Nerd Font..."
mkdir -p FiraCodeNerd
unzip FiraCode.zip -d FiraCodeNerd

sudo mkdir -p /usr/share/fonts/TTF/FiraCodeNerd
sudo cp FiraCodeNerd/*.ttf /usr/share/fonts/TTF/FiraCodeNerd

echo "Configurando vim..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
unzip

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


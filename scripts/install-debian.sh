#!/bin/sh
# install-debian.sh — Full installation script for Debian / Ubuntu

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Installing packages..."
sudo apt update

sudo apt install -y \
    alsa-utils \
    bash \
    bash-completion \
    build-essential \
    brightnessctl \
    cmake \
    dunst \
    eza \
    feh \
    git \
    gvim \
    imlib2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libharfbuzz-dev \
    libncurses-dev \
    libx11-dev \
    libxft-dev \
    libxinerama-dev \
    lsd \
    fastfetch \
    make \
    mpd \
    network-manager \
    network-manager-gnome \
    picom \
    pipewire \
    pipewire-pulse \
    pkg-config \
    playerctl \
    rmpc \
    seatd \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    wireplumber \
    x11-xkb-utils \
    xinit

echo "==> Enabling services..."
sudo systemctl enable --now seatd
sudo systemctl enable --now NetworkManager

echo "==> Adding user to groups..."
sudo adduser "$USER" plugdev

echo "==> Changing shell to bash..."
chsh -s "$(which bash)" "$USER"

echo "==> Copying dotfiles..."
cp -af "$REPO_DIR/home/." "$HOME/"

echo "==> Building and installing suckless tools..."
for tool in dmenu dwm st dwmblocks; do
    echo "    Building $tool..."
    cd "$HOME/suckless/$tool"
    sudo make clean install
done

cd "$HOME"

echo "==> Installing vim plugins..."
vim +PlugInstall +qall

echo "==> Done! Log out and back in for group changes to take effect."
echo "    Then run 'startx' from the console TTY to start the session."

#!/bin/sh
# install-arch.sh — Full installation script for Arch Linux

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Installing packages..."
sudo pacman -S --needed --noconfirm \
    alsa-utils \
    bash \
    bash-completion \
    base-devel \
    brightnessctl \
    cmake \
    dunst \
    eza \
    feh \
    fontconfig \
    freetype2 \
    git \
    gvim \
    harfbuzz \
    imlib2 \
    libx11 \
    libxft \
    libxinerama \
    lsd \
    fastfetch \
    make \
    mpd \
    ncurses \
    networkmanager \
    nm-connection-editor \
    picom \
    pipewire \
    pipewire-pulse \
    playerctl \
    rmpc \
    seatd \
    shadow \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    wireplumber \
    xorg-setxkbmap \
    xorg-xinit

echo "==> Enabling services..."
sudo systemctl enable --now seatd
sudo systemctl enable --now NetworkManager

echo "==> Adding user to groups..."
sudo usermod -aG video,input "$USER"

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

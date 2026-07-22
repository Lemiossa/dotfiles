#!/bin/sh
# install-fedora.sh — Full installation script for Fedora

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Installing packages..."
sudo dnf install -y \
    alsa-utils \
    bash \
    bash-completion \
    brightnessctl \
    cmake \
    dunst \
    eza \
    feh \
    fontconfig-devel \
    freetype-devel \
    gcc \
    git \
    gvim \
    harfbuzz-devel \
    imlib2-devel \
    libX11-devel \
    libXft-devel \
    libXinerama-devel \
    lsd \
    fastfetch \
    make \
    mpd \
    ncurses \
    ncurses-devel \
    NetworkManager \
    NetworkManager-tui \
    picom \
    pipewire \
    pipewire-pulse \
    pkg-config \
    playerctl \
    rmpc \
    seatd \
    shadow-utils \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    wireplumber \
    xinit \
    xorg-x11-setxkbmap

echo "==> Removing elogind (conflicts with seatd)..."
sudo dnf remove -y elogind || true

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

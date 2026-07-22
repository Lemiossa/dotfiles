#!/bin/sh
# install-void.sh — Full installation script for Void Linux

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Syncing package repos..."
sudo xbps-install -S

echo "==> Installing packages..."
sudo xbps-install -y \
    alsa-utils \
    bash \
    bash-completion \
    base-devel \
    brightnessctl \
    cmake \
    dunst \
    eza \
    feh \
    fontconfig-devel \
    freetype-devel \
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
    picom \
    pipewire \
    pipewire-pulse \
    pkg-config \
    playerctl \
    rmpc \
    seatd \
    shadow \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    wireplumber \
    xinit \
    xorg-setxkbmap

echo "==> Removing elogind (conflicts with seatd)..."
sudo xbps-remove -y elogind || true

echo "==> Enabling services..."
sudo ln -sf /etc/sv/seatd /var/run/service/
sudo ln -sf /etc/sv/NetworkManager /var/run/service/

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
vim +PlugInstall +qall || gvim +PlugInstall +qall

echo "==> Done! Log out and back in for group changes to take effect."
echo "    Then run 'startx' from the console TTY to start the session."

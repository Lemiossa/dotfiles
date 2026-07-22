#!/bin/sh
# install-alpine.sh — Full installation script for Alpine Linux

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Installing packages..."
doas setup-xorg-base
doas apk add \
    alsa-utils \
    bash \
    bash-completion \
    build-base \
    brightnessctl \
    cmake \
    dunst \
    feh \
    fontconfig-dev \
    freetype-dev \
    git \
    gvim \
    harfbuzz-dev \
    libx11-dev \
    libxft-dev \
    libxinerama-dev \
    lsd \
    fastfetch \
    make \
    mpd \
    mpc \
    eza \
    networkmanager \
    networkmanager-bash-completion \
    networkmanager-tui \
    picom \
    pipewire \
    pipewire-pulse \
    pkgconf \
    playerctl \
    rmpc \
    seatd \
    setxkbmap \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    wireplumber \
    xinit \
    imlib2-dev \
    shadow \
    ncurses \
    ncurses-dev

echo "==> Removing elogind (conflicts with seatd)..."
doas apk del elogind || true

echo "==> Enabling services..."
doas rc-update add seatd default
doas rc-service seatd start

doas rc-update del wpa_supplicant boot
doas rc-update del networking boot
doas rc-service wpa_supplicant stop
doas rc-update add networkmanager default
doas rc-service networkmanager start

echo "==> Adding user to groups..."
doas adduser "$USER" plugdev

echo "==> Changing shell to bash..."
chsh -s $(which bash) "$USER"

echo "==> Copying dotfiles..."
cp -af "$REPO_DIR/home/." "$HOME/"

echo "==> Building and installing suckless tools..."
for tool in dmenu dwm st dwmblocks; do
    echo "    Building $tool..."
    cd "$HOME/suckless/$tool"
    doas make clean install
done

cd "$HOME"

echo "==> Installing vim plugins..."
vim +PlugInstall +qall

echo "==> Done! Log out and back in for group changes to take effect."
echo "    Then run 'startx' from the console TTY to start the session."

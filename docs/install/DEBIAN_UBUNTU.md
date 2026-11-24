# Instalação — Debian / Ubuntu

Instalação validada em 24/11/2026 com `debian:trixie` (contêiner limpo);
os mesmos pacotes foram conferidos no `ubuntu:26.04`.

Use `sudo` (o `doas` não faz parte da instalação padrão de Debian/Ubuntu).

## 1. Pacotes

```sh
sudo apt update
sudo apt install -y --no-install-recommends \
    xinit x11-xserver-utils x11-xkb-utils xauth dbus \
    build-essential libx11-dev libxinerama-dev libfreetype-dev \
    libfontconfig1-dev pkg-config \
    feh fzf vim vim-gtk3 xclip adwaita-icon-theme pavucontrol rofi pulseaudio-utils \
    fonts-jetbrains-mono fontconfig procps \
    iw wireless-tools curl ca-certificates bash git unzip emptty \
    pipewire pipewire-pulse wireplumber dunst \
    mpd mpc ncmpcpp picom ncurses-bin sudo
```

`x11-xserver-utils` fornece `xsetroot`, `xset` e `xrdb`; `x11-xkb-utils`
fornece `setxkbmap`; `pulseaudio-utils` fornece `pactl`, usado por `volume.sh`;
`wireless-tools` fornece `iwgetid`, usado como fallback em `network.sh`.
`ncurses-bin` fornece `tic`, usado pelo `make install` do st para registrar o
terminfo `st-256color`.

## 2. Fontes Nerd

Não há pacotes de Nerd Fonts nos repositórios oficiais de Debian/Ubuntu.
Baixe as duas famílias usadas pelo dwm:

```sh
mkdir -p ~/.local/share/fonts/nerd
curl -fL -o /tmp/JetBrainsMono.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
curl -fL -o /tmp/NerdFontsSymbolsOnly.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/nerd/jetbrains
unzip -o /tmp/NerdFontsSymbolsOnly.zip -d ~/.local/share/fonts/nerd/symbols
rm -f /tmp/JetBrainsMono.zip /tmp/NerdFontsSymbolsOnly.zip
```

## 3. Sessão

```sh
sudo systemctl enable emptty@tty1.service
```

A unit `emptty@.service` do Debian lê `/etc/emptty/conf-tty1`, não
`/etc/emptty/conf`. Após copiar `root/.` (ver [COMMON.md](COMMON.md)), faça:

```sh
sudo cp /etc/emptty/conf /etc/emptty/conf-tty1
```

## 4. Continuar

Siga [COMMON.md](COMMON.md) para copiar os dotfiles, ajustar permissões,
compilar o suckless e instalar os plugins do vim.

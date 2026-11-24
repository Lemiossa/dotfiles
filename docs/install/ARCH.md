# Instalação — Arch Linux

Validado em 24/11/2026 com `archlinux:base` (rolling).

Use `sudo` (o `doas` não faz parte da instalação padrão do Arch).

## 1. Pacotes

```sh
sudo pacman -Syu
sudo pacman -S --needed \
    base-devel xorg xorg-xinit xorg-xsetroot xorg-xset xorg-setxkbmap xorg-xrdb \
    dbus feh fzf gvim xclip adwaita-icon-theme pavucontrol rofi \
    ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols \
    emptty curl bash iw wireless_tools fontconfig procps-ng \
    git unzip picom \
    pipewire pipewire-pulse wireplumber dunst \
    mpd mpc ncmpcpp ncurses
```

- `gvim` já fornece o comando `vim`; instalar `vim` separadamente gera conflito.
- `ttf-jetbrains-mono-nerd` e `ttf-nerd-fonts-symbols` cobrem as duas fontes do `config.h` do dwm.
- `wireless_tools` fornece `iwgetid`, usado como fallback em `network.sh`.
- `ncurses` fornece o `tic`, usado pelo `make install` do st para registrar o terminfo `st-256color`.

## 2. Sessão

```sh
sudo systemctl enable emptty.service
```

O serviço lê `/etc/emptty/conf`, instalado a partir de `root/` neste repositório.
Se preferir `startx`, inicie com `startx dwm` (o patch de autostart do dwm
executa `~/.local/share/dwm/autostart.sh`).

## 3. Continuar

Siga [COMMON.md](COMMON.md) para copiar os dotfiles, ajustar permissões,
compilar o suckless e instalar os plugins do vim.

# Instalação — Alpine Linux

Validado em 24/11/2026 com `alpine:3.24` (contêiner limpo).

No Alpine, **`doas` já vem por padrão**; todos os comandos abaixo usam `doas`.

## 1. Pacotes

```sh
doas apk update
doas apk add --no-cache alpine-conf
doas setup-xorg-base
doas apk add --no-cache \
    bash curl dbus dbus-openrc feh fontconfig fzf gvim vim iw shadow \
    adwaita-icon-theme pavucontrol rofi font-jetbrains-mono nerd-fonts-all \
    build-base setxkbmap xinit xset wireless-tools procps xz \
    git unzip emptty \
    pipewire pipewire-pulse wireplumber dunst \
    mpc mpd ncmpcpp picom ncurses
```

- `setup-xorg-base` faz parte do `alpine-conf`, presente em uma instalação padrão do Alpine.
- `dbus-openrc` é necessário: o pacote `dbus` sozinho **não** traz o script `/etc/init.d/dbus` no Alpine 3.24.
- `wireless-tools` fornece `iwgetid`, usado como fallback em `network.sh`.
- `nerd-fonts-all` + `font-jetbrains-mono` cobrem as fontes pedidas pelo `config.h` do dwm e pelo rofi.
- `ncurses` fornece o `tic`, usado pelo `make install` do st para registrar o terminfo `st-256color`.

## 2. Serviços

```sh
doas rc-update add dbus default
doas rc-update add emptty default
```

O `emptty` lê `/etc/emptty/conf`, que é instalado a partir de `root/` neste repositório.

## 3. Continuar

Siga [COMMON.md](COMMON.md) para copiar os dotfiles, ajustar permissões,
compilar o suckless e instalar os plugins do vim.

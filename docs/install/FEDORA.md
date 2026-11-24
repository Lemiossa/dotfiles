# Instalação — Fedora

Validado em 24/11/2026 com `fedora:42` (contêiner limpo).

Use `sudo` (o `doas` não faz parte da instalação padrão do Fedora).

## 1. Pacotes

```sh
sudo dnf install -y \
    xorg-x11-xinit xsetroot xrdb xset setxkbmap xorg-x11-xauth dbus dbus-daemon \
    gcc make libX11-devel libXinerama-devel freetype-devel \
    fontconfig-devel pkgconf-pkg-config \
    feh fzf vim-enhanced vim-X11 pulseaudio-utils xclip adwaita-icon-theme pavucontrol rofi \
    jetbrains-mono-fonts fontconfig procps-ng \
    iw curl bash git unzip \
    pipewire pipewire-pulseaudio wireplumber dunst \
    mpc ncmpcpp picom ncurses sudo
```

Diferenças em relação ao Alpine que foram validadas nos repositórios do Fedora 42:

- `pipewire-pulseaudio` (não `pipewire-pulse`).
- `dbus-daemon`: o pacote `dbus` sozinho instala o `dbus-broker` e não traz
  `dbus-daemon`/`dbus-run-session`.
- `vim-X11` fornece `gvim` e `vim-enhanced` fornece `vim`; `pulseaudio-utils`
  fornece `pactl`, usado por `volume.sh`.
- `xsetroot`, `xrdb`, `xset` e `setxkbmap` são pacotes avulsos.
- `wireless-tools`/`iwgetid` não existem nos repositórios. O `network.sh` usa `iw`
  primeiro e só cai para `iwgetid` como fallback, então a barra continua funcionando.
- `ncurses` fornece o `tic`, usado pelo `make install` do st para registrar o terminfo `st-256color`.
- `mpd` não está nos repositórios oficiais. Se quiser o player de música:

  ```sh
  sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install -y mpd
  ```

## 2. Fontes Nerd

Não há pacotes de Nerd Fonts nos repositórios oficiais do Fedora. Baixe as duas
famílias usadas pelo dwm:

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

O `emptty` não está nos repositórios oficiais do Fedora. Inicie o dwm direto:

```sh
startx dwm
```

O patch de autostart do dwm executa `~/.local/share/dwm/autostart.sh`
(wallpaper, picom, dunst e dwmblocks). Se quiser um login manager, instale o
`emptty` do COPR/fonte e habilite o serviço dele.

## 4. Continuar

Siga [COMMON.md](COMMON.md) para copiar os dotfiles, ajustar permissões,
compilar o suckless e instalar os plugins do vim.

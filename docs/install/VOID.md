# Instalação — Void Linux

Validado em 25/11/2026 com `voidlinux/voidlinux:latest` (contêiner limpo,
x86_64 glibc).

Use `sudo` (o `doas` não faz parte da instalação padrão do Void).

## 1. Pacotes

No Void o `xbps` precisa ser atualizado em uma transação separada antes do
resto do sistema:

```sh
sudo xbps-install -Su xbps
sudo xbps-install -Suy
sudo xbps-install -Sy \
    bash ca-certificates curl dbus feh fontconfig fzf gvim vim xclip \
    iw wireless_tools shadow adwaita-icon-theme pavucontrol rofi \
    xorg xinit xsetroot xset xrdb setxkbmap xorg-fonts \
    nerd-fonts-ttf nerd-fonts-symbols-ttf \
    gcc make pkg-config libX11-devel libXinerama-devel libXft-devel \
    freetype-devel fontconfig-devel xz git unzip sudo procps-ng \
    emptty pipewire wireplumber dunst pulseaudio-utils \
    mpd mpc ncmpcpp picom ncurses
```

- `xorg` já traz o servidor X, `xinit`, `xsetroot`, `xset` e `xrandr`; os
  utilitários `xrdb` e `setxkbmap` são listados para deixar explícito o que os
  dotfiles usam.
- `wireless_tools` (com underscore) fornece `iwgetid`, usado como fallback em
  `network.sh`.
- `nerd-fonts-ttf` fornece `JetBrainsMono Nerd Font` e
  `nerd-fonts-symbols-ttf` fornece `Symbols Nerd Font`, as duas famílias
  pedidas pelo `config.h` do dwm e do st.
- `libX11-devel`, `libXinerama-devel`, `libXft-devel`, `freetype-devel` e
  `fontconfig-devel` são necessários para compilar dwm, dmenu e st.
- `pipewire` inclui o comando `pipewire-pulse` no Void; **não** existe um
  pacote separado `pipewire-pulse` como no Alpine/Arch.
- `ncurses` fornece o `tic`, usado pelo `make install` do st para registrar o
  terminfo `st-256color`.

## 2. Serviços (runit)

```sh
sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/emptty /var/service/
```

O `emptty` lê `/etc/emptty/conf`, instalado a partir de `root/` neste
repositório. O serviço runit dele fica em `/etc/sv/emptty`.

O Void já habilita `agetty-tty1` por padrão; ele entra em conflito com o
emptty em `tty1`. A etapa 2 de [COMMON.md](COMMON.md) marca o serviço como
`down` e remove o link. Para aplicar imediatamente nesta etapa:

```sh
sudo touch /etc/sv/agetty-tty1/down
sudo rm -f /var/service/agetty-tty1 /etc/runit/runsvdir/default/agetty-tty1
```

### Sessão e PATH (runit)

É no Void que o problema do PATH aparece com mais frequência: o stage 2 do
runit exporta `PATH=/usr/bin:/usr/sbin` para os serviços e o emptty repassa
esse PATH para a sessão. Um `Exec=dwm` falharia com "executable file not found
in $PATH" mesmo com `/usr/local/bin/dwm` instalado.

A correção vale para **todas** as distros e já vem no repositório: o
`dwm.desktop` chama o dwm por caminho absoluto e define o PATH da sessão, e o
`autostart.sh` exporta o mesmo PATH para os filhos. Veja a explicação em
[COMMON.md](COMMON.md). Depois de copiar `root/` e compilar:

```sh
test -x /usr/local/bin/dwm && grep '^Exec=' /usr/share/xsessions/dwm.desktop
```

## 3. Continuar

Siga [COMMON.md](COMMON.md) para copiar os dotfiles, liberar a TTY do
emptty, ajustar permissões, compilar o suckless e instalar os plugins do vim.

Se preferir iniciar o dwm sem emptty:

```sh
startx dwm
```

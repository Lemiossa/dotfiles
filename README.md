# Dotfiles

This is my dotfiles.

## Requisitos

### Base
- xorg (xinit, xsetroot)
- dbus (dbus-run-session, dbus-daemon)
- setxkbmap
- feh
- pipewire
- pipewire-pulse
- wireplumber
- dunst
- bspwm
- sxhkd
- polybar
- gvim
- xclip
- shadow
- adwaita-icon-theme
- pavucontrol
- alacritty
- rofi
- font-jetbrains-mono (usado pelo polybar)
- vim (plugins via vim-plug, instale na primeira execução com `:PlugInstall`)
- nerd-fonts

### Aparência (opcional)
Para instalar o tema visual completo sem root:
- git
- curl
- unzip
- python3 (usado para ajustar a cor das pastas dos ícones)

O script `scripts/install-appearance.sh` instala no seu perfil:
- Tema GTK3 Gruvbox Plus com destaque roxo
- Ícones Gruvbox Plus com pastas roxas
- Cursores Capitaine Cursors (Gruvbox)

### Para uma melhor experiência
Para animações:
- picom
Para música:
- mpd
- mpc
- ncmpcpp

## Tema

O tema é o **Gruvbox Dark** com destaque em roxo (`#D3869B`). A paleta é aplicada em:
- Alacritty, Polybar, Dunst, Rofi e bordas do bspwm
- Vim (colorscheme `gruvbox-purple`) e Lightline
- Prompt do bash, cores do `ls` (quando `coreutils`/`dircolors` estiver disponível)
- GTK3/GTK4, ícones, cursores e wallpaper

O wallpaper fica em `~/Pictures/Wallpapers/gruvbox-purple.png` e pode ser regerado com:
```sh
python3 scripts/generate-wallpaper.py
```

## Install

The first step is install all packages

### Alpine
```sh
doas apk update
doas setup-xorg-base
doas apk add polybar bspwm sxhkd feh pipewire pipewire-pulse \
        wireplumber dunst gvim vim xclip shadow adwaita-icon-theme \
        pavucontrol alacritty rofi font-jetbrains-mono nerd-fonts-all
# Optional
doas apk add mpd mpc ncmpcpp picom
```

After this, set the bash to default shell and copy the home/ files
```sh
chsh -s $(which bash)
cp -af home/. ~/
```

Make sure the scripts are executable:
```sh
chmod +x ~/.xinitrc ~/.services.sh ~/.gservices.sh ~/.start.sh ~/.config/bspwm/bspwmrc ~/.config/bspwm/services.sh scripts/install-appearance.sh
```

Instale os assets visuais (sem root):
```sh
./scripts/install-appearance.sh
```

Update font cache:
```sh
fc-cache -fv
```

Then start the graphical session with:
```sh
startx
```

The wallpaper is set by bspwmrc from `~/Pictures/Wallpapers/` (currently `gruvbox-purple.png`).

### Third Party
- GTK theme: https://github.com/SylEleuth/gruvbox-plus-gtk
- Icon pack: https://github.com/SylEleuth/gruvbox-plus-icon-pack
- Cursors: https://github.com/sainnhe/capitaine-cursors (variante Gruvbox)
- Vim/lightline: https://github.com/morhetz/gruvbox (adaptado com destaque roxo)
- Gruvbox wallpapers: https://gruvbox-wallpapers.pages.dev/


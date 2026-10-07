# Dotfiles

This is my dotfiles.

## Requeriments

### Base
- xorg
- startx
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
- font-jetbrains-mono (used by polybar)
- vim (plugins via vim-plug, install them on first run with `:PlugInstall`)

### For better experince
For animations:
- picom
For Musics:
- mpd
- mpc
- ncmpcpp

## Install

The first step is install all packages

### Alpine
```sh
doas apk update
doas setup-xorg-base
doas apk add polybar bspwm sxhkd feh pipewire pipewire-pulse \
        wireplumber dunst gvim vim xclip shadow adwaita-icon-theme \
        pavucontrol alacritty rofi font-jetbrains-mono
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
chmod +x ~/.xinitrc ~/.services.sh ~/.gservices.sh ~/.config/bspwm/bspwmrc ~/.config/bspwm/services.sh
```

Update font cache:
```sh
fc-cache -fv
```

Then start the graphical session with:
```sh
startx
```

The wallpaper is set by bspwmrc from `~/Pictures/Wallpapers/` (currently `viozene-circuits-dark.png`).

### Third Party
- Vim/lightline/Alacritty theme: https://github.com/Lemiossa/Viozene
- Gruvbox wallpapers: https://gruvbox-wallpapers.pages.dev/


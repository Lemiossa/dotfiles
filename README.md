# dotfiles

Atenção: isso foi pensado para ser instalado no void-linux, caso queira instalar em arch-linux ou outros, você terá que adaptar
Foi pensado mais como um setup pos-instalação

## Configurações
- cava
- vim

## Programas
- dwm
- dwmblocks
- alacritty
- dmenu

## Dependências

### X11
- xorg
- xinit
- xrandr
- xsetroot
- xprop
- xev
- mesa

### dwm
- libX11-devel
- libXinerama-devel
- libXft-devel
- fontconfig-devel
- imlib2-devel

## Outros pacotes para instalar
- picom
- vim-x11
- fastfetch
- cava
- bash
- NetworkManager
- dbus
- alacritty
- elogind
- pavucontrol
- polkit
- xclip
- nodejs
- git
- feh
- luakit

## Como instalar
```bash
git clone https://github.com/Lemiossa/dotfiles.git
cd dotfiles
./install.sh # Vai instalar dependencias

# Compilar dwm, dwmblocks, st e dmenu
cd dwm
sudo make clean install

cd ../dwmblocks
sudo make clean install

cd ../dmenu
sudo make clean install

chsh -s $(which bash)

sudo reboot # Aplicar mudanças
```

Você verá o login no tty(agetty)

depois de logar, use:

```bash
startx
```

Inclue um script de instalação

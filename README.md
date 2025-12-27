# leme-dotfiles

Atenção: isso foi pensado para ser instalado no void-linux, caso queira instalar em arch-linux ou outros, você terá que adaptar
Foi pensado mais como um setup pos-instalação

## Pacotes do xbps para void
- discord

## Configurações
- cava
- picom
- vim
- fastfetch

## Programas
- dwm
- dwmblocks
- st
- surf
- dmenu
- tabbed

## Dependências

### X11
- xorg
- xinit
- xrandr
- xsetroot
- xprop
- xev
- mesa

### dwm e st
- libX11-devel
- libXinerama-devel
- libXft-devel
- fontconfig-devel

### surf 
- libwebkit2gtk41
- libwebkit2gtk41-devel
- gcr-devel
- libX11-devel
- libXinerama-devel

## Outros pacotes para instalar
- picom
- vim-x11
- fastfetch
- cava
- bash
- nerd-fonts
- NetworkManager
- dbus 
- elogind
- pavucontrol
- polkit
- xclip
- nodejs
- git

## Como instalar
```bash
sudo xbps-install -S 

sudo xbps-install -y \
xorg \
xinit \
xrandr \
xsetroot \
xprop \
xev \
mesa 

sudo xbps-install -y \
base-devel \
pkg-config \
git \
curl

sudo xbps-install -y \
libX11-devel \
libXinerama-devel \
libXft-devel \
fontconfig-devel

sudo xbps-install -y \
libwebkit2gtk41 \
libwebkit2gtk41-devel \
gcr-devel

sudo xbps-install -y \
picom \
vim-x11 \
fastfetch \
cava \
bash \
nerd-fonts \
pavucontrol \
xclip \
nodejs \
dbus \
NetworkManager \
elogind \
polkit

# Serviços
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/elogind /var/service
sudo ln -s /etc/sv/udevd /var/service
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/polkitd /var/service

git clone https://github.com/Lemiossa/leme-dotfiles.git
cd leme-dotfiles
./install.sh

# Compilar dwm, st e surf
cd dwm
sudo make clean install

cd ../st
sudo make clean install

cd ../surf
sudo make clean install

cd ../dmenu
sudo make clean install

cd ../tabbed
sudo make clean install

# Vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

chsh -s $(which bash) 

sudo reboot # Aplicar mudanças
```

Você verá o login no tty(agetty)

depois de logar, use:

```bash
startx
```

Inclue um instalador

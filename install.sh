#!/bin/bash

set -euo pipefail

# --- Cores para output ---
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# --- Funções de Logging ---
log_info() { echo -e "${GREEN}[INFO]${NC}  $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_step() { echo -e "${BLUE}[STEP]${NC}  $1"; }

# --- Verificações Iniciais ---
if [[ $EUID -eq 0 ]]; then
	log_error "Este script não deve ser executado como root diretamente. Use um usuário comum com sudo."
	exit 1
fi

# --- Detecção de Distro ---
if [ -f /etc/os-release ]; then
	. /etc/os-release
	DISTRO=$ID
else
	log_error "Não foi possível detectar a distribuição."
	exit 1
fi

log_info "Detectado: $NAME"

# --- Configuração de Pacotes por Distro ---
case $DISTRO in
fedora)
	PKG_MANAGER="sudo dnf"
	INSTALL_CMD="install -y"
	UPDATE_CMD="upgrade -y"
	XORG_PKGS=(xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-apps mesa-dri-drivers)
	DEV_PKGS=(@development-tools pkgconfig git curl clang clang-tools-extra)
	LIB_PKGS=(libX11-devel libXinerama-devel libXft-devel fontconfig-devel imlib2-devel)
	APP_PKGS=(vim-X11 cava bash pavucontrol xclip nodejs feh firefox unzip)
	SYS_PKGS=(dbus NetworkManager polkit lightdm lightdm-gtk-greeter)
	INIT_SYS="systemd"
	;;
arch)
	PKG_MANAGER="sudo pacman"
	INSTALL_CMD="-S --noconfirm --needed"
	UPDATE_CMD="-Syu --noconfirm"
	XORG_PKGS=(xorg-server xorg-xinit xorg-xrandr xorg-xsetroot xorg-xprop xorg-xev mesa)
	DEV_PKGS=(base-devel pkgconf git curl clang)
	LIB_PKGS=(libx11 libxinerama libxft fontconfig imlib2)
	APP_PKGS=(gvim cava bash pavucontrol xclip nodejs feh firefox unzip)
	SYS_PKGS=(dbus networkmanager polkit lightdm lightdm-gtk-greeter)
	INIT_SYS="systemd"
	;;
debian | ubuntu)
	PKG_MANAGER="sudo apt-get"
	INSTALL_CMD="install -y"
	UPDATE_CMD="update && sudo apt-get upgrade -y"
	XORG_PKGS=(xorg xinit x11-xserver-utils mesa-utils)
	DEV_PKGS=(build-essential pkg-config git curl clang clangd)
	LIB_PKGS=(libx11-dev libxinerama-dev libxft-dev libfontconfig1-dev libimlib2-dev)
	APP_PKGS=(vim-gtk3 cava bash pavucontrol alsa-utils xclip nodejs feh firefox-esr unzip wpa_supplicant)
	SYS_PKGS=(dbus network-manager lightdm lightdm-gtk-greeter)
	INIT_SYS="systemd"
	;;
void)
	PKG_MANAGER="sudo xbps-install"
	INSTALL_CMD="-y"
	UPDATE_CMD="-Syu"
	XORG_PKGS=(xorg xinit xrandr xsetroot xprop xev mesa)
	DEV_PKGS=(base-devel pkg-config git curl clang clang-tools-extra)
	LIB_PKGS=(libX11-devel libXinerama-devel libXft-devel fontconfig-devel imlib2-devel)
	APP_PKGS=(vim-x11 cava bash pavucontrol xclip nodejs feh firefox unzip)
	SYS_PKGS=(dbus NetworkManager elogind polkit lightdm lightdm-gtk-greeter)
	INIT_SYS="runit"
	;;
*)
	log_error "Distribuição não suportada."
	exit 1
	;;
esac

# --- 1. Atualização ---
log_step "Atualizando repositórios..."
eval "$PKG_MANAGER $UPDATE_CMD"

# --- 2. Instalação ---
log_step "Instalando todos os pacotes..."
ALL_PKGS=("${XORG_PKGS[@]}" "${DEV_PKGS[@]}" "${LIB_PKGS[@]}" "${APP_PKGS[@]}" "${SYS_PKGS[@]}")
eval "$PKG_MANAGER $INSTALL_CMD ${ALL_PKGS[*]}"

# --- 3. Dotfiles ---
log_step "Copiando arquivos de configuração (home)..."
if [[ -d "home" ]]; then
	cp -rv home/. "${HOME}/"
	find "${HOME}/.config/dwmblocks" -name "*.sh" -exec chmod +x {} +
fi

# --- 4. Serviços ---
log_step "Configurando serviços ($INIT_SYS)..."
case $INIT_SYS in
systemd)
	for svc in dbus NetworkManager lightdm; do
		sudo systemctl enable $svc || true
	done
	sudo systemctl disable --now dhcpcd 2>/dev/null || true
	if [[ "$DISTRO" != "debian" && "$DISTRO" != "ubuntu" ]]; then
		sudo systemctl disable --now wpa_supplicant 2>/dev/null || true
	fi
	;;
runit)
	for svc in dbus elogind udevd NetworkManager polkitd lightdm; do
		[ -d "/etc/sv/$svc" ] && sudo ln -sf "/etc/sv/$svc" /var/service/ || true
	done
	;;
esac

# --- 5. Componentes Globais ---
log_step "Instalando componentes adicionais..."
for tool in "shell-color-scripts:https://github.com/charitarthchugh/shell-color-scripts.git:colorscript.sh:colorscript" \
	"pipes.sh:https://github.com/pipeseroni/pipes.sh:pipes.sh:pipes" \
	"pfetch:https://github.com/dylanaraps/pfetch.git:pfetch:pfetch"; do
	IFS=":" read -r name repo script bin <<<"$tool"
	if [[ ! -d "/opt/$name" ]]; then
		sudo git clone "$repo" "/opt/$name"
		sudo ln -sf "/opt/$name/$script" "/usr/local/bin/$bin"
		sudo chmod +x "/usr/local/bin/$bin"
	fi
done

# --- 6. Fontes ---
log_step "Instalando FiraCode Nerd Font..."
if [[ -f "FiraCodeNerd.zip" ]]; then
	TEMP_DIR=$(mktemp -d)
	unzip -q "FiraCodeNerd.zip" -d "$TEMP_DIR"
	sudo mkdir -p /usr/share/fonts/truetype/FiraCodeNerd
	sudo cp "$TEMP_DIR"/*.ttf /usr/share/fonts/truetype/FiraCodeNerd/ 2>/dev/null || true
	sudo fc-cache -f
	rm -rf "$TEMP_DIR"
fi

# --- 7. Vim Plug ---
log_step "Configurando Vim-Plug..."
if [[ ! -f "${HOME}/.vim/autoload/plug.vim" ]]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	[ -f "${HOME}/.vimrc" ] && vim +PlugInstall +qall || true
fi

# --- 8. Suckless ---
log_step "Compilando Suckless..."
if [[ -d "suckless" ]]; then
	PROGS=(dwm st dmenu dwmblocks)
	for prog in "${PROGS[@]}"; do
		if [[ -d "suckless/$prog" ]]; then
			cd "suckless/$prog"
			sudo make clean install
			make clean
			cd - >/dev/null
		fi
	done
fi

# --- 9. Login Manager (LightDM GTK OneDark) ---
log_step "Customizando LightDM com GTK Greeter OneDark..."

# Criar entrada XSession para o dwm
sudo mkdir -p /usr/share/xsessions
sudo bash -c 'cat > /usr/share/xsessions/dwm.desktop <<EOF
[Desktop Entry]
Name=dwm
Comment=Dynamic Window Manager
Exec=dwm
Type=Application
EOF'

# Criar CSS OneDark
sudo mkdir -p /etc/lightdm
sudo bash -c 'cat > /etc/lightdm/greeter.css <<EOF
window { background-color: #282c34; color: #abb2bf; font-family: "FiraCode Nerd Font", "Sans"; }
#login_window { background-color: #21252b; border: 2px solid #61afef; border-radius: 12px; padding: 40px; box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5); }
entry { background-color: #282c34; color: #abb2bf; border: 1px solid #3e4452; border-radius: 6px; padding: 10px; margin-bottom: 10px; caret-color: #61afef; }
entry:focus { border-color: #61afef; box-shadow: 0 0 5px #61afef; }
button { background-color: #3e4452; color: #abb2bf; border-radius: 6px; padding: 8px 16px; border: none; }
button:hover { background-color: #61afef; color: #21252b; }
label { color: #abb2bf; font-weight: bold; }
#panel { background-color: transparent; color: #abb2bf; }
#message_label { color: #e06c75; }
EOF'

# Configurar o Greeter
sudo bash -c 'cat > /etc/lightdm/lightdm-gtk-greeter.conf <<EOF
[greeter]
background = #282c34
theme-name = Adwaita-dark
icon-theme-name = Adwaita
font-name = FiraCode Nerd Font 11
user-background = false
hide-user-image = true
indicators = ~time;~spacer;~power
pos = 50%, center
user-css-file = /etc/lightdm/greeter.css
EOF'

# Definir como padrão
sudo sed -i 's/^#greeter-session=.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
sudo sed -i 's/^greeter-session=.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf

if grep -q "^user-session=" /etc/lightdm/lightdm.conf; then
	sudo sed -i 's/^user-session=.*/user-session=dwm/' /etc/lightdm/lightdm.conf
else
	echo -e "\n[Seat:*]\nuser-session=dwm" | sudo tee -a /etc/lightdm/lightdm.conf
fi

log_step "CONCLUÍDO! O LightDM agora usa o GTK Greeter com tema OneDark customizado."

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
gentoo)
	PKG_MANAGER="sudo emerge"
	INSTALL_CMD="--ask=n"
	UPDATE_CMD="--sync"
	XORG_PKGS=(x11-base/xorg-server x11-apps/xinit media-libs/mesa)
	DEV_PKGS=(sys-devel/gcc sys-devel/make dev-util/pkgconf dev-vcs/git net-misc/curl sys-devel/clang)
	LIB_PKGS=(x11-libs/libX11 x11-libs/libXinerama x11-libs/libXft media-libs/fontconfig media-libs/imlib2)
	APP_PKGS=(app-editors/vim media-sound/cava app-shells/bash media-sound/pavucontrol x11-misc/xclip net-libs/nodejs media-gfx/feh www-client/firefox app-arch/unzip)
	SYS_PKGS=(sys-apps/dbus net-misc/networkmanager sys-auth/polkit sys-auth/elogind x11-misc/lightdm x11-misc/lightdm-gtk-greeter)
	INIT_SYS="openrc"
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

# --- 4. Serviços e Prevenção de Quebras ---
log_step "Configurando serviços ($INIT_SYS)..."
case $INIT_SYS in
systemd)
	for svc in dbus NetworkManager lightdm; do
		sudo systemctl enable $svc || true
	done

	log_info "Limpando conflitos de rede..."
	sudo systemctl disable --now dhcpcd 2>/dev/null || true

	if [[ "$DISTRO" != "debian" && "$DISTRO" != "ubuntu" ]]; then
		sudo systemctl disable --now wpa_supplicant 2>/dev/null || true
	fi
	;;
openrc)
	for svc in dbus elogind NetworkManager lightdm; do
		sudo rc-update add $svc default || true
	done
	;;
runit)
	for svc in dbus elogind udevd NetworkManager polkitd lightdm; do
		[ -d "/etc/sv/$svc" ] && sudo ln -sf "/etc/sv/$svc" /var/service/ || true
	done
	;;
esac

# --- 5. Componentes Globais ---
log_step "Instalando componentes adicionais..."
# Colorscripts
if [[ ! -d "/opt/shell-color-scripts" ]]; then
	sudo git clone https://github.com/charitarthchugh/shell-color-scripts.git /opt/shell-color-scripts
	sudo ln -sf /opt/shell-color-scripts/colorscript.sh /usr/local/bin/colorscript
	sudo chmod +x /usr/local/bin/colorscript
fi
# Pipes
if [[ ! -d "/opt/pipes.sh" ]]; then
	sudo git clone https://github.com/pipeseroni/pipes.sh /opt/pipes.sh
	sudo ln -sf /opt/pipes.sh/pipes.sh /usr/local/bin/pipes
	sudo chmod +x /usr/local/bin/pipes
fi
# pfetch
if [[ ! -d "/opt/pfetch" ]]; then
	sudo git clone https://github.com/dylanaraps/pfetch.git /opt/pfetch
	sudo ln -sf /opt/pfetch/pfetch /usr/local/bin/pfetch
	sudo chmod +x /usr/local/bin/pfetch
fi

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

# --- 9. Login Manager (LightDM Custom OneDark) ---
log_step "Customizando LightDM (Estilo Antergos-Dark)..."

# Criar entrada XSession para o dwm
sudo mkdir -p /usr/share/xsessions
sudo bash -c 'cat > /usr/share/xsessions/dwm.desktop <<EOF
[Desktop Entry]
Name=dwm
Comment=Dynamic Window Manager
Exec=dwm
Type=Application
EOF'

# Criar CSS customizado OneDark
sudo mkdir -p /etc/lightdm/
sudo bash -c 'cat > /etc/lightdm/greeter.css <<EOF
/* Fundo OneDark */
window {
    background-color: #282c34;
    background-image: none;
}

/* Caixa de Login Estilo Webkit/Antergos */
#login_window {
    background-color: #21252b;
    border: 1px solid #61afef;
    border-radius: 10px;
    padding: 25px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.5);
}

/* Inputs e Botões */
entry {
    background-color: #282c34;
    color: #abb2bf;
    border: 1px solid #3e4452;
    border-radius: 4px;
    caret-color: #61afef;
    margin: 5px 0;
}

label {
    color: #abb2bf;
}

#shutdown_button, #restart_button {
    color: #e06c75;
}
EOF'

# Aplicar configuração no LightDM GTK Greeter
sudo bash -c 'cat > /etc/lightdm/lightdm-gtk-greeter.conf <<EOF
[greeter]
background = #282c34
theme-name = Adwaita-dark
icon-theme-name = Adwaita
font-name = FiraCode Nerd Font 11
user-background = false
hide-user-image = false
default-user-image = #61afef
indicators = ~time;~spacer;~power
pos = 50%, center
user-css-file = /etc/lightdm/greeter.css
EOF'

# Definir dwm como sessão padrão
sudo sed -i 's/^#user-session=.*/user-session=dwm/' /etc/lightdm/lightdm.conf ||
	echo "[Seat:*]
user-session=dwm" | sudo tee -a /etc/lightdm/lightdm.conf

log_step "CONCLUÍDO! Reinicie para entrar no seu novo dwm."

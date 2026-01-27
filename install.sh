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
	DEV_PKGS=(@development-tools pkgconfig git curl clang clang-tools-extra zig)
	LIB_PKGS=(libX11-devel libXinerama-devel libXft-devel fontconfig-devel imlib2-devel pam-devel)
	APP_PKGS=(vim-X11 cava bash pavucontrol xclip nodejs feh firefox unzip)
	SYS_PKGS=(dbus NetworkManager polkit)
	INIT_SYS="systemd"
	;;
arch)
	PKG_MANAGER="sudo pacman"
	INSTALL_CMD="-S --noconfirm --needed"
	UPDATE_CMD="-Syu --noconfirm"
	XORG_PKGS=(xorg-server xorg-xinit xorg-xrandr xorg-xsetroot xorg-xprop xorg-xev mesa)
	DEV_PKGS=(base-devel pkgconf git curl clang zig)
	LIB_PKGS=(libx11 libxinerama libxft fontconfig imlib2 pam)
	APP_PKGS=(gvim cava bash pavucontrol xclip nodejs feh firefox unzip)
	SYS_PKGS=(dbus networkmanager polkit)
	INIT_SYS="systemd"
	;;
debian | ubuntu)
	PKG_MANAGER="sudo apt-get"
	INSTALL_CMD="install -y"
	UPDATE_CMD="update && sudo apt-get upgrade -y"
	XORG_PKGS=(xorg xinit x11-xserver-utils mesa-utils)
	DEV_PKGS=(build-essential pkg-config git curl clang clangd)
	LIB_PKGS=(libx11-dev libxinerama-dev libxft-dev libfontconfig1-dev libimlib2-dev libpam0g-dev)
	APP_PKGS=(vim-gtk3 cava bash pavucontrol alsa-utils xclip nodejs feh firefox-esr unzip wpa_supplicant)
	SYS_PKGS=(dbus network-manager)
	INIT_SYS="systemd"
	;;
void)
	PKG_MANAGER="sudo xbps-install"
	INSTALL_CMD="-y"
	UPDATE_CMD="-Syu"
	XORG_PKGS=(xorg xinit xrandr xsetroot xprop xev mesa)
	DEV_PKGS=(base-devel pkg-config git curl clang clang-tools-extra zig)
	LIB_PKGS=(libX11-devel libXinerama-devel libXft-devel fontconfig-devel imlib2-devel pam-devel)
	APP_PKGS=(vim-x11 cava bash pavucontrol xclip nodejs feh firefox unzip)
	SYS_PKGS=(dbus NetworkManager elogind polkit)
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
	if [[ -d "${HOME}/.config/dwmblocks" ]]; then
		find "${HOME}/.config/dwmblocks" -name "*.sh" -exec chmod +x {} +
	fi
fi

cp -r suckless ~/

# --- 5. Serviços ---
log_step "Configurando serviços ($INIT_SYS)..."
case $INIT_SYS in
systemd)
	for svc in dbus NetworkManager; do
		sudo systemctl enable "$svc" 2>/dev/null || true
	done
	# Desabilita serviços conflitantes
	sudo systemctl disable --now dhcpcd 2>/dev/null || true
	if [[ "$DISTRO" != "debian" && "$DISTRO" != "ubuntu" ]]; then
		sudo systemctl disable --now wpa_supplicant 2>/dev/null || true
	fi
	;;
runit)
	for svc in dbus elogind udevd NetworkManager polkitd; do
		[ -d "/etc/sv/$svc" ] && sudo ln -sf "/etc/sv/$svc" /var/service/ 2>/dev/null || true
	done
	;;
esac

# --- 6. Componentes Globais ---
log_step "Instalando componentes adicionais..."
declare -A TOOLS=(
	["shell-color-scripts"]="https://github.com/charitarthchugh/shell-color-scripts.git:colorscript.sh:colorscript"
	["pipes.sh"]="https://github.com/pipeseroni/pipes.sh:pipes.sh:pipes"
	["pfetch"]="https://github.com/dylanaraps/pfetch.git:pfetch:pfetch"
)

for name in "${!TOOLS[@]}"; do
	IFS=":" read -r repo script bin <<<"${TOOLS[$name]}"
	if [[ ! -d "/opt/$name" ]]; then
		sudo git clone "$repo" "/opt/$name" 2>/dev/null || continue
		if [[ -f "/opt/$name/$script" ]]; then
			sudo ln -sf "/opt/$name/$script" "/usr/local/bin/$bin"
			sudo chmod +x "/usr/local/bin/$bin"
		fi
	fi
done

# --- 7. Fontes ---
log_step "Instalando FiraCode Nerd Font..."
if [[ -f "FiraCodeNerd.zip" ]]; then
	TEMP_DIR=$(mktemp -d)
	unzip -q "FiraCodeNerd.zip" -d "$TEMP_DIR" 2>/dev/null || {
		log_warn "Falha ao extrair fonte. Continuando..."
	}
	if [[ -n "$(ls -A "$TEMP_DIR"/*.ttf 2>/dev/null)" ]]; then
		sudo mkdir -p /usr/share/fonts/truetype/FiraCodeNerd
		sudo cp "$TEMP_DIR"/*.ttf /usr/share/fonts/truetype/FiraCodeNerd/ 2>/dev/null || true
		sudo fc-cache -f
	fi
	rm -rf "$TEMP_DIR"
else
	log_warn "FiraCodeNerd.zip não encontrado. Pulando instalação de fonte."
fi

# --- 8. Vim Plug ---
log_step "Configurando Vim-Plug..."
if [[ ! -f "${HOME}/.vim/autoload/plug.vim" ]]; then
	curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	if [[ -f "${HOME}/.vimrc" ]]; then
		vim +PlugInstall +qall 2>/dev/null || log_warn "Instalação de plugins do Vim pode precisar ser feita manualmente"
	fi
fi

# --- 9. Suckless ---
log_step "Compilando Suckless..."
if [[ -d "suckless" ]]; then
	PROGS=(dwm st dmenu dwmblocks)
	for prog in "${PROGS[@]}"; do
		if [[ -d "suckless/$prog" ]]; then
			log_info "Compilando $prog..."
			(
				cd "suckless/$prog" || exit
				sudo make clean install 2>/dev/null || {
					log_error "Falha ao compilar $prog"
					exit 1
				}
				make clean 2>/dev/null || true
			)
		fi
	done
else
	log_warn "Diretório 'suckless' não encontrado. Pulando compilação."
fi

# --- 10. Configuração final ---
log_step "Configurações finais..."
# Garante que .xinitrc existe
if [[ ! -f "${HOME}/.xinitrc" ]]; then
	echo "#!/bin/sh" > "${HOME}/.xinitrc"
	echo "exec dwm" >> "${HOME}/.xinitrc"
	chmod +x "${HOME}/.xinitrc"
fi

echo ""
log_step "CONCLUÍDO!"

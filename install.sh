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
alpine)
	PKG_MANAGER="sudo apk"
	INSTALL_CMD="add"
	UPDATE_CMD="update"
	XORG_PKGS=(xorg-server xinit xrandr xsetroot xprop xev mesa-dri-gallium)
	DEV_PKGS=(build-base pkgconf git curl clang21 clang21-extra-tools npm)
	LIB_PKGS=(libx11-dev libxinerama-dev libxft-dev fontconfig-dev imlib2-dev linux-pam-dev harfbuzz harfbuzz-dev)
	APP_PKGS=(vim bash bash-completion pavucontrol xclip nodejs feh chromium unzip i3 i3blocks i3-gaps papirus-icon-theme rofi terminus-font)
	SYS_PKGS=(dbus networkmanager polkit-elogind)
	INIT_SYS="openrc"
	;;
fedora)
	PKG_MANAGER="sudo dnf"
	INSTALL_CMD="install -y"
	UPDATE_CMD="upgrade -y"
	XORG_PKGS=(xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-apps mesa-dri-drivers)
	DEV_PKGS=(@development-tools pkgconfig git curl clang clang-tools-extra zig cargo npm)
	LIB_PKGS=(libX11-devel libXinerama-devel libXft-devel fontconfig-devel imlib2-devel pam-devel harfbuzz harfbuzz-devel rofi)
	APP_PKGS=(vim-X11 cava bash bash-completion pavucontrol xclip nodejs feh chromium unzip i3 i3blocks i3-gaps papirus-icon-theme terminus-fonts)
	SYS_PKGS=(dbus NetworkManager polkit)
	INIT_SYS="systemd"
	;;
arch)
	PKG_MANAGER="sudo pacman"
	INSTALL_CMD="-S --noconfirm --needed"
	UPDATE_CMD="-Syu --noconfirm"
	XORG_PKGS=(xorg-server xorg-xinit xorg-xrandr xorg-xsetroot xorg-xprop xorg-xev mesa)
	DEV_PKGS=(base-devel pkgconf git curl clang zig cargo npm)
	LIB_PKGS=(libx11 libxinerama libxft fontconfig imlib2 pam harfbuzz)
	APP_PKGS=(gvim cava bash bash-completion pavucontrol xclip nodejs feh chromium unzip i3 i3blocks i3-gaps papirus-icon-theme rofi terminus-font)
	SYS_PKGS=(dbus networkmanager polkit)
	INIT_SYS="systemd"
	;;
debian | ubuntu)
	PKG_MANAGER="sudo apt-get"
	INSTALL_CMD="install -y"
	UPDATE_CMD="update && sudo apt-get upgrade -y"
	XORG_PKGS=(xorg xinit x11-xserver-utils mesa-utils)
	DEV_PKGS=(build-essential pkg-config git curl clang clangd cargo npm)
	LIB_PKGS=(libx11-dev libxinerama-dev libxft-dev libfontconfig1-dev libimlib2-dev libpam0g-dev libharfbuzz-dev)
	APP_PKGS=(vim-gtk3 cava bash pavucontrol alsa-utils xclip nodejs feh chromium unzip wpa_supplicant i3 i3blocks papirus-icon-theme rofi xfonts-terminus)
	SYS_PKGS=(dbus network-manager)
	INIT_SYS="systemd"
	;;
void)
	PKG_MANAGER="sudo xbps-install"
	INSTALL_CMD="-y"
	UPDATE_CMD="-Syu"
	XORG_PKGS=(xorg xinit xrandr xsetroot xprop xev mesa)
	DEV_PKGS=(base-devel pkg-config git curl clang clang-tools-extra cargo)
	LIB_PKGS=(libX11-devel libXinerama-devel libXft-devel fontconfig-devel imlib2-devel pam-devel harfbuzz harfbuzz-devel)
	APP_PKGS=(vim-gtk3 cava bash bash-completion pavucontrol alsa-utils xclip nodejs feh chromium unzip wpa_supplicant i3 i3blocks papirus-icon-theme rofi xfonts-terminus)
	SYS_PKGS=(dbus NetworkManager elogind polkit)
	INIT_SYS="runit"
	;;
gentoo)
	PKG_MANAGER="sudo emerge"
	INSTALL_CMD="-q --autounmask-write --deep --newuse"
	UPDATE_CMD="--sync && sudo emerge -uDN @world"
	XORG_PKGS=("x11-base/xorg-server" "x11-apps/xinit" "x11-apps/xrandr" "x11-apps/xsetroot" "x11-apps/xprop" "x11-apps/xev" "media-libs/mesa")
	DEV_PKGS=("sys-devel/gcc" "sys-devel/make" "dev-vcs/git" "sys-devel/pkgconf" "net-misc/curl" "sys-devel/clang" "dev-lang/nodejs" "dev-lang/zig" "dev-lang/rust")
	LIB_PKGS=("x11-libs/libX11" "x11-libs/libXinerama" "x11-libs/libXft" "media-libs/fontconfig" "media-libs/imlib2" "sys-libs/pam" "media-libs/harfbuzz")
	APP_PKGS=("app-editors/vim" "media-sound/cava" "sys-apps/bash" "app-shells/bash-completion" "media-sound/pavucontrol" "media-sound/alsa-utils" "x11-misc/xclip" "dev-lang/nodejs" "media-gfx/feh" "www-client/chromium" "app-arch/unzip" "x11-wm/i3" "x11-wm/i3status" "x11-themes/papirus-icon-theme" "x11-misc/rofi" "media-fonts/terminus-font")
	SYS_PKGS=("sys-apps/dbus" "net-misc/networkmanager" "sys-auth/polkit")
	INIT_SYS="openrc"
	;;
*)
	log_error "Distribuição não suportada."
	exit 1
	;;
esac

# --- 1. Atualização ---
log_step "Atualizando repositórios..."
# Para Gentoo, --sync é executado antes do emerge -uDN @world
if [ "$DISTRO" = "gentoo" ]; then
    log_info "Sincronizando a árvore Portage..."
    sudo emerge --sync
    log_info "Atualizando o sistema Gentoo..."
    sudo emerge -uDN @world
else
    eval "$PKG_MANAGER $UPDATE_CMD"
fi

# --- 2. Instalação ---
log_step "Instalando todos os pacotes..."
ALL_PKGS=("${XORG_PKGS[@]}" "${DEV_PKGS[@]}" "${LIB_PKGS[@]}" "${APP_PKGS[@]}" "${SYS_PKGS[@]}")

if [ "$DISTRO" = "gentoo" ]; then
    # Para Gentoo, emerge pode precisar de --autounmask-write e depois um dispatch-conf
    log_info "Instalando pacotes no Gentoo. Isso pode gerar prompts para USE flags ou unmasking."
    log_info "Se solicitado, aceite as alterações de USE flags e execute 'etc-update' ou 'dispatch-conf' após a instalação."
    sudo emerge -q --autounmask-write --deep --newuse "${ALL_PKGS[@]}"
    log_info "Verifique se há atualizações de configuração com 'etc-update' ou 'dispatch-conf'."
else
    eval "$PKG_MANAGER $INSTALL_CMD ${ALL_PKGS[*]}"
fi

# --- 3. Dotfiles ---
log_step "Copiando arquivos de configuração ..."
if [[ -d "home" ]]; then
	cp -rv home/. "${HOME}/"
	if [[ -d "${HOME}/.config/i3blocks" ]]; then
		find "${HOME}/.config/i3blocks" -name "*.sh" -exec chmod +x {} +
	fi
fi

# --- 5. Serviços ---
log_step "Configurando serviços ($INIT_SYS)..."
case $INIT_SYS in	systemd)
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
	openrc)
		for svc in dbus networkmanager polkitd; do # Adicionado polkitd para Gentoo OpenRC
			sudo rc-update add "$svc" default 2>/dev/null || true
			sudo rc-service "$svc" start 2>/dev/null || true
		done
		# Desabilitar serviços conflitantes no OpenRC (ex: dhcpcd, wpa_supplicant)
		# A lógica exata pode variar, mas geralmente envolve remover do runlevel default
		sudo rc-update del dhcpcd default 2>/dev/null || true
		sudo rc-update del wpa_supplicant default 2>/dev/null || true
		;;
esac

# --- 6. Fontes ---
log_step "Instalando BigBlueTerminal Nerd Font..."
if [[ -f "BigBlueTerminal.zip" ]]; then
	TEMP_DIR=$(mktemp -d)
	unzip -q "BigBlueTerminal.zip" -d "$TEMP_DIR" 2>/dev/null || {
		log_warn "Falha ao extrair fonte. Continuando..."
	}
	if [[ -n "$(ls -A "$TEMP_DIR"/*.ttf 2>/dev/null)" ]]; then
		sudo mkdir -p /usr/share/fonts/truetype/BigBlueTerminalNerd
		sudo cp "$TEMP_DIR"/*.ttf /usr/share/fonts/truetype/BigBlueTerminalNerd/ 2>/dev/null || true
		sudo fc-cache -f
	fi
	rm -rf "$TEMP_DIR"
else
	log_warn "BigBlueTerminal.zip não encontrado. Pulando instalação de fonte."
fi

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

# --- 7. Configuração final ---
log_step "Configurações finais..."
# Garante que .xinitrc existe
if [[ ! -f "${HOME}/.xinitrc" ]]; then
	echo "#!/bin/sh" > "${HOME}/.xinitrc"
	echo "exec dwm" >> "${HOME}/.xinitrc"
	chmod +x "${HOME}/.xinitrc"
fi

echo ""
log_step "CONCLUIDO!"

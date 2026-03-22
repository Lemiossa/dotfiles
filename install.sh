#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# =============================================================================
#  Constantes
# =============================================================================
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/tmp/setup-$(date +%Y%m%d-%H%M%S).log"
readonly FONT_DIR_SYSTEM="/usr/share/fonts/truetype"
readonly CURSOR_THEME="Adwaita"
readonly ICON_THEME="Papirus-Dark"

# =============================================================================
#  Cores & Logging
# =============================================================================
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

_log() {
	local level="$1" color="$2"
	shift 2
	local msg="$*"
	local ts; ts="$(date '+%H:%M:%S')"
	echo -e "${color}${BOLD}[${level}]${NC} ${ts}  ${msg}" | tee -a "$LOG_FILE"
}

log_info()  { _log "INFO " "$GREEN"  "$@"; }
log_warn()  { _log "WARN " "$YELLOW" "$@"; }
log_error() { _log "ERROR" "$RED"    "$@" >&2; }
log_step()  { echo -e "\n${CYAN}${BOLD}━━━  $*  ━━━${NC}" | tee -a "$LOG_FILE"; }
log_ok()    { echo -e "  ${GREEN}✓${NC} $*" | tee -a "$LOG_FILE"; }
log_skip()  { echo -e "  ${YELLOW}↷${NC} $* (pulado)" | tee -a "$LOG_FILE"; }

# =============================================================================
#  Utilitários
# =============================================================================

# Verifica se um comando existe
has() { command -v "$1" &>/dev/null; }

# Instala pacotes apenas se ainda não estiverem presentes (por nome de comando)
# Uso: pkg_install_if_missing <comando_de_verificação> <pacote1> [pacote2 ...]
# Para pacotes sem comando direto use install_pkgs diretamente.
install_pkgs() {
	if [[ ${#@} -eq 0 ]]; then return 0; fi
	log_info "Instalando: $*"
	# shellcheck disable=SC2086
	eval "$PKG_MANAGER $INSTALL_CMD $*" >> "$LOG_FILE" 2>&1 || {
		log_warn "Falha ao instalar um ou mais pacotes acima. Verifique $LOG_FILE"
	}
}

# Copia arquivos de configuração de forma segura, com backup
safe_copy() {
	local src="$1" dst="$2"
	if [[ ! -e "$src" ]]; then
		log_warn "Fonte não encontrada: $src"
		return 0
	fi
	if [[ -e "$dst" && ! -L "$dst" ]]; then
		cp -a "$dst" "${dst}.bak.$(date +%s)" 2>/dev/null || true
	fi
	cp -rv "$src" "$dst" >> "$LOG_FILE" 2>&1
	log_ok "Copiado: $src → $dst"
}

# Habilita um serviço no init system correto
enable_service() {
	local svc="$1"
	case $INIT_SYS in
		systemd)
			sudo systemctl enable --now "$svc" 2>/dev/null || true ;;
		runit)
			[[ -d "/etc/sv/$svc" ]] && sudo ln -sf "/etc/sv/$svc" /var/service/ 2>/dev/null || true ;;
		openrc)
			sudo rc-update add "$svc" default 2>/dev/null || true
			sudo rc-service "$svc" start 2>/dev/null || true ;;
	esac
	log_ok "Serviço habilitado: $svc"
}

disable_service() {
	local svc="$1"
	case $INIT_SYS in
		systemd) sudo systemctl disable --now "$svc" 2>/dev/null || true ;;
		openrc)  sudo rc-update del "$svc" default 2>/dev/null || true ;;
	esac
	log_ok "Serviço desabilitado: $svc"
}

# Instala uma fonte a partir de um .zip
install_font_zip() {
	local zip_file="$1" font_dir_name="$2"
	local target_dir="$FONT_DIR_SYSTEM/$font_dir_name"

	if [[ ! -f "$zip_file" ]]; then
		log_skip "Arquivo não encontrado: $zip_file"
		return 0
	fi

	local tmp; tmp="$(mktemp -d)"
	# shellcheck disable=SC2064
	trap "rm -rf '$tmp'" RETURN

	if ! unzip -q "$zip_file" -d "$tmp" 2>>"$LOG_FILE"; then
		log_warn "Falha ao extrair $zip_file"
		return 0
	fi

	local ttfs=()
	mapfile -t ttfs < <(find "$tmp" -name "*.ttf" -o -name "*.otf" 2>/dev/null)

	if [[ ${#ttfs[@]} -eq 0 ]]; then
		log_warn "Nenhuma fonte encontrada em $zip_file"
		return 0
	fi

	sudo mkdir -p "$target_dir"
	for font in "${ttfs[@]}"; do
		sudo cp "$font" "$target_dir/" && log_ok "Fonte instalada: $(basename "$font")"
	done
}

# =============================================================================
#  Verificações Iniciais
# =============================================================================

if [[ $EUID -eq 0 ]]; then
	log_error "Não execute como root. Use um usuário comum com sudo."
	exit 1
fi

if ! sudo -v 2>/dev/null; then
	log_error "Este usuário não tem privilégios sudo."
	exit 1
fi

log_info "Log em: $LOG_FILE"
log_info "Diretório do script: $SCRIPT_DIR"

# =============================================================================
#  Detecção de Distro
# =============================================================================

if [[ -f /etc/os-release ]]; then
	# shellcheck disable=SC1091
	. /etc/os-release
	DISTRO="$ID"
else
	log_error "Não foi possível detectar a distribuição."
	exit 1
fi

log_info "Detectado: ${PRETTY_NAME:-$NAME}"

# =============================================================================
#  Configuração de Pacotes por Distro
# =============================================================================
case "$DISTRO" in
	alpine)
		PKG_MANAGER="sudo apk"
		INSTALL_CMD="add --no-cache"
		UPDATE_CMD="update && sudo apk upgrade"
		XORG_PKGS=(xorg-server xinit xrandr xsetroot xprop xev mesa-dri-gallium)
		DEV_PKGS=(build-base pkgconf git curl clang21 clang21-extra-tools npm)
		LIB_PKGS=(libx11-dev libxinerama-dev libxft-dev fontconfig-dev imlib2-dev linux-pam-dev harfbuzz harfbuzz-dev)
		APP_PKGS=(vim bash bash-completion zsh pavucontrol xclip nodejs feh chromium unzip
				  i3 i3blocks i3-gaps papirus-icon-theme rofi 
				  xterm adwaita-icon-theme)
		SYS_PKGS=(dbus networkmanager polkit-elogind)
		INIT_SYS="openrc"
		NETWORK_SVCS=(dbus networkmanager)
		CONFLICT_SVCS=(dhcpcd wpa_supplicant)
		;;

	fedora)
		PKG_MANAGER="sudo dnf"
		INSTALL_CMD="install -y"
		UPDATE_CMD="upgrade -y"
		XORG_PKGS=(xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-apps mesa-dri-drivers)
		DEV_PKGS=(@development-tools pkgconfig git curl clang clang-tools-extra zig cargo npm)
		LIB_PKGS=(libX11-devel libXinerama-devel libXft-devel fontconfig-devel imlib2-devel pam-devel harfbuzz harfbuzz-devel)
		APP_PKGS=(vim-X11 cava bash bash-completion zsh pavucontrol xclip nodejs feh chromium unzip
				  i3 i3blocks i3-gaps papirus-icon-theme rofi 
				  xterm adwaita-cursor-theme)
		SYS_PKGS=(dbus NetworkManager polkit)
		INIT_SYS="systemd"
		NETWORK_SVCS=(dbus NetworkManager)
		CONFLICT_SVCS=(dhcpcd wpa_supplicant)
		;;

	arch)
		PKG_MANAGER="sudo pacman"
		INSTALL_CMD="-S --noconfirm --needed"
		UPDATE_CMD="-Syu --noconfirm"
		XORG_PKGS=(xorg-server xorg-xinit xorg-xrandr xorg-xsetroot xorg-xprop xorg-xev mesa)
		DEV_PKGS=(base-devel pkgconf git curl clang zig cargo npm)
		LIB_PKGS=(libx11 libxinerama libxft fontconfig imlib2 pam harfbuzz)
		APP_PKGS=(gvim cava bash bash-completion zsh pavucontrol xclip nodejs feh chromium unzip
				  i3 i3blocks i3-gaps papirus-icon-theme rofi 
				  xterm adwaita-cursors)
		SYS_PKGS=(dbus networkmanager polkit)
		INIT_SYS="systemd"
		NETWORK_SVCS=(dbus NetworkManager)
		CONFLICT_SVCS=(dhcpcd wpa_supplicant)
		;;

	debian | ubuntu)
		PKG_MANAGER="sudo apt-get"
		INSTALL_CMD="install -y"
		UPDATE_CMD="update -y"
		XORG_PKGS=(xorg xinit x11-xserver-utils mesa-utils)
		DEV_PKGS=(build-essential pkg-config git curl clang clangd cargo npm)
		LIB_PKGS=(libx11-dev libxinerama-dev libxft-dev libfontconfig1-dev libimlib2-dev libpam0g-dev libharfbuzz-dev)
		APP_PKGS=(vim-gtk3 cava bash zsh pavucontrol alsa-utils xclip nodejs feh chromium unzip
				  i3 i3blocks papirus-icon-theme rofi 
				  xterm adwaita-icon-theme)
		SYS_PKGS=(dbus network-manager)
		INIT_SYS="systemd"
		NETWORK_SVCS=(dbus NetworkManager)
		CONFLICT_SVCS=(dhcpcd wpa_supplicant)
		;;

	void)
		PKG_MANAGER="sudo xbps-install"
		INSTALL_CMD="-y"
		UPDATE_CMD="-Syu"
		XORG_PKGS=(xorg xinit xrandr xsetroot xprop xev mesa)
		DEV_PKGS=(base-devel pkg-config git curl clang clang-tools-extra cargo)
		LIB_PKGS=(libX11-devel libXinerama-devel libXft-devel fontconfig-devel imlib2-devel pam-devel harfbuzz harfbuzz-devel)
		APP_PKGS=(vim-gtk3 cava bash bash-completion zsh pavucontrol alsa-utils xclip nodejs feh chromium unzip
				  wpa_supplicant i3 i3blocks papirus-icon-theme rofi 
				  xterm Adwaita-Cursors)
		SYS_PKGS=(dbus NetworkManager elogind polkit)
		INIT_SYS="runit"
		NETWORK_SVCS=(dbus elogind udevd NetworkManager polkitd)
		CONFLICT_SVCS=()
		;;

	gentoo)
		PKG_MANAGER="sudo emerge"
		INSTALL_CMD="-q --autounmask-write --deep --newuse"
		UPDATE_CMD="--sync"
		XORG_PKGS=("x11-base/xorg-server" "x11-apps/xinit" "x11-apps/xrandr"
				   "x11-apps/xsetroot" "x11-apps/xprop" "x11-apps/xev" "media-libs/mesa")
		DEV_PKGS=("sys-devel/gcc" "sys-devel/make" "dev-vcs/git" "sys-devel/pkgconf"
				  "net-misc/curl" "sys-devel/clang" "dev-lang/nodejs" "dev-lang/zig" "dev-lang/rust")
		LIB_PKGS=("x11-libs/libX11" "x11-libs/libXinerama" "x11-libs/libXft"
				  "media-libs/fontconfig" "media-libs/imlib2" "sys-libs/pam" "media-libs/harfbuzz")
		APP_PKGS=("app-editors/vim" "media-sound/cava" "sys-apps/bash" "app-shells/bash-completion"
				  "app-shells/zsh"
				  "media-sound/pavucontrol" "media-sound/alsa-utils" "x11-misc/xclip"
				  "dev-lang/nodejs" "media-gfx/feh" "www-client/chromium" "app-arch/unzip"
				  "x11-wm/i3" "x11-wm/i3status" "x11-themes/papirus-icon-theme"
				  "x11-misc/rofi" 
				  "x11-terms/xterm" "x11-themes/adwaita-icon-theme")
		SYS_PKGS=("sys-apps/dbus" "net-misc/networkmanager" "sys-auth/polkit")
		INIT_SYS="openrc"
		NETWORK_SVCS=(dbus networkmanager)
		CONFLICT_SVCS=(dhcpcd wpa_supplicant)
		;;

	*)
		log_error "Distribuição '$DISTRO' não suportada."
		exit 1
		;;
esac

# =============================================================================
#  1. Atualização do sistema
# =============================================================================
log_step "Atualizando repositórios e sistema"

if [[ "$DISTRO" == "gentoo" ]]; then
	log_info "Sincronizando Portage..."
	sudo emerge --sync >> "$LOG_FILE" 2>&1
	log_info "Atualizando @world..."
	sudo emerge -uDN @world >> "$LOG_FILE" 2>&1
elif [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
	sudo apt-get update -y >> "$LOG_FILE" 2>&1
	sudo apt-get upgrade -y >> "$LOG_FILE" 2>&1
elif [[ "$DISTRO" == "void" ]]; then
	sudo xbps-install -Syu >> "$LOG_FILE" 2>&1
else
	eval "$PKG_MANAGER $UPDATE_CMD" >> "$LOG_FILE" 2>&1
fi

log_ok "Sistema atualizado"

# =============================================================================
#  2. Instalação de pacotes
# =============================================================================
log_step "Instalando pacotes"

ALL_PKGS=(
	"${XORG_PKGS[@]}"
	"${DEV_PKGS[@]}"
	"${LIB_PKGS[@]}"
	"${APP_PKGS[@]}"
	"${SYS_PKGS[@]}"
)

if [[ "$DISTRO" == "gentoo" ]]; then
	log_info "Instalando no Gentoo. Isso pode levar bastante tempo..."
	sudo emerge -q --autounmask-write --deep --newuse "${ALL_PKGS[@]}" >> "$LOG_FILE" 2>&1 || {
		log_warn "Pode ser necessário rodar 'etc-update' ou 'dispatch-conf'."
	}
else
	install_pkgs "${ALL_PKGS[@]}"
fi

log_ok "Pacotes instalados"

# =============================================================================
#  3. Dotfiles
# =============================================================================
log_step "Copiando dotfiles"

if [[ -d "$SCRIPT_DIR/home" ]]; then
	# Copia arquivo a arquivo para ter controle granular
	while IFS= read -r -d '' src; do
		rel="${src#"$SCRIPT_DIR/home/"}"
		dst="${HOME}/${rel}"
		mkdir -p "$(dirname "$dst")"
		safe_copy "$src" "$dst"
	done < <(find "$SCRIPT_DIR/home" -type f -print0)

	# Torna scripts do i3blocks executáveis
	if [[ -d "${HOME}/.config/i3blocks" ]]; then
		find "${HOME}/.config/i3blocks" -name "*.sh" -exec chmod +x {} +
		log_ok "Scripts i3blocks: chmod +x aplicado"
	fi
else
	log_skip "Diretório home/ não encontrado"
fi

# =============================================================================
#  3.1. Configurar os plugins do ZSH
# =============================================================================
log_step "Instalando plugins do Zsh"

ZSH_PLUGIN_DIR="${HOME}/.zsh/plugins"
mkdir -p "$ZSH_PLUGIN_DIR"

clone_plugin() {
	local repo="$1"
	local dir="$2"

	if [[ ! -d "$dir" ]]; then
		git clone --depth=1 "$repo" "$dir" >> "$LOG_FILE" 2>&1 && \
			log_ok "Plugin instalado: $(basename "$dir")" || \
			log_warn "Falha ao clonar $repo"
	else
		log_skip "Plugin já existe: $dir"
	fi
}

clone_plugin https://github.com/zsh-users/zsh-autosuggestions \
	"$ZSH_PLUGIN_DIR/zsh-autosuggestions"

clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting \
	"$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"

# =============================================================================
#  4. Configuração do cursor Adwaita
# =============================================================================
log_step "Configurando cursor Adwaita"

CURSOR_TARGET_DIR="${HOME}/.local/share/icons/$CURSOR_THEME"
mkdir -p "${HOME}/.local/share/icons"

# Verifica se o tema de cursor já está instalado no sistema
if [[ -d "/usr/share/icons/$CURSOR_THEME" ]]; then
	log_ok "Cursor $CURSOR_THEME já disponível no sistema"
else
	log_warn "Cursor $CURSOR_THEME não encontrado em /usr/share/icons — pode ser necessário instalar adwaita-icon-theme manualmente"
fi

# Configura ~/.icons/default para apontar para Adwaita
mkdir -p "${HOME}/.icons/default"
cat > "${HOME}/.icons/default/index.theme" <<EOF
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=$CURSOR_THEME
EOF
log_ok "~/.icons/default → $CURSOR_THEME"

# Configura via GTK settings para aplicações GTK respeitarem o cursor
GTK3_SETTINGS="${HOME}/.config/gtk-3.0/settings.ini"
mkdir -p "$(dirname "$GTK3_SETTINGS")"
if [[ -f "$GTK3_SETTINGS" ]]; then
	# Remove entradas antigas de cursor e icon-theme para reescrever
	sed -i '/gtk-cursor-theme-name/d' "$GTK3_SETTINGS"
	sed -i '/gtk-icon-theme-name/d' "$GTK3_SETTINGS"
	# Se não existe [Settings], adiciona
	grep -q '^\[Settings\]' "$GTK3_SETTINGS" || echo '[Settings]' >> "$GTK3_SETTINGS"
	echo "gtk-cursor-theme-name=$CURSOR_THEME" >> "$GTK3_SETTINGS"
	echo "gtk-icon-theme-name=$ICON_THEME" >> "$GTK3_SETTINGS"
else
	cat > "$GTK3_SETTINGS" <<EOF
[Settings]
gtk-cursor-theme-name=$CURSOR_THEME
gtk-icon-theme-name=$ICON_THEME
gtk-font-name=FiraCode Nerd Font 10
EOF
fi
log_ok "GTK3 configurado: cursor=$CURSOR_THEME, icons=$ICON_THEME"

GTK2_RC="${HOME}/.gtkrc-2.0"
{
	echo "gtk-cursor-theme-name=\"$CURSOR_THEME\""
	echo "gtk-icon-theme-name=\"$ICON_THEME\""
} >> "$GTK2_RC"
log_ok "GTK2 configurado: $GTK2_RC"

# Configura cursor via Xresources também (para aplicações Xlib puras)
XRESOURCES="${HOME}/.Xresources"
if ! grep -q "Xcursor.theme" "$XRESOURCES" 2>/dev/null; then
	echo "Xcursor.theme: $CURSOR_THEME" >> "$XRESOURCES"
	echo "Xcursor.size: 24" >> "$XRESOURCES"
	log_ok "Xcursor configurado em $XRESOURCES"
fi

# =============================================================================
#  5. Configuração do tema de ícones Papirus
# =============================================================================
log_step "Configurando tema de ícones Papirus"

# papirus-folders permite colorir as pastas, se disponível
if has papirus-folders; then
	papirus-folders -C nordic-blue --theme Papirus-Dark 2>>"$LOG_FILE" || true
	log_ok "papirus-folders: cor nordic-blue aplicada"
fi

# Fallback: configura via index.theme local se necessário
PAPIRUS_SYS_DIR="/usr/share/icons/Papirus-Dark"
if [[ -d "$PAPIRUS_SYS_DIR" ]]; then
	log_ok "Papirus-Dark encontrado em $PAPIRUS_SYS_DIR"
else
	log_warn "Papirus-Dark não encontrado — verifique se papirus-icon-theme instalou corretamente"
fi

# =============================================================================
#  6. Serviços
# =============================================================================
log_step "Configurando serviços ($INIT_SYS)"

for svc in "${NETWORK_SVCS[@]:-}"; do
	[[ -n "$svc" ]] && enable_service "$svc"
done

for svc in "${CONFLICT_SVCS[@]:-}"; do
	[[ -n "$svc" ]] && disable_service "$svc"
done

# =============================================================================
#  7. Fontes
# =============================================================================
log_step "Instalando fontes"

install_font_zip "$SCRIPT_DIR/BigBlueTerminal.zip" "BigBlueTerminalNerd"
install_font_zip "$SCRIPT_DIR/FiraCodeNerd.zip"    "FiraCodeNerd"

# Atualiza cache apenas uma vez no final
if has fc-cache; then
	sudo fc-cache -f >> "$LOG_FILE" 2>&1
	log_ok "Cache de fontes atualizado"
fi

# =============================================================================
#  8. Configuração do .xinitrc
# =============================================================================
log_step "Configurando .xinitrc"

XINITRC="${HOME}/.xinitrc"
if [[ ! -f "$XINITRC" ]]; then
	cat > "$XINITRC" <<'EOF'
#!/bin/sh
# =============================================================================
#  .xinitrc — gerado pelo setup.sh
# =============================================================================

# Carrega recursos do Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Aplica cursor
xsetroot -cursor_name left_ptr

# Compositor (opcional; descomente se usar picom)
# picom --daemon &

# Barra de status (i3blocks/i3bar é gerenciado pelo i3)

exec i3
EOF
	chmod +x "$XINITRC"
	log_ok ".xinitrc criado"
else
	log_skip ".xinitrc já existe"
fi

# =============================================================================
#  Resumo final
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║          INSTALAÇÃO CONCLUÍDA            ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Log completo: ${CYAN}$LOG_FILE${NC}"
echo -e "  Cursor:       ${CYAN}$CURSOR_THEME${NC}"
echo -e "  Ícones:       ${CYAN}$ICON_THEME${NC}"
echo -e "  Terminal:     ${CYAN}Kitty${NC}"
echo ""
echo -e "  ${YELLOW}Próximos passos:${NC}"
echo -e "   1. Reinicie a sessão para aplicar o cursor corretamente"
echo -e "   2. Rode ${CYAN}startx${NC} para iniciar o ambiente"
if [[ "$DISTRO" == "gentoo" ]]; then
	echo -e "   3. Verifique pendências com ${CYAN}etc-update${NC} ou ${CYAN}dispatch-conf${NC}"
fi
echo ""

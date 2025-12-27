#!/bin/bash

# ============================================
# TEMAS
# ============================================

catppuccin_mocha() {
	BG="#1e1e2e"
	FG="#cdd6f4"
	RED="#f38ba8"
	GREEN="#a6e3a1"
	YELLOW="#f9e2af"
	BLUE="#89b4fa"
	PURPLE="#cba6f7"
	CYAN="#89dceb"
	GRAY="#45475a"
}

dracula() {
	BG="#282a36"
	FG="#f8f8f2"
	RED="#ff5555"
	GREEN="#50fa7b"
	YELLOW="#f1fa8c"
	BLUE="#8be9fd"
	PURPLE="#bd93f9"
	CYAN="#8be9fd"
	GRAY="#44475a"
}

gruvbox_dark() {
	BG="#282828"
	FG="#ebdbb2"
	RED="#fb4934"
	GREEN="#b8bb26"
	YELLOW="#fabd2f"
	BLUE="#83a598"
	PURPLE="#d3869b"
	CYAN="#8ec07c"
	GRAY="#504945"
}

nord() {
	BG="#2e3440"
	FG="#eceff4"
	RED="#bf616a"
	GREEN="#a3be8c"
	YELLOW="#ebcb8b"
	BLUE="#81a1c1"
	PURPLE="#b48ead"
	CYAN="#88c0d0"
	GRAY="#4c566a"
}

tokyo_night() {
	BG="#1a1b26"
	FG="#c0caf5"
	RED="#f7768e"
	GREEN="#9ece6a"
	YELLOW="#e0af68"
	BLUE="#7aa2f7"
	PURPLE="#bb9af7"
	CYAN="#7dcfff"
	GRAY="#414868"
}

# ============================================
# HELPERS
# ============================================

COLOR() { echo -n "^c$1^"; }
BG() { echo -n "^b$1^"; }
ICON() { echo -n "$1"; }
TEXT() { echo -n "$1"; }

# Módulo sem separador - só ícone + texto + espaço
MODULE() {
	local cor="$1"
	local icone="$2"
	local texto="$3"
	echo -n "$(COLOR $cor)$(ICON "$icone")$(TEXT " $texto") "
}

# Módulo com background colorido (estilo pill/badge)
PILL() {
	local bg="$1"
	local fg="$2"
	local icone="$3"
	local texto="$4"
	echo -n "$(BG $bg)$(COLOR $fg) $(ICON "$icone") $(TEXT "$texto") $(BG "#00000000") "
}

# Separador minimalista (ponto)
DOT() {
	echo -n "$(COLOR $GRAY)• "
}

# Separador invisível (só espaço)
SPACE() {
	echo -n "  "
}

# ============================================
# ESCOLHE TEMA
# ============================================
catppuccin_mocha

# ============================================
# MÓDULOS
# ============================================

get_volume() {
	local vol=$(pamixer --get-volume 2>/dev/null || echo "0")
	
	if pamixer --get-mute &>/dev/null; then
		MODULE "$RED" "󰖁" "muted"
	else
		MODULE "$PURPLE" "󰕾" "$vol%"
	fi
}

get_network() {
	if ping -c 1 8.8.8.8 &>/dev/null 2>&1; then
		MODULE "$GREEN" "󰖩" ""
	else
		MODULE "$RED" "󰖪" ""
	fi
}

get_battery() {
	local bat="/sys/class/power_supply/BAT0"
	
	if [ -d "$bat" ]; then
		local capacity=$(cat "$bat/capacity")
		local status=$(cat "$bat/status")
		
		if [ "$status" = "Charging" ]; then
			MODULE "$YELLOW" "󰂄" "$capacity%"
		elif [ $capacity -le 20 ]; then
			MODULE "$RED" "󰁺" "$capacity%"
		elif [ $capacity -le 50 ]; then
			MODULE "$YELLOW" "󰁾" "$capacity%"
		else
			MODULE "$GREEN" "󰁹" "$capacity%"
		fi
	fi
}

get_cpu() {
	local cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')
	MODULE "$BLUE" "" "$cpu%"
}

get_ram() {
	local ram=$(free -h | awk '/^Mem:/ {print $3}')
	MODULE "$CYAN" "󰍛" "$ram"
}

get_datetime() {
	local hora=$(date '+%H:%M')
	local data=$(date '+%d %b')
    echo -n "$(MODULE "$FG" "󰃰" "$hora")"
}

# ============================================
# ESTILOS DIFERENTES - ESCOLHA UM
# ============================================

# Estilo 1: Minimalista sem separadores (recomendado)
style_minimal() {
	STATUS=""
	STATUS+="$(get_volume)"
	STATUS+="$(get_network)"
	STATUS+="$(get_battery)"
	# STATUS+="$(get_cpu)"
	# STATUS+="$(get_ram)"
	STATUS+="$(get_datetime)"
	echo "$STATUS"
}

# Estilo 2: Com pontinhos como separador
style_dots() {
	STATUS=""
	STATUS+="$(get_volume)$(DOT)"
	STATUS+="$(get_network)$(DOT)"
	STATUS+="$(get_battery)$(DOT)"
	# STATUS+="$(get_cpu)$(DOT)"
	# STATUS+="$(get_ram)$(DOT)"
	STATUS+="$(get_datetime)"
	echo "$STATUS"
}

# Estilo 3: Pills/Badges (moderno, tipo macOS)
style_pills() {
	STATUS=""
	# Volume
	local vol=$(pamixer --get-volume 2>/dev/null || echo "0")
	if pamixer --get-mute &>/dev/null; then
		STATUS+="$(PILL "$RED" "$BG" "󰖁" "muted")"
	else
		STATUS+="$(PILL "$PURPLE" "$BG" "󰕾" "$vol%")"
	fi
	
	# Network
	if ping -c 1 8.8.8.8 &>/dev/null 2>&1; then
		STATUS+="$(PILL "$GREEN" "$BG" "󰖩" "")"
	fi
	
	# Battery
	local bat="/sys/class/power_supply/BAT0"
	if [ -d "$bat" ]; then
		local capacity=$(cat "$bat/capacity")
		local status=$(cat "$bat/status")
		if [ "$status" = "Charging" ]; then
			STATUS+="$(PILL "$YELLOW" "$BG" "󰂄" "$capacity%")"
		elif [ $capacity -le 20 ]; then
			STATUS+="$(PILL "$RED" "$BG" "󰁺" "$capacity%")"
		else
			STATUS+="$(PILL "$GREEN" "$BG" "󰁹" "$capacity%")"
		fi
	fi
	
	# Time
	local hora=$(date '+%H:%M')
	STATUS+="$(PILL "$BLUE" "$BG" "󰃰" "$hora")"
	
	echo "$STATUS"
}

# Estilo 4: Ultra minimal (só ícones, sem texto)
style_icons_only() {
	STATUS=""
	
	# Volume icon com cor
	local vol=$(pamixer --get-volume 2>/dev/null || echo "0")
	if pamixer --get-mute &>/dev/null; then
		STATUS+="$(COLOR $RED)󰖁 "
	else
		STATUS+="$(COLOR $PURPLE)󰕾 "
	fi
	
	# Network
	if ping -c 1 8.8.8.8 &>/dev/null 2>&1; then
		STATUS+="$(COLOR $GREEN)󰖩 "
	fi
	
	# Battery
	local bat="/sys/class/power_supply/BAT0"
	if [ -d "$bat" ]; then
		local capacity=$(cat "$bat/capacity")
		if [ $capacity -le 20 ]; then
			STATUS+="$(COLOR $RED)󰁺 "
		else
			STATUS+="$(COLOR $GREEN)󰁹 "
		fi
	fi
	
	# Time com texto
	STATUS+="$(COLOR $FG)$(date '+%H:%M')"
	
	echo "$STATUS"
}

# ============================================
# LOOP
# ============================================

while true; do
	# ESCOLHE O ESTILO AQUI:
	xsetroot -name "$(style_minimal)"
	# xsetroot -name "$(style_dots)"
	# xsetroot -name "$(style_pills)"
	# xsetroot -name "$(style_icons_only)"
	
	sleep 1
done
```

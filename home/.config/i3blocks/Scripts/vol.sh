#!/bin/sh

# Verifica se o áudio está no mudo (usando amixer para maior compatibilidade)
MUTE=$(amixer sget Master | grep -Po '\[off\]' | head -1)
# Pega o volume atual (apenas o número)
VOL=$(amixer sget Master | grep -Po '\d+(?=%\])' | head -1)

if [ "$MUTE" = "[off]" ] || [ "$VOL" -eq 0 ]; then
	ICON="󰖁" # Ícone de mudo
	VOL="0"
else
	if [ "$VOL" -ge 70 ]; then
		ICON="󰕾" # Volume alto
	elif [ "$VOL" -ge 30 ]; then
		ICON="󰖀" # Volume médio
	else
		ICON="󰕿" # Volume baixo
	fi
fi

echo "$ICON $VOL%"

#!/bin/sh

BACKLIGHT_PATH="/sys/class/backlight"

# Pega o primeiro dispositivo de backlight
DEVICE=$(ls $BACKLIGHT_PATH | head -n 1)

if [ -n "$DEVICE" ]; then
	CUR=$(cat "$BACKLIGHT_PATH/$DEVICE/brightness")
	MAX=$(cat "$BACKLIGHT_PATH/$DEVICE/max_brightness")

	PERC=$(( CUR * 100 / MAX ))

	if [ "$PERC" -ge 70 ]; then
		ICON="󰃠" # Alto
	elif [ "$PERC" -ge 30 ]; then
		ICON="󰃝" # Médio
	else
		ICON="󰃟" # Baixo
	fi

	echo "$ICON $PERC%"
else
	echo "󰃞 N/A"
fi

#!/bin/sh

SERVICES_FILE="$HOME/.services.sh"

if [ ! -f "$SERVICES_FILE" ]; then
    echo "Error: Services file not found!"
    exit 1
fi

if [ ! -x "$SERVICES_FILE" ]; then
    chmod +x "$SERVICES_FILE"
fi

"$SERVICES_FILE" &

if [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi


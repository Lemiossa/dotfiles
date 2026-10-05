#!/bin/bash

SERVICES_FILE="$HOME/.services.sh"

if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR="/tmp/run-user-$(id -u)"
    if [ ! -d "$XDG_RUNTIME_DIR" ]; then
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 700 "$XDG_RUNTIME_DIR"
    fi
fi

source ~/.bashrc

export XCURSOR_THEME="${CURSOR_THEME:-Adwaita}"
export XCURSOR_SIZE="${CURSOR_SIZE:-24}"

if [ ! -f "$SERVICES_FILE" ]; then
    echo "Error: Services file not found!"
    exit 1
fi

if [ ! -x "$SERVICES_FILE" ]; then
    chmod +x "$SERVICES_FILE"
fi

"$SERVICES_FILE" &

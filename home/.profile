#!/bin/sh

if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR="/tmp/run-user-$(id -u)"
    if [ ! -d "$XDG_RUNTIME_DIR" ]; then
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 700 "$XDG_RUNTIME_DIR"
    fi
fi

if [ -z "${DISPLAY}" ] && [ "$(tty)" = "/dev/tty1" ]; then
    if command -v startx >/dev/null 2>&1; then
        startx
    fi
fi


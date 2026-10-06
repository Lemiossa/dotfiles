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

# Start a D-Bus session bus if there isn't one; without it, user services
# (pipewire, pipewire-pulse, wireplumber, dunst...) fail to start on TTY login.
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    DBUS_OUTPUT="$(dbus-daemon --session --fork --print-address=1 --print-pid=1)"
    export DBUS_SESSION_BUS_ADDRESS="$(printf '%s\n' "$DBUS_OUTPUT" | sed -n '1p')"
    export DBUS_SESSION_BUS_PID="$(printf '%s\n' "$DBUS_OUTPUT" | sed -n '2p')"
fi

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

if [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi

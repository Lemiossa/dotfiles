#!/bin/bash

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

if [ "$(tty)" = "/dev/tty1" ]; then
    exec dbus-run-session "$HOME/.start.sh"
fi

# Non-tty1 logins: start a session bus manually so user services work,
# without replacing the interactive shell.
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    DBUS_OUTPUT="$(dbus-daemon --session --fork --print-address=1 --print-pid=1)"
    export DBUS_SESSION_BUS_ADDRESS="$(printf '%s\n' "$DBUS_OUTPUT" | sed -n '1p')"
    export DBUS_SESSION_BUS_PID="$(printf '%s\n' "$DBUS_OUTPUT" | sed -n '2p')"
fi

"$HOME/.start.sh" &

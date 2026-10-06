#!/bin/sh
# This file initializes the user services(no X11)

exec_service() {
    local service="$1"
    shift

    if pgrep -x "$service" >/dev/null; then
        return 0
    fi

    "$service" "$@" &
}

# exec_service mpd --no-daemon &
exec_service pipewire &
exec_service pipewire-pulse &
exec_service wireplumber &

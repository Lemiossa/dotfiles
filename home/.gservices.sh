#!/bin/sh
# This file executes the user services(graphics)

exec_service() {
    local service="$1"
    shift

    if pgrep -x "$service" >/dev/null; then
        return 0
    fi

    "$service" "$@" &
}

exec_service dunst &
# exec_service picom &

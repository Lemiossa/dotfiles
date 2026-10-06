#!/bin/sh
# This file executes services for bspwm

exec_service() {
    local service="$1"
    shift

    if pgrep -x "$service" >/dev/null; then
        return 0
    fi

    "$service" "$@" &
}

exec_service polybar &
exec_service sxhkd &


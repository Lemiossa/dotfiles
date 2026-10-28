#!/bin/sh
# Este arquivo executa os serviços para o bspwm

exec_service() {
    local service="$1"
    shift

    if pgrep -x "$service" >/dev/null; then
        return 0
    fi

    "$service" "$@" &
}

exec_service polybar main
exec_service sxhkd

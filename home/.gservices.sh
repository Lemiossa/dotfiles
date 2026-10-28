#!/bin/sh
# Este arquivo executa os serviços do usuário (com interface gráfica)

exec_service() {
    local service="$1"
    shift

    if pgrep -x "$service" >/dev/null; then
        return 0
    fi

    "$service" "$@" &
}

if command -v picom >/dev/null 2>&1; then
    exec_service picom
fi

exec_service dunst

#!/bin/sh
# Mostra ethernet ou wifi

# mostra os primeiros caracteres e troca o resto por '*'
mask() {
    s=$1
    keep=3
    [ "${#s}" -le 4 ] && keep=1      # SSID curto: mostra só 1 caractere
    head=$(printf '%s' "$s" | cut -c1-"$keep")
    rest=${s#"$head"}
    stars=$(printf '%s' "$rest" | sed 's/./*/g')
    printf '%s%s' "$head" "$stars"
}

eth=""; wifi=""; haswifi=0

for d in /sys/class/net/*; do
    n=${d##*/}
    # interfaces físicas têm o link "device"; ignora lo, docker, veth, br, tun...
    [ -e "$d/device" ] || continue

    state=$(cat "$d/operstate" 2>/dev/null)

    if [ -d "$d/wireless" ]; then
        haswifi=1
        [ "$state" = up ] && [ -z "$wifi" ] && wifi=$n
    else
        [ "$state" = up ] && [ -z "$eth" ] && eth=$n
    fi
done

if [ -n "$eth" ]; then
    printf '󰈀 '
elif [ -n "$wifi" ]; then
    ssid=$(iw dev "$wifi" link 2>/dev/null | sed -n 's/^[[:space:]]*SSID: //p')
    [ -z "$ssid" ] && ssid=$(iwgetid -r "$wifi" 2>/dev/null)
    if [ -n "$ssid" ]; then
        printf '󰤨 %s ' "$(mask "$ssid")"
    else
        printf '󰤨 '
    fi
elif [ "$haswifi" = 1 ]; then
    printf '󰤯 '
else
    printf '󰤭 '
fi

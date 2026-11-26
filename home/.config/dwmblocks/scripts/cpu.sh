#!/bin/sh
# Média de uso da CPU desde o boot (suficiente para um indicador leve).
cpu=$(awk 'NR==1 { used=$2+$4; total=$2+$4+$5+$6+$7+$8+$9+$10 } END { if (total>0) printf "%d", 100*used/total; else printf "?" }' /proc/stat)
printf '󰍛 %s%% ' "$cpu"

#!/bin/sh
# Percentual de memória em uso lido diretamente de /proc/meminfo.
# Não depende de free(1) nem de awk: o formato do free muda entre versões
# (buff/cache vs. available) e sistemas mínimos podem não ter nenhum dos dois.

total= avail= memfree= buffers= cached= reclaimable= shmem=

if [ -r /proc/meminfo ]; then
	while read -r key value rest; do
		case $key in
			MemTotal:)     total=$value ;;
			MemAvailable:) avail=$value ;;
			MemFree:)      memfree=$value ;;
			Buffers:)      buffers=$value ;;
			Cached:)       cached=$value ;;
			SReclaimable:) reclaimable=$value ;;
			Shmem:)        shmem=$value ;;
		esac
	done < /proc/meminfo
fi

# MemAvailable existe a partir do kernel 3.14. Sem ele, usa a conta clássica.
if [ -z "$avail" ]; then
	avail=$(( ${memfree:-0} + ${buffers:-0} + ${cached:-0} + ${reclaimable:-0} - ${shmem:-0} ))
fi
[ "$avail" -lt 0 ] 2>/dev/null && avail=0

mem=
if [ -n "$total" ] && [ "$total" -gt 0 ] 2>/dev/null &&
   [ -n "$avail" ] && [ "$avail" -ge 0 ] 2>/dev/null; then
	[ "$avail" -gt "$total" ] && avail=$total
	mem=$(( (total - avail) * 100 / total ))
else
	# Último recurso: free(1), se estiver disponível.
	mem=$(free -m 2>/dev/null | awk '/^Mem:/ { printf "%d", ($2 - $7) * 100 / $2; exit }' 2>/dev/null)
	[ -z "$mem" ] && mem=$(free -m 2>/dev/null | awk '/^Mem:/ { printf "%d", $3 * 100 / $2; exit }' 2>/dev/null)
fi

[ -n "$mem" ] || mem='?'
printf ' %s%% ' "$mem"

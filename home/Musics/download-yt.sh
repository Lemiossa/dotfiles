#!/bin/bash
# ─────────────────────────────────────────────
#  baixar.sh — downloader de playlist turbinado
#  Uso: ./baixar.sh <URL> <NOME_DA_PASTA> [JOBS]
#  JOBS = quantas músicas em paralelo (padrão: 4)
# ─────────────────────────────────────────────

set -euo pipefail

# ── Cores ──────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m'

die() { echo -e "${RED}${BOLD}[ERRO]${RESET}  $*" >&2; exit 1; }

# ── Verificações iniciais ──────────────────────
[[ -z "${1:-}" ]] && die "URL da playlist não informada.\n  Uso: $0 <URL> <NOME> [JOBS]"
[[ -z "${2:-}" ]] && die "Nome da pasta não informado.\n  Uso: $0 <URL> <NOME> [JOBS]"

command -v yt-dlp &>/dev/null || die "yt-dlp não encontrado. Instale com: pip install -U yt-dlp"
command -v ffmpeg &>/dev/null || die "ffmpeg não encontrado — necessário para converter para mp3.\n  Instale com: sudo apt install ffmpeg"

URL="$1"
NAME="$2"
JOBS="${3:-4}"
FRAGS=4
PLAYLIST_FILE="${NAME}.m3u"
ARCHIVE="${NAME}/.downloaded.txt"
COOKIES_FILE="${HOME}/.config/yt-dlp/cookies.txt"
URL_LIST="${NAME}/.urls.txt"
LOG_DIR="${NAME}/.logs"
STATUS_DIR="${NAME}/.status"   # arquivos de estado por slot: "índice|título|%|estado"

mkdir -p "$NAME" "$LOG_DIR" "$STATUS_DIR"

COOKIES_ARGS=()
[[ -f "$COOKIES_FILE" ]] && COOKIES_ARGS=(--cookies "$COOKIES_FILE")

# ── Extrair títulos e URLs em paralelo ─────────
echo -e "${CYAN}${BOLD}  Obtendo informações da playlist…${RESET}"
yt-dlp "${COOKIES_ARGS[@]+"${COOKIES_ARGS[@]}"}" \
    --flat-playlist --print "%(url)s	%(title)s" "$URL" > "$URL_LIST"

TOTAL=$(wc -l < "$URL_LIST")
echo -e "${CYAN}${BOLD}  Faixas: ${TOTAL}  |  Paralelo: ${JOBS} músicas  |  ${FRAGS} fragmentos cada${RESET}"
echo

# ── Display: N linhas fixas (uma por slot) ─────
# Esconde cursor, reserva N linhas, limpa ao sair
tput civis 2>/dev/null || true
_cleanup() {
    tput cnorm 2>/dev/null || true
    # apaga as linhas de status
    for (( i=0; i<JOBS; i++ )); do
        tput el 2>/dev/null || true
        echo
    done
}
trap _cleanup EXIT

# Imprime N linhas vazias pra reservar espaço
for (( i=0; i<JOBS; i++ )); do echo; done

# Função que redesenha todas as linhas de status
_redraw() {
    # sobe JOBS linhas
    tput cuu "$JOBS" 2>/dev/null || printf '\033[%dA' "$JOBS"
    for (( slot=0; slot<JOBS; slot++ )); do
        local sf="${STATUS_DIR}/slot${slot}"
        local line=""
        if [[ -f "$sf" ]]; then
            IFS='|' read -r idx title pct state < "$sf" || true
            local truncated="${title:0:45}"
            [[ ${#title} -gt 45 ]] && truncated="${truncated}…"
            case "$state" in
                downloading)
                    local filled=$(( pct * 20 / 100 ))
                    local bar=""
                    for (( b=0; b<filled; b++ ));    do bar+="█"; done
                    for (( b=filled; b<20; b++ )); do bar+="░"; done
                    line="${CYAN}[${idx}/${TOTAL}]${RESET} ${DIM}${bar}${RESET} ${pct}%  ${truncated}"
                    ;;
                done)
                    line="${GREEN}[${idx}/${TOTAL}] ✓${RESET}  ${truncated}"
                    ;;
                error)
                    line="${RED}[${idx}/${TOTAL}] ✗${RESET}  ${truncated}"
                    ;;
                skipped)
                    line="${YELLOW}[${idx}/${TOTAL}] ↷${RESET}  ${DIM}${truncated} (já existe)${RESET}"
                    ;;
                *)
                    line="${DIM}[slot $((slot+1))] aguardando…${RESET}"
                    ;;
            esac
        else
            line="${DIM}[slot $((slot+1))] aguardando…${RESET}"
        fi
        # limpa linha e escreve
        tput el 2>/dev/null || printf '\033[2K'
        echo -e "$line"
    done
}

# Loop de redesenho em background
_display_loop() {
    while [[ -f "${STATUS_DIR}/.running" ]]; do
        _redraw
        sleep 0.3
    done
    _redraw  # último desenho final
}

touch "${STATUS_DIR}/.running"
_display_loop &
DISPLAY_PID=$!

# ── Contador global de concluídos ──────────────
DONE_FILE="${STATUS_DIR}/.done_count"
echo 0 > "$DONE_FILE"
_inc_done() { flock "$DONE_FILE" bash -c "echo \$(( \$(cat '$DONE_FILE') + 1 )) > '$DONE_FILE'"; }
export -f _inc_done

# ── Worker: baixa uma música, atualiza slot ────
_download_one() {
    local video_url="$1"
    local title="$2"
    local idx="$3"
    local slot="$4"
    local name="$5"
    local archive="$6"
    local frags="$7"
    local status_dir="$8"
    local log_dir="$9"
    shift 9
    local cookies_args=("$@")

    local sf="${status_dir}/slot${slot}"
    local log="${log_dir}/${idx}.log"
    local short_title="${title:0:50}"

    # marca: iniciando
    printf '%s|%s|0|downloading\n' "$idx" "$short_title" > "$sf"

    # roda yt-dlp, filtra linhas de progresso
    yt-dlp \
        "${cookies_args[@]+"${cookies_args[@]}"}" \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --concurrent-fragments "$frags" \
        --continue \
        --download-archive "$archive" \
        --no-abort-on-error \
        --embed-metadata \
        --embed-thumbnail \
        --add-metadata \
        --parse-metadata "%(uploader)s:%(meta_artist)s" \
        --retries 10 \
        --fragment-retries 10 \
        --retry-sleep 3 \
        --socket-timeout 15 \
        --newline \
        -o "${name}/%(title)s - %(uploader)s.%(ext)s" \
        "$video_url" 2>&1 | tee "$log" | while IFS= read -r line; do
            # detecta progresso  "[download]  45.3% ..."
            if [[ "$line" =~ \[download\][[:space:]]+([0-9]+)\.[0-9]+% ]]; then
                printf '%s|%s|%s|downloading\n' "$idx" "$short_title" "${BASH_REMATCH[1]}" > "$sf"
            # detecta já baixado
            elif [[ "$line" == *"has already been recorded"* ]] || [[ "$line" == *"already been downloaded"* ]]; then
                printf '%s|%s|100|skipped\n' "$idx" "$short_title" > "$sf"
            fi
        done

    # verifica erro no log
    if grep -q "^ERROR:" "$log" 2>/dev/null; then
        printf '%s|%s|0|error\n' "$idx" "$short_title" > "$sf"
    else
        printf '%s|%s|100|done\n' "$idx" "$short_title" > "$sf"
    fi

    _inc_done
}
export -f _download_one

# ── Distribui URLs nos workers ─────────────────
# Usa um FIFO + loop manual pra controlar slots
IDX=0
declare -A SLOT_PIDS=()

while IFS=$'\t' read -r video_url title || [[ -n "$video_url" ]]; do
    IDX=$(( IDX + 1 ))

    # encontra slot livre (espera se todos ocupados)
    while true; do
        for (( s=0; s<JOBS; s++ )); do
            pid="${SLOT_PIDS[$s]:-}"
            if [[ -z "$pid" ]] || ! kill -0 "$pid" 2>/dev/null; then
                SLOT_PIDS[$s]=""
                # dispara worker nesse slot
                _download_one \
                    "$video_url" "$title" "$IDX" "$s" \
                    "$NAME" "$ARCHIVE" "$FRAGS" "$STATUS_DIR" "$LOG_DIR" \
                    "${COOKIES_ARGS[@]+"${COOKIES_ARGS[@]}"}" &
                SLOT_PIDS[$s]=$!
                break 2
            fi
        done
        sleep 0.1
    done
done < "$URL_LIST"

# espera todos terminarem
for pid in "${SLOT_PIDS[@]:-}"; do
    [[ -n "$pid" ]] && wait "$pid" 2>/dev/null || true
done

# para o loop de display
rm -f "${STATUS_DIR}/.running"
wait "$DISPLAY_PID" 2>/dev/null || true

echo
DONE_COUNT=$(cat "$DONE_FILE")
echo -e "${GREEN}${BOLD}  ✓ ${DONE_COUNT}/${TOTAL} faixas concluídas${RESET}"

# mostra erros se houver
ERRORS=()
for log in "${LOG_DIR}"/*.log; do
    [[ -f "$log" ]] || continue
    grep -q "^ERROR:" "$log" && ERRORS+=("$(basename "$log" .log)")
done
if [[ ${#ERRORS[@]} -gt 0 ]]; then
    echo -e "${RED}  Erros nas faixas: ${ERRORS[*]}${RESET}"
    echo -e "${DIM}  Logs em: ${LOG_DIR}/${RESET}"
fi

# ── Limpar temporários ─────────────────────────
rm -f "$URL_LIST"
rm -rf "$STATUS_DIR"

# ── Gerar .m3u ────────────────────────────────
echo
echo -e "${CYAN}  Gerando playlist: ${BOLD}${PLAYLIST_FILE}${RESET}"

{
    echo "#EXTM3U"
    find "$(realpath "$NAME")" -name "*.mp3" \
        ! -path '*/.logs/*' \
        | sort \
        | while IFS= read -r f; do
            if command -v ffprobe &>/dev/null; then
                dur=$(ffprobe -v quiet -show_entries format=duration \
                      -of default=noprint_wrappers=1:nokey=1 "$f" 2>/dev/null | cut -d. -f1)
                title=$(basename "${f%.*}")
                echo "#EXTINF:${dur:-(-1)},${title}"
            fi
            echo "$f"
        done
} > "$PLAYLIST_FILE"

BAIXADAS=$(grep -c "^[^#]" "$PLAYLIST_FILE" 2>/dev/null || echo 0)

echo -e "${GREEN}${BOLD}  Playlist: ${PLAYLIST_FILE} (${BAIXADAS} faixas)${RESET}"
echo -e "${GREEN}${BOLD}  Tudo pronto! 🎵${RESET}"
echo

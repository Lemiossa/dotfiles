#!/bin/sh
# lib/common.sh — shared helpers (log, error, REPO_DIR).

if [ -n "${COMMON_LOADED:-}" ]; then
	return 0
fi
COMMON_LOADED=1

: "${REPO_DIR:?REPO_DIR not set (define it before loading the libs)}"
export REPO_DIR

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
info() { printf '    %s\n' "$*"; }
die() { printf '\033[1;31m[!]\033[0m %s\n' "$*" >&2; exit 1; }

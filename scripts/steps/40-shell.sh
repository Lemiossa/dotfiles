#!/bin/sh
# steps/40-shell.sh — sets the default shell to bash.

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

. "$REPO_DIR/scripts/lib/common.sh"

log "Setting the default shell to bash..."
chsh -s "$(command -v bash)" "$USER"

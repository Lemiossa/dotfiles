#!/bin/sh
# steps/70-vim.sh — installs the vim plugins.

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

. "$REPO_DIR/scripts/lib/common.sh"

log "Installing vim plugins..."
vim +PlugInstall +qall

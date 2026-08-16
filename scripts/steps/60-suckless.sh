#!/bin/sh
# steps/60-suckless.sh — builds and installs the suckless tools.

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

. "$REPO_DIR/scripts/lib/common.sh"
. "$REPO_DIR/scripts/lib/detect.sh"

log "Building and installing suckless tools..."
for tool in dmenu dwm st dwmblocks; do
	info "Building $tool..."
	$SUDO make -C "$HOME/suckless/$tool" clean install
done

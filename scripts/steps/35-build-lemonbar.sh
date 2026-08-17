#!/bin/sh
# steps/35-build-lemonbar.sh — compiles and installs lemonbar-xft from source.

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

. "$REPO_DIR/scripts/lib/common.sh"
. "$REPO_DIR/scripts/lib/detect.sh"

BUILD_DIR="${TMPDIR:-/tmp}/lemonbar-xft-build"
REPO_URL="https://gitlab.com/protesilaos/lemonbar-xft.git"

log "Building lemonbar-xft..."

if command -v lemonbar >/dev/null 2>&1; then
	info "lemonbar-xft already installed, skipping."
	exit 0
fi

[ -d "$BUILD_DIR" ] && rm -rf "$BUILD_DIR"
git clone --depth 1 "$REPO_URL" "$BUILD_DIR"

make -C "$BUILD_DIR"

$SUDO make -C "$BUILD_DIR" install

rm -rf "$BUILD_DIR"
log "lemonbar-xft installed."

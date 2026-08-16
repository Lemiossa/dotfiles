#!/bin/sh
# steps/10-packages.sh — installs the distro packages.

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

. "$REPO_DIR/scripts/lib/common.sh"
. "$REPO_DIR/scripts/lib/detect.sh"

log "Installing packages for $DISTRO_NAME..."
pkg_sync
pkg_install $PM_PACKAGES

if [ "${REMOVE_ELOGIND:-0}" -eq 1 ]; then
	log "Removing elogind (conflicts with seatd)..."
	pkg_remove elogind || true
fi

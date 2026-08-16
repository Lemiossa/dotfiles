#!/bin/sh
# install.sh — entry point: detects the distro and runs every step.
#
# Usage: ./scripts/install.sh            (everything)
#        ./scripts/steps/10-packages.sh  (a single step)

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

. "$REPO_DIR/scripts/lib/common.sh"
. "$REPO_DIR/scripts/lib/detect.sh"

log "Detected distro: $DISTRO_NAME"
log "Running the setup steps..."

for step in "$REPO_DIR"/scripts/steps/*.sh; do
	log "Running: $(basename "$step")"
	"$step"
done

log "Done! Log out and back in for group changes to take effect."
log "Then run 'startx' from the console TTY to start the session."

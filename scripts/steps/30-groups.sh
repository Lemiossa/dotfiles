#!/bin/sh
# steps/30-groups.sh — adds the user to the required groups.

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

. "$REPO_DIR/scripts/lib/common.sh"
. "$REPO_DIR/scripts/lib/detect.sh"

log "Adding the user to groups..."
setup_groups

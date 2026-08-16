#!/bin/sh
# lib/detect.sh — detects the distro via /etc/os-release and loads the
# matching profile from scripts/pkg/<distro>.sh.

if [ -n "${DETECT_LOADED:-}" ]; then
	return 0
fi
DETECT_LOADED=1

[ -f /etc/os-release ] || die "Cannot detect the distro: /etc/os-release not found"

# shellcheck disable=SC1091
. /etc/os-release

case "${ID:-}" in
	alpine | arch | debian | fedora | void)
		DISTRO="$ID" ;;
	ubuntu | linuxmint | pop | raspbian)
		DISTRO="debian" ;;
	*)
		die "Unsupported distro: ${ID:-unknown} (${PRETTY_NAME:-?})" ;;
esac

DISTRO_NAME="${NAME:-$DISTRO}"

# shellcheck disable=SC1090
. "$REPO_DIR/scripts/pkg/$DISTRO.sh"

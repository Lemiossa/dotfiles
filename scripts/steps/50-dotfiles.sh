#!/bin/sh
# steps/50-dotfiles.sh — copies dotfiles to $HOME and system files (fonts).

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

. "$REPO_DIR/scripts/lib/common.sh"
. "$REPO_DIR/scripts/lib/detect.sh"

log "Copying dotfiles to $HOME..."
cp -af "$REPO_DIR/home/." "$HOME/"

log "Installing system files (fonts)..."
$SUDO cp -af "$REPO_DIR/root/." /

if command -v fc-cache >/dev/null 2>&1; then
	log "Refreshing the system font cache..."
	$SUDO fc-cache -f
	log "Refreshing the user font cache..."
	fc-cache -f
fi

log "Setting default wallpaper"
rm -f "$HOME/.wallpaper"
ln -s "$HOME/Pictures/wallpapers/gruvbox_wallpaper_01.jpg" "$HOME/.wallpaper"

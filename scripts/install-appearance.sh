#!/bin/sh
# Instala os assets visuais do tema Gruvbox Purple no perfil do usuário.
# Não requer root: tudo vai para ~/.themes, ~/.icons e ~/.local/share/icons.

set -eu

# Garante que binários instalados no perfil (ex.: xsettingsd) sejam encontrados.
PATH="$HOME/.local/bin:$PATH"
export PATH

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles-appearance"

THEME_NAME="Gruvbox-Plus-Purple-Dark"
ICON_NAME="Gruvbox-Plus-Dark"
CURSOR_NAME="Gruvbox-Cursors"

GTK_REPO="https://github.com/SylEleuth/gruvbox-plus-gtk.git"
ICONS_ZIP="https://github.com/SylEleuth/gruvbox-plus-icon-pack/releases/download/v6.6.0/gruvbox-plus-icon-pack-6.6.0.zip"
CURSORS_ZIP="https://github.com/sainnhe/capitaine-cursors/releases/download/r5/Linux.zip"

mkdir -p "$CACHE_DIR" "$HOME/.themes" "$HOME/.local/share/icons" "$HOME/.icons"

echo "==> Tema GTK3: $THEME_NAME"
if [ ! -d "$CACHE_DIR/gruvbox-plus-gtk/.git" ]; then
    rm -rf "$CACHE_DIR/gruvbox-plus-gtk"
    git clone --depth 1 "$GTK_REPO" "$CACHE_DIR/gruvbox-plus-gtk"
fi

rm -rf "$HOME/.themes/$THEME_NAME"
cp -a "$CACHE_DIR/gruvbox-plus-gtk/Gruvbox-Plus-Dark" "$HOME/.themes/$THEME_NAME"

GTK3="$HOME/.themes/$THEME_NAME/gtk-3.0/gtk.css"
GTK2="$HOME/.themes/$THEME_NAME/gtk-2.0/gtkrc"

# Troca o laranja do Gruvbox Plus pelo roxo de destaque
sed -i \
    's/#fe8019/#d3869b/g; s/254, 128, 25/211, 134, 155/g; s/256, 128, 25/211, 134, 155/g' \
    "$GTK3"
sed -i \
    's/@define-color theme_selected_fg_color #ebdbb2;/@define-color theme_selected_fg_color #1d2021;/; s/@define-color theme_unfocused_selected_fg_color #ebdbb2;/@define-color theme_unfocused_selected_fg_color #1d2021;/' \
    "$GTK3"
sed -i 's/#fe8019/#d3869b/g; s/selected_fg_color:#ebdbb2/selected_fg_color:#1d2021/' "$GTK2"

cat >"$HOME/.themes/$THEME_NAME/index.theme" <<EOF
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=$THEME_NAME
Comment=Gruvbox Plus com destaque roxo
Encoding=UTF-8

[X-GNOME-Metatheme]
GtkTheme=$THEME_NAME
IconTheme=$ICON_NAME
CursorTheme=$CURSOR_NAME
ButtonLayout=close,minimize,maximize:menu
EOF

echo "==> Ícones: $ICON_NAME"
if [ ! -d "$HOME/.local/share/icons/$ICON_NAME" ]; then
    if [ ! -f "$CACHE_DIR/gruvbox-plus-icons.zip" ]; then
        curl -L --fail --progress-bar "$ICONS_ZIP" -o "$CACHE_DIR/gruvbox-plus-icons.zip"
    fi
    unzip -q -o "$CACHE_DIR/gruvbox-plus-icons.zip" "$ICON_NAME/*" -d "$HOME/.local/share/icons"
fi
sed -i 's/^Inherits=.*/Inherits=hicolor/' \
    "$HOME/.local/share/icons/$ICON_NAME/index.theme"

# O script oficial usa GNU cut; aqui fazemos o mesmo com Python (BusyBox não tem --delimiter)
python3 - "$HOME/.local/share/icons/$ICON_NAME/places/scalable" purple <<'PY'
from pathlib import Path
import os
import sys

places = Path(sys.argv[1])
color = sys.argv[2]
for source in sorted(places.glob(f"*-{color}*.svg")):
    if source.name == f"bookmarks-{color}.svg":
        target = places / "folder-bookmark.svg"
    else:
        target = places / source.name.replace(f"-{color}", "")
    if target.exists() or target.is_symlink():
        target.unlink()
    os.symlink(source.name, target)
PY

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons/$ICON_NAME" >/dev/null 2>&1 || true
fi

echo "==> Cursores: $CURSOR_NAME"
if [ ! -d "$HOME/.icons/$CURSOR_NAME" ]; then
    if [ ! -f "$CACHE_DIR/capitaine-cursors.zip" ]; then
        curl -L --fail --progress-bar "$CURSORS_ZIP" -o "$CACHE_DIR/capitaine-cursors.zip"
    fi
    rm -rf "$CACHE_DIR/cursor-extract"
    mkdir -p "$CACHE_DIR/cursor-extract"
    unzip -q -o "$CACHE_DIR/capitaine-cursors.zip" \
        "Capitaine Cursors (Gruvbox)/*" -d "$CACHE_DIR/cursor-extract"
    mv "$CACHE_DIR/cursor-extract/Capitaine Cursors (Gruvbox)" "$HOME/.icons/$CURSOR_NAME"
    sed -i "s/^Name=.*/Name=$CURSOR_NAME/" "$HOME/.icons/$CURSOR_NAME/index.theme"
fi

mkdir -p "$HOME/.icons/default"
cat >"$HOME/.icons/default/index.theme" <<EOF
[Icon Theme]
Name=Default
Comment=Tema de cursor padrão
Inherits=$CURSOR_NAME
EOF

# xsettingsd faz os temas GTK/ícones/cursores chegarem a apps X11 via XSETTINGS.
# No Alpine, instalamos apenas o binário no perfil do usuário (sem root).
if ! command -v xsettingsd >/dev/null 2>&1 && command -v apk >/dev/null 2>&1; then
    mkdir -p "$CACHE_DIR/apk" "$CACHE_DIR/apk-cache" "$HOME/.local/bin"
    if apk fetch --cache-dir "$CACHE_DIR/apk-cache" -o "$CACHE_DIR/apk" xsettingsd >/dev/null 2>&1; then
        XSD_APK=$(find "$CACHE_DIR/apk" -name 'xsettingsd-*.apk' -print -quit)
        if [ -n "$XSD_APK" ]; then
            rm -rf "$CACHE_DIR/xsettingsd-extract"
            mkdir -p "$CACHE_DIR/xsettingsd-extract"
            tar -xzf "$XSD_APK" -C "$CACHE_DIR/xsettingsd-extract"
            cp "$CACHE_DIR/xsettingsd-extract/usr/bin/xsettingsd" "$HOME/.local/bin/xsettingsd"
            cp "$CACHE_DIR/xsettingsd-extract/usr/bin/dump_xsettings" "$HOME/.local/bin/dump_xsettings"
            chmod +x "$HOME/.local/bin/xsettingsd" "$HOME/.local/bin/dump_xsettings"
        fi
    fi
fi

if [ -n "${DISPLAY:-}" ] && command -v xsettingsd >/dev/null 2>&1; then
    if pgrep -f '[x]settingsd' >/dev/null 2>&1; then
        pkill -f '[x]settingsd' 2>/dev/null || true
    fi
    # xsettingsd roda em foreground; inicia em segundo plano e desanexa do script.
    xsettingsd -c "$HOME/.config/xsettingsd/xsettingsd.conf" >/dev/null 2>&1 &
    disown 2>/dev/null || true
fi

if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "$ICON_NAME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Nerd Font 10" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface accent-color "purple" 2>/dev/null || true
fi

if [ -n "${DISPLAY:-}" ] && command -v feh >/dev/null 2>&1; then
    WALLPAPER="$HOME/Pictures/Wallpapers/gruvbox-purple.png"
    [ -f "$WALLPAPER" ] || WALLPAPER="$REPO_DIR/home/Pictures/Wallpapers/gruvbox-purple.png"
    [ -f "$WALLPAPER" ] && feh --bg-scale "$WALLPAPER" 2>/dev/null || true
fi

if [ -n "${DISPLAY:-}" ] && command -v dunstctl >/dev/null 2>&1; then
    dunstctl reload 2>/dev/null || true
fi

if [ -n "${DISPLAY:-}" ] && command -v polybar-msg >/dev/null 2>&1; then
    polybar-msg cmd restart >/dev/null 2>&1 || true
fi

echo "Pronto. Reinicie os aplicativos abertos para ver o tema completo."

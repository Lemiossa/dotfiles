#!/bin/sh

# No Alpine o doas já vem por padrão; nas demais distros usamos sudo.
if [ "$(id -u)" -eq 0 ]; then
	SUDO=
elif command -v doas >/dev/null 2>&1; then
	SUDO=doas
elif command -v sudo >/dev/null 2>&1; then
	SUDO=sudo
else
	echo "Erro: doas ou sudo é necessário para 'make install'." >&2
	exit 1
fi

for d in dwm dwmblocks dmenu st; do
	(cd "$HOME/Suckless/$d" && make && $SUDO make install && make clean)
done

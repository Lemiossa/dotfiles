# Etapas comuns (todas as distros)

Depois de instalar os pacotes e configurar a sessão do seu distro (veja os guias
de [Alpine](ALPINE.md), [Arch](ARCH.md), [Debian/Ubuntu](DEBIAN_UBUNTU.md) ou
[Fedora](FEDORA.md)), execute o restante uma única vez.

## 1. Shell, arquivos e permissões

De dentro do clone deste repositório:

```sh
if command -v doas >/dev/null 2>&1; then SUDO=doas; else SUDO=sudo; fi

chsh -s "$(command -v bash)"
cp -af home/. ~/
$SUDO cp -af root/. /

chmod +x ~/.config/dwmblocks/scripts/*.sh ~/.local/share/dwm/*.sh ~/.local/bin/*
```

## 2. Diretórios usados pelos configs

O `.vimrc` guarda undo em `~/.vim/undo`, o `mpd` espera `~/Music` e
`~/.config/mpd/playlists`. Crie-os antes de abrir vim/mpd:

```sh
mkdir -p ~/.vim/undo ~/Music ~/.config/mpd/playlists
```

## 3. Compilar o dwm, dmenu, st e dwmblocks

```sh
cd ~/Suckless
chmod +x compile_all.sh
./compile_all.sh
```

O `compile_all.sh` detecta automaticamente `doas` (Alpine), `sudo` (demais)
ou executa `make install` diretamente se você já for root. Os binários são
instalados em `/usr/local/bin`.

## 4. Cache de fontes e plugins do vim

```sh
fc-cache -fv

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
```

> O `PlugInstall` precisa de `git` e de `fzf` instalados (veja a seção de
> pacotes do seu distro).

Após isso, reinicie a sessão (ou o computador).

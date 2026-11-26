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

O pacote `root/` já instala `/usr/local/bin/disable-emptty-getty` como executável.

## 2. Liberar a TTY do emptty (evitar conflito com getty)

O `emptty` usa `TTY_NUMBER=1` por padrão neste repositório. Se o getty também
estiver ativo nessa TTY, os dois disputam o console. O script abaixo lê o
`TTY_NUMBER` de `/etc/emptty/conf` e desativa apenas o getty daquela TTY:
comenta a linha correspondente em `/etc/inittab` (Alpine/OpenRC) e recarrega o
init, desativa `getty@ttyN.service` (systemd) ou marca `agetty-ttyN` como
`down` no runit (Void). As outras TTYs continuam com login normal.

```sh
disable-emptty-getty
```

Para outra TTY, passe o número: `disable-emptty-getty tty2`.

## 3. Diretórios usados pelos configs

O `.vimrc` guarda undo em `~/.vim/undo`, o `mpd` espera `~/Music` e
`~/.config/mpd/playlists`. Crie-os antes de abrir vim/mpd:

```sh
mkdir -p ~/.vim/undo ~/Music ~/.config/mpd/playlists
```

## 4. Compilar o dwm, dmenu, st e dwmblocks

```sh
cd ~/Suckless
chmod +x compile_all.sh
./compile_all.sh
```

O `compile_all.sh` detecta automaticamente `doas` (Alpine), `sudo` (demais)
ou executa `make install` diretamente se você já for root. Os binários são
instalados em `/usr/local/bin`. Ele também verifica antes se `tic` está
disponível: o `make install` do st usa `tic -sx st.info` para registrar o
terminfo `st-256color` (pacote `ncurses`, ou `ncurses-bin` no Debian/Ubuntu).

### Sessão dwm: PATH do login manager

Os binários do suckless ficam em `/usr/local/bin`, mas login managers **não**
carregam `.bashrc`/`.profile`. Em alguns init systems (o runit do Void, por
exemplo) o PATH dos serviços é apenas `/usr/bin:/usr/sbin`, e o emptty reclama
que `dwm` não está na PATH mesmo com `/usr/local/bin/dwm` existindo.

O `/usr/share/xsessions/dwm.desktop` instalado por `root/` já resolve isso em
qualquer distro, usando caminho absoluto e definindo o PATH da sessão:

```desktop
Exec=/usr/bin/env PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin /usr/local/bin/dwm
TryExec=/usr/local/bin/dwm
```

Como o `DEFAULT_SESSION=dwm` do `/etc/emptty/conf` casa com o `Name=dwm`, nada
muda na seleção da sessão. O `~/.local/share/dwm/autostart.sh` também exporta
o mesmo PATH antes de iniciar `dwmblocks`, `feh`, `picom` etc. Assim `st`,
`dmenu`, `dwmblocks` e os scripts da barra são encontrados por herança,
independentemente do PATH do serviço do emptty.

Depois de compilar, vale conferir:

```sh
ls -l /usr/local/bin/dwm /usr/local/bin/dmenu /usr/local/bin/dwmblocks /usr/local/bin/st
grep '^Exec=' /usr/share/xsessions/dwm.desktop
```

## 5. Cache de fontes e plugins do vim

```sh
fc-cache -fv

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
```

> O `PlugInstall` precisa de `git` e de `fzf` instalados (veja a seção de
> pacotes do seu distro).

Após isso, reinicie a sessão (ou o computador).

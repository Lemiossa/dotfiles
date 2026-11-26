# Dotfiles
Meus dotfiles.

Usa dwm

## Requisitos

Os nomes dos pacotes variam por distro; os comandos prontos estão em
[docs/install/](docs/install/).

### Base
- xorg (xinit, xsetroot, xset, xrdb, xauth)
- dbus (dbus-run-session, dbus-daemon)
- setxkbmap
- feh
- pipewire, wireplumber e `pipewire-pulse` (no Void o comando já vem do pacote `pipewire`)
- dunst
- gvim / vim (o `gvim` fornece `vim` no Arch e no Fedora; nos demais, instale ambos)
- plugins do vim via vim-plug (precisam de `git` e `fzf`; instale na primeira execução com `:PlugInstall`)
- xclip
- shadow
- adwaita-icon-theme
- pavucontrol
- rofi
- font-jetbrains-mono (usada pelo rofi)
- nerd-fonts (JetBrainsMono Nerd Font e Symbols Nerd Font, usadas pelo dwm e pelo st)
- fontconfig (`fc-cache`)
- emptty
- curl e ca-certificates
- bash
- iw e wireless-tools (`iwgetid`, usado como fallback no `network.sh`)
- pulseaudio-utils (`pactl`, usado no `volume.sh`)
- procps/procps-ng (utilitários como `free` e `ps`)
- sudo ou doas (para o `make install`)
- ncurses (fornece `tic`, usado pelo `make install` do st; no Debian/Ubuntu o pacote é `ncurses-bin`)

### Bibliotecas para compilar o suckless
O dwm e o dmenu linkam `-lX11 -lXinerama -lfontconfig -lXft`; o st usa
`pkg-config` para fontconfig/freetype e também linka `-lXft`. Instale os
arquivos de desenvolvimento:

- libX11
- libXinerama
- libXft
- freetype2
- fontconfig
- pkg-config
- make e um compilador C (gcc/clang) para compilar dwm, st, dmenu e dwmblocks

### Aparência (opcional)
Para instalar o tema visual completo (o `git` também é usado pelo vim-plug):
- git
- unzip

### Para uma melhor experiência
Para transparência do ST:
- picom
Para música:
- mpd
- mpc
- ncmpcpp

## Instalação

Os comandos de instalação dependem da distro e estão em `docs/install/`:

- [Alpine Linux](docs/install/ALPINE.md) — usa `doas`, que já vem por padrão
- [Arch Linux](docs/install/ARCH.md) — usa `sudo`
- [Debian / Ubuntu](docs/install/DEBIAN_UBUNTU.md) — usa `sudo`
- [Fedora](docs/install/FEDORA.md) — usa `sudo`
- [Void Linux](docs/install/VOID.md) — usa `sudo` e runit

As etapas comuns (cópia dos dotfiles, liberação da TTY do emptty, permissões,
compilação do suckless e plugins do vim) estão em
[docs/install/COMMON.md](docs/install/COMMON.md). O getty na TTY usada pelo
emptty é desativado automaticamente para evitar conflito no console.

Os binários do suckless vão para `/usr/local/bin`. O `dwm.desktop` usa caminho
absoluto e define o PATH da sessão, e o `autostart.sh` faz o mesmo para os
filhos — isso evita o erro "dwm não está na PATH" com login managers que não
carregam `.profile`/`.bashrc` (como o emptty sob runit no Void) e funciona em
qualquer distro.

## Wallpaper

O fundo é carregado de `~/.local/share/wallpaper` pelo autostart do dwm.
Para trocar:
```sh
set-wallpaper /caminho/para/imagem.png
```
## Atalhos

`Mod` é a tecla **Alt** (`Mod1Mask`, definida no `config.h` do dwm).

### Geral

| Atalho | Ação |
|---|---|
| `Mod + Enter` | Abre o terminal (st) |
| `Mod + p` | Abre o dmenu |
| `Mod + q` | Fecha a janela focada |
| `Mod + Shift + q` | Sai do dwm |
| `Mod + b` | Mostra/esconde a barra |

### Tags (1 a 5)

| Atalho | Ação |
|---|---|
| `Mod + 1..5` | Vai para a tag |
| `Mod + Shift + 1..5` | Move a janela para a tag |
| `Mod + 0` | Mostra todas as tags |
| `Mod + Shift + 0` | Coloca a janela em todas as tags |

### Janelas (direcional, estilo vim)

`h` = esquerda, `j` = baixo, `k` = cima, `l` = direita.

| Atalho | Ação |
|---|---|
| `Mod + h/j/k/l` | Move o foco na direção |
| `Mod + Shift + h/j/k/l` | Move a janela na direção |
| `Mod + Ctrl + h/j/k/l` | Redimensiona a janela na direção |
| `Mod + Shift + Enter` | Promove a janela para a área principal |
| `Mod + Shift + Space` | Alterna janela flutuante |

### Layouts

| Símbolo | Layout |
|---|---|
| `(@)` | Spiral (fibonacci), padrão |
| `[\]` | Dwindle |
| `[]=` | Tile |
| `[M]` | Monocle |
| `><>` | Flutuante |

`Mod + Space` alterna entre o layout atual e o anterior.

### Gaps

| Atalho | Ação |
|---|---|
| `Mod + Shift + g` | Liga/desliga os gaps |
| `Mod + Ctrl + Shift + g` | Restaura os gaps padrão |

### Mouse

| Ação | Efeito |
|---|---|
| `Mod + botão esquerdo` na janela | Move a janela |
| `Mod + botão do meio` na janela | Alterna flutuante |
| `Mod + botão direito` na janela | Redimensiona a janela |
| Clique esquerdo na tag | Vai para a tag |
| Clique direito na tag | Mostra/oculta a tag junto com a atual |
| `Mod` + clique esquerdo na tag | Move a janela para a tag |
| `Mod` + clique direito na tag | Adiciona/remove a tag na janela |
| Clique esquerdo no símbolo do layout | Alterna com o layout anterior |
| Clique direito no símbolo do layout | Layout flutuante |
| Clique do meio no título | Promove a janela para a área principal |
| Clique do meio na barra de status | Abre o terminal |

### Janelas que abrem flutuando

Gimp, Pavucontrol, Nm-connection-editor, feh e Qemu (i386).

## Aparência

Tema Catppuccin Mocha, fonte JetBrainsMono Nerd Font, borda de 2px, gaps de 12px e área principal com 52% da largura.

A barra do dwmblocks usa o patch status2d: cada bloco tem fundo em uma cor de
destaque diferente (mauve, green, blue, yellow, teal e peach) e texto escuro
(`#11111b`), como um "chip". As cores ficam em
`home/Suckless/dwmblocks/blocks.def.h`, no prefixo `^b#...^^c#...^` de cada
bloco; `^d^` no separador volta às cores normais da barra.

## Patches do dwm

- autostart (scripts em `~/.local/share/dwm/`)
- vanitygaps (gaps e layouts fibonacci)
- dwm-dir (foco, mover e redimensionar direcionais)

## Terceiros

Este repositório inclui ou depende de material de outros autores:

| Item | Origem | Uso |
|---|---|---|
| Wallpaper padrão (`Cloudsnight.jpg`, instalado como `~/.local/share/wallpaper`) | [catppuccin/wallpapers](https://github.com/catppuccin/wallpapers) | Fundo de tela padrão. Licença MIT: [licenses/catppuccin-wallpapers.LICENSE](licenses/catppuccin-wallpapers.LICENSE) |
| Paleta Catppuccin Mocha | [catppuccin](https://github.com/catppuccin/catppuccin) | Cores do dwm, st e demais programas |
| dwm, st, dmenu | [suckless.org](https://suckless.org) | Gerenciador de janelas, terminal e launcher |
| dwmblocks | (link do fork que você usa) | Barra de status |
| Patches: autostart, vanitygaps, dwm-dir | [dwm.suckless.org/patches](https://dwm.suckless.org/patches/) | Ver a seção "Patches do dwm" |
| JetBrains Mono e Nerd Fonts | [nerdfonts.com](https://www.nerdfonts.com) | Fontes |
| vim-plug | [junegunn/vim-plug](https://github.com/junegunn/vim-plug) | Gerenciador de plugins do vim |

Cada item mantém a licença original. Consulte o repositório de origem de cada um.

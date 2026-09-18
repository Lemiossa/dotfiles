# dotfiles

My personal dotfiles.

## Installation

The setup is split into small, reusable scripts:

```
scripts/
├── install.sh            # entry point: detects the distro and runs all steps
├── lib/                  # shared helpers
│   ├── common.sh         # logging/errors and repository location
│   └── detect.sh         # detects the distro via /etc/os-release
├── pkg/                  # per-distro profile (apk/pacman/apt/dnf/xbps)
│   ├── alpine.sh
│   ├── arch.sh
│   ├── debian.sh
│   ├── fedora.sh
│   └── void.sh
└── steps/                # small steps, runnable individually
    ├── 10-packages.sh    # installs packages (and removes elogind if needed)
    ├── 20-services.sh    # enables services (seatd, NetworkManager, ...)
    ├── 30-groups.sh      # adds the user to the required groups
    ├── 40-shell.sh       # sets the default shell to bash
    ├── 50-dotfiles.sh    # copies home/ and root/ (fonts) into the system
    └── 60-vim.sh         # installs the vim plugins
```

To install everything:

```sh
./scripts/install.sh
```

To run a single step (e.g. packages only):

```sh
./scripts/steps/10-packages.sh
```

Supported distros: Alpine, Arch, Debian/Ubuntu, Fedora and Void. The distro
is detected automatically; to add another one, create a profile in
`scripts/pkg/` defining `SUDO`, `PM_PACKAGES` and the functions `pkg_sync`,
`pkg_install`, `pkg_remove`, `setup_services` and `setup_groups`.

### Cursors

- Krypton(https://www.gnome-look.org/p/2367491)

### Theme

Everything ships in **Solarized Dark** and can be switched to Solarized Light
with a shortcut:

| Key | Action |
|-----|--------|
| `Alt+T` | theme picker (rofi menu) |
| `Alt+Shift+T` | toggle dark/light directly |

The `solarized` script (`~/.local/bin/solarized`, invoked as `solarized`) flips
the urxvt palette (`.Xresources`), bspwm borders, polybar colors, the GTK dark
preference and the wallpaper, then triggers vim to `:source ~/.vimrc` on the
next window focus. Subcommands: `dark`, `light`, `toggle`, `rofi`, `current`.

### Wallpapers

6 Solarized wallpapers (`home/Pictures/wallpapers/`):

- `solarized_dark_01..05.png` — Solarized Dark walls, sourced from
  [fr0st-xyz/wallz](https://github.com/fr0st-xyz/wallz) (the dark default is
  `solarized_dark_01.png`, symlinked to `~/.wallpaper`).
- `solarized_light_01.png` — the classic Solarized-stripes design in Light
  (base3 background), derived from the 4K artwork of
  [NicksLameCode/solarized-light-gnome50-rice](https://github.com/NicksLameCode/solarized-light-gnome50-rice)
  and resized to 1920x1080.

The theme shortcut swaps the wallpaper automatically.

### Fastfetch logo

The ASCII cat logo (`home/.config/fastfetch/cat.txt`) is a classic, widely
circulated public ASCII cat (original author unknown, e.g. seen in the
[asciiart.eu cats archive](http://www.asciiart.eu/animals/cats)) with colors
from the solarized palette. Public ASCII art; no attribution required.

### Vim Plugins

| Plugin | Repository |
|--------|------------|
| vim-colors-solarized (colorscheme) | [altercation/vim-colors-solarized](https://github.com/altercation/vim-colors-solarized) |
| auto-pairs | [jiangmiao/auto-pairs](https://github.com/jiangmiao/auto-pairs) |
| lightline.vim | [itchyny/lightline.vim](https://github.com/itchyny/lightline.vim) |
| nerdtree | [preservim/nerdtree](https://github.com/preservim/nerdtree) |
| fzf.vim | [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim) |
| vim-gitgutter | [airblade/vim-gitgutter](https://github.com/airblade/vim-gitgutter) |
| vim-polyglot | [sheerun/vim-polyglot](https://github.com/sheerun/vim-polyglot) |
| asyncomplete.vim | [prabirshrestha/asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim) |
| vim-lsp | [prabirshrestha/vim-lsp](https://github.com/prabirshrestha/vim-lsp) |
| vim-lsp-settings | [mattn/vim-lsp-settings](https://github.com/mattn/vim-lsp-settings) |
| asyncomplete-lsp.vim | [prabirshrestha/asyncomplete-lsp.vim](https://github.com/prabirshrestha/asyncomplete-lsp.vim) |
| colorizer | [lilydjwg/colorizer](https://github.com/lilydjwg/colorizer) |

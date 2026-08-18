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

### Wallpapers

10 Nord-themed wallpapers sourced from
[nordic-wallpapers](https://github.com/linuxdotexe/nordic-wallpapers/)
(`home/Pictures/wallpapers/`). Pick one with `Mod+Shift+t` (set_wallpaper.sh).

### Vim Plugins

| Plugin | Repository |
|--------|------------|
| nord-vim (colorscheme) | [arcticicestudio/nord-vim](https://github.com/arcticicestudio/nord-vim) |
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

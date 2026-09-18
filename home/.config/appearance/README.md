# Appearance module

All the look of the desktop is centralized here so every element can be
configured in one place. Edit the files below, then run
`~/.config/appearance/apply.sh` (or toggle the theme with `Alt+T`); the
generated files are re-rendered from these sources when the theme changes or
at login.

## Layout

| File            | What it configures                                    |
|-----------------|-------------------------------------------------------|
| `settings.conf` | cursor theme/size, terminal + icon fonts, wallpapers, bspwm border width & gap |
| `dark.conf`     | Solarized Dark palette, polybar/bspwm colors, gtk dark preference |
| `light.conf`    | Solarized Light palette, polybar/bspwm colors, gtk dark preference |
| `apply.sh`      | renders `~/.Xresources`, `~/.config/polybar/colors.ini`, the gtk settings, the cursor fallback and `~/.wallpaper`, then applies them live |

## What to edit for each element

- **Cursor theme/size** -> `CURSOR_THEME` / `CURSOR_SIZE` in `settings.conf`.
  The theme ships system-wide under `root/usr/share/icons` in this repo.
- **Terminal font** -> `TERM_FONT` / `TERM_FONT_SIZE` in `settings.conf`.
- **Icon (nerd font) font** -> `ICON_FONT` / `ICON_FONT_SIZE` in `settings.conf`.
- **Wallpapers** -> `WALLPAPER_DARK` / `WALLPAPER_LIGHT` in `settings.conf`
  (filenames inside `~/Pictures/wallpapers`).
- **bspwm gaps / border width** -> `WINDOW_GAP` / `BORDER_WIDTH` in `settings.conf`.
- **Palette colors** -> `PALETTE_*` in `dark.conf` / `light.conf`.
- **polybar colors** -> `POLYBAR_*` in `dark.conf` / `light.conf`.
- **bspwm border colors** -> `BORDER_NORMAL` / `BORDER_FOCUSED` in `dark.conf` / `light.conf`.
- **Default theme** -> `DEFAULT_THEME` in `settings.conf`.

Generated files (`~/.Xresources`, `~/.config/polybar/colors.ini`, the gtk
`settings.ini` files, `~/.icons/default/index.theme`) are derived from these
sources and should not be edited by hand.

The root window cursor is fixed at login by `xsetroot -cursor_name left_ptr`
in `~/.config/bspwm/bspwmrc`.
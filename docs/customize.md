# Customizing

These dotfiles are personal defaults, not a distro-neutral starter kit. Check
these files before using them on another machine.

Refer to MangoWM docs: [mangowm.github.io/docs](https://mangowm.github.io/docs).

## Monitors

Edit `.config/mango/conf.d/00-monitors.conf`.
To set this nice, check Mango`s monitor docs:
[mangowm.github.io/docs/configuration/monitors](https://mangowm.github.io/docs/configuration/monitors).

The current setup expects:

- `DP-1` at `1920x1080@170`, positioned at `0,0`
- `HDMI-A-1` at `1920x1080@60`, positioned at `-1920,0`

Use `.config/mango/conf.d/00-monitors.conf` as a starting point.

## Bar Output

Edit `.config/rs-yambar/config.toml`.

The workspace module uses `output = "DP-1"`; its click helper receives the
same output. The desktop widget separately uses `monitor = "DP-1"` in
`.config/rs-wwidget/config.toml`. Update both for your display layout.

To replace the primary output name before installing, use:

```sh
old=DP-1
new=eDP-1
sed -i "s/$old/$new/g" \
  .config/mango/conf.d/00-monitors.conf \
  .config/rs-yambar/config.toml \
  .config/rs-wwidget/config.toml \
  .local/bin/layout.sh
```

## Browser And Apps

Application key binds live in `.config/mango/conf.d/30-binds-apps.conf`.

Common personal choices to replace:

- browser: `librewolf`
- terminal: `themed-footclient` (for current palette overrides)
- file manager: `thunar`
- volume UI: `pavucontrol`

## Wallpaper Directory

`.local/bin/wallpaper-pick` reads images from `~/Wallpaper` by default.

Override it with:

```sh
WALLPAPER_DIR=/path/to/wallpapers ~/.local/bin/wallpaper-pick
```

## Portal Paths

Mango autostarts `.local/bin/start-portals.sh` from
`.config/mango/conf.d/20-autostart.conf`.

The confusing part is path layout:

- Gentoo commonly exposes portal backend binaries under `/usr/libexec`.
- Most other distros usually expose them through `$PATH` or under `/usr/lib`.

The helper checks those usual locations and starts the main portal, GTK backend
and wlr backend when it can find them.

`.config/xdg-desktop-portal/mango-portals.conf` keeps GTK as the default portal
backend and uses the wlr backend for screenshot and screencast portals.

## Themes And Fonts

GTK, foot, rs-yambar, dunst, and fastfetch expect the fonts and themes listed in
`docs/packages.md`.

The repo bundles the Gruvbox GTK theme config (`.config/gtk-3.0`, `gtk-4.0`),
the `gruvbox-kvantum` Kvantum style (`.config/Kvantum`) and the Qt6ct setup
(`.config/qt6ct`, plus `QT_QPA_PLATFORMTHEME`/`QT_STYLE_OVERRIDE` in
`.config/environment.d`). Icons use the default `Adwaita` scheme. The installer
only copies these files; it no longer prompts to install third-party GTK themes
or icon themes.

Check:

- `.config/gtk-3.0/settings.ini`
- `.config/gtk-4.0/settings.ini`
- `.config/foot/foot.ini`
- `.config/rs-yambar/config.toml`
- `.config/dunst/dunstrc`

## Global theme palettes

Use Super + grave or `desktop-theme NAME`. Put custom JSON files in
`~/.config/desktop-themes/themes/`; assign images with each theme's `wallpaper`
field. Super + X picks a temporary image without changing colors.

See [themes.md](themes.md) for the full schema, component overrides, Neovim
integration, terminal launch helper, generated state and troubleshooting.
The script writes color fields in the app configurations listed above; make
persistent color edits in the JSON palette rather than generated color fields.

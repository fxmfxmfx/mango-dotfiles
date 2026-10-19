# Customizing

These dotfiles are personal defaults, not a distro-neutral starter kit. Check
these files before using them on another machine.

Refer to MangoWM docs: [mangowm.github.io/docs](https://mangowm.github.io/docs).

## Keyboard layouts

Interactive installation first asks whether to enable keyboard switching with
**Alt+Shift**. If enabled, the first layout is `us` and the second defaults to
`ru`. Enter another XKB layout code, such as `de` or `ua`, or enter `?` to see
installed codes and descriptions. Unknown codes are rejected and requested
again. Declining switching writes only `us` and clears the switching shortcut.

For scripts or an explicit choice without prompts:

```sh
./scripts/install.sh --keyboard-layouts us,ru
./scripts/install.sh --keyboard-layouts us,de
./scripts/install.sh --keyboard-layouts us
```

Explicit layout lists are validated too. The validator reads the layout section
of installed XKB `rules/evdev.lst` (or `base.lst`); install `xkeyboard-config`
if the data is missing. For a nonstandard location, set `XKB_CONFIG_ROOT` to
the directory containing `rules/`. Validation and cancelled prompts happen
before installation changes files. Dry runs do not prompt. Noninteractive
installation without `--keyboard-layouts` copies repository keyboard defaults.

After installation, edit `~/.config/mango/conf.d/10-input.conf`:

```ini
xkb_rules_layout=us,ru
xkb_rules_options=grp:lalt_lshift_toggle
```

Change the layout codes and the XKB group shortcut for your needs. The
installer prints this config path, including the target of `--home`.

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
It attempts every backend even if one is missing, and returns a failure status
if any could not be found.

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

## Optional application presets

See [app-themes.md](app-themes.md) for signed browser package installation,
Vesktop Desktop Theme setup and optional GTK/Qt asset installation. These
settings live in the palette's optional `apps` object.

## Updating and checking the repository

Use `./scripts/install.sh --skip-fonts` to update configs offline while keeping
your installed fonts. Normal installation still copies/downloads fonts.
Overwritten files go into a separate backup directory per run. When setting
`DOTFILES_BACKUP_DIR` yourself, use a fresh directory; the installer refuses
to overwrite existing backup files. Retired helpers are always backed up,
including with `--no-backup`.

Run `python3 scripts/check-repo.py` after editing scripts or configuration.
It validates data and script syntax and runs tests, including installation in
a temporary home, without needing a graphical session or network access.

The session launcher defaults to the same `Bibata-Modern-Ice`, size 24 cursor
as the GTK/Mango settings. Set `XCURSOR_THEME` and `XCURSOR_SIZE` before launching
Mango to override the session defaults; update the GTK/Mango configs as well
if you want those settings to agree.

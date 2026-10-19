# Desktop themes

`desktop-theme` applies one JSON palette to MangoWM, rofi, foot, Neovim,
dunst, rs-yambar and rs-wwidget. A theme can also select a local image wallpaper.
The rofi menu is bound to **Super + grave** (the backtick key, `).

Changing a wallpaper with **Super + X** never generates or changes colors.
The picker supports local images only. Video wallpaper, URL wallpaper and
wallpaper-derived color scripts have been removed.

## Quick start

Run these commands from the installed desktop session:

```sh
~/.local/bin/desktop-theme                  # open the rofi menu
~/.local/bin/desktop-theme --list           # list theme names
~/.local/bin/desktop-theme --check gruvbox  # validate without applying
~/.local/bin/desktop-theme gruvbox          # apply a theme
~/.local/bin/desktop-theme cflowers         # restore the original look
```

The menu shows the current theme in its prompt and preselects that entry.
Enter applies the highlighted theme; Escape cancels. The menu stays open until
you choose or cancel. Only names from the theme directory are accepted.

Bundled themes:

| Name | Appearance | Default wallpaper |
| --- | --- | --- |
| `cflowers` | Original desktop, terminal and editor colors | `~/Wallpaper/cupsizeflowers.jpg` |
| `gruvbox` | Dark Gruvbox palette | `~/Wallpaper/prism.png` |
| `catppuccin-mocha` | Catppuccin Mocha with a mauve accent | `~/Wallpaper/gentoo.png` |

The selected name is saved and restored at the next MangoWM login.
Applying the current theme again also reloads edits to its JSON and restores
its assigned wallpaper.

## Installation and dependencies

Install the repository dotfiles using `scripts/install.sh`. It copies the helper
scripts, palettes, Neovim integration, widget configuration and bundled images.
Keep `~/.local/bin` in `PATH`; `start-mango.sh` now exports it for the session.
Run `scripts/check-deps.sh` before using the setup. `install.sh --home PATH`
changes where files are copied; it does not change the running user's HOME,
XDG environment or the meaning of `~` in palette paths. Use a matching HOME/XDG
environment when testing an installation in another directory.

The theme system needs:

| Component | Requirements |
| --- | --- |
| Main script | Linux, Python 3, writable configuration directory, `pgrep`, `pkill` |
| Theme menu and rofi validation | Wayland-capable `rofi` |
| MangoWM | `mango`, `mmsg`, the session's IPC environment |
| Terminal | `foot`, `/usr/bin/footclient`, access to the user's own `/proc` and PTYs |
| Notifications | `dunst`, `dunstctl`, `notify-send` from libnotify |
| Top bar | `rs-yambar` with `--validate -c` support |
| Desktop widget | `rs-wwidget` with `--check-config`, `status` and `restart` support |
| Neovim | Neovim 0.11 or newer, installed `lazy.nvim` and the bundled config |
| Existing Neovim discovery | Python `msgpack` module and Unix RPC sockets |
| Theme wallpaper | `awww`, running `awww-daemon`, a supported local image |
| Manual wallpaper picker | Bash, GNU `find` and `sort` with NUL-delimited output |

The repository includes locally built `rs-yambar` and `rs-wwidget` executables.
Rebuild them on systems with incompatible libraries:
[rs-yambar](https://github.com/fxmfxmfx/rs-yambar),
[rs-wwidget](https://github.com/fxmfxmfx/rs-wwidget).
On Gentoo, the Python MessagePack package is commonly `dev-python/msgpack`;
ensure it is enabled for the interpreter used by `python3`. The dependency
checker verifies the actual import. See [packages.md](packages.md) for the
rest of the desktop dependencies.

The installer moves retired helpers and data into its backup directory even
with `--no-backup`; they are no longer present in the active configuration.

The main script currently expects all six desktop component configs to exist.
It does not silently skip a missing component. `--check` runs the component
validators too, so it needs their binaries even though it does not reload them.

## Files and environment

Default layout:

```text
~/.local/bin/desktop-theme
~/.local/bin/themed-footclient
~/.local/bin/wallpaper-pick
~/.config/desktop-themes/
    themes/
        cflowers.json
        gruvbox.json
        catppuccin-mocha.json
    current           # generated: selected theme name
    active.json       # generated: resolved palette for Neovim
    .lock             # serializes application of themes
~/.config/nvim/lua/config/desktop_theme.lua
~/.local/state/desktop-theme/rs-yambar.log
~/.cache/current_wallpaper
~/.cache/current_wallpaper_mode
```

`current`, `active.json` and `.lock` are local state, not tracked theme sources.
If `current` does not exist, the default is `cflowers`. Neovim can read the
selected theme file directly before the first `active.json` has been generated.
Do not edit `active.json`: the next application overwrites it.

Supported environment variables:

| Variable | Meaning |
| --- | --- |
| `XDG_CONFIG_HOME` | Configuration root; defaults to `~/.config` |
| `XDG_CACHE_HOME` | Wallpaper cache root; defaults to `~/.cache` |
| `XDG_STATE_HOME` | Bar log root; defaults to `~/.local/state` |
| `XDG_RUNTIME_DIR` | Search root for existing Neovim RPC sockets; defaults to `/run/user/UID` |
| `MANGO_INSTANCE_SIGNATURE` | Mango IPC endpoint; needed for live compositor reload |
| `WALLPAPER_DIR` | Manual picker directory only; defaults to `~/Wallpaper` |
| `SWWW_TRANSITION` | Manual picker's awww transition; defaults to `fade` |
| `SWWW_DURATION` | Manual picker's transition seconds; defaults to `1` |
| `SWWW_FPS` | Manual picker's transition FPS; defaults to `60` |

The historical `SWWW_*` names belong to `wallpaper-pick`; the backend is awww.
The theme's assigned wallpaper always uses a one-second fade at 60 FPS.
`WALLPAPER_DIR` does not override a theme's `wallpaper` field. GTK, Qt and other
programs may have their own XDG or font configuration; changing the helper's
root alone does not relocate an entire desktop installation.

## Create your own theme

1. Copy a bundled theme under a new name:

   ```sh
   cp ~/.config/desktop-themes/themes/gruvbox.json \
      ~/.config/desktop-themes/themes/mytheme.json
   ```

2. Edit `mytheme.json`. Use six hexadecimal RGB digits, without `#` or an alpha
   suffix. Uppercase and lowercase hex are both valid. JSON does not support
   comments or trailing commas.
3. Set `wallpaper` to an existing image, or use `null` to keep the current one.
4. Validate and apply:

   ```sh
   desktop-theme --check mytheme
   desktop-theme mytheme
   ```

The filename becomes the menu entry. No script or keybinding changes are needed.
Use letters, digits, hyphens and underscores for the filename stem; no spaces,
slashes or dots. Themes are independent complete palettes: copying a theme is a
starting point, not an inheritance relationship. Saving a JSON file alone does
not apply it; reselect the theme or run the command.

This complete minimal example has all required colors and keeps the wallpaper:

```json
{
  "bg": "282828",
  "bg_alt": "3c3836",
  "bg_soft": "504945",
  "fg": "ebdbb2",
  "muted": "a89984",
  "accent": "fabd2f",
  "urgent": "fb4934",
  "border": "665c54",
  "green": "b8bb26",
  "wallpaper": null,
  "terminal": {
    "regular0": "282828",
    "regular1": "cc241d",
    "regular2": "98971a",
    "regular3": "d79921",
    "regular4": "458588",
    "regular5": "b16286",
    "regular6": "689d6a",
    "regular7": "a89984",
    "bright0": "928374",
    "bright1": "fb4934",
    "bright2": "b8bb26",
    "bright3": "fabd2f",
    "bright4": "83a598",
    "bright5": "d3869b",
    "bright6": "8ec07c",
    "bright7": "ebdbb2"
  }
}
```

## Palette reference

All nine top-level color keys below are required. Every color is an RGB string.

| Key | Role |
| --- | --- |
| `bg` | Main background; default terminal background; widget and bar background |
| `bg_alt` | Secondary surfaces; low urgency notification background by default |
| `bg_soft` | Selected rows; terminal selection and widget bar background by default |
| `fg` | Main text; default terminal foreground |
| `muted` | Secondary text, empty workspaces and low urgency notifications |
| `accent` | Focus, highlighted workspaces, bar icons and normal notification frames |
| `urgent` | Critical notification frames and urgent rofi entries |
| `border` | Rofi, MangoWM and widget borders |
| `green` | Widget positive indicator and default Neovim insert-mode background |

Other top-level keys documented below are optional except `terminal`.

For the current bar layout, the first `foreground` field uses `fg`, later
segment foreground fields use `accent`, and the date uses `muted`.
Optional `low_bg` overrides the low urgency notification background.

### `terminal`

Required object. Define `regular0` through `regular7` and `bright0` through
`bright7`. These sixteen ANSI colors are also used for Neovim syntax colors.
Their usual roles are black, red, green, yellow, blue, magenta, cyan and white.

Additional optional keys:

| Key | Default |
| --- | --- |
| `background` | `bg` |
| `foreground` | `fg` |
| `selection-background` | `bg_soft` |
| `selection-foreground` | `fg` |
| `urls` | `accent` |

`cflowers` overrides all five to preserve its original foot colors. Other foot
options such as alpha, padding, font, cursor shape and keybindings remain in
`foot.ini`. They are not RGB palette entries.

### `mango`

Optional object for compositor-specific overrides:

| Key | Default |
| --- | --- |
| `rootcolor` | `bg` |
| `bordercolor` | `border` |
| `focuscolor` | `accent` |
| `maximizescreencolor` | `accent` |
| `scratchpadcolor` | `accent` |

The script appends `ff` alpha when writing MangoWM's `0xRRGGBBAA` colors.
Gaps, border sizes, animations, blur and shadows retain their existing settings.

### `widget`

Optional rs-wwidget overrides:

| Key | Default |
| --- | --- |
| `background` | `bg` |
| `foreground` | `fg` |
| `muted` | `muted` |
| `accent` | `accent` |
| `green` | `green` |
| `border` | `border` |
| `bar_background` | `bg_soft` |
| `grid_background` | `bg` |

Widget monitor, language, fonts, opacity and visible modules remain in
`~/.config/rs-wwidget/config.toml`.

### `nvim`

Optional overrides for editor surfaces and mini.statusline:

| Key | Default |
| --- | --- |
| `surface` | `bg_alt` |
| `comment` | `muted` |
| `status_fg` | `bg` |
| `status_normal` | `accent` |
| `status_insert` | `green` |
| `status_visual` | `terminal.bright5` |
| `status_replace` | `urgent` |
| `status_command` | `terminal.bright3` |
| `status_other` | `terminal.bright6` |
| `status_info` | `bg_alt` |

`surface` colors cursor lines, folds, menus and similar secondary areas.
`comment` colors comments and the filename/inactive status segments.
`status_normal` is the normal mode background and the foreground of the
information segments; `status_info` is their background. The filename and
inactive segments use `status_fg` as their background. The original custom
highlight mapping is retained for syntax, Treesitter, diagnostics and NvimTree.
The integration also sets Neovim's sixteen terminal colors.

For example, add these optional overrides alongside the required palette:

```json
"nvim": {
  "surface": "32302f",
  "comment": "928374",
  "status_fg": "282828"
}
```

These are JSON fragments, not complete standalone theme files. Use only the
documented fields as supported customization points. Unknown color-shaped
fields may currently pass validation, but are not a supported way to add
application settings. Do not supply `name`; the theme name comes from its filename.

## Wallpaper behavior

```json
"wallpaper": "~/Wallpaper/forest.png"
```

`wallpaper` accepts an absolute file path, a path beginning with `~`, or a path
relative to `~/.config/desktop-themes` (the XDG equivalent when configured).
For example, `images/forest.png` refers to the theme directory's `images`
subdirectory. Relative paths are not relative to the individual JSON file or
the shell's working directory. Environment variables such as `$HOME` are not
expanded inside this field; use `~` instead.

Supported extensions are `.jpg`, `.jpeg`, `.png`, `.webp`, `.gif`, `.bmp` and
`.avif`, case-insensitively. File existence and extension are checked before
any component config is written. The actual decoder is awww; an extension
alone does not guarantee the file contains a valid supported image.

Omit `wallpaper`, set it to `null`, or set it to `""` to keep the current image.
A theme image is applied to all awww-managed outputs, with no per-monitor theme
wallpaper setting. Login restoration applies it too.

`wallpaper-pick` recursively lists images in `WALLPAPER_DIR`, defaults to
`~/Wallpaper`, and lets you pick an image without changing colors or modifying
a theme JSON. This temporary choice remains until you select another image or
apply a theme with an assigned wallpaper. The picker does not auto-save your
choice as that theme's default. To make it permanent, edit `wallpaper` in JSON.

## What applying a theme does

1. Load the selected JSON and validate color strings, required keys and any
   assigned wallpaper path. Serialize concurrent applications with `.lock`.
2. Render updates to existing component configs plus resolved `active.json`.
3. Validate temporary foot, rofi, rs-yambar and rs-wwidget configs using their
   own binaries. A validation failure leaves the existing configs unchanged.
4. Replace each component file atomically and save `current`.
5. Reload MangoWM and running dunst; restart rs-yambar. Restart rs-wwidget only
   if it is already running. The theme does not enable a stopped widget.
6. Send output-only OSC color updates to open foot PTYs. No terminal process
   is killed and no shell input is sent.
7. Notify discovered Neovim RPC sockets so older instances load the integration.
   Already-integrated Neovim instances also watch `active.json` for atomic
   replacements and reload on focus/resume.
8. Apply the assigned image via awww and update the wallpaper cache.
9. Show a notification headed `Theme`. Startup restoration omits that popup.

MangoWM's autostart runs `desktop-theme --restore` after starting awww-daemon.
`--restore` uses the saved name, or `cflowers` on first use, and skips a recursive
MangoWM config reload. It still performs validation and component refresh.

Application changes only recognized color fields in existing config layouts.
It preserves fonts, geometry, keybindings, bar modules and unrelated options.
If you rename/delete required fields or restructure the layouts, update the
renderer too. Optional `apps` assignments select installed browser/Vesktop
presets and, when configured, GTK/Qt presets. See [app-themes.md](app-themes.md).

Configuration writes are atomic per file, not one transaction covering the
entire desktop. Write errors trigger an attempt to restore prior file contents.
A later component reload or wallpaper failure is reported, but does not roll
back already-applied colors or the saved theme name. Fix the reported error and
reapply the same theme. There are no automatic long-term per-switch backups;
keep custom JSON in version control or copy it before experimenting.

## foot and Neovim details

MangoWM's terminal/scratchpad bindings and rofi use `themed-footclient`.
It reads the current `foot.ini` colors and forwards them as launch overrides
to `/usr/bin/footclient`, even if the server was started with an older palette.
Use this helper for additional footclient launchers too. A plain `foot` process
reads the updated configuration normally. A plain `footclient` may inherit
older server defaults. If your footclient binary is installed elsewhere,
update its path in `themed-footclient`.

Open foot windows receive the ANSI palette, foreground, background, cursor
foreground and selection colors via OSC. Some application-defined truecolor
styles are independent; changing terminal colors cannot recolor every TUI.
The URL highlight override is passed to new foot windows but is not part of
the live OSC broadcast.

Neovim uses a Lua module, not an external downloadable Gruvbox colorscheme.
Its theme name is visible as `vim.g.desktop_theme`, and `colors_name` becomes
`desktop-cflowers`, `desktop-gruvbox`, etc. No buffers are saved or closed.
A modal editor prompt can defer the bootstrap RPC notification; close the
prompt normally. If an older editor's socket was not discovered, bootstrap it
once with:

```vim
:lua require('config.desktop_theme').setup()
```

Once installed, a directory watcher handles future updates without needing an
RPC round trip. A manually forced external `:colorscheme` may replace these
highlights until the next global-theme application or focus/resume event.

## CLI reference

```text
desktop-theme [--check] [--restore] [--list] [theme]
```

| Invocation | Behavior |
| --- | --- |
| No arguments | Open the rofi menu |
| `NAME` | Validate and apply the named JSON |
| `--list` | Print sorted JSON filename stems and exit |
| `--check NAME` | Validate without writing configs, changing wallpaper or reloading |
| `--check` | Choose a theme in rofi, then validate it |
| `--restore` | Apply the saved name, suppress the popup and compositor reload |
| `--help` | Show argparse usage |

Use one mode at a time. `--list` takes precedence; `--restore` selects the saved
name even if a positional name was supplied. Success and menu cancellation
return zero. Invalid themes, validation or reported reload failures return a
nonzero status. Argparse usage errors return 2. Some best-effort live terminal
or editor connection failures are printed without failing the whole switch.
`--check` validates configuration generation; it does not test IPC, live
reloads, wallpaper decoding or the visual result.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Super + grave opens the old launcher | Install the updated Mango bind file and reload with Super + R |
| `desktop-theme` is not found | Use `~/.local/bin/desktop-theme` or add `~/.local/bin` to session PATH |
| A theme is absent from the menu | Put validly named `*.json` in `desktop-themes/themes`, then reopen the menu |
| Invalid RGB color | Remove `#`, alpha suffixes, numbers and non-color metadata; use six-digit strings |
| Missing color/key/config | Start from a complete bundled theme and retain required fields in app configs |
| Wallpaper missing | Fix the local path or use `null`; the image must exist on this machine |
| Colors change but wallpaper does not | Run `awww query`, check the daemon/session and image decoding, then reapply |
| `msgpack` import fails | Install it for `python3`; run the dependency checker again |
| Existing Neovim keeps old colors | Close modal prompts; run the setup command above; check the RPC socket location |
| New terminal uses old colors | Use `themed-footclient`; verify rofi and custom launchers use it |
| Widget remains hidden | Theme switching preserves stopped state; use `rs-wwidget start` to enable it |
| Bar disappears | Inspect `~/.local/state/desktop-theme/rs-yambar.log` and validate its config |
| Validation works but reload fails | Run from the MangoWM session with its Wayland, runtime and IPC environment |
| Notifications or widget use wrong output/font | Edit the component configuration; palettes do not change geometry or fonts |

The installer backs up overwritten files under `~/.dotfiles-backup/` by default.
For recovery, use an installer backup or restore your version-controlled
palette/configs, then apply a known working theme. Do not delete the theme
source directory as a way to reset generated state.

## Development checks

From the repository root:

```sh
python3 -m unittest discover -s tests -v
sh -n scripts/install.sh
sh -n scripts/check-deps.sh
```

The unit tests use temporary configuration roots and mock live reloads. They
cover the bundled palettes, validation without writes, color updates with
layout preservation, invalid wallpaper rejection, relative paths and rollback
after a simulated write failure. They do not restart your desktop components.
After installation, also run `desktop-theme --check cflowers` and
`desktop-theme --check gruvbox` to exercise the actual application validators.


## Worked example: Catppuccin Mocha

The bundled `catppuccin-mocha.json` adapts the
[official Mocha palette](https://catppuccin.com/palette/#mocha) to this theme
system. It uses Base for the main background, Mantle for secondary surfaces,
Surface 0 for selections, Text for foreground, Subtext 0 for muted text, Mauve
for the accent, Red for urgency, Surface 1 for borders and Green for positive
indicators. The terminal ANSI slots use the corresponding named Mocha colors;
Neovim keeps this setup's existing syntax-to-ANSI mapping.

Its assigned wallpaper is `~/Wallpaper/gentoo.png`. To try it:

```sh
desktop-theme --check catppuccin-mocha
desktop-theme catppuccin-mocha
```

To make a personal variant, keep the complete ANSI palette and change just the
roles you want:

```sh
cp ~/.config/desktop-themes/themes/catppuccin-mocha.json \
   ~/.config/desktop-themes/themes/my-mocha.json
nvim ~/.config/desktop-themes/themes/my-mocha.json
```

For a blue accent and another wallpaper, edit these existing fields:

```json
"accent": "89b4fa",
"wallpaper": "~/Wallpaper/my-picture.png"
```

This snippet is a fragment of the copied theme, not a complete file. Keep all
other fields. Use `"wallpaper": null` to leave the current wallpaper unchanged.
Then run `desktop-theme --check my-mocha` followed by `desktop-theme my-mocha`.
The filename automatically appears in the Super + grave menu. No plugin,
Lua module, extra script or keybinding needs to be written for another palette.

## Browser and application presets

See [app-themes.md](app-themes.md) for the bundled signed browser packages,
native handler setup, the three Vesktop CSS files and the optional GTK/Qt
installer. `apps` is the optional object of application preset names/IDs,
separate from the common RGB palette.


# Browser, Vesktop and optional GTK/Qt themes

The normal dotfile installer copies the browser packages, native handler,
Vesktop styles and application adapter. Browser installation and the Vesktop
selection are one-time manual steps. GTK/Qt theme downloads are a separate,
optional command. Profiles, cookies, account settings and session data are not
part of this bundle.

## Layout

```text
.config/desktop-themes/
    browser-addons/
        desktop-theme-bridge-1.0.0.xpi  # signed switcher
        gruvbox-dark-1.1.xpi           # signed browser theme
        catppuccin-1.0.xpi             # signed browser theme
        SHA256SUMS
        README.md
    browser-extension/                # matching switcher source
    themes/*.json                     # palette and app assignments
.config/vesktop/themes/
    GruvboxSharp.theme.css             # original preset
    CatppuccinMochaSharp.theme.css     # adapted preset
    DesktopTheme.theme.css            # enable this managed stylesheet
.local/bin/
    desktop-theme
    desktop-theme-browser-host
    desktop-theme-browser-setup
.local/lib/desktop_theme_apps.py
scripts/install-app-themes.sh          # optional GTK/Qt preset download
```

## Browser: install once

After `./scripts/install.sh`:

```sh
~/.local/bin/desktop-theme-browser-setup
```

The command verifies the bundled archives against `SHA256SUMS`, registers the
native handler in common per-user LibreWolf/Firefox lookup directories, and
prints the three XPI locations. It does not open or modify browser profiles.
Native manifests contain this user's absolute executable path and are generated
on the target machine, rather than committed as machine-specific files.

In the browser profile that you use:

1. Open `about:addons`.
2. Choose the gear menu > **Install Add-on From File**.
3. Install all three XPI files from
   `~/.config/desktop-themes/browser-addons/`.
4. Apply a global theme with Super + grave or `desktop-theme NAME`.

Install them in each profile where synchronization is wanted. These packages
are already signed and remain installed after a browser restart. The bundled
bridge requires a Firefox/LibreWolf version based on Firefox 142 or newer. No temporary
loading, Mozilla developer account, upload, or local rebuilding is needed.
The browser still asks for the normal installation/permission confirmation.

The selected installed theme is controlled by `apps.librewolf`:

| Global theme | Browser theme |
| --- | --- |
| `cflowers` | Gruvbox Dark |
| `gruvbox` | Gruvbox Dark |
| `catppuccin-mocha` | Catppuccin |

The JSON values are add-on IDs from the bundle, not visible names or profile
paths. The bridge uses only `management` and `nativeMessaging`; it has no tab,
history, cookie or network permissions. Its handler exposes only the selected
browser theme ID/change generation and accepts bounded status reports. It does
not execute browser-provided commands or accept arbitrary filesystem paths.

The extension reconnects at browser startup and applies the latest selection.
A manual browser-theme choice is retained until the next global theme
application. Its toolbar popup reports the current selection or connection
error. Diagnostic state is local at
`~/.config/desktop-themes/librewolf-bridge-status.json`.

### Check or develop the bridge

```sh
desktop-theme-browser-setup --check
```

`--check` validates the bundle without registering anything. The signed archive
is preserved exactly. `--build-unsigned` is a developer option that creates a
separate `~/.config/desktop-themes/browser-bridge-unsigned.xpi`; it does not
replace the signed package. New bridge versions need new signed packages.
Third-party browser-theme authors, sources and licenses are recorded in the
bundle's README. The bridge's source ID must continue matching the native-host
allowed-extension ID.

## Vesktop: three CSS files, one enabled

In Vesktop's **Settings > Vencord > Themes**, enable **Desktop Theme** once.
Disable the other local theme selections and any remote theme links that would
layer conflicting colors over it. Keep Discord's built-in dark appearance on.

| CSS file | Purpose |
| --- | --- |
| `GruvboxSharp.theme.css` | Original Gruvbox Sharp preset |
| `CatppuccinMochaSharp.theme.css` | Mocha palette adapted to the same layout |
| `DesktopTheme.theme.css` | Managed theme that receives the selected preset |

All three files are included. The shipped Desktop Theme bootstrap imports
Gruvbox; applying a global theme replaces its installed copy with the selected
preset CSS. The two source presets remain unchanged. Vencord watches the
stylesheet directory and refreshes enabled CSS when it changes. If a particular
client build stops refreshing it, reload the client manually.

`cflowers` and `gruvbox` use Gruvbox Sharp. `catppuccin-mocha` uses Catppuccin
Mocha Sharp. The adaptation preserves the original sharp corners, selectors,
IBM Plex font import and upstream attribution. The inherited Google Fonts
import is still present. `apps.vesktop` is the source preset filename.

Do not edit the installed managed file for permanent customizations; it is
replaced on theme application. Edit a source preset or add a new CSS file and
assign its filename instead. The switcher does not rewrite Vesktop settings,
restart the app or touch its account/session data.

## GTK/Qt: optional installer and optional synchronization

The normal `install.sh` copies GTK settings, qt6ct settings and the bundled
Gruvbox Kvantum preset. It does not download GTK/Qt theme assets.
These are static defaults: GTK 3 names `Gruvbox-Dark-Soft`, Qt selects the
bundled Gruvbox Kvantum preset, and GTK 4 has no explicit theme name in its
settings file. Switching global palettes changes GTK/Qt only after you enable
the assignments described below.

To install the official Catppuccin Mocha/Mauve GTK and Kvantum presets:

```sh
./scripts/install-app-themes.sh
```

This optional script downloads pinned GTK release `v1.0.3` and Kvantum commit
`71105d224fef95dd023691303477ce3eea487457`, verifies archive/license SHA-256
hashes, and installs only the chosen presets plus their licenses. It needs
`curl`, `sha256sum`, `unzip`, and `tar`, and uses no sudo.

Targets are:

- `$XDG_DATA_HOME/themes/catppuccin-mocha-mauve-standard+default`
  (default `~/.local/share/themes/...`), with GTK 3 and GTK 4 CSS;
- `$XDG_CONFIG_HOME/Kvantum/catppuccin-mocha-mauve`
  (default `~/.config/Kvantum/...`).

The existing Gruvbox-Dark-Soft GTK theme is a separate prerequisite if you want
that appearance; it is not downloaded by this Catppuccin installer. Install it
in `~/.themes`, `$XDG_DATA_HOME/themes` or a system theme directory. The Kvantum
Gruvbox preset is already bundled. System theme names must match exactly.

Repository palettes enable browser/Vesktop assignments by default. GTK/Qt
synchronization is optional: add the following keys inside a palette's `apps`
object after installing the relevant assets:

```json
"gtk": "catppuccin-mocha-mauve-standard+default",
"kvantum": "catppuccin-mocha-mauve"
```

For existing Gruvbox assets, use `"gtk": "Gruvbox-Dark-Soft"` and
`"kvantum": "gruvbox-kvantum"`. Omit/null either key to keep its current system
selection. These supplied presets are dark; the GTK integration requests dark
appearance as well as setting the named theme.

GTK settings retain unrelated fonts/options. GTK 4 user CSS gets a managed
import of the preset, preserving existing regular custom CSS after that block;
previous named-theme CSS symlinks are replaced by the import file. `gsettings`
updates are sent when available. Qt selection updates the Kvantum preset and
qt6ct/installed qt5ct appearance style. The session needs the existing
`QT_QPA_PLATFORMTHEME=qt6ct` and `QT_STYLE_OVERRIDE=kvantum` settings. Some open
GTK/Qt applications need reopening to pick up a new preset. Applications with
their own styling may ignore it. No applications are force-closed.

## Assignments and troubleshooting

A palette may contain:

```json
"apps": {
  "vesktop": "CatppuccinMochaSharp.theme.css",
  "librewolf": "{f5525f34-4102-4f6e-8478-3cf23cfeff7a}"
}
```

This is a fragment to add alongside the RGB/terminal palette. `apps` is optional;
missing/null entries keep that application's current selection. Unknown keys,
paths and control characters are rejected. Theme files are checked before
writing configs; a browser theme's installed status is checked by its add-on.
`--check` validates config generation but cannot prove that a browser add-on or
Vesktop managed theme has been enabled in the UI.

| Problem | Action |
| --- | --- |
| Browser theme does not change | Install all three signed XPIs in the active profile; run browser setup; inspect the bridge popup |
| Native host not found | Rerun setup after moving the installation; confirm the browser has access to one of the generated user-host manifests |
| Browser theme missing | Install the corresponding bundled theme in this profile |
| Vesktop stays unchanged | Enable only Desktop Theme and apply the global theme again |
| Missing GTK/Kvantum preset | Install its assets, or remove/null that optional app key |
| GTK/Qt existing window stays unchanged | Reopen that window/application |

Native manifests, generated state, unsigned development builds, user profiles
and Vesktop settings/session directories are excluded from the repository and
installer. The installer overwrites the installed managed CSS with its bootstrap
on reinstall; reapply the selected global theme afterward to restore its preset.

# Browser, Vesktop and optional GTK/Qt themes

LibreWolf and Vesktop integration is optional; neither application is required
for desktop theme switching. The normal dotfile installer copies the signed
browser add-ons, native-messaging handler, Vesktop styles and application
adapter, but does not install either application, add browser extensions to a
profile or enable the Vesktop stylesheet. Those app-specific setup steps are
manual and optional.
GTK/Qt theme downloads are a separate optional command. Profiles, cookies,
account settings and session data are not part of this bundle.

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
    DesktopTheme.theme.css            # optional: enable to sync Vesktop
.local/bin/
    desktop-theme
    desktop-theme-browser-host
    desktop-theme-browser-setup
.local/lib/desktop_theme_apps.py
scripts/install-app-themes.sh          # optional GTK/Qt preset download
```

## LibreWolf: optional setup

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

## Vesktop: optional CSS setup

This requires Vesktop with Vencord's theme support enabled. In **Settings >
Vencord > Themes**, enable **Desktop Theme** once. Disable the other local
theme selections and any remote theme links that would layer conflicting colors
over it. Keep Discord's built-in dark appearance on.

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
These are defaults for `cflowers` and `gruvbox`: GTK selects
`Gruvbox-Dark-Soft`, and Qt selects the bundled `gruvbox-kvantum` preset. The
`catppuccin-mocha` palette selects Catppuccin Mocha/Mauve for GTK and Kvantum.
GTK 4 has no explicit theme name in its static settings file; the theme helper
sets it when applying a palette.

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

The existing Gruvbox-Dark-Soft GTK theme is a separate prerequisite; it is not
downloaded by this Catppuccin installer. Install it in `~/.themes`,
`$XDG_DATA_HOME/themes` or a system theme directory. The Kvantum Gruvbox preset
is already bundled. System theme names must match exactly.

Repository palettes declare LibreWolf, Vesktop, GTK and Qt assignments by
default. LibreWolf and Vesktop assignments take effect after their optional
setup above. GTK/Qt assignments take effect when the selected presets are
installed. Missing GTK or Kvantum presets are skipped with a warning; the rest
of the global theme still applies. Install the optional Catppuccin assets with
the script above and provide the separate Gruvbox GTK prerequisite to enable
all three themes' GTK/Qt synchronization. None of these apps or presets is
required for core desktop theme switching.

The mappings are:

| Global theme | GTK preset | Kvantum preset |
| --- | --- | --- |
| `cflowers` | `Gruvbox-Dark-Soft` | `gruvbox-kvantum` |
| `gruvbox` | `Gruvbox-Dark-Soft` | `gruvbox-kvantum` |
| `catppuccin-mocha` | `catppuccin-mocha-mauve-standard+default` | `catppuccin-mocha-mauve` |

To customize a mapping, change its `apps.gtk` or `apps.kvantum` value in the
palette JSON. Set a key to `null` to leave that system selection alone. The
following fragment shows the Catppuccin assignments:

```json
"gtk": "catppuccin-mocha-mauve-standard+default",
"kvantum": "catppuccin-mocha-mauve"
```

These supplied presets are dark; the GTK integration requests dark appearance
as well as setting the named theme.

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

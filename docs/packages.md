# Packages

These dotfiles are tuned for Gentoo GNU/Linux and MangoWM. Package names vary by
repository and overlay, so treat this as the software surface the setup expects.

## Mango Session

- [`mango`](https://github.com/mangowm/mango)
- `dbus`
- `dbus-run-session`
- `pipewire`
- `pipewire-pulse`
- `wireplumber`
- `xdg-desktop-portal`
- `xdg-desktop-portal-wlr`
- `xdg-desktop-portal-gtk`
- [`foot`](https://github.com/DanteAlighierin/foot)
- [`rofi`](https://github.com/DaveDavenport/rofi)
- [`awww`](https://github.com/NotAShelf/awww)
- [`rs-yambar`](https://github.com/fxmfxmfx/rs-yambar)
- [`rs-wwidget`](https://github.com/fxmfxmfx/rs-wwidget)
- [`dunst`](https://github.com/dunst-project/dunst)

## Script Dependencies

- `bash`
- `curl` and `tar` (font downloads during normal installation;
  `install.sh --skip-fonts` avoids that step)
- `notify-send` (libnotify), `dunstctl`, `pgrep`, `pkill`
- GNU `coreutils`
- `findutils`
- `gawk` or compatible `awk`
- `grep`
- `sed`
- `head`
- `procps`/`psmisc` tools such as `pgrep` and `killall`
- [`wl-clipboard`](https://github.com/bugaevc/wl-clipboard)
- [`cliphist`](https://github.com/sentriz/cliphist)
- [`wayfreeze`](https://github.com/Jappie3/wayfreeze)
- [`grim`](https://gitlab.freedesktop.org/emersion/grim)
- [`slurp`](https://github.com/emersion/slurp)
- [`swappy`](https://github.com/jtheoof/swappy)

## Optional Apps And Tools

- `mpv`
- `imv`
- `thunar`
- `librewolf`
- `pavucontrol`

## Shell And Editor

- `zsh`
- `nvim`
- `git`
- `make`
- `gcc` or another C compiler for Treesitter parsers
- `python3` and its `msgpack` module (existing Neovim theme updates)
- `btop`
- `fastfetch`
- [`ripgrep`](https://github.com/BurntSushi/ripgrep)
- [`fd`](https://github.com/sharkdp/fd)
- [`eza`](https://github.com/eza-community/eza)
- [`bat`](https://github.com/sharkdp/bat)
- [`dust`](https://github.com/bootandy/dust)
- `doas`
- [`neo`](https://github.com/st3w/neo)

## UI And Themes

- [`Symbols Nerd Font Mono`](https://www.nerdfonts.com/) - install via [nix-fonts](https://github.com/nerd-fonts/nerd-fonts) or your package manager
- [`JetBrainsMono Nerd Font`](https://www.nerdfonts.com/) - install via [nix-fonts](https://github.com/nerd-fonts/nerd-fonts) or your package manager
- [`Gruvbox-Dark-Soft`](https://github.com/morhetz/gruvbox) - GTK theme (installed under `~/.themes`)
- `gruvbox-kvantum` - Kvantum style for Qt apps (bundled in `.config/Kvantum`)
- Catppuccin Mocha/Mauve GTK 3/4 and Kvantum themes - downloaded by the optional `scripts/install-app-themes.sh`
- Signed LibreWolf themes: Gruvbox Dark and Catppuccin
- Vesktop CSS themes: Gruvbox Sharp and Catppuccin Mocha Sharp (bundled in `.config/vesktop/themes`)
- `Adwaita` - GTK/Qt icons; `Papirus-Dark` - rofi icons; `Bibata-Modern-Ice` - cursor

MxPlus IBM VGA 8x16 MidTilde font is included in `fonts/` directory.

## Check

Run:

```sh
./scripts/check-deps.sh
```

The checker is the source of truth for required commands. It also checks Gentoo's
`/usr/libexec` portal paths separately from common `/usr/lib` locations and
regular `$PATH` command lookup. Optional commands are reported for convenience,
but missing optional commands do not make the check fail.

## Global themes

See [themes.md](themes.md) for the theme helper requirements and configuration.
Video wallpaper packages are no longer used by this setup.

## Optional application presets

The signed browser bundle needs the included native host and one-time addon
installation. Vesktop requires Desktop Theme enabled once. The separate
`install-app-themes.sh` needs curl, sha256sum, unzip and tar; GTK live updates
use gsettings when available. See [app-themes.md](app-themes.md).

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
- [`dunst`](https://github.com/dunst-project/dunst)

## Script Dependencies

- `bash`
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

- `git`
- `make`
- `gcc` or another C compiler for Treesitter parsers
- `python`
- `btop`
- `fastfetch`
- [`ripgrep`](https://github.com/BurntSushi/ripgrep)
- [`fd`](https://github.com/sharkdp/fd)
- [`eza`](https://github.com/eza-community/eza)
- [`bat`](https://github.com/sharkdp/bat)
- [`dust`](https://github.com/bootandy/dust)
- `doas`
- [`tty-clock`](https://github.com/xorg62/tty-clock)
- [`neo`](https://github.com/st3w/neo)

## UI And Themes

- [`DejaVu Sans`](https://dejavu-fonts.github.io/)
- [`DejaVu Sans Mono`](https://dejavu-fonts.github.io/)
- [`Symbols Nerd Font Mono`](https://www.nerdfonts.com/)
- [`Graphite-Dark`](https://github.com/vinceliuice/Graphite-gtk-theme)
- [`Goldy-Dark-Icons`](https://github.com/L4ki/Goldy-Plasma-Themes/tree/main/Goldy%20Icons%20Themes/Goldy-Dark-Icons)

## Check

Run:

```sh
./scripts/check-deps.sh
```

The checker is the source of truth for required commands. It also checks Gentoo's
`/usr/libexec` portal paths separately from common `/usr/lib` locations and
regular `$PATH` command lookup. Optional commands are reported for convenience,
but missing optional commands do not make the check fail.

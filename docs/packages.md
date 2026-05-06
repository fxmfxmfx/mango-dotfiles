# Packages

These dotfiles are tuned for Gentoo GNU/Linux and MangoWM. Package names vary by
repository and overlay, so treat this as the software surface the setup expects.

## Mango Session

- `mango`
- `mmsg`
- `dbus`
- `pipewire`
- `pipewire-pulse`
- `wireplumber`
- `xdg-desktop-portal`
- `xdg-desktop-portal-wlr`
- `xdg-desktop-portal-gtk`
- `foot`
- `fuzzel`
- `awww`
- `yambar`
- `dunst`
- `xsettingsd`

## Script Dependencies

- `bash`
- GNU `coreutils`
- `findutils`
- `gawk` or compatible `awk`
- `grep`
- `sed`
- `procps`/`psmisc` tools such as `pgrep` and `killall`
- `wl-clipboard`
- `cliphist`
- `wayfreeze`
- `grim`
- `slurp`
- `swappy`
- `curl`
- `jq`
- `socat`

## Daily Apps

- `mpv`
- `imv`
- `thunar`
- `librewolf`
- `pavucontrol`

## Shell And Editor

- `fish`
- `fisher`
- `neovim`
- `git`
- `make`
- `gcc` or another C compiler for Treesitter parsers
- `btop`
- `fastfetch`
- `ripgrep`
- `fd`
- `eza`
- `bat`
- `dust`
- `doas`
- `tty-clock`

## UI And Themes

- `DejaVu Sans`
- `DejaVu Sans Mono`
- `Symbols Nerd Font Mono`
- `Colloid-Dark`
- `Goldy-Dark-Icons`

## Check

Run:

```sh
./scripts/check-deps.sh
```

The checker validates commands used by the session and scripts. It also checks
Gentoo's `/usr/libexec` portal paths.

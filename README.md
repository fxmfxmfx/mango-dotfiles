# Mango Dotfiles

Personal [MangoWM](https://github.com/mangowm/mango) dotfiles for Gentoo GNU/Linux.

![MangoWM desktop](screenshots/image1.png)

## Quick Install

```sh
git clone https://github.com/fxmfxmfx/mango-dotfiles.git
cd mango-dotfiles
./scripts/check-deps.sh
./scripts/install.sh --dry-run
./scripts/install.sh
```

This repo mirrors `$HOME` for dot directories such as `.config` and `.local`.
The installer backs up overwritten files by default and asks whether to install
the Colloid GTK theme and Goldy icon theme.

Run Mango from a TTY with:

```sh
~/.local/bin/start-mango.sh
```

The setup is intentionally not distro-neutral. It assumes MangoWM, GNU userland,
Wayland tooling, `fish` as the interactive shell, and xdg-desktop-portal binaries
in `/usr/libexec`.

## Contents

- `.config/mango` - MangoWM session, monitor rules, key binds and autostart
- `.config/yambar` - top bar with Mango workspace and keyboard-layout scripts
- `.config/foot`, `.config/fuzzel`, `.config/dunst` - terminal, launcher and notifications
- `.config/nvim` - Neovim config using lazy.nvim and pinned plugin lockfile
- `.config/fish` - shell aliases and colors
- `.local/bin` - helper scripts for screenshots, clipboard, layout, wallpaper and emoji picker
- `Wallpaper` - wallpapers used by the wallpaper picker
- `docs` - package list and customization notes for forks
- `screenshots` - some screenshots

## Compatibility Notes

- Monitor config is machine-specific: `DP-1` at `1920x1080@170` and `HDMI-A-1`
  at `1920x1080@60`. Edit `.config/mango/conf.d/00-monitors.conf` before using
  this on another machine.
- Yambar is pinned to `DP-1` in `.config/yambar/config.yml`. The workspace script
  can read `YAMBAR_MANGO_OUTPUT`, but the bar config and click actions still need
  edits if your output has another name.
- `layout.sh` defaults to `DP-1`; override with `MANGO_OUTPUT=...` if needed.
- Wallpaper picker reads images from `~/Wallpaper` by default. Override with
  `WALLPAPER_DIR=/path/to/wallpapers`.
- Portal autostart uses Gentoo's `/usr/libexec/xdg-desktop-portal-wlr` path.
  Other distros may place portal backends elsewhere.
- Neovim bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim) from GitHub
  on first launch and Treesitter parsers may need a C toolchain.
- Fish aliases and functions assume the shell-experience tools listed below
  (`eza`, `bat`, `rg`, `fd`, `dust`, `btop`, `fastfetch`, `doas`, `tty-clock`,
  etc.). Install them first or edit `.config/fish/config.fish` and
  `.config/fish/functions` before using this setup.
- See `docs/customize.md` for the files that usually need local edits.

## Dependencies

Run the checker first:

```sh
./scripts/check-deps.sh
```

It is the source of truth for this setup. If it reports everything you need as
`ok`, you usually do not need to audit this list by hand. The list below is here
mainly so missing tools have links and are easier to install.

### Mango Session

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
- [`fuzzel`](https://codeberg.org/dnkl/fuzzel)
- [`awww`](https://github.com/NotAShelf/awww)
- [`yambar`](https://github.com/neonkore/yambar)
- [`dunst`](https://github.com/dunst-project/dunst)
- `xsettingsd`

### Script Dependencies

These are mostly command-line tools used by helper scripts. Prefer
`./scripts/check-deps.sh` over manually reading this section.

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

### Optional Apps And Tools

- `mpv`
- `imv`
- `thunar`
- `librewolf`
- `pavucontrol`

### Shell And Editor

- [`fish`](https://github.com/fish-shell/fish-shell)
- [`fisher`](https://github.com/jorgebucaran/fisher)
- `neovim`
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

### UI And Themes

- [`DejaVu Sans`](https://dejavu-fonts.github.io/)
- [`DejaVu Sans Mono`](https://dejavu-fonts.github.io/)
- [`Symbols Nerd Font Mono`](https://www.nerdfonts.com/)
- [`Colloid-Dark`](https://github.com/vinceliuice/Colloid-gtk-theme)
- [`Goldy-Dark-Icons`](https://github.com/L4ki/Goldy-Plasma-Themes/tree/main/Goldy%20Icons%20Themes/Goldy-Dark-Icons)

For a more readable package list, see `docs/packages.md`.

## Key Binds

- `Super+Return` - terminal
- `Super+Esc` - launcher
- `Super+W` - browser
- `Super+E` - file manager
- `Super+V` - clipboard history
- `Super+X` - wallpaper picker
- `Super+/` - emoji picker
- `Print` - monitor screenshot to clipboard
- `Ctrl+Print` - full screenshot to clipboard
- `Super+Shift+S` - area screenshot to clipboard
- `Super+Shift+D` - area screenshot through Swappy

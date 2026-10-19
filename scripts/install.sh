#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
target_home=${HOME:?HOME is not set}
backup_root=
dry_run=0
skip_backup=0
skip_fonts=0
keyboard_layouts=

usage() {
    cat <<'EOF'
Usage: ./scripts/install.sh [options]

Options:
  --dry-run       Show what would be installed without changing files.
  --no-backup     Overwrite existing files without moving them to a backup.
  --skip-fonts    Skip font copying/downloads (for offline config updates).
  --keyboard-layouts LIST
                  Set layouts without prompting: us or us,ru, for example.
  --home PATH     Install into PATH instead of $HOME.
  -h, --help      Show this help.

Environment:
  DOTFILES_BACKUP_DIR  Backup directory for overwritten files.
  XKB_CONFIG_ROOT     Optional XKB data directory (contains rules/evdev.lst).
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dry-run)
            dry_run=1
            ;;
        --no-backup)
            skip_backup=1
            ;;
        --skip-fonts)
            skip_fonts=1
            ;;
        --keyboard-layouts)
            shift
            if [ "$#" -eq 0 ]; then
                printf '%s\n' "install.sh: --keyboard-layouts needs a comma-separated list" >&2
                exit 2
            fi
            keyboard_layouts=$1
            case "$keyboard_layouts" in
                ''|,*|*,|*,,*|*[!A-Za-z0-9_,]*)
                    printf '%s\n' "install.sh: invalid keyboard layout list: $keyboard_layouts" >&2
                    exit 2
                    ;;
            esac
            ;;
        --home)
            shift
            if [ "$#" -eq 0 ]; then
                printf '%s\n' "install.sh: --home needs a path" >&2
                exit 2
            fi
            target_home=$1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            printf 'install.sh: unknown option: %s\n' "$1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

backup_root=${DOTFILES_BACKUP_DIR:-"$target_home/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)-$$"}

# Refuse reused backup runs before any home files are changed.
if [ "$dry_run" -eq 0 ] && { [ -e "$backup_root" ] || [ -L "$backup_root" ]; }; then
    if [ ! -d "$backup_root" ] || [ -L "$backup_root" ] ||
        [ -n "$(find "$backup_root" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
        printf 'install.sh: refusing to reuse a nonempty backup directory: %s\n' "$backup_root" >&2
        exit 1
    fi
fi

load_keyboard_layouts() {
    xkb_rules=
    # Keep a custom root intact even when its path contains spaces.
    if [ -n "${XKB_CONFIG_ROOT:-}" ]; then
        for rules in "$XKB_CONFIG_ROOT/rules/evdev.lst" "$XKB_CONFIG_ROOT/rules/base.lst"; do
            if [ -r "$rules" ]; then xkb_rules=$rules; break; fi
        done
    else
        for root in /usr/share/X11/xkb /usr/share/xkeyboard-config-2; do
            for rules in "$root/rules/evdev.lst" "$root/rules/base.lst"; do
                if [ -r "$rules" ]; then xkb_rules=$rules; break 2; fi
            done
        done
    fi
    if [ -z "$xkb_rules" ]; then
        printf 'install.sh: cannot validate layouts; install xkeyboard-config or set XKB_CONFIG_ROOT to its data directory.\n' >&2
        exit 1
    fi
    available_layouts=$(awk '
        /^![[:space:]]+layout[[:space:]]*$/ { active=1; next }
        /^!/ { active=0 }
        active && NF { print $1 }
    ' "$xkb_rules")
    if [ -z "$available_layouts" ]; then
        printf 'install.sh: no keyboard layouts found in %s\n' "$xkb_rules" >&2
        exit 1
    fi
}

keyboard_layout_exists() {
    printf '%s\n' "$available_layouts" | grep -Fx -- "$1" >/dev/null
}

if [ -n "$keyboard_layouts" ] || { [ "$dry_run" -eq 0 ] && [ -t 0 ]; }; then
    load_keyboard_layouts
fi

if [ -z "$keyboard_layouts" ] && [ "$dry_run" -eq 0 ] && [ -t 0 ]; then
    while :; do
        printf 'Enable keyboard layout switching with Alt+Shift? [Y/n] '
        if ! IFS= read -r answer; then
            printf '\ninstall.sh: cancelled before installation\n' >&2
            exit 1
        fi
        case "$answer" in
            ''|y|Y|yes|YES)
                while :; do
                    printf 'Second keyboard layout [ru] (? to list): '
                    if ! IFS= read -r second_layout; then
                        printf '\ninstall.sh: cancelled before installation\n' >&2
                        exit 1
                    fi
                    second_layout=${second_layout:-ru}
                    if [ "$second_layout" = '?' ]; then
                        awk '/^![[:space:]]+layout[[:space:]]*$/ { active=1; next }
                             /^!/ { active=0 } active && NF { print }' "$xkb_rules"
                    elif [ "$second_layout" = us ]; then
                        printf 'US is already the first layout; choose a different second layout.\n'
                    elif keyboard_layout_exists "$second_layout"; then
                        keyboard_layouts=us,$second_layout
                        break
                    else
                        printf 'Unknown XKB layout: %s. Use a code such as ru, de or ua, or ? to list.\n' "$second_layout"
                    fi
                done
                break
                ;;
            n|N|no|NO) keyboard_layouts=us; break ;;
            *) printf 'Please answer y or n.\n' ;;
        esac
    done
fi

if [ -n "$keyboard_layouts" ]; then
    layout_codes=$(printf '%s' "$keyboard_layouts" | tr ',' ' ')
    for layout_code in $layout_codes; do
        if ! keyboard_layout_exists "$layout_code"; then
            printf 'install.sh: unknown XKB keyboard layout: %s\n' "$layout_code" >&2
            exit 2
        fi
    done
    case "$keyboard_layouts" in
        *,*) keyboard_options=grp:lalt_lshift_toggle ;;
        *) keyboard_options= ;;
    esac
fi

check_backup_path() {
    if [ -e "$1" ] || [ -L "$1" ]; then
        printf 'install.sh: refusing to overwrite an existing backup: %s\n' "$1" >&2
        exit 1
    fi
}

copy_file() {
    rel_path=$1
    src=$repo_dir/$rel_path
    dst=$target_home/$rel_path

    case "$rel_path" in
        .cache/*|.local/share/*|.local/state/*|.config/vesktop/settings/*|.config/vesktop/sessionData/*)
            return
            ;;
        *.log|*.bak|*.swp|*.swo|*.pyc|*.pyo|*/__pycache__/*|.config/desktop-themes/librewolf-bridge-status.json|.config/desktop-themes/.browser-status-*|.config/desktop-themes/browser-bridge-unsigned.xpi|.config/desktop-themes/desktop-theme-browser.xpi)
            return
            ;;
        .config/desktop-themes/active.json|.config/desktop-themes/current|.config/desktop-themes/.lock|.config/desktop-themes/backup*/*)
            return
            ;;
    esac

    if [ "$dry_run" -eq 1 ]; then
        if [ -e "$dst" ] || [ -L "$dst" ]; then
            printf 'would backup  %s\n' "$dst"
        fi
        printf 'would install %s\n' "$dst"
        return
    fi

    mkdir -p -- "$(dirname -- "$dst")"

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ "$skip_backup" -eq 0 ]; then
            backup_path=$backup_root/$rel_path
            check_backup_path "$backup_path"
            mkdir -p -- "$(dirname -- "$backup_path")"
            mv -- "$dst" "$backup_path"
            printf 'backup  %s -> %s\n' "$dst" "$backup_path"
        fi
    fi

    if [ -L "$src" ] && [ ! -e "$src" ]; then
        printf 'warning: %s is a dangling symlink, copied as-is\n' "$rel_path" >&2
    fi

    cp -Pp -- "$src" "$dst"
    if [ "$rel_path" = .config/mango/conf.d/10-input.conf ] && [ -n "$keyboard_layouts" ]; then
        sed -i \
            -e "s/^xkb_rules_layout=.*/xkb_rules_layout=$keyboard_layouts/" \
            -e "s/^xkb_rules_options=.*/xkb_rules_options=$keyboard_options/" "$dst"
    fi
    printf 'install %s\n' "$dst"
}

retire_file() {
    rel_path=$1
    dst=$target_home/$rel_path
    [ -e "$dst" ] || [ -L "$dst" ] || return 0
    if [ "$dry_run" -eq 1 ]; then
        printf 'would retire  %s\n' "$dst"
        return
    fi
    # Keep retired helpers recoverable, including with --no-backup.
    backup_path=$backup_root/retired/$rel_path
    check_backup_path "$backup_path"
    mkdir -p -- "$(dirname -- "$backup_path")"
    mv -- "$dst" "$backup_path"
    printf 'retire  %s -> %s\n' "$dst" "$backup_path"
}

install_fonts() {
    font_dst=$target_home/.local/share/fonts

    if [ -d "$repo_dir/fonts" ]; then
        if [ "$dry_run" -eq 1 ]; then
            printf 'would install MxPlus IBM VGA font to %s\n' "$font_dst"
        else
            mkdir -p -- "$font_dst"
            printf 'install MxPlus IBM VGA font\n'
            cp -R -- "$repo_dir/fonts/." "$font_dst/"
            if command -v fc-cache >/dev/null 2>&1; then
                fc-cache -f "$font_dst" >/dev/null 2>&1 || true
            fi
        fi
    fi

    if [ "$dry_run" -eq 1 ]; then
        printf 'would install Symbols Nerd Font Mono and JetBrainsMono Nerd Font\n'
        return
    fi

    nerd_font_dir=$(mktemp -d)
    printf 'download Symbols Nerd Font (NerdFontsSymbolsOnly.zip)\n'
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip" \
        -o "$nerd_font_dir/NerdFontsSymbolsOnly.zip"
    if command -v unzip >/dev/null 2>&1; then
        unzip -o -q "$nerd_font_dir/NerdFontsSymbolsOnly.zip" -d "$nerd_font_dir"
    elif command -v python3 >/dev/null 2>&1; then
        python3 -m zipfile -e "$nerd_font_dir/NerdFontsSymbolsOnly.zip" "$nerd_font_dir"
    else
        python -m zipfile -e "$nerd_font_dir/NerdFontsSymbolsOnly.zip" "$nerd_font_dir"
    fi

    printf 'download JetBrainsMono Nerd Font\n'
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" \
        -o "$nerd_font_dir/JetBrainsMono.tar.xz"
    tar -xf "$nerd_font_dir/JetBrainsMono.tar.xz" -C "$nerd_font_dir"

    symbols_ttf=$(find "$nerd_font_dir" -maxdepth 1 -name 'SymbolsNerdFont*.ttf' | wc -l)
    jetbrains_ttf=$(find "$nerd_font_dir" -maxdepth 1 -name 'JetBrainsMono*.ttf' | wc -l)
    if [ "$symbols_ttf" -eq 0 ] || [ "$jetbrains_ttf" -eq 0 ]; then
        printf 'error: unexpected Nerd Fonts archive layout, no fonts installed\n' >&2
        rm -rf -- "$nerd_font_dir"
        return 1
    fi

    mkdir -p -- "$font_dst/JetBrainsMonoNerd"
    find "$nerd_font_dir" -maxdepth 1 -name 'SymbolsNerdFont*.ttf' -exec cp -p -t "$font_dst/" {} +
    find "$nerd_font_dir" -maxdepth 1 -name 'JetBrainsMono*.ttf' -exec cp -p -t "$font_dst/JetBrainsMonoNerd/" {} +

    rm -rf -- "$nerd_font_dir"
    if command -v fc-cache >/dev/null 2>&1; then
        printf 'refresh font cache\n'
        fc-cache -f "$font_dst" >/dev/null 2>&1 || true
    fi
    printf 'install %s Nerd Font files to %s\n' "$((symbols_ttf + jetbrains_ttf))" "$font_dst"
}

for root in "$repo_dir"/.[!.]* "$repo_dir"/..?* "$repo_dir"/Wallpaper; do
    [ -e "$root" ] || continue

    case "$(basename -- "$root")" in
        .git|.gitignore|.codex|.cache)
            continue
            ;;
    esac

    find "$root" \( -type f -o -type l \) | while IFS= read -r path; do
        rel_path=${path#"$repo_dir"/}
        copy_file "$rel_path"
    done
done

for retired in \
    .config/rs-yambar/scripts/reminder-poller.sh \
    .config/rs-yambar/scripts/reminder.py \
    .config/rs-yambar/reminders.txt \
    .config/rs-yambar/reminders.txt.lock \
    .local/bin/live-wallpaper \
    .local/bin/mpvpaper-stop \
    .local/bin/wallpaper-url-add \
    .config/dunst/scripts/walltheme.sh \
    .config/rofi/scripts/walltheme.sh \
    .config/rs-yambar/scripts/walltheme.sh; do
    retire_file "$retired"
done

if [ "$skip_fonts" -eq 0 ]; then
    install_fonts
fi

if [ "$dry_run" -eq 0 ] && [ "$skip_backup" -eq 0 ]; then
    printf 'backup directory: %s\n' "$backup_root"
fi

if [ "$dry_run" -eq 1 ]; then
    printf 'Keyboard layouts (planned): %s\n' "${keyboard_layouts:-repository defaults}"
else
    printf 'Keyboard layouts: %s\n' "${keyboard_layouts:-repository defaults (no interactive terminal)}"
fi
printf 'Customize xkb_rules_layout and xkb_rules_options in %s/.config/mango/conf.d/10-input.conf for your languages and shortcut.\n' "$target_home"

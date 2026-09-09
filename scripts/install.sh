#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
target_home=${HOME:?HOME is not set}
backup_root=
dry_run=0
skip_backup=0

usage() {
    cat <<'EOF'
Usage: ./scripts/install.sh [options]

Options:
  --dry-run       Show what would be installed without changing files.
  --no-backup     Overwrite existing files without moving them to a backup.
  --home PATH     Install into PATH instead of $HOME.
  -h, --help      Show this help.

Environment:
  DOTFILES_BACKUP_DIR  Backup directory for overwritten files.
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

backup_root=${DOTFILES_BACKUP_DIR:-"$target_home/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"}

copy_file() {
    rel_path=$1
    src=$repo_dir/$rel_path
    dst=$target_home/$rel_path

    case "$rel_path" in
        .cache/*|.local/share/*|.local/state/*)
            return
            ;;
        *.log|*.bak|*.swp|*.swo)
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
            mkdir -p -- "$(dirname -- "$backup_path")"
            mv -- "$dst" "$backup_path"
            printf 'backup  %s -> %s\n' "$dst" "$backup_path"
        fi
    fi

    if [ -L "$src" ] && [ ! -e "$src" ]; then
        printf 'warning: %s is a dangling symlink, copied as-is\n' "$rel_path" >&2
    fi

    cp -Pp -- "$src" "$dst"
    printf 'install %s\n' "$dst"
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

install_fonts

if [ "$dry_run" -eq 0 ] && [ "$skip_backup" -eq 0 ]; then
    printf 'backup directory: %s\n' "$backup_root"
fi

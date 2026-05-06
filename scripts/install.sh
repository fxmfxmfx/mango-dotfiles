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
        .cache/*|.local/share/*|.local/state/*|.config/fish/fish_variables)
            return
            ;;
        .config/nvim/lazy/*|.config/nvim/swap/*|.config/nvim/undo/*|.config/nvim/view/*)
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

    cp -Pp -- "$src" "$dst"
    printf 'install %s\n' "$dst"
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

if [ "$dry_run" -eq 0 ] && [ "$skip_backup" -eq 0 ]; then
    printf 'backup directory: %s\n' "$backup_root"
fi

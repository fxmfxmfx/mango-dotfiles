#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
target_home=${HOME:?HOME is not set}
backup_root=
dry_run=0
skip_backup=0
install_theme=1
install_icons=1
assume_yes=0
theme_source=${GTK_THEME_DIR:-"$HOME/Colloid-gtk-theme"}
theme_installer=${GTK_THEME_INSTALLER:-}
theme_repo=https://github.com/vinceliuice/Colloid-gtk-theme.git
icons_source=${GOLDY_ICONS_DIR:-"$HOME/Goldy-Plasma-Themes"}
icons_repo=https://github.com/L4ki/Goldy-Plasma-Themes.git

usage() {
    cat <<'EOF'
Usage: ./scripts/install.sh [options]

Options:
  --dry-run       Show what would be installed without changing files.
  --no-backup     Overwrite existing files without moving them to a backup.
  --no-theme      Skip Colloid GTK theme prompt.
  --no-icons      Skip Goldy icon theme prompt.
  -y, --yes       Install optional theme and icons without prompting.
  --home PATH     Install into PATH instead of $HOME.
  -h, --help      Show this help.

Environment:
  DOTFILES_BACKUP_DIR  Backup directory for overwritten files.
  GTK_THEME_DIR         Path to a local Colloid-gtk-theme checkout.
  GTK_THEME_INSTALLER   Path to a local Colloid install.sh.
  GOLDY_ICONS_DIR       Path to a local Goldy-Plasma-Themes checkout.
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
        --no-theme)
            install_theme=0
            ;;
        --no-icons)
            install_icons=0
            ;;
        -y|--yes)
            assume_yes=1
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

ask_yes_no() {
    prompt=$1

    if [ "$assume_yes" -eq 1 ]; then
        return 0
    fi

    if [ ! -t 0 ]; then
        return 1
    fi

    printf '%s [y/N] ' "$prompt"
    read -r answer

    case "$answer" in
        y|Y|yes|YES)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

backup_path_if_needed() {
    dst=$1
    rel_path=${dst#"$target_home"/}

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ "$skip_backup" -eq 0 ]; then
            backup_path=$backup_root/$rel_path
            mkdir -p -- "$(dirname -- "$backup_path")"
            mv -- "$dst" "$backup_path"
            printf 'backup  %s -> %s\n' "$dst" "$backup_path"
        fi
    fi
}

install_gtk_theme() {
    if [ "$install_theme" -ne 1 ]; then
        return 0
    fi

    if [ "$dry_run" -eq 1 ]; then
        printf 'would ask to install Colloid GTK theme with --tweaks black rimless\n'
        return
    fi

    if ! ask_yes_no "Install Colloid GTK theme?"; then
        printf 'skip Colloid GTK theme\n'
        return
    fi

    if [ -n "$theme_installer" ]; then
        if [ ! -x "$theme_installer" ]; then
            printf 'missing Colloid installer: %s\n' "$theme_installer" >&2
            return 1
        fi
        HOME=$target_home "$theme_installer" --tweaks black rimless
        return
    fi

    if [ -x "$theme_source/install.sh" ]; then
        HOME=$target_home "$theme_source/install.sh" --tweaks black rimless
        return
    fi

    temp_dir=$(mktemp -d)
    git clone --depth 1 "$theme_repo" "$temp_dir/Colloid-gtk-theme"
    HOME=$target_home "$temp_dir/Colloid-gtk-theme/install.sh" --tweaks black rimless
}

install_icon_theme() {
    if [ "$install_icons" -ne 1 ]; then
        return 0
    fi

    if [ "$dry_run" -eq 1 ]; then
        printf 'would ask to install Goldy-Dark-Icons\n'
        return
    fi

    if ! ask_yes_no "Install Goldy-Dark-Icons?"; then
        printf 'skip Goldy-Dark-Icons\n'
        return
    fi

    icon_rel='Goldy Icons Themes/Goldy-Dark-Icons'
    icon_src=$icons_source/$icon_rel

    if [ ! -d "$icon_src" ]; then
        temp_dir=$(mktemp -d)
        git clone --depth 1 "$icons_repo" "$temp_dir/Goldy-Plasma-Themes"
        icon_src=$temp_dir/Goldy-Plasma-Themes/$icon_rel
    fi

    icon_dst=$target_home/.local/share/icons/Goldy-Dark-Icons
    mkdir -p -- "$(dirname -- "$icon_dst")"
    backup_path_if_needed "$icon_dst"
    mkdir -p -- "$icon_dst"
    cp -R -- "$icon_src"/. "$icon_dst"/
    printf 'install %s\n' "$icon_dst"
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

install_gtk_theme
install_icon_theme

if [ "$dry_run" -eq 0 ] && [ "$skip_backup" -eq 0 ]; then
    printf 'backup directory: %s\n' "$backup_root"
fi

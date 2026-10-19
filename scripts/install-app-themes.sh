#!/usr/bin/env bash
set -euo pipefail

# Install official Catppuccin Mocha/Mauve GTK and Kvantum themes for this user.
# Sources are pinned and SHA-256 checked before extraction.

GTK_URL='https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-mauve-standard%2Bdefault.zip'
GTK_SHA256='cbacdac6161f98c315fb86740e21426ef6dda64f0ad69157cf28f3a1dda446fe'
GTK_LICENSE_URL='https://raw.githubusercontent.com/catppuccin/gtk/v1.0.3/LICENSE'
GTK_LICENSE_SHA256='3972dc9744f6499f0f9b2dbf76696f2ae7ad8af9b23dde66d6af86c9dfb36986'

KVANTUM_COMMIT='71105d224fef95dd023691303477ce3eea487457'
KVANTUM_URL="https://codeload.github.com/catppuccin/kvantum/tar.gz/${KVANTUM_COMMIT}"
KVANTUM_SHA256='f2bd573f8d7500c65fd69e1629b3bcf3eba3468124b81f1d12d54b2f5dda1a0c'
KVANTUM_LICENSE_SHA256='814096d2c34cc216c624738a49356f32b7237733b4f7edb0685f4e50ef5074ba'
KVANTUM_ROOT="kvantum-${KVANTUM_COMMIT}"

for command in curl sha256sum unzip tar; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Missing required command: %s\n' "$command" >&2
        exit 1
    fi
done

if [[ -z "${HOME:-}" ]]; then
    printf 'HOME must be set.\n' >&2
    exit 1
fi

data_home=${XDG_DATA_HOME:-"$HOME/.local/share"}
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
gtk_name='catppuccin-mocha-mauve-standard+default'
kvantum_name='catppuccin-mocha-mauve'
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/catppuccin-app-themes.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT

verify_sha256() {
    local file=$1 expected=$2 actual
    actual=$(sha256sum "$file")
    actual=${actual%% *}
    if [[ "$actual" != "$expected" ]]; then
        printf 'SHA-256 mismatch for %s\nExpected: %s\nActual:   %s\n' "$file" "$expected" "$actual" >&2
        exit 1
    fi
}

download() {
    curl --fail --location --silent --show-error --retry 2 "$1" --output "$2"
}

download "$GTK_URL" "$tmp_dir/gtk.zip"
verify_sha256 "$tmp_dir/gtk.zip" "$GTK_SHA256"
download "$GTK_LICENSE_URL" "$tmp_dir/gtk-LICENSE"
verify_sha256 "$tmp_dir/gtk-LICENSE" "$GTK_LICENSE_SHA256"

mkdir -p "$tmp_dir/gtk-stage" "$tmp_dir/kvantum-stage"
unzip -q "$tmp_dir/gtk.zip" "$gtk_name/*" -d "$tmp_dir/gtk-stage"
gtk_source="$tmp_dir/gtk-stage/$gtk_name"
if [[ ! -f "$gtk_source/index.theme" || ! -d "$gtk_source/gtk-3.0" || ! -d "$gtk_source/gtk-4.0" ]]; then
    printf 'GTK archive did not contain the expected GTK 3 and GTK 4 theme files.\n' >&2
    exit 1
fi
cp "$tmp_dir/gtk-LICENSE" "$gtk_source/LICENSE"

download "$KVANTUM_URL" "$tmp_dir/kvantum.tar.gz"
verify_sha256 "$tmp_dir/kvantum.tar.gz" "$KVANTUM_SHA256"
tar -xzf "$tmp_dir/kvantum.tar.gz" --strip-components=2 -C "$tmp_dir/kvantum-stage" \
    "$KVANTUM_ROOT/themes/$kvantum_name"
tar -xOzf "$tmp_dir/kvantum.tar.gz" "$KVANTUM_ROOT/LICENSE" > "$tmp_dir/kvantum-LICENSE"
verify_sha256 "$tmp_dir/kvantum-LICENSE" "$KVANTUM_LICENSE_SHA256"
kvantum_source="$tmp_dir/kvantum-stage/$kvantum_name"
if [[ ! -f "$kvantum_source/$kvantum_name.kvconfig" || ! -f "$kvantum_source/$kvantum_name.svg" ]]; then
    printf 'Kvantum archive did not contain the expected Mocha/Mauve preset files.\n' >&2
    exit 1
fi
cp "$tmp_dir/kvantum-LICENSE" "$kvantum_source/LICENSE"

gtk_target="$data_home/themes/$gtk_name"
kvantum_target="$config_home/Kvantum/$kvantum_name"
mkdir -p "$gtk_target" "$kvantum_target"
cp -a "$gtk_source/." "$gtk_target/"
cp -a "$kvantum_source/." "$kvantum_target/"

printf 'Installed GTK theme: %s\n' "$gtk_target"
printf 'Installed Kvantum theme: %s\n' "$kvantum_target"

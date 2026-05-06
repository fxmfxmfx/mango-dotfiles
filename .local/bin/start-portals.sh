#!/usr/bin/env sh
set -eu

find_portal() {
    name=$1
    shift

    if command -v "$name" >/dev/null 2>&1; then
        command -v "$name"
        return 0
    fi

    for path in "$@"; do
        if [ -x "$path" ]; then
            printf '%s\n' "$path"
            return 0
        fi
    done

    return 1
}

start_portal() {
    name=$1
    shift

    binary=$(find_portal "$name" "$@") || {
        printf 'missing %s\n' "$name" >&2
        return 1
    }

    "$binary" &
}

start_portal \
    xdg-desktop-portal \
    /usr/libexec/xdg-desktop-portal \
    /usr/lib/xdg-desktop-portal

start_portal \
    xdg-desktop-portal-gtk \
    /usr/libexec/xdg-desktop-portal-gtk \
    /usr/lib/xdg-desktop-portal-gtk

start_portal \
    xdg-desktop-portal-wlr \
    /usr/libexec/xdg-desktop-portal-wlr \
    /usr/lib/xdg-desktop-portal-wlr

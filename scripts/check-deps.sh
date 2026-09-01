#!/usr/bin/env sh
set -eu

required_commands="
bash
zsh
mango
mmsg
dbus-run-session
pipewire
pipewire-pulse
wireplumber
foot
footclient
rofi
awww
awww-daemon
rs-yambar
dunst
wl-copy
wl-paste
cliphist
wayfreeze
grim
slurp
swappy
git
rg
fd
bat
eza
dust
btop
fastfetch
awk
grep
sed
head
find
sort
timeout
pgrep
killall
mktemp
xdg-open
"

optional_commands="
mpv
imv
thunar
librewolf
pavucontrol
doas
tty-clock
neo
make
gcc
magick
ffmpeg
mpvpaper
yt-dlp
xsettingsd
unzip
fc-cache
"

missing=0

check_command() {
    name="$1"
    label="$2"
    required="${3:-1}"

    if command -v "$name" >/dev/null 2>&1; then
        printf 'ok      %s %s\n' "$label" "$name"
    else
        printf 'missing %s %s\n' "$label" "$name"
        if [ "$required" -eq 1 ]; then
            missing=1
        fi
    fi
}

check_portal() {
    command_name=$1
    gentoo_path=$2
    common_path=$3

    found=0

    if command -v "$command_name" >/dev/null 2>&1; then
        printf 'ok      portal  %s in PATH\n' "$command_name"
        found=1
    else
        printf 'notfound portal %s in PATH\n' "$command_name"
    fi

    if [ -x "$gentoo_path" ]; then
        printf 'ok      gentoo  %s\n' "$gentoo_path"
        found=1
    else
        printf 'notfound gentoo %s\n' "$gentoo_path"
    fi

    if [ -x "$common_path" ]; then
        printf 'ok      common  %s\n' "$common_path"
        found=1
    else
        printf 'notfound common %s\n' "$common_path"
    fi

    if [ "$found" -eq 0 ]; then
        printf 'missing required portal backend %s\n' "$command_name"
        missing=1
    fi
}

for command_name in $required_commands; do
    check_command "$command_name" "required" 1
done

for command_name in $optional_commands; do
    check_command "$command_name" "optional" 0
done

if command -v python3 >/dev/null 2>&1; then
    printf 'ok      required python3\n'
elif command -v python >/dev/null 2>&1; then
    printf 'ok      required python (python3 not found, python is fine)\n'
else
    printf 'missing required python3\n'
    missing=1
fi

check_command curl "optional" 0

check_portal xdg-desktop-portal /usr/libexec/xdg-desktop-portal /usr/lib/xdg-desktop-portal
check_portal xdg-desktop-portal-gtk /usr/libexec/xdg-desktop-portal-gtk /usr/lib/xdg-desktop-portal-gtk
check_portal xdg-desktop-portal-wlr /usr/libexec/xdg-desktop-portal-wlr /usr/lib/xdg-desktop-portal-wlr

exit "$missing"

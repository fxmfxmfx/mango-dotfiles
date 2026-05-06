#!/usr/bin/env sh
set -eu

required_commands="
mango
mmsg
dbus-run-session
pipewire
pipewire-pulse
wireplumber
foot
footclient
fuzzel
awww
awww-daemon
yambar
dunst
wl-copy
wl-paste
cliphist
wayfreeze
grim
slurp
swappy
pavucontrol
fish
nvim
git
rg
fd
bat
eza
dust
btop
fastfetch
xsettingsd
awk
grep
sed
find
sort
timeout
killall
mktemp
xdg-open
"

optional_commands="
mpv
imv
thunar
librewolf
doas
tty-clock
curl
jq
socat
make
gcc
"

required_files="
/usr/libexec/xdg-desktop-portal
/usr/libexec/xdg-desktop-portal-wlr
/usr/libexec/xdg-desktop-portal-gtk
"

missing=0

check_command() {
    name="$1"
    label="$2"

    if command -v "$name" >/dev/null 2>&1; then
        printf 'ok      %s %s\n' "$label" "$name"
    else
        printf 'missing %s %s\n' "$label" "$name"
        missing=1
    fi
}

for command_name in $required_commands; do
    check_command "$command_name" "required"
done

for command_name in $optional_commands; do
    check_command "$command_name" "optional"
done

for file_path in $required_files; do
    if [ -x "$file_path" ]; then
        printf 'ok      required %s\n' "$file_path"
    else
        printf 'missing required %s\n' "$file_path"
        missing=1
    fi
done

exit "$missing"

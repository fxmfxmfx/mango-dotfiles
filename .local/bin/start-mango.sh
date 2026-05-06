#!/bin/sh

if [ -n "${WAYLAND_DISPLAY:-}" ] || [ -n "${DISPLAY:-}" ]; then
    printf '%s\n' "Refusing to start a nested mango session from an existing desktop session." >&2
    exit 1
fi

exec dbus-run-session -- sh -c '
    export XDG_CURRENT_DESKTOP=mango
    export XDG_SESSION_TYPE=wayland
    exec mango
'

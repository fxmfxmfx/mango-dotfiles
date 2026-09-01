#!/bin/sh

export XCURSOR_THEME=DMZ-Black
export XCURSOR_SIZE=16

export QT_QPA_PLATFORMTHEME=qt6ct
export QT_STYLE_OVERRIDE=kvantum

if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] || [ "${DBUS_SESSION_BUS_ADDRESS:-}" = "disabled:" ]; then
    exec dbus-run-session -- sh -c '
        export XCURSOR_THEME=DMZ-Black
        export XCURSOR_SIZE=16
        export QT_QPA_PLATFORMTHEME=qt6ct
        export QT_STYLE_OVERRIDE=kvantum
        exec mango
    '
fi

exec mango

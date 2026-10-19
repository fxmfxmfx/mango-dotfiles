#!/bin/sh

export PATH="$HOME/.local/bin:$PATH"

export XCURSOR_THEME=DMZ-Black
export XCURSOR_SIZE=16

export QT_QPA_PLATFORMTHEME=qt6ct
export QT_STYLE_OVERRIDE=kvantum

# GTK4 defaults to the Vulkan renderer, and the proprietary NVIDIA driver makes
# it spam VK_SUBOPTIMAL_KHR on Wayland. Force the GL renderer for the session.
export GSK_RENDERER="${GSK_RENDERER:-gl}"

if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] || [ "${DBUS_SESSION_BUS_ADDRESS:-}" = "disabled:" ]; then
    exec dbus-run-session -- sh -c '
        export XCURSOR_THEME=DMZ-Black
        export XCURSOR_SIZE=16
        export QT_QPA_PLATFORMTHEME=qt6ct
        export QT_STYLE_OVERRIDE=kvantum
        export GSK_RENDERER="${GSK_RENDERER:-gl}"
        exec mango
    '
fi

exec mango

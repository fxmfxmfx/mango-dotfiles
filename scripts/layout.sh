#!/bin/sh
OUT="DP-1"
CURRENT="$(
    mmsg get monitor "$OUT" 2>/dev/null |
        sed -n 's/.*"layout_symbol"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' |
        sed -n '1p'
)"

set_layout() {
    mmsg dispatch focusmon,"$OUT" >/dev/null 2>&1
    mmsg dispatch setlayout,"$1" >/dev/null 2>&1
}

case "$CURRENT" in
    T)
        set_layout grid
        ;;
    G)
        set_layout vertical_scroller
        ;;
    VS)
        set_layout scroller
        ;;
    S)
        set_layout tile
        ;;
    *)
        set_layout tile
        ;;
esac

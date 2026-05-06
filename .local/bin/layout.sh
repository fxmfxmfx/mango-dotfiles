#!/bin/sh
OUT="${MANGO_OUTPUT:-${YAMBAR_MANGO_OUTPUT:-DP-1}}"
CURRENT="$(mmsg -o "$OUT" -g -l | awk '{print $2}')"
case "$CURRENT" in
    T)
        mmsg -o "$OUT" -s -l G
        ;;
    G)
        mmsg -o "$OUT" -s -l VS
        ;;
    VS)
        mmsg -o "$OUT" -s -l S
        ;;
    S)
        mmsg -o "$OUT" -s -l T
        ;;
    *)
        mmsg -o "$OUT" -s -l T
        ;;
esac

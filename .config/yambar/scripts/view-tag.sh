#!/bin/sh

tag="$1"
output="${2:-${YAMBAR_MANGO_OUTPUT:-DP-1}}"

[ -n "$tag" ] || exit 1

mmsg dispatch "viewcrossmon,$tag,$output" >/dev/null 2>&1 && exit 0
mmsg dispatch "view,$tag" >/dev/null 2>&1 && exit 0
mmsg -o "$output" -s -t "$tag" >/dev/null 2>&1 && exit 0

exit 1

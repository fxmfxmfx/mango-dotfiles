#!/bin/sh

layout="$(mmsg -g -k 2>/dev/null | grep -Eo 'us|ru' | head -n1)"

case "$layout" in
  us) layout="EN" ;;
  ru) layout="RU" ;;
  *)  layout="??" ;;
esac

printf 'layout|string|%s\n\n' "$layout"

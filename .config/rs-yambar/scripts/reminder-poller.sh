#!/bin/sh
# Outputs the reminder count for the rs-yambar bell module (yambar protocol).
# Tag: count (int)

store="${RS_YAMBAR_REMINDERS:-$HOME/.config/rs-yambar/reminders.txt}"
count=0
[ -f "$store" ] && count="$(wc -l < "$store" | tr -d ' ')"

printf 'count|int|%s\n' "${count:-0}"
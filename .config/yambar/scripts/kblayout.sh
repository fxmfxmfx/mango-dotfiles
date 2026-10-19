#!/bin/sh

parse_new_layout() {
  if command -v jq >/dev/null 2>&1; then
    jq -r '
      if type == "string" then
        .
      else
        ([.. | objects | .kb_layout?, .keyboardlayout?, .layout?, .value?]
         | map(select(. != null))
         | first) // empty
      end
    ' 2>/dev/null
    return
  fi

  awk '
    {
      value = $0
      if (value ~ /^"/) {
        gsub(/^"|"$/, "", value)
        print value
        exit
      }

      if (value !~ /"(kb_layout|keyboardlayout|layout|value)":/) {
        next
      }

      sub(/^.*"(kb_layout|keyboardlayout|layout|value)":"/, "", value)
      sub(/".*$/, "", value)
      print value
      exit
    }
  ' 2>/dev/null
}

format_layout() {
  normalized="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"

  case "$normalized" in
    us|gb|uk|english*|*english\ \(us\)*|*english\ \(uk\)*)
      printf '%s\n' "EN"
      ;;
    ru|russian*)
      printf '%s\n' "RU"
      ;;
    "")
      printf '%s\n' "??"
      ;;
    *)
      printf '%s\n' "$(printf '%s' "$1" | tr '[:lower:]' '[:upper:]')"
      ;;
  esac
}

layout="$(
  mmsg get keyboardlayout 2>/dev/null | parse_new_layout
)"

if [ -z "$layout" ]; then
  layout="$(mmsg -g -k 2>/dev/null | rg -o 'us|gb|uk|ru|English \(US\)|English \(UK\)|Russian' -m1)"
fi

printf 'layout|string|%s\n\n' "$(format_layout "$layout")"

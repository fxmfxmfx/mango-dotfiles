#!/usr/bin/env bash
set -euo pipefail

# rofi emoji picker with a separate emoji list and recents.
# Data format: emoji<TAB>description / keywords

data_file="${EMOJI_DATA_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/emoji-picker/emojis.tsv}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/emoji-picker"
recent_file="$state_dir/recent.tsv"
recent_limit="${EMOJI_RECENT_LIMIT:-30}"

if ! command -v rofi >/dev/null 2>&1; then
    printf 'emoji-picker: rofi not found\n' >&2
    exit 1
fi

if ! command -v wl-copy >/dev/null 2>&1; then
    printf 'emoji-picker: wl-copy not found\n' >&2
    exit 1
fi

if [ ! -r "$data_file" ]; then
    printf 'emoji-picker: list not found: %s\n' "$data_file" >&2
    exit 1
fi

mkdir -p "$state_dir"
touch "$recent_file"

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

recent_candidates="$workdir/recent.tsv"
recent_emojis="$workdir/recent-emojis.txt"
main_candidates="$workdir/main.tsv"
candidates="$workdir/candidates.tsv"
new_recent="$workdir/recent-new.tsv"

# Recent file format: emoji<TAB>last_used_unix_time<TAB>use_count
# Show recently used emojis first, then the rest of the list without duplicates.
awk -F '\t' '
    FILENAME == ARGV[1] {
        if ($1 != "" && $1 !~ /^#/ && NF >= 2) desc[$1] = $2
        next
    }
    ($1 in desc) {
        count = ($3 == "" ? 0 : $3)
        print $2 "\t" count "\t" $1 "\t" desc[$1] "  ★ recent"
    }
' "$data_file" "$recent_file" \
    | sort -t $'\t' -k1,1nr -k2,2nr \
    | head -n "$recent_limit" \
    | cut -f3- > "$recent_candidates"

cut -f1 "$recent_candidates" > "$recent_emojis"

awk -F '\t' -v recent="$recent_emojis" '
    BEGIN {
        while ((getline emoji < recent) > 0) {
            if (emoji != "") seen[emoji] = 1
        }
        close(recent)
    }
    $1 != "" && $1 !~ /^#/ && NF >= 2 && !($1 in seen) { print $1 "\t" $2 }
' "$data_file" > "$main_candidates"

cat "$recent_candidates" "$main_candidates" > "$candidates"

chosen="$(rofi -dmenu -no-custom -p 'emoji ' < "$candidates")"
[ -n "$chosen" ] || exit 0

emoji="${chosen%%$'\t'*}"
[ -n "$emoji" ] || exit 0

printf '%s' "$emoji" | wl-copy

now="$(date +%s)"
awk -F '\t' -v OFS='\t' -v emoji="$emoji" -v now="$now" '
    BEGIN { done = 0 }
    $1 == emoji {
        $2 = now
        $3 = ($3 == "" ? 1 : $3 + 1)
        done = 1
    }
    $1 != "" { print }
    END {
        if (!done) print emoji, now, 1
    }
' "$recent_file" > "$new_recent"

mv "$new_recent" "$recent_file"

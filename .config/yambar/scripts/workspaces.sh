#!/bin/sh

tag_count=9
output="${YAMBAR_MANGO_OUTPUT:-DP-1}"

emit() {
  mmsg -o "$output" -g -t 2>/dev/null | awk -v tag_count="$tag_count" '
    function mask_has(mask, tag) {
      divisor = 2 ^ (tag - 1)
      return int(mask / divisor) % 2
    }

    {
      for (i = 1; i <= NF - 2; i++) {
        if ($i == "tag" && $(i + 1) ~ /^[0-9]+$/ && $(i + 2) ~ /^[0-9]+$/) {
          tag = $(i + 1)
          state = $(i + 2)
          clients = 0

          if ($(i + 3) ~ /^[0-9]+$/) {
            clients = $(i + 3)
          }

          if (state == 1) {
            state_active[tag] = 1
          }

          if (state != 0 || clients > 0) {
            show[tag] = 1
          }
        }
      }

      if ($0 !~ /tag/ && NF >= 4 && $(NF - 2) ~ /^[0-9]+$/ && $(NF - 1) ~ /^[0-9]+$/ && $NF ~ /^[0-9]+$/) {
        occupied_mask = $(NF - 2)
        active_mask = $(NF - 1)
        urgent_mask = $NF
      }
    }

    END {
      for (i = 1; i <= tag_count; i++) {
        if (occupied_mask != "" && mask_has(occupied_mask, i)) {
          show[i] = 1
        }
        if (active_mask != "") {
          if (mask_has(active_mask, i)) {
            active[i] = 1
            show[i] = 1
          }
        } else if (state_active[i]) {
          active[i] = 1
          show[i] = 1
        }
        if (urgent_mask != "" && mask_has(urgent_mask, i)) {
          show[i] = 1
        }

        printf "show%d|bool|%s\n", i, show[i] ? "true" : "false"
        printf "active%d|bool|%s\n", i, active[i] ? "true" : "false"
      }

      printf "\n"
    }
  '
}

emit

while true; do
  if command -v timeout >/dev/null 2>&1; then
    timeout 3600 mmsg -o "$output" -w -t 2>/dev/null | while IFS= read -r _; do
      emit
    done
  else
    sleep 1
  fi

  sleep 1
  emit
done

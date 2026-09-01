#!/bin/sh
set -eu

wall="${1:-}"
cfg="${DUNST_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/dunst/dunstrc}"

[ -n "$wall" ] || {
  printf '%s\n' "usage: walltheme.sh /path/to/wallpaper" >&2
  exit 1
}

[ -f "$wall" ] || {
  printf '%s\n' "wallpaper not found: $wall" >&2
  exit 1
}

[ -f "$cfg" ] || {
  printf '%s\n' "dunst config not found: $cfg" >&2
  exit 1
}

command -v magick >/dev/null 2>&1 || {
  printf '%s\n' "need ImageMagick installed for magick" >&2
  exit 1
}

base="$(
  magick "$wall" -resize 1x1\! -format '%[hex:p{0,0}]' info:- |
    tr '[:lower:]' '[:upper:]' |
    cut -c1-6
)"

python3 - "$cfg" "$base" <<'PY'
import colorsys
import re
import sys
from pathlib import Path

cfg = Path(sys.argv[1])
base = sys.argv[2].strip().lstrip("#")

if len(base) != 6:
    raise SystemExit(f"bad base color: {base}")

r = int(base[0:2], 16) / 255
g = int(base[2:4], 16) / 255
b = int(base[4:6], 16) / 255

h, l, s = colorsys.rgb_to_hls(r, g, b)

if s < 0.1:
    s = 0.0

accent_sat = max(s, 0.62) if s > 0 else 0.0
danger_sat = max(s, 0.60) if s > 0 else 0.0

def rgba_from_hls(hue_shift, light, sat):
    rr, gg, bb = colorsys.hls_to_rgb((h + hue_shift / 360) % 1, light, sat)
    return f"#{round(rr * 255):02x}{round(gg * 255):02x}{round(bb * 255):02x}ff"

bg = rgba_from_hls(0, 0.070, min(s * 0.45, 0.45))
bg_soft = rgba_from_hls(0, 0.100, min(s * 0.30, 0.28))
fg = rgba_from_hls(0, 0.880, min(s, 0.16))
muted = rgba_from_hls(0, 0.560, min(s, 0.18))
accent = rgba_from_hls(0, 0.740, accent_sat)
danger = rgba_from_hls(-16, 0.620, danger_sat)

section_keys = {
    "global": {
        "background": bg,
        "foreground": fg,
        "frame_color": accent,
        "separator_color": accent,
        "highlight": accent,
        "format": f"<span foreground='{accent[:7]}'>%s</span>\\n%b",
    },
    "urgency_low": {
        "background": bg_soft,
        "foreground": muted,
        "frame_color": muted,
        "highlight": muted,
    },
    "urgency_normal": {
        "background": bg,
        "foreground": fg,
        "frame_color": accent,
        "highlight": accent,
    },
    "urgency_critical": {
        "background": bg,
        "foreground": fg,
        "frame_color": danger,
        "highlight": danger,
    },
}

lines = cfg.read_text().splitlines()
section = None
out = []

for line in lines:
    match = re.match(r"^\[(.+)\]$", line.strip())
    if match:
        section = match.group(1)
        out.append(line)
        continue

    if section in section_keys:
        updated = False
        for key, value in section_keys[section].items():
            if re.match(rf"^\s*{re.escape(key)}\s*=", line):
                indent = re.match(r"^(\s*)", line).group(1)
                line = f'{indent}{key} = "{value}"'
                updated = True
                break
        if updated:
            out.append(line)
            continue

    out.append(line)

cfg.write_text("\n".join(out) + "\n")
print(f"base=#{base}")
print(f"accent={accent[:7]}")
PY

if command -v dunstctl >/dev/null 2>&1; then
  dunstctl reload >/dev/null 2>&1 || true
fi

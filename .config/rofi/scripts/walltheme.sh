#!/bin/sh
set -eu

wall="${1:-}"
cfg="${ROFI_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/rofi/config.rasi}"

[ -n "$wall" ] || {
  printf '%s\n' "usage: walltheme.sh /path/to/wallpaper" >&2
  exit 1
}

[ -f "$wall" ] || {
  printf '%s\n' "wallpaper not found: $wall" >&2
  exit 1
}

[ -f "$cfg" ] || {
  printf '%s\n' "rofi config not found: $cfg" >&2
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

# Если обои почти серые, зануляем насыщенность, чтобы тема была нейтральной
if s < 0.1:
    s = 0.0

# Для цветных обоев оставляем акцент ярким, для серых — серым
accent_sat = max(s, 0.62) if s > 0 else 0.0
urgent_sat = max(s, 0.60) if s > 0 else 0.0

def rgba_from_hls(hue_shift, light, sat):
    rr, gg, bb = colorsys.hls_to_rgb((h + hue_shift / 360) % 1, light, sat)
    return f"#{round(rr * 255):02x}{round(gg * 255):02x}{round(bb * 255):02x}ff"

bg = rgba_from_hls(0, 0.070, min(s * 0.45, 0.45))
bg_alt = rgba_from_hls(0, 0.100, min(s * 0.36, 0.32))
bg_soft = rgba_from_hls(0, 0.140, min(s * 0.28, 0.24))
fg = rgba_from_hls(0, 0.880, min(s, 0.16))
fg_dim = rgba_from_hls(0, 0.560, min(s, 0.18))
accent = rgba_from_hls(0, 0.740, accent_sat)
urgent = rgba_from_hls(-16, 0.620, urgent_sat)
border = rgba_from_hls(0, 0.190, min(s * 0.26, 0.24))

replacements = {
    "bg": bg,
    "bg-alt": bg_alt,
    "bg-soft": bg_soft,
    "fg": fg,
    "fg-dim": fg_dim,
    "accent": accent,
    "urgent": urgent,
    "border": border,
}

text = cfg.read_text()

for key, value in replacements.items():
    pattern = rf'(?m)^(\s*{re.escape(key)}\s*:\s*)#[0-9A-Fa-f]{{8}};'
    text, changed = re.subn(pattern, rf'\1{value};', text, count=1)
    if changed == 0:
        raise SystemExit(f"missing color key in {cfg}: {key}")

cfg.write_text(text)
print(f"base=#{base}")
print(f"accent={accent[:7]}")
PY

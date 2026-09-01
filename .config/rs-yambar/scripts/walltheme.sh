#!/bin/sh
set -eu

wall="${1:-}"
cfg="${RS_YAMBAR_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/rs-yambar/config.toml}"
bar="${RS_YAMBAR_BIN:-$HOME/.local/bin/rs-yambar}"

[ -n "$wall" ] || {
  printf '%s\n' "usage: walltheme.sh /path/to/wallpaper" >&2
  exit 1
}

[ -f "$wall" ] || {
  printf '%s\n' "wallpaper not found: $wall" >&2
  exit 1
}

[ -f "$cfg" ] || {
  printf '%s\n' "rs-yambar config not found: $cfg" >&2
  exit 1
}

[ -x "$bar" ] || {
  bar="$(command -v rs-yambar 2>/dev/null || true)"
}

[ -n "$bar" ] && [ -x "$bar" ] || {
  printf '%s\n' "rs-yambar binary not found; expected $HOME/.local/bin/rs-yambar" >&2
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

def rgba_from_hls(hue_shift, light, sat):
    rr, gg, bb = colorsys.hls_to_rgb((h + hue_shift / 360) % 1, light, sat)
    return f"#{round(rr * 255):02x}{round(gg * 255):02x}{round(bb * 255):02x}ff"

bg     = rgba_from_hls(0,    0.070, min(s * 0.45, 0.45))
fg     = rgba_from_hls(0,    0.880, min(s, 0.16))
muted  = rgba_from_hls(0,    0.560, min(s, 0.18))
accent = rgba_from_hls(0,    0.740, accent_sat)

replacements = {
    "background": bg,
    "foreground": fg,
    "active_foreground": bg,
    "active_background": accent,
    "occupied_foreground": fg,
    "occupied_underline": accent,
    "empty_foreground": muted,
}

text = cfg.read_text()

def replace_key(src, key, value, count=1):
    pattern = rf'(?m)^({re.escape(key)}\s*=\s*)"[#0-9A-Fa-f]{{9}}"'
    updated, changed = re.subn(pattern, rf'\1"{value}"', src, count=count)
    if changed == 0:
        raise SystemExit(f"missing color key in {cfg}: {key}")
    return updated

for key, value in replacements.items():
    text = replace_key(text, key, value)

matches = list(re.finditer(r'(?m)^(foreground\s*=\s*)"[#0-9A-Fa-f]{9}"', text))
for match in reversed(matches[1:]):
    text = text[:match.start()] + f'{match.group(1)}"{accent}"' + text[match.end():]

lines = text.splitlines()
last_format = None
for index, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith("format"):
        last_format = stripped
        continue
    if stripped.startswith("foreground") and last_format == 'format = "{date} "':
        lines[index] = re.sub(r'"[#0-9A-Fa-f]{9}"', f'"{muted}"', line)
    elif stripped.startswith("foreground") and last_format == 'format = "{time}"':
        lines[index] = re.sub(r'"[#0-9A-Fa-f]{9}"', f'"{accent}"', line)

text = "\n".join(lines) + "\n"
cfg.write_text(text)
print(f"base=#{base}")
print(f"accent={accent[:7]}")
PY

"$bar" --validate -c "$cfg" >/tmp/rs-yambar.log 2>&1
pkill -x yambar 2>/dev/null || true
pkill -x rs-yambar 2>/dev/null || true
setsid -f "$bar" -c "$cfg" >>/tmp/rs-yambar.log 2>&1

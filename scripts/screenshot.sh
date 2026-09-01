#!/usr/bin/env sh

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

case "$1" in
    full)
        wayfreeze \
          --after-freeze-cmd '
sleep 0.1
grim - | wl-copy -t image/png
killall wayfreeze
'
        ;;

    area)
        wayfreeze \
          --after-freeze-cmd '
sleep 0.1
geo="$(slurp -b 00000066)" || {
    killall wayfreeze
    exit 1
}
grim -g "$geo" - | wl-copy -t image/png
killall wayfreeze
'
        ;;

    monitor)
        wayfreeze \
          --after-freeze-cmd '
sleep 0.1
geo="$(slurp -b 00000066 -o)" || {
    killall wayfreeze
    exit 1
}
grim -g "$geo" - | wl-copy -t image/png
killall wayfreeze
'
        ;;

    area-swappy)
        wayfreeze \
          --after-freeze-cmd '
file="$(mktemp --suffix=.png)"
sleep 0.1

geo="$(slurp -b 00000066)" || {
    killall wayfreeze
    rm -f "$file"
    exit 1
}

grim -g "$geo" "$file"
killall wayfreeze

swappy -f "$file"
rm -f "$file"
'
        ;;
esac

#!/usr/bin/env sh

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
geo="$(slurp)" || {
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
geo="$(slurp -o)" || {
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

geo="$(slurp)" || {
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

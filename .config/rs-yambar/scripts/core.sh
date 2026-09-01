#!/bin/sh

host="$(hostname)"
up="$(uptime -p | sed 's/up //; s/hour/h/; s/hours/h/; s/minute/m/; s/minutes/m/')"

printf '{"text":"%s · %s"}\n' "$host" "$up"

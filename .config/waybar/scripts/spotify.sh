#!/usr/bin/env bash

player="spotify"
max_len=35
scroll_file="/tmp/waybar-spotify-scroll"

status=$(playerctl -p "$player" status 2>/dev/null)

if [[ "$status" != "Playing" && "$status" != "Paused" ]]; then
  echo ""
  echo 0 > "$scroll_file"
  exit 0
fi

artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
title=$(playerctl -p "$player" metadata title 2>/dev/null)

text="$artist - $title"

if [[ "$status" == "Paused" ]]; then
  icon=""
else
  icon=""
fi

# Si entra en el largo máximo, mostrar normal
if (( ${#text} <= max_len )); then
  echo "$icon $text"
  echo 0 > "$scroll_file"
  exit 0
fi

# Leer posición actual
pos=$(cat "$scroll_file" 2>/dev/null || echo 0)

# Espacios para separar el loop
scroll_text="$text     $text"
visible="${scroll_text:$pos:$max_len}"

echo "$icon $visible"

# Avanzar posición
pos=$((pos + 1))

if (( pos >= ${#text} + 5 )); then
  pos=0
fi

echo "$pos" > "$scroll_file"

#!/bin/bash

DIR="$HOME/wallpapers"
INTERVAL=300   # 5분

# awww daemon이 뜰 때까지 대기
while ! awww query > /dev/null 2>&1; do
    sleep 0.2
done

while true; do
    for IMG in "$DIR"/*.{jpg,jpeg,png,webp}; do
        [ -f "$IMG" ] || continue

        awww img "$IMG" \
            --transition-type fade \
            --transition-duration 1

        sleep $INTERVAL
    done
done


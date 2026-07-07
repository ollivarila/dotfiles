#!/usr/bin/env bash

set -e

while inotifywait ./dunstrc; do
    pkill dunst && dunst &
    notify-send "Test notification";
done

#!/usr/bin/env bash

mode="$1"

case $mode in
    "region")
        grim -g "$(slurp)" && notify-send "Screenshot Saved" "$(date "+%F_%T").png"
        ;;
    "window")
        grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)" && notify-send "Screenshot Window Saved" "$(date "+%F_%T").png"
        ;;
    "output")
        grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" && notify-send "Screenshot Output Saved" "$(date "+%F_%T").png"
        ;;
    "all")
        grim && notify-send "Screenshot All Outputs Saved" "$(date "+%F_%T").png"
        ;;
    *)
        echo >&2 "unsupported command \"$mode\""
        echo >&2 "Usage:"
        echo >&2 "screenshot.sh <region|window|output|all>"
        exit 1
esac

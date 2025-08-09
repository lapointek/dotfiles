#!/usr/bin/env bash

mode="$1"

case $mode in
    "region")
        grim -g "$(slurp)" && notify-send -u low "Screenshot Saved" "$(date "+%F_%T").png" -i document-save
        ;;
    "window")
        grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)" && notify-send -u low "Screenshot Window Saved" "$(date "+%F_%T").png" -i document-save 
        ;;
    "output")
        grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" && notify-send -u low "Screenshot Output Saved" "$(date "+%F_%T").png" -i document-save
        ;;
    "all")
        grim && notify-send -u low "Screenshot All Outputs Saved" "$(date "+%F_%T").png" -i document-save
        ;;
    *)
        echo >&2 "unsupported command \"$mode\""
        echo >&2 "Usage:"
        echo >&2 "screenshot.sh <region|window|output|all>"
        exit 1
esac

#!/bin/sh
xrandr --output eDP-1 --off \
    --output DP-1 --off \
    --output HDMI-1 --off \
    --output DP-2 --off \
    --output DP-2-1 --mode 1920x1080 --pos 0x0 --rotate right \
    --output DP-2-2 --mode 2560x1440 --right-of DP-2-1 --rotate normal --primary \
    --output DP-2-3 --mode 2560x1440 --right-of DP-2-2 --rotate normal

#!/bin/sh
xrandr --output DP-2-3 --primary --mode 2560x1440  --refresh 59.98
xrandr --output eDP-1 --mode 1920x1080 --refresh 59.97 --right-of DP-2-3
xrandr --output DP-2-2 --mode 2560x1440 --left-of DP-2-3


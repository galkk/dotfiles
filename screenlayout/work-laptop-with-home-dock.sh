#!/bin/sh
xrandr --output eDP-1 --mode 1920x1080 --refresh 59.97
xrandr --output DP-2-2 --primary  --mode 3840x2160 --right-of eDP-1 
xrandr --output DP-2-3 --mode 1920x1080 --right-of DP-2-2 --refresh 59.94
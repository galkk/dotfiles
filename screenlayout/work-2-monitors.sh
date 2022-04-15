#!/bin/sh
xrandr --output eDP-1 --off \
  --output DP-1 --off \
  --output HDMI-1 --off \
  --output DP-2 --off \
  --output DP-2-1 --mode 2560x1440 --pos 0x0 --rotate normal \
  --output DP-2-2 --primary --mode 2560x1440 --pos 2560x0 --rotate normal --rate 99.95 \
  --output DP-2-3 --off

#!/bin/sh
xrandr	--output DP-1.2 --primary --mode 3840x2160 --pos 0x0 --rotate normal \
		--output DP-1.3 --mode 2560x1440 --pos 3840x0 --rotate normal --rate 144.0 \
		--output DP-0 --off --output DP-1 --off --output HDMI-0 --off

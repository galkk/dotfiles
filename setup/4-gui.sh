#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive apt-get -qq --no-install-recommends install \
    i3 rofi flameshot remmina xinit brightnessctl peek \
    copyq sway wdisplays krita kazam nemo ffmpegthumbnailer

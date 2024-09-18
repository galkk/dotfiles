#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive apt-get -qq --no-install-recommends install \
    i3 rofi flameshot remmina xinit brightnessctl peek \
    copyq sway wdisplays krita kazam nemo ffmpegthumbnailer \
    ffmpegthumbnailer ffmpeg imagemagick xclip fnt

# Install latest kitty
mkdir -p ~/.local/bin
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator ~/.local/bin/kitty 50

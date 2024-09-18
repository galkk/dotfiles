#!/usr/bin/env bash

wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
apt-get -qq --no-install-recommends install ./vscode.deb
rm vscode.deb

# easy way out for remote access, no need to do xrdp/vnc all the stuff.
# TODO(galk): consider doing some "proper" xrdp configuration later
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
apt-get -qq --no-install-recommends install ./chrome-remote-desktop_current_amd64.deb
rm chrome-remote-desktop_current_amd64.deb

apt-get -qq --no-install-recommends install flatpak

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Community
flatpak install -y flathub com.github.tchx84.Flatseal

# to run brightnessctl without sudo
# usermod -aG video $USER

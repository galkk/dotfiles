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

# Install latest kitty
mkdir -p ~/.local/bin
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator ~/.local/bin/kitty 50
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

# to run brightnessctl without sudo
# usermod -aG video $USER


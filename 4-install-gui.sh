apt install -y fonts-firacode fonts-dejavu fonts-hack-ttf fonts-powerline unzip

# Install Victor Mono
wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip
unzip -j VictorMonoAll.zip TTF/* -d ~/.fonts
rm VictorMonoAll.zip

# TODO(galk): add azeret mono
# TODO(galk): add https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

apt install -y i3 rofi flameshot remmina xinit brightnessctl kitty peek \
	copyq flatpak

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub md.obsidian.Obsidian

# TODO(galk): add intellij, vscode
# TODO(galk): add repository for i3 latest and install i3 from there, to get things like gaps

# to run brightnessctl without sudo
usermod -aG video $USER

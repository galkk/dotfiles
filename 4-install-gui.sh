apt install -y fonts-firacode fonts-dejavu fonts-hack-ttf fonts-powerline

# Install Victor Mono

wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip
unzip -j VictorMonoAll.zip TTF/* -d ~/.fonts
rm VictorMonoAll.zip

# TODO(galk): add azeret mono

apt install -y i3 rofi flameshot remmina xinit brightnessctl kitty peek \
	copyq

# to run brightnessctl without sudo
usermod -aG video $USER

# Fonts
apt-get -qq install --no-install-recommends fnt unzip \
    fonts-firacode fonts-dejavu fonts-hack-ttf

fnt update

# Victor Mono
wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip
unzip -j VictorMonoAll.zip "TTF/*" -d ~/.fonts
rm VictorMonoAll.zip

fnt install azeretmono anonymouspro notosansmono robotomono cousine ibmplexmono

# Nerd fonts symbols only, for kitty
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
unzip -j NerdFontsSymbolsOnly.zip "*.ttf" -d ~/.fonts
rm NerdFontsSymbolsOnly.zip

fc-cache -f -v

# UI stuff
DEBIAN_FRONTEND=noninteractive apt-get -qq --no-install-recommends install \
    i3 rofi flameshot remmina xinit brightnessctl peek \
    copyq sway wdisplays
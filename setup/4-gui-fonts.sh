#!/usr/bin/env bash

# Fonts
apt-get -qq install --no-install-recommends fnt unzip subversion

fnt update

# Change to `fnt install` after https://github.com/alexmyczko/fnt/issues/30 is fixed
fonts=( anonymouspro \
        cousine \
        firacode \
        ibmplexmono \
        jetbrains-mono \
        barlowcondensed \
        sairaextracondensed \
        sofiasansextracondensed \
        stintultracondensed
    )

for font in ${fonts[@]}; do
    fnt install $font
done

svn export --force https://github.com/googlefonts/RobotoMono/trunk/fonts/ttf ~/.fonts/
svn export --force https://github.com/displaay/Azeret/trunk/fonts/ttf ~/.fonts/
svn export --force https://github.com/ryanoasis/nerd-fonts/trunk/master/patched-fonts/NerdFontsSymbolsOnly ~/.fonts/
svn export --force https://github.com/notofonts/notofonts.github.io/trunk/fonts/NotoSansMono/unhinted/ttf ~/.fonts/

chdir $(mktemp -d)
wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip
wget https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_2_37/dejavu-fonts-ttf-2.37.zip
wget https://github.com/be5invis/Iosevka/releases/download/v27.0.2/ttf-iosevka-27.0.2.zip
wget https://github.com/be5invis/Iosevka/releases/download/v27.0.2/ttf-iosevka-term-27.0.2.zip
wget https://github.com/be5invis/Iosevka/releases/download/v27.0.2/ttf-iosevka-slab-27.0.2.zip
wget https://github.com/be5invis/Iosevka/releases/download/v27.0.2/ttf-iosevka-term-slab-27.0.2.zip
wget https://github.com/be5invis/Iosevka/releases/download/v27.0.2/ttf-iosevka-aile-27.0.2.zip
wget https://github.com/be5invis/Iosevka/releases/download/v27.0.2/ttf-iosevka-etoile-27.0.2.zip

unzip -j '*.zip'
mv *.ttf ~/.fonts

fc-cache -f -v


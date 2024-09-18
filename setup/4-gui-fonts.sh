#!/usr/bin/env bash

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
        stintultracondensed \
        azeretmono \
        victormono \
        robotomono \
    )

for font in ${fonts[@]}; do
    fnt install $font
done

cd $(mktemp -d)
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
curl -s 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' | jq -r ".assets[] | .browser_download_url" | grep PkgTTC-Iosevka | xargs -n 1 curl -L -O --fail --silent --show-error
unzip -j '*.zip'
mv *.ttf ~/.fonts

fc-cache -f -v


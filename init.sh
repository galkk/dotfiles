sudo apt install zsh curl i3 rofi peco terminator fzf htop mc flameshot mosh vim 

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/jimeh/zsh-peco-history.git $ZSH_CUSTOM/plugins/zsh-peco-history

mkdir -p ~/projects/
git clone https://github.com/galkk/dotfiles.git ~/projects/

touch ~/.work.zshrc

ln -s ~/projects/dotfiles/i3/i3status ~/.config/i3status
ln -s ~/projects/dotfiles/i3/i3 ~/.config/i3

ln -s ~/projects/dotfiles/vim/.vimrc ~/.vimrc
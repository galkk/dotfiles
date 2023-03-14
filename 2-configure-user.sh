sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/custom/plugins/zsh-autocomplete

[ ! -f ~/.zshrc ] || mv ~/.zshrc ~/.zshrc.backup
[ ! -f ~/.tmux.conf ] || mv ~/.tmux.conf ~/.tmux.conf.backup
[ ! -f ~/.vimrc ] || mv ~/.vimrc ~/.vimrc.backup
[ ! -f ~/.gitconfig ] || mv ~/.gitconfig ~/.gitconfig.backup

touch ~/.work.zshrc

mkdir -p ~/.config

ln -s ~/projects/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/projects/dotfiles/i3/i3status ~/.config/i3status
ln -s ~/projects/dotfiles/i3/i3 ~/.config/i3
ln -s ~/projects/dotfiles/vim/.vimrc ~/.vimrc
ln -s ~/projects/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/projects/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/projects/dotfiles/screenlayout ~/.screenlayout
ln -s ~/projects/dotfiles/kitty ~/.config/kitty
ln -s ~/projects/dotfiles/nvim ~/.config/nvim
ln -s ~/projects/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/projects/dotfiles/rofi ~/.config/rofi

chsh -s $(which zsh) $USER

zsh

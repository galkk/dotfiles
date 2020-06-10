init:
	sudo apt install zsh curl i3 rofi peco terminator fzf htop mc flameshot mosh vim		
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh

configure:
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
	git clone https://github.com/jimeh/zsh-peco-history.git $ZSH_CUSTOM/plugins/zsh-peco-history

	mv ~/.zshrc ~/.zshrc.backup
	mv ~/.vimrc ~/.vimrc.backup
	mv ~/.tmux.conf ~/.tmux.conf.backup

	touch ~/.work.zshrc

	ln -s ~/projects/dotfiles/i3/i3status ~/.config/i3status
	ln -s ~/projects/dotfiles/i3/i3 ~/.config/i3
	ln -s ~/projects/dotfiles/vim/.vimrc ~/.vimrc
	ln -s ~/projects/dotfiles/tmix/.tmux.conf ~/.tmux.conf
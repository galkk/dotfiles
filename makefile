install:
	sudo apt install zsh curl i3 rofi peco openssh-server terminator \
		fzf htop mc flameshot mosh vim cmake python3-dev golang nodejs npm \
		clang build-essential sc jq fonts-firacode fonts-dejavu

init-zsh:
	sudo apt install zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
	git clone https://github.com/jimeh/zsh-peco-history.git $ZSH_CUSTOM/plugins/zsh-peco-history
	mv ~/.zshrc ~/.zshrc.backup
	mv ~/.tmux.conf ~/.tmux.conf.backup


init-dotfiles:
	git clone git@github.com:galkk/dotfiles.git ~/projects/

	mv ~/.vimrc ~/.vimrc.backup
	touch ~/.work.zshrc

	ln -s ~/projects/dotfiles/i3/i3status ~/.config/i3status
	ln -s ~/projects/dotfiles/i3/i3 ~/.config/i3
	ln -s ~/projects/dotfiles/vim/.vimrc ~/.vimrc
	ln -s ~/projects/dotfiles/tmix/.tmux.conf ~/.tmux.conf
	ln -s ~/projects/dotfiles/mc ~/.config/mc


all: install init-zsh init-dotfiles

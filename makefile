# git clone git@github.com:galkk/dotfiles.git ~/projects/

install:
	sudo apt install zsh curl i3 rofi peco openssh-server terminator \
		fzf htop mc flameshot mosh vim cmake python3-dev golang nodejs npm \
		clang build-essential sc jq fonts-firacode fonts-dejavu lldb strace rr \
		highlight remmina

install-oh-my-zsh:
	curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o install-oh-my-zsh.sh;
	sh install-oh-my-zsh.sh
	rm install-oh-my-zsh.sh
	chsh -s /usr/bin/zsh

configure-oh-my-zsh: install-oh-my-zsh
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/jimeh/zsh-peco-history.git ~/.oh-my-zsh/custom/plugins/zsh-peco-history


init-dotfiles:
	[-f ~/.zshrc] && mv ~/.zshrc ~/.zshrc.backup
	[-f ~/.tmux.conf] && mv ~/.tmux.conf ~/.tmux.conf.backup
	[-f ~/.vimrc] && mv ~/.vimrc ~/.vimrc.backup

	touch ~/.work.zshrc

	ln -s ~/projects/dotfiles/zsh/.zshrc ~/.zshrc
	ln -s ~/projects/dotfiles/i3/i3status ~/.config/i3status
	ln -s ~/projects/dotfiles/i3/i3 ~/.config/i3
	ln -s ~/projects/dotfiles/vim/.vimrc ~/.vimrc
	ln -s ~/projects/dotfiles/tmux/.tmux.conf ~/.tmux.conf
	ln -s ~/projects/dotfiles/mc ~/.config/mc
	ln -s ~/projects/dotfiles/compton.conf ~/.config/compton.conf
	ln -s ~/projects/dotfiles/rofi/config.rasi ~/.config/rofi/config.rasi

all: install install-oh-my-zsh configure-oh-my-zsh init-dotfiles

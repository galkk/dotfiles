# git clone git@github.com:galkk/dotfiles.git ~/projects/

install:
	sudo apt install zsh curl i3 rofi peco openssh-server \
		fzf htop mc flameshot mosh vim cmake python3-dev golang nodejs npm \
		clang build-essential sc jq lldb strace rr \
		highlight remmina xinit firefox imagemagick poppler-utils ffmpeg \
		command-not-found brightnessctl kitty peek\
		fonts-firacode fonts-dejavu fonts-hack-ttf  
	
	chsh -s $(which zsh)

install-oh-my-zsh:
	curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o /tmp/install-oh-my-zsh.sh;
	sh /tmp/install-oh-my-zsh.sh --unattended
	rm /tmp/install-oh-my-zsh.sh

configure-oh-my-zsh:
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/jimeh/zsh-peco-history.git ~/.oh-my-zsh/custom/plugins/zsh-peco-history	
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

init-dotfiles:
	[ ! -f ~/.zshrc ] || mv ~/.zshrc ~/.zshrc.backup
	[ ! -f ~/.tmux.conf ] || mv ~/.tmux.conf ~/.tmux.conf.backup
	[ ! -f ~/.vimrc ] || mv ~/.vimrc ~/.vimrc.backup

	touch ~/.work.zshrc

	mkdir -p ~/.config

	ln -s ~/projects/dotfiles/zsh/.zshrc ~/.zshrc
	ln -s ~/projects/dotfiles/i3/i3status ~/.config/i3status
	ln -s ~/projects/dotfiles/i3/i3 ~/.config/i3
	ln -s ~/projects/dotfiles/vim/.vimrc ~/.vimrc
	ln -s ~/projects/dotfiles/tmux/.tmux.conf ~/.tmux.conf
	ln -s ~/projects/dotfiles/.p10k.zsh ~/.p10k.zsh
	ls -s ~/projects/dotfiles/screenlayout ~/.screenlayout
	ls -s ~/projects/dotfiles/kitty ~/.config/kitty

# to run brightnessctl without sudo
post-install:
	 sudo usermod -aG video $USER

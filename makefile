# git clone git@github.com:galkk/dotfiles.git ~/projects/

install:
	sudo apt install -y zsh curl  peco openssh-server \
		fzf htop mc  mosh vim cmake python3-dev golang nodejs npm \
		clang build-essential sc jq lldb strace rr \
		highlight imagemagick poppler-utils ffmpeg \
		command-not-found neovim ripgrep
	
install-fonts:
	sudo apt install -y fonts-firacode fonts-dejavu fonts-hack-ttf fonts-powerline
	wget https://rubjo.github.io/victor-mono/VictorMonoAll.zip
	unzip -j VictorMonoAll.zip TTF/* -d ~/.fonts
	rm VictorMonoAll.zip

install-gui: install-fonts
	sudo apt install -y i3 rofi flameshot remmina xinit brightnessctl kitty peek \
		copyq

install-kitty:
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin	
	mkdir -p ~/.local/bin
	ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator `which kitty` 50

install-oh-my-zsh:
	chsh -s $(which zsh)
	curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o /tmp/install-oh-my-zsh.sh;
	sh /tmp/install-oh-my-zsh.sh --unattended
	rm /tmp/install-oh-my-zsh.sh

configure-oh-my-zsh:
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/jimeh/zsh-peco-history.git ~/.oh-my-zsh/custom/plugins/zsh-peco-history	
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
	git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/custom/plugins/zsh-autocomplete

init-dotfiles:
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


# to run brightnessctl without sudo
post-install:
	 sudo usermod -aG video $USER

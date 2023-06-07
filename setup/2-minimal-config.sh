[ -f ~/.work.zshrc ] || touch ~/.work.zshrc
[ -d ~/.config ] || mkdir -p ~/.config
[ -d ~/.local/bin ] || mkdir -p ~/.local/bin 

# make top level symlinks to all files in dotfiles from home directory
# only if ~/project/dotfiles exists (not the case for docker container).
# all existing files are going to be backed up.
if [ -d ~/projects/dotfiles ]; then 
    # link dotfiles unconditionally
    ln -sfb $(find ~/projects/dotfiles/ -maxdepth 1 -mindepth 1 -type f -not -name '.dockerignore') ~
    
    # link folders that I want to have controlled in .config
    ln -sfb $(find ~/projects/dotfiles/.config -maxdepth 1 -mindepth 1 ) ~/.config/
fi

# change shell to zsh using usermod
usermod -s "$(which zsh)" $USER

# This runs all installation steps, needed for zsh and plugins
echo exit | script -qec zsh /dev/null


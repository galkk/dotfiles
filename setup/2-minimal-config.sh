[ -f ~/.work.zshrc ] || touch ~/.work.zshrc

# if no .config directory in ~, create it
if [ ! -d ~/.config ]; then 
    mkdir -p ~/.config
fi

# make top level symlinks to all files in dotfiles from home directory
# only if ~/project/dotfiles exists (not the case for docker container).
# all existing files are backed up.
if [ -d ~/projects/dotfiles ]; then 
    # link dotfiles unconditionally
    ln -sfb $(find ~/projects/dotfiles/ -maxdepth 1 -mindepth 1 -type f -not -name ".dockerignore") ~
    
    # link folders that I want to have controlled in .config
    ln -sfb $(find ~/projects/dotfiles/.config -maxdepth 1 -mindepth 1 -maxdepth 1 ) ~/.config/
fi

chsh -s $(which zsh) $USER

# This runs all installation steps, needed for zsh and plugins
echo exit | script -qec zsh /dev/null

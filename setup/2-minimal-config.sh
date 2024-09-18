#!/usr/bin/env bash

[ -f ~/.work.zshrc ]    || touch ~/.work.zshrc
[ -d ~/.config ]        || mkdir -p ~/.config
[ -d ~/.local/bin ]     || mkdir -p ~/.local/bin

# make top level symlinks to all files in dotfiles from home directory
# only if ~/project/dotfiles exists (not the case for docker container).
# all existing files are going to be backed up.
if [ -d ~/projects/dotfiles ]; then
    ln -sfb $(find ~/projects/dotfiles/ -maxdepth 1 -mindepth 1 -type f -not -name '.dockerignore') ~
    ln -sfb $(find ~/projects/dotfiles/.config -maxdepth 1 -mindepth 1) ~/.config/
fi

# This runs all installation steps, needed for zsh and plugins
echo exit | script -qec "$(which zsh)" /dev/null

# change shell to zsh using usermod
[ -z "$USER" ] || usermod -s "$(which zsh)" "$USER"

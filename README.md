# Initial setup

Setup git/ssh and clone repository
`git clone git@github.com:galkk/dotfiles.git ~/projects/dotfiles`, then run shell scripts one by one (the ones that are needed).

# Docker

In dotfiles:

## Minimal:

Build 

`docker build --target minimal --tag andy-dotfiles-minimal`

Run

`docker run -it docker.io/library/andy-dotfiles-minimal`


## Full

Build

`docker build --target full --tag andy-dotfiles-full`

Run

`docker run -it docker.io/library/andy-dotfiles-full`
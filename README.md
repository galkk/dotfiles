# Initial setup

Setup git/ssh and clone repository
`git clone git@github.com:galkk/dotfiles.git ~/projects/dotfiles`, then run shell scripts one by one (the ones that are needed).

# Docker

In dotfiles:

## Minimal:

Run from repository 

`docker run --rm -it galkkk/andy-dotfiles-minimal:latest`

or 

`docker compose run --rm galkkk/andy-dotfiles-minimal:latest`

Build locally

`docker build --target minimal --tag andy-dotfiles-minimal`

Run locally

`docker run -it docker.io/library/andy-dotfiles-minimal`

Push to repository

```bash
docker tag andy-dotfiles-minimal:latest galkkk/andy-dotfiles-minimal:latest
docker image push galkkk/andy-dotfiles-minimal
```

## Full

Run from repository
`docker run --rm -it galkkk/andy-dotfiles-full:latest`

Build locally

`docker build --target full --tag andy-dotfiles-full`

Run locally

`docker run -it docker.io/library/andy-dotfiles-full`
![Build status](https://github.com/galkk/dotfiles/actions/workflows/push-docker-image.yml/badge.svg)

Dotfiles are 1:1 reflection of destination paths.

# Initial setup

Setup GitHub CLI authentication, clone repository, then run shell scripts one by one (the ones that
are needed).

```sh
gh auth login --hostname github.com --git-protocol ssh
git clone git@github.com:galkk/dotfiles.git ~/projects/dotfiles
```

Configs could be used for both fresh linux installations and docker/distrobox style images.

# Docker

Each change is being built by [github action](.github/workflows/push-docker-image.yml) and sent to
[docker hub repository](https://hub.docker.com/repository/docker/galkkk/dotfiles).

| Action        | Command                                            |
| ------------- | -------------------------------------------------- |
| Run prebuilt  | `docker run --rm -it galkkk/dotfiles:minimal`  |
| Build and run | `docker compose run --rm --build min`          |
| Full image    | `docker compose run --rm --build full`         |
| Toolbox       | `docker compose run --rm toolbox`              |

# macOS

```
brew bundle --file=Brewfile
setup/macos-defaults.sh
```

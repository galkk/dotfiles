![Build status](https://github.com/galkk/dotfiles/actions/workflows/push-docker-image.yml/badge.svg)

Dotfiles are 1:1 reflection of destination paths.

# Initial setup

Setup git/ssh and clone repository
`git clone git@github.com:galkk/dotfiles.git ~/projects/dotfiles`, then run shell scripts one by one (the ones that are needed).

Configs could be used for both fresh linux installations and docker/distrobox style images.

# Docker

Each change is being built by [github action](.github/workflows/push-docker-image.yml) and sent to [docker hub repository](https://hub.docker.com/repository/docker/galkkk/dotfiles).

Configuration: [Dockerfile](setup/Dockerfile), [Docker compose](setup/docker-compose.yml)

| Action        | Command                                                                  |
| ------------- | ------------------------------------------------------------------------ |
| Run prebuilt  | `docker run --rm -it galkkk/dotfiles:minimal`                            |
| Build and run | `docker compose -f setup/docker-compose.yml run --rm --build dotfiles-minimal` |
| Toolbox       | `docker compose -f setup/docker-compose.yml run --rm toolbox`            |

Replace `dotfiles-minimal` with `dotfiles-full` for the full image.

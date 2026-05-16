![Build status](https://github.com/galkk/dotfiles/actions/workflows/push-docker-image.yml/badge.svg)

Dotfiles are 1:1 reflection of destination paths.

# Initial setup

Setup git/ssh and clone repository
`git clone git@github.com:galkk/dotfiles.git ~/projects/dotfiles`, then run shell scripts one by one (the ones that are needed).

Configs could be used for both fresh linux installations and docker/distrobox style images.

Quick build and run:

```
docker build --build-context setupscripts=setup --target minimal --tag minimal --file setup/Dockerfile . && docker run --rm -it minimal
```

# Docker

Each change is being built by [github action](.github/workflows/push-docker-image.yml) and sent to [docker hub repository](https://hub.docker.com/repository/docker/galkkk/dotfiles).

Configuration:

- [Dockerfile](setup/Dockerfile)
- [Docker compose](setup/docker-compose.yml)

| Action                              | Command                                                                                                                    |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Run from repository                 | `docker run --rm -it galkkk/dotfiles:minimal`                                                                              |
| Build via compose                   | `docker compose -f setup/docker-compose.yml build dotfiles-minimal`                                                        |
| Run via compose                     | `docker compose -f setup/docker-compose.yml run --rm dotfiles-minimal`                                                     |
| Toolbox (host home mounted)         | `docker compose -f setup/docker-compose.yml run --rm toolbox`                                                              |
| Build minimal                       | `docker build --build-context setupscripts=setup --target minimal --tag dotfiles:minimal --file setup/Dockerfile --progress=plain .` |
| Build full                          | `docker build --build-context setupscripts=setup --target full --tag dotfiles:full --file setup/Dockerfile --progress=plain .` |
| Build gui                           | `docker build --build-context setupscripts=setup --target gui --tag dotfiles:gui --file setup/Dockerfile --progress=plain .` |
| Run locally                         | `docker run -it docker.io/library/dotfiles:minimal`                                                                        |
| Push to repository                  | <code>docker tag dotfiles:minimal galkkk/dotfiles:minimal <br>docker image push galkkk/dotfiles:minimal </code>            |

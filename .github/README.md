![Build status](https://github.com/galkk/dotfiles/actions/workflows/push-docker-image.yml/badge.svg)

Dotfiles are in dotfiles folder, and are 1:1 reflection of destination paths.
To build, run from repository folder:

```
docker buildx build --build-context setupscripts=setup --build-context dotfiles=. . --target minimal --tag minimal -f setup/Dockerfile && docker run --rm -it minimal
```

# Initial setup

Setup git/ssh and clone repository
`git clone git@github.com:galkk/dotfiles.git ~/projects/dotfiles`, then run shell scripts one by one (the ones that are needed).

Configs could be used for both fresh linux installations and docker toolbox style imagesf (although not everything there will work, for example podman).

# Docker/Podman

Each change is being built by [github action](.github/workflows/push-docker-image.yml) and sent to [docker hub repository](https://hub.docker.com/repository/docker/galkkk/dotfiles).

Configuration:

- [Dockerfile](setup/Dockerfile)
- [Docker compose](setup/docker-compose.yml)

| Action                              | Minimal                                                                                                                    |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Run from repository, docker         | `docker run --rm -it galkkk/dotfiles:minimal`                                                                              |
| Run from repository, docker compose | `docker compose run --rm dotfiles:minimal`                                                                                 |
| Build                               | `docker buildx build --build-context setupscripts=setup --target minimal --tag dotfiles:minimal --file setup/Dockerfile  --progress=plain --no-cache .` |
| Run locally                         | `docker run -it docker.io/library/dotfiles:minimal`                                                                        |
| Push to repository                  | <code>docker tag dotfiles:minimal galkkk/dotfiles:minimal <br>docker image push galkkk/dotfiles:minimal </code>            |
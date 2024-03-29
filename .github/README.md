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

- [Dockerfile](Dockerfile)
- [Docker compose](docker-compose.yml)

| Action                              | Minimal                                                                                                         | Full                                           |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| Run from repository, docker         | `docker run --rm -it galkkk/dotfiles:minimal`                                                                   | `docker run --rm -it galkkk/dotfiles:full`     |
| Run from repository, docker compose | `docker compose run --rm dotfiles:minimal`                                                               | `docker compose run --rm dotfiles:full` |
| Build                               | `docker build --target minimal --tag dotfiles:minimal`                                                          |
| Run locally                         | `docker run -it docker.io/library/dotfiles:minimal`                                                             |
| Push to repository                  | <code>docker tag dotfiles:minimal galkkk/dotfiles:minimal <br>docker image push galkkk/dotfiles:minimal </code> |

TODO: Figure out if it is possible to move setup files to subdirectory and real dotfiles *into* parent directory. 
      That will require figuring out build context and may be not possible in general case. Unless I will figure out sub repositories or docker contexts, then it will work.
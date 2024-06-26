#!/usr/bin/env bash

apt-get -qq install --no-install-recommends openssh-server htop mc mosh \
    build-essential cmake python3-dev golang \
    jq strace highlight imagemagick ffmpeg \
    neovim ripgrep podman podman-toolbox \
    openjdk-17-jdk tmux wget \
    clang lldb gcc g++ gdb rr

# Let podman to get images from docker hub.
echo "
[registries.search]
registries = ['docker.io']" | tee -a /etc/containers/registries.conf

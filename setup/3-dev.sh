#!/usr/bin/env bash

apt-get -qq install --no-install-recommends \
    build-essential cmake python3-dev golang \
    strace podman podman-toolbox \
    openjdk-21-jdk clang lldb gcc g++ gdb rr

# Let podman to get images from docker hub.
echo "
[registries.search]
registries = ['docker.io']" | tee -a /etc/containers/registries.conf

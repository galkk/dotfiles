apt-get -qq install --no-install-recommends openssh-server htop mc mosh \
    build-essential cmake python3-dev golang \
    jq strace highlight imagemagick ffmpeg \
    neovim ripgrep podman \
    openjdk-17-jdk exa tmux wget \
    clang lldb gcc-13 g++-13 gdb rr

# Let podman to get images from docker hub.
echo "
# [registries.search]
# registries = ['docker.io']" | tee -a /etc/containers/registries.conf

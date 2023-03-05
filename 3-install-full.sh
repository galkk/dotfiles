apt install -y openssh-server htop mc mosh \
    build-essential cmake python3-dev golang \
    clang jq lldb strace rr \
    highlight imagemagick ffmpeg \
    command-not-found neovim ripgrep bat podman \
    openjdk-17-jdk flatpak docker.io exa
# TODO(galk): Replace docker.io with installation script/code from docker to install latest version.

# Let podman to get images from docker hub.
echo "
# [registries.search]
# registries = ['docker.io']" | tee -a /etc/containers/registries.conf

# Install bazelisk (bazel wrapper)
mkdir -p ~/.local/bin
wget -O ~/.local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64
chmod +x ~/.local/bin/bazel

# like, but not really necessary command line spreadsheet calculator
# apt install sc

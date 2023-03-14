apt-get -qq install openssh-server htop mc mosh \
    build-essential cmake python3-dev golang \
    clang jq lldb strace rr \
    highlight imagemagick ffmpeg \
    command-not-found neovim ripgrep bat podman \
    openjdk-17-jdk flatpak exa tmux

# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Let podman to get images from docker hub.
echo "
# [registries.search]
# registries = ['docker.io']" | tee -a /etc/containers/registries.conf

# Bazelisk (bazel wrapper)
mkdir -p ~/.local/bin
wget -O ~/.local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64
chmod +x ~/.local/bin/bazel

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# like, but not really necessary command line spreadsheet calculator
# apt install sc

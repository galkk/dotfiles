apt install -y zsh curl git \
    openssh-server wget \
    fzf htop mc mosh vim cmake python3-dev golang \
    clang build-essential jq lldb strace rr \
    highlight imagemagick ffmpeg \
    command-not-found neovim ripgrep bat podman

echo "
[registries.search]
registries = ['docker.io']" | tee -a /etc/containers/registries.conf

# like, but not really necessary
# command line spreadsheet calculator
# apt install sc

# Things that shouldn't be installed at work etc

# Docker
curl -fsSL https://get.docker.com | sh
groupadd docker
usermod -aG docker "$USER"
rm get-docker.sh

# Bazelisk (bazel wrapper)
wget -O ~/.local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64
chmod +x ~/.local/bin/bazel

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Glow - markdown viewer
GOBIN=~/.local/bin/ go install github.com/charmbracelet/glow@latest

#!/usr/bin/env bash

# Things that shouldn't be installed at work, because they require custom binary downloads, custom repositories etc

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Docker.
# Must be last as they have weird thing and require 20s sleep for non-interactive scripts
curl -fsSL https://get.docker.com | sh

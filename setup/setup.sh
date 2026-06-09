#!/usr/bin/env bash

set -e

SUDO=

setup_sudo() {
    if [ "$(id -u)" = 0 ]; then
        SUDO=""
    elif type sudo &>/dev/null; then
        SUDO="sudo"
    else
        echo "Need to be able to run commands as sudo."
        exit 1
    fi
}

setup_ssh() {
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ~/.ssh/config

    if ! grep -Eq '^[[:space:]]*ControlMaster[[:space:]]+' ~/.ssh/config; then
        cat >>~/.ssh/config <<'EOF'

# Dotfiles SSH multiplexing
Host *
    ControlMaster auto
    ControlPath ~/.ssh/cm-%C
    ControlPersist 10m
EOF
    fi

    # Fix stale SSH_AUTH_SOCK after tmux detach/reattach
    if [ ! -f ~/.ssh/rc ]; then
        cat >~/.ssh/rc <<'EOF'
if test "$SSH_AUTH_SOCK"; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
EOF
        chmod 755 ~/.ssh/rc
    fi
}

setup_links() {
    local dotfiles_dir=${DOTFILES_DIR:-~/projects/dotfiles}

    touch ~/.work.zshrc ~/.work.gitconfig
    mkdir -p ~/.config ~/.local/bin
    setup_ssh

    [ -d "$dotfiles_dir" ] || return

    ln -svfn $(find "$dotfiles_dir"/ -mindepth 1 -prune -type f ! -name '.dockerignore') ~
    ln -svfn $(find "$dotfiles_dir"/.config -mindepth 1 -prune) ~/.config/

    mkdir -p ~/.claude ~/.codex ~/.agents ~/.claude/agents ~/.claude/skills ~/.codex/agents ~/.codex/skills ~/.agents/skills
    [ -L ~/.claude/skills/command-execution-hygiene ] && rm ~/.claude/skills/command-execution-hygiene
    [ -L ~/.codex/skills/command-execution-hygiene ] && rm ~/.codex/skills/command-execution-hygiene
    [ -L ~/.agents/skills/command-execution-hygiene ] && rm ~/.agents/skills/command-execution-hygiene
    ln -svf "$dotfiles_dir"/.claude/CLAUDE.md ~/.claude/CLAUDE.md
    ln -svf "$dotfiles_dir"/.claude/user-settings.json ~/.claude/settings.json
    ln -svfn "$dotfiles_dir"/.claude/agents/research-gatherer.md ~/.claude/agents/research-gatherer.md
    ln -svfn "$dotfiles_dir"/agent-skills/github-pr-workflow ~/.claude/skills/github-pr-workflow
    ln -svfn "$dotfiles_dir"/agent-skills/git-local-workflow ~/.claude/skills/git-local-workflow
    ln -svfn "$dotfiles_dir"/agent-skills/document-hygiene ~/.claude/skills/document-hygiene
    ln -svf "$dotfiles_dir"/.codex/AGENTS.md ~/.codex/AGENTS.md
    ln -svf "$dotfiles_dir"/.codex/personal.config.toml ~/.codex/personal.config.toml
    ln -svf "$dotfiles_dir"/.codex/user-hooks.json ~/.codex/hooks.json
    ln -svfn "$dotfiles_dir"/.codex/agents/research-gatherer.toml ~/.codex/agents/research-gatherer.toml
    ln -svfn "$dotfiles_dir"/agent-skills/github-pr-workflow ~/.codex/skills/github-pr-workflow
    ln -svfn "$dotfiles_dir"/agent-skills/git-local-workflow ~/.codex/skills/git-local-workflow
    ln -svfn "$dotfiles_dir"/agent-skills/document-hygiene ~/.codex/skills/document-hygiene
    ln -svfn "$dotfiles_dir"/agent-skills/github-pr-workflow ~/.agents/skills/github-pr-workflow
    ln -svfn "$dotfiles_dir"/agent-skills/git-local-workflow ~/.agents/skills/git-local-workflow
    ln -svfn "$dotfiles_dir"/agent-skills/document-hygiene ~/.agents/skills/document-hygiene
    ln -svf "$dotfiles_dir"/setup/ensure-agent-research-dir.sh ~/.local/bin/ensure-agent-research-dir
}

setup_packages() {
    echo "Installing base packages"

    # Do not skip fzf key bindings
    local dpkg_excludes=/etc/dpkg/dpkg.cfg.d/excludes
    local fzf_examples_include="path-include=/usr/share/doc/fzf/examples/*"
    if [ ! -f "$dpkg_excludes" ] || ! grep -qxF "$fzf_examples_include" "$dpkg_excludes"; then
        echo "$fzf_examples_include" | $SUDO tee -a "$dpkg_excludes"
    fi

    $SUDO apt-get -qq update
    $SUDO apt-get -qq install --no-install-recommends zsh git git-delta gh gnupg vim fzf curl bat \
        unzip htop mc mosh tmux neovim ripgrep fd-find wget jq yq sd tree openssh-server \
        ca-certificates eza nodejs npm pyenv pipx

    # AI coding assistants and Python tooling
    npm install -g @anthropic-ai/claude-code @openai/codex
    curl -LsSf https://astral.sh/uv/install.sh | sh
    case "$(dpkg --print-architecture)" in
        amd64) difft_arch=x86_64 ;;
        arm64) difft_arch=aarch64 ;;
        *) echo "Unsupported difftastic architecture"; exit 1 ;;
    esac
    curl -LsSf "https://github.com/Wilfred/difftastic/releases/latest/download/difft-${difft_arch}-unknown-linux-gnu.tar.gz" |
        $SUDO tar -xz -C /usr/local/bin difft

    mkdir -p ~/.local/bin
    if [ -f /etc/debian_version ]; then
        ln -sf /usr/bin/batcat ~/.local/bin/bat
        ln -sf /usr/bin/fdfind ~/.local/bin/fd
    fi
}

setup_config() {
    echo "Configuring environment"

    setup_links

    # This runs all installation steps, needed for zsh and plugins
    zsh=$(which zsh)
    echo exit | script -qec "$zsh" /dev/null

    # change shell to zsh using usermod
    [ -z "${USER}" ] || $SUDO usermod -s "$zsh" "${USER}"
}

setup_base() {
    setup_packages
    setup_config
}

setup_dev() {
    echo "Setting up dev installation"
    $SUDO apt-get -qq install --no-install-recommends \
        build-essential cmake python3-dev golang \
        strace podman distrobox pipx \
        openjdk-21-jdk clang lldb gcc g++ gdb rr

    # Let podman to get images from docker hub.
    $SUDO mkdir -p /etc/containers/registries.conf.d
    echo "[registries.search]
registries = ['docker.io']" | $SUDO tee /etc/containers/registries.conf.d/10-dockerhub.conf

    # Docker CLI only (daemon runs on host, mounted via socket)
    $SUDO install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
        $SUDO gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) \
        signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        $SUDO tee /etc/apt/sources.list.d/docker.list
    $SUDO apt-get -qq update
    $SUDO apt-get -qq install --no-install-recommends docker-ce-cli docker-compose-plugin

}

setup_gui() {
    echo "Setting up gui installation"
    $SUDO apt-get -qq --no-install-recommends install \
        i3 rofi flameshot remmina xinit brightnessctl peek \
        copyq sway wdisplays krita kazam nemo ffmpegthumbnailer \
        ffmpeg imagemagick xclip fnt pipx dunst lxpolkit

    pipx install autotiling || pipx upgrade autotiling

    # Install latest kitty
    mkdir -p ~/.local/bin
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
    $SUDO update-alternatives --install \
        /usr/bin/x-terminal-emulator x-terminal-emulator ~/.local/bin/kitty 50

    fnt update

    # Change to `fnt install` after https://github.com/alexmyczko/fnt/issues/30 is fixed
    FONTS=(anonymouspro cousine firacode ibmplexmono jetbrains-mono
        barlowcondensed sairaextracondensed sofiasansextracondensed
        stintultracondensed azeretmono victormono robotomono)

    for font in "${FONTS[@]}"; do
        fnt install "$font"
    done

    FONTDIR="$(mktemp -d)"
    cd "$FONTDIR"
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
    curl -s 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' |
        jq -r ".assets[] | .browser_download_url" |
        grep SuperTTC-Iosevka | grep -v SS |
        xargs -n 1 curl -L -O --fail --show-error
    unzip -j '*.zip'
    mv ./*.ttf ./*.ttc ~/.fonts
    rm -rf "$FONTDIR"

    fc-cache -f -v
}

# Things that shouldn't be installed at work, because they require custom binary downloads, custom repositories etc
setup_personal() {
    echo "Setting up personal installation"

    # Tailscale
    $SUDO curl -fsSL https://tailscale.com/install.sh | sh

    wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    $SUDO apt-get -qq --no-install-recommends install ./vscode.deb
    rm vscode.deb

    # easy way out for remote access, no need to do xrdp/vnc all the stuff.
    # TODO(galk): consider doing some "proper" xrdp configuration later
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    $SUDO apt-get -qq --no-install-recommends install ./chrome-remote-desktop_current_amd64.deb
    rm chrome-remote-desktop_current_amd64.deb

    $SUDO apt-get -qq --no-install-recommends install flatpak

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub md.obsidian.Obsidian
    flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Community
    flatpak install -y flathub com.github.tchx84.Flatseal

    # to run brightnessctl without sudo
    # usermod -aG video $USER
}

[ "${1-}" = "links" ] && setup_links && exit
[ "${1-}" = "config" ] && setup_sudo && setup_config && exit

setup_sudo

export DEBIAN_FRONTEND=noninteractive

[ -z "${1-}" ] && setup_base && exit
[ "${1-}" = "packages" ] && setup_packages && exit
[ "${1-}" = "dev" ] && setup_dev && exit
[ "${1-}" = "gui" ] && setup_gui && exit
[ "${1-}" = "personal" ] && setup_personal && exit

# vim:foldmethod=marker:foldmarker={{,}}:foldlevel=0:foldtext=substitute(getline(v\:foldstart),'\\#\\\ \\\|{{','','g')

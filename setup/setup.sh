#!/usr/bin/env bash

set -e

SUDO=

setup_sudo() {
    local CAN_ROOT=
    if [ "$(id -u)" = 0 ]; then
        CAN_ROOT=1
        SUDO=""
    elif type sudo >/dev/null; then
        CAN_ROOT=1
        SUDO="sudo"
    fi

    if [ "$CAN_ROOT" != "1" ]; then
        echo "Need to be able to run commands as sudo."
        exit 1
    fi
    echo $"sudo: $SUDO, can_root: $CAN_ROOT"
}

setup_ssh() {
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ~/.ssh/config

    if ! grep -Eq '^[[:space:]]*ControlMaster[[:space:]]+' ~/.ssh/config; then
        cat >> ~/.ssh/config <<'EOF'

# Dotfiles SSH multiplexing
Host *
    ControlMaster auto
    ControlPath ~/.ssh/cm-%C
    ControlPersist 10m
EOF
    fi

    # Fix stale SSH_AUTH_SOCK after tmux detach/reattach
    if [ ! -f ~/.ssh/rc ]; then
        cat > ~/.ssh/rc <<'EOF'
if test "$SSH_AUTH_SOCK"; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
EOF
        chmod 755 ~/.ssh/rc
    fi
}

setup_base() {
    echo "Setting up base installation"

    # Do not skip fzf key bindings
    echo "path-include=/usr/share/doc/fzf/examples/*" | $SUDO tee -a /etc/dpkg/dpkg.cfg.d/excludes

    $SUDO apt-get -qq update
    $SUDO apt-get -qq install --no-install-recommends zsh git vim fzf curl bat \
        unzip htop mc mosh tmux neovim ripgrep fd-find wget jq yq sd openssh-server \
        ca-certificates eza nodejs npm

    # AI coding assistants and Python tooling
    npm install -g @anthropic-ai/claude-code @openai/codex
    curl -LsSf https://astral.sh/uv/install.sh | sh

    [ -f ~/.work.zshrc ]    || touch ~/.work.zshrc
    [ -f ~/.work.gitconfig ] || touch ~/.work.gitconfig
    [ -d ~/.config ]        || mkdir -p ~/.config
    [ -d ~/.local/bin ]     || mkdir -p ~/.local/bin
    which bat >/dev/null 2>&1 || ln -sf /usr/bin/batcat ~/.local/bin/bat
    which fd >/dev/null 2>&1 || { which fdfind >/dev/null 2>&1 && ln -sf "$(which fdfind)" ~/.local/bin/fd; }
    setup_ssh

    # make top level symlinks to all files in dotfiles from home directory
    # only if ~/project/dotfiles exists (not the case for docker container).
    # all existing files are going to be backed up.
    if [ -d ~/projects/dotfiles ]; then
        ln -svfn $(find ~/projects/dotfiles/ -mindepth 1 -prune -type f ! -name '.dockerignore') ~
        ln -svfn $(find ~/projects/dotfiles/.config -mindepth 1 -prune) ~/.config/

        # AI coding assistants
        mkdir -p ~/.claude ~/.codex
        ln -svf ~/projects/dotfiles/.claude/CLAUDE.md ~/.claude/CLAUDE.md
        ln -svf ~/projects/dotfiles/.codex/AGENTS.md ~/.codex/AGENTS.md
    fi

    # This runs all installation steps, needed for zsh and plugins
    echo exit | script -qec "$(which zsh)" /dev/null

    # change shell to zsh using usermod
    [ -z "${USER}" ] || $SUDO usermod -s "$(which zsh)" "${USER}"
}

setup_dev() {
    echo "Setting up dev installation"
    $SUDO apt-get -qq install --no-install-recommends \
        build-essential cmake python3-dev golang \
        strace podman distrobox pipx \
        openjdk-21-jdk clang lldb gcc g++ gdb rr

    # Let podman to get images from docker hub.
    echo "
    [registries.search]
    registries = ['docker.io']" | $SUDO tee -a /etc/containers/registries.conf

    # Docker CLI only (daemon runs on host, mounted via socket)
    $SUDO install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $SUDO gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | $SUDO tee /etc/apt/sources.list.d/docker.list
    $SUDO apt-get -qq update
    $SUDO apt-get -qq install --no-install-recommends docker-ce-cli docker-compose-plugin

}


setup_gui() {
    echo "Setting up gui installation"
    $SUDO apt-get -qq --no-install-recommends install \
        i3 rofi flameshot remmina xinit brightnessctl peek \
        copyq sway wdisplays krita kazam nemo ffmpegthumbnailer \
        ffmpeg imagemagick xclip fnt autotiling

    # Install latest kitty
    mkdir -p ~/.local/bin
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
    $SUDO update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator ~/.local/bin/kitty 50

    fnt update

    # Change to `fnt install` after https://github.com/alexmyczko/fnt/issues/30 is fixed
    FONTS=( anonymouspro \
            cousine \
            firacode \
            ibmplexmono \
            jetbrains-mono \
            barlowcondensed \
            sairaextracondensed \
            sofiasansextracondensed \
            stintultracondensed \
            azeretmono \
            victormono \
            robotomono \
        )

    for font in "${FONTS[@]}"; do
        fnt install "$font"
    done

    FONTDIR="$(mktemp -d)"
    cd "$FONTDIR" || exit
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
    curl -s 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' | jq -r ".assets[] | .browser_download_url" | grep SuperTTC-Iosevka | grep -v SS | xargs -n 1 curl -L -O --fail --show-error
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

setup_sudo

export DEBIAN_FRONTEND=noninteractive

[ -z "${1-}" ] && setup_base && exit
[ "${1-}" = "dev" ] && setup_dev && exit
[ "${1-}" = "gui" ] && setup_gui && exit
[ "${1-}" = "personal" ] && setup_personal && exit

# vim:foldmethod=marker:foldmarker={{,}}:foldlevel=0:foldtext=substitute(getline(v\:foldstart),'\\#\\\ \\\|{{','','g')
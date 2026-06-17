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

    mkdir -p ~/.claude ~/.codex ~/.agents ~/.claude/agents ~/.claude/skills ~/.codex/agents ~/.codex/rules ~/.codex/skills ~/.agents/skills
    [ -L ~/.codex/skills/command-execution-hygiene ] && rm ~/.codex/skills/command-execution-hygiene
    [ -L ~/.agents/skills/command-execution-hygiene ] && rm ~/.agents/skills/command-execution-hygiene
    ln -svf "$dotfiles_dir"/.claude/CLAUDE.md ~/.claude/CLAUDE.md
    ln -svf "$dotfiles_dir"/.codex/AGENTS.md ~/.codex/AGENTS.md
    ln -svf "$dotfiles_dir"/.codex/personal.config.toml ~/.codex/personal.config.toml
    ln -svf "$dotfiles_dir"/.codex/rules/default.rules ~/.codex/rules/default.rules
    ln -svf "$dotfiles_dir"/.codex/user-hooks.json ~/.codex/hooks.json
    for agent_file in "$dotfiles_dir"/.claude/agents/*.md; do
        [ -f "$agent_file" ] || continue
        ln -svfn "$agent_file" ~/.claude/agents/"$(basename "$agent_file")"
    done
    for agent_file in "$dotfiles_dir"/.codex/agents/*.toml; do
        [ -f "$agent_file" ] || continue
        ln -svfn "$agent_file" ~/.codex/agents/"$(basename "$agent_file")"
    done
    for skill_dir in "$dotfiles_dir"/agent-skills/*; do
        [ -d "$skill_dir" ] || continue
        skill_name="$(basename "$skill_dir")"
        ln -svfn "$skill_dir" ~/.claude/skills/"$skill_name"
        ln -svfn "$skill_dir" ~/.codex/skills/"$skill_name"
        ln -svfn "$skill_dir" ~/.agents/skills/"$skill_name"
    done
    ln -svf "$dotfiles_dir"/setup/ensure-agent-research-dir.sh ~/.local/bin/ensure-agent-research-dir
    ln -svf "$dotfiles_dir"/setup/agent-learning-stop-hook.sh ~/.local/bin/agent-learning-stop-hook
}

setup_node() {
    case "$(dpkg --print-architecture)" in
        amd64) node_arch=x64 ;;
        arm64) node_arch=arm64 ;;
        *) echo "Unsupported Node.js architecture"; exit 1 ;;
    esac

    mkdir -p ~/.local/bin ~/.local/node
    node_file="$(curl -LsSf https://nodejs.org/dist/latest-v22.x/SHASUMS256.txt |
        awk -v suffix="linux-${node_arch}.tar.gz" '$2 ~ suffix "$" { print $2; exit }')"
    curl -LsSf "https://nodejs.org/dist/latest-v22.x/${node_file}" |
        tar -xz --strip-components=1 -C ~/.local/node
    ln -sf ~/.local/node/bin/node ~/.local/node/bin/npm ~/.local/node/bin/npx ~/.local/node/bin/corepack ~/.local/bin/
    export PATH="$HOME/.local/bin:$PATH"
}

setup_dotnet() {
    curl -LsSf https://dot.net/v1/dotnet-install.sh |
        bash /dev/stdin --channel LTS --install-dir "$HOME/.dotnet"
    ln -sf ~/.dotnet/dotnet ~/.local/bin/dotnet
    export DOTNET_ROOT="$HOME/.dotnet"
    export PATH="$HOME/.dotnet:$HOME/.local/bin:$PATH"
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
        unzip htop mc mosh tmux ripgrep fd-find wget jq yq sd tree openssh-server \
        ca-certificates eza pyenv pipx

    mkdir -p ~/.local/bin
    curl -LsSf -o ~/.local/bin/nvim \
        https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod 755 ~/.local/bin/nvim

    # AI coding assistants and Python tooling
    setup_node
    npm install --global --prefix "$HOME/.local" @anthropic-ai/claude-code @openai/codex
    curl -LsSf https://astral.sh/uv/install.sh | sh
    case "$(dpkg --print-architecture)" in
        amd64) difft_arch=x86_64 ;;
        arm64) difft_arch=aarch64 ;;
        *) echo "Unsupported difftastic architecture"; exit 1 ;;
    esac
    curl -LsSf "https://github.com/Wilfred/difftastic/releases/latest/download/difft-${difft_arch}-unknown-linux-gnu.tar.gz" |
        $SUDO tar -xz -C /usr/local/bin difft
    if [ -f /etc/debian_version ]; then
        ln -sf /usr/bin/batcat ~/.local/bin/bat
        ln -sf /usr/bin/fdfind ~/.local/bin/fd
    fi
}

setup_lsp_servers() {
    echo "Installing LSP servers"

    $SUDO apt-get -qq install --no-install-recommends \
        ca-certificates curl jq unzip openjdk-21-jdk clangd gopls shellcheck shfmt

    setup_node
    npm install --global --prefix "$HOME/.local" \
        bash-language-server pyright typescript typescript-language-server \
        vim-language-server vscode-langservers-extracted yaml-language-server \
        dockerfile-language-server-nodejs @microsoft/compose-language-service

    setup_dotnet
    dotnet tool install --tool-path "$HOME/.local/bin" csharp-ls ||
        dotnet tool update --tool-path "$HOME/.local/bin" csharp-ls

    mkdir -p ~/.local/bin

    case "$(uname -m)" in
        x86_64|amd64)
            luals_arch=x64
            rust_analyzer_arch=x86_64-unknown-linux-gnu
            helm_ls_arch=amd64
            kotlin_lsp_arch_suffix=
            lemminx_arch=x86_64
            starpls_arch=amd64
            bazelrc_lsp_asset=bazelrc-lsp-ubuntu
            ;;
        aarch64|arm64)
            luals_arch=arm64
            rust_analyzer_arch=aarch64-unknown-linux-gnu
            helm_ls_arch=arm64
            kotlin_lsp_arch_suffix=-aarch64
            lemminx_arch=aarch_64
            starpls_arch=aarch64
            bazelrc_lsp_asset=
            ;;
        *)
            echo "Unsupported LSP server architecture"
            exit 1
            ;;
    esac

    luals_tag="$(curl -LsSf https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | jq -r .tag_name)"
    luals_dir="$HOME/.local/share/lua-language-server"
    luals_tmp="$(mktemp -d)"
    curl -LsSf "https://github.com/LuaLS/lua-language-server/releases/download/${luals_tag}/lua-language-server-${luals_tag}-linux-${luals_arch}.tar.gz" |
        tar -xz -C "$luals_tmp"
    rm -rf "$luals_dir"
    mv "$luals_tmp" "$luals_dir"
    cat >~/.local/bin/lua-language-server <<EOF
#!/usr/bin/env bash
exec "$luals_dir/bin/lua-language-server" "\$@"
EOF
    chmod 755 ~/.local/bin/lua-language-server

    kotlin_lsp_version="$(curl -LsSf https://api.github.com/repos/Kotlin/kotlin-lsp/releases/latest |
        jq -r '.tag_name | split("/")[-1] | sub("^v"; "")')"
    kotlin_lsp_dir="$HOME/.local/kotlin-lsp"
    rm -rf "$kotlin_lsp_dir"
    mkdir -p "$kotlin_lsp_dir"
    curl -LsSf "https://download-cdn.jetbrains.com/kotlin-lsp/${kotlin_lsp_version}/kotlin-server-${kotlin_lsp_version}${kotlin_lsp_arch_suffix}.tar.gz" |
        tar -xz --strip-components=1 -C "$kotlin_lsp_dir"
    chmod 755 "$kotlin_lsp_dir/kotlin-lsp.sh"
    ln -sf "$kotlin_lsp_dir/kotlin-lsp.sh" ~/.local/bin/kotlin-lsp

    jdtls_dir="$HOME/.local/jdtls"
    jdtls_file="$(curl -LsSf https://download.eclipse.org/jdtls/snapshots/latest.txt)"
    rm -rf "$jdtls_dir"
    mkdir -p "$jdtls_dir"
    curl -LsSf "https://download.eclipse.org/jdtls/snapshots/${jdtls_file}" |
        tar -xz -C "$jdtls_dir"
    ln -sf "$jdtls_dir/bin/jdtls" ~/.local/bin/jdtls

    rust_analyzer_tmp="$(mktemp)"
    curl -LsSf "https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-${rust_analyzer_arch}.gz" |
        gunzip -c >"$rust_analyzer_tmp"
    install -m 0755 "$rust_analyzer_tmp" ~/.local/bin/rust-analyzer
    rm "$rust_analyzer_tmp"

    curl -LsSf -o ~/.local/bin/helm_ls \
        "https://github.com/mrjosh/helm-ls/releases/latest/download/helm_ls_linux_${helm_ls_arch}"
    chmod 755 ~/.local/bin/helm_ls

    lemminx_tag="$(curl -LsSf https://api.github.com/repos/redhat-developer/vscode-xml/releases/latest | jq -r .tag_name)"
    lemminx_tmp="$(mktemp -d)"
    curl -LsSf -o "$lemminx_tmp/lemminx.zip" \
        "https://github.com/redhat-developer/vscode-xml/releases/download/${lemminx_tag}/lemminx-linux-${lemminx_arch}.zip"
    unzip -q "$lemminx_tmp/lemminx.zip" -d "$lemminx_tmp"
    lemminx_bin="$(find "$lemminx_tmp" -type f -name 'lemminx*' ! -name '*.sha256' -print -quit)"
    install -m 0755 "$lemminx_bin" ~/.local/bin/lemminx
    rm -rf "$lemminx_tmp"

    starpls_tag="$(curl -LsSf https://api.github.com/repos/withered-magic/starpls/releases/latest | jq -r .tag_name)"
    curl -LsSf -o ~/.local/bin/starpls \
        "https://github.com/withered-magic/starpls/releases/download/${starpls_tag}/starpls-linux-${starpls_arch}"
    chmod 755 ~/.local/bin/starpls

    if [ -n "$bazelrc_lsp_asset" ]; then
        bazelrc_lsp_tag="$(curl -LsSf https://api.github.com/repos/salesforce-misc/bazelrc-lsp/releases/latest | jq -r .tag_name)"
        curl -LsSf -o ~/.local/bin/bazelrc-lsp \
            "https://github.com/salesforce-misc/bazelrc-lsp/releases/download/${bazelrc_lsp_tag}/${bazelrc_lsp_asset}"
        chmod 755 ~/.local/bin/bazelrc-lsp
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

    setup_lsp_servers

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
[ "${1-}" = "lsp" ] && setup_lsp_servers && exit
[ "${1-}" = "gui" ] && setup_gui && exit
[ "${1-}" = "personal" ] && setup_personal && exit

# vim:foldmethod=marker:foldmarker={{,}}:foldlevel=0:foldtext=substitute(getline(v\:foldstart),'\\#\\\ \\\|{{','','g')

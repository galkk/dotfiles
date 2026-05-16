# p10k instant prompt {{
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi #}}

# zsh-autocomplete settings (must be BEFORE loading the plugin) {{
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

zstyle ':autocomplete:*' list-lines 16
zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'
zstyle ':completion:*' file-sort modification
# }}

# Docker CLI completions
[[ -d "$HOME/.docker/completions" ]] && fpath=($HOME/.docker/completions $fpath)

# plugins {{
PLUG_REPO=~/.znap
[[ -r $PLUG_REPO/znap/znap.zsh ]] ||
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git $PLUG_REPO/znap
source $PLUG_REPO/znap/znap.zsh

znap source romkatv/powerlevel10k
znap source zsh-users/zsh-completions
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-syntax-highlighting
znap source wfxr/forgit
znap source agkozak/zsh-z
znap eval fzf 'fzf --zsh'
znap eval kubectl 'kubectl completion zsh'
znap eval uv 'uv generate-shell-completion zsh'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
znap source zsh-users/zsh-autosuggestions
#}}

alias icat="kitty +kitten icat --align left"
alias ls="eza --icons=auto --group-directories-first"
alias ll="eza -l --icons=auto --git --group-directories-first --time-style=long-iso"
alias la="eza -la --icons=auto --git --group-directories-first --time-style=long-iso"
alias lt="eza --tree --level=2 --icons=auto --group-directories-first"
alias yp='noglob yt-dlp -v -S "+codec:h264" -o "%(uploader)s - %(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"'
alias yf='noglob yt-dlp -v -S "+codec:h264" --output-na-placeholder "" -f "bv[ext=mp4]*+ba/bv*+ba/b" --sponsorblock-remove default -o "%(uploader)s - %(title)s.%(ext)s"'

PATH=~/.local/bin:$PATH
export LESS="-iMFRasW -x4 -j3 --mouse --incsearch"
export BAT_STYLE=changes # git diff markers only
export BAT_PAGING=never
export EDITOR=vim
export DOTNET_CLI_TELEMETRY_OPTOUT=true
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_UPGRADE=1
ZSHZ_CASE=smart # case-insensitive unless query has uppercase
ZSHZ_TILDE=1    # display ~ instead of /Users/username
KITTY_INSTALLATION_DIR=$HOME/.local/kitty.app/lib/kitty/

# options {{
setopt extended_glob          # advanced globbing (#, ~, ^)
setopt interactive_comments   # allow # comments in interactive shell
setopt no_clobber             # prevent > from overwriting (use >| to force)
setopt no_beep
#}}

# binds {{
bindkey '^[[3~' delete-char           # enables DEL key proper behaviour
bindkey '^[[1;5C' forward-word        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word       # [Ctrl-LeftArrow] - move backward one word
bindkey  "^[[H"   beginning-of-line   # [Home] - goes at the begining of the line
bindkey  "^[[F"   end-of-line         # [End] - goes at the end of the line

autoload -z edit-command-line            # Enable editing of command line by pressing Ctrl+x, E
zle -N edit-command-line
bindkey '^Xe' edit-command-line       #}}

# fzf settings {{
# use fd instead of find — faster, respects .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'  # Alt-C: fuzzy cd
export FZF_DEFAULT_OPTS="--height 30 --ansi --layout=reverse --style=full --highlight-line --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}' --preview-window 'down:50%:wrap'"
export FZF_CTRL_R_OPTS="--scheme=history --highlight-line"
export FZF_ALT_C_OPTS="--preview 'eza --color=always {}'"

rgf() {
    local rg_prefix='rg --column --line-number --no-heading --color=always --smart-case'

    : | fzf --ansi --disabled --query "$*" \
        --bind "start:reload:$rg_prefix {q} || true" \
        --bind "change:reload:$rg_prefix {q} || true" \
        --delimiter : \
        --preview 'bat --color=always --style=plain --highlight-line {2} -- {1}' \
        --preview-window 'right:60%:+{2}/2' \
        --bind 'enter:become(vim +{2} -- {1})' \
        --bind 'alt-enter:become(echo {1}:{2})' \
        --bind "ctrl-o:become($rg_prefix {q})"
}
# }}

# history {{
setopt share_history          # share history between terminals
setopt hist_ignore_dups       # do not enter command if it is same as previous command
setopt hist_reduce_blanks     # trim blanks before recording
setopt hist_verify            # show expansion before executing (!! safety)
setopt histignorespace
setopt hist_find_no_dups

HISTSIZE=50000                # How many lines of history to keep in memory
HISTFILE=~/.zsh_history       # Where to save history to disk
SAVEHIST=5000000              # Number of history entries to save to disk }}

[[ ! -f ~/.work.zshrc ]] || source ~/.work.zshrc            # load work setting, that I don't want to put to source control
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh                # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# kitty shell integration {{
if [ -d "$KITTY_INSTALLATION_DIR" ]; then
    export KITTY_SHELL_INTEGRATION="no-sudo enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi
# }}

# zsh-autocomplete binds (must be AFTER loading the plugin) {{
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
#}}

# vim:foldmethod=marker:foldmarker={{,}}:foldlevel=0:foldtext=substitute(getline(v\:foldstart),'\\#\\\ \\\|{{','','g')

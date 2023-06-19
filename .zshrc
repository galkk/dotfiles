# p10k instant prompt {{
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi #}}

# plugins {{
PLUG_REPO=~/.znap
[[ -r $PLUG_REPO/znap/znap.zsh ]] ||
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git $PLUG_REPO/znap
source $PLUG_REPO/znap/znap.zsh

znap source romkatv/powerlevel10k
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source marlonrichert/zsh-autocomplete
znap source agkozak/zsh-z #}}

alias cat="batcat --plain --color=always --paging=never "
alias icat="kitty +kitten icat --align left"
alias ls="ls --color"

PATH=~/.local/bin:$PATH
LESS="-iMFXRas" # main thing - colorize less and print if fits one screen, to exit hg diff immediately for short files.
EDITOR=/usr/bin/vim
DOTNET_CLI_TELEMETRY_OPTOUT=true

# binds {{
bindkey '^[[3~' delete-char           #enables DEL key proper behaviour
bindkey '^[[1;5C' forward-word        #[Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word       #[Ctrl-LeftArrow] - move backward one word
bindkey  "^[[H"   beginning-of-line   #[Home] - goes at the begining of the line
bindkey  "^[[F"   end-of-line         #[End] - goes at the end of the line }}

# zsh-autocomplete settings {{
zstyle ':autocomplete:*' widget-style menu-select
zstyle ':autocomplete:*' list-lines 16
zstyle ':autocomplete:*' insert-unambiguous yes
zstyle ':autocomplete:*' fzf-completion yes #}}

# fzf settings {{
FZF_DEFAULT_OPTS="--height 30 --ansi --layout=reverse --preview 'echo {} | batcat --color=always --language=bash --style=plain' --preview-window down:7:wrap"

if [ -d /usr/share/doc/fzf/examples ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
fi # }}

# autosuggest {{
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
ZSH_AUTOSUGGEST_STRATEGY=(history) #}}

# history {{
setopt share_history          # share history between terminals
setopt hist_ignore_dups       # do not enter command if it is same as previous command

HISTSIZE=50000                # How many lines of history to keep in memory
HISTFILE=~/.zsh_history       # Where to save history to disk
SAVEHIST=5000000              # Number of history entries to save to disk }}

[[ ! -f ~/.work.zshrc ]] || source ~/.work.zshrc            # load work setting, that I don't want to put to source control
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh                # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# vim:foldmethod=marker:foldmarker={{,}}:foldlevel=0:foldtext=substitute(getline(v\:foldstart),'\\#\\\ \\\|{{','','g')

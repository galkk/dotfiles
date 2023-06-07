# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

PLUG_REPO=~/.znap
[[ -r $PLUG_REPO/znap/znap.zsh ]] ||
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git $PLUG_REPO/znap
source $PLUG_REPO/znap/znap.zsh

znap source romkatv/powerlevel10k
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source marlonrichert/zsh-autocomplete
znap source agkozak/zsh-z

setopt share_history
setopt hist_ignore_dups 

HISTSIZE=50000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000000              #Number of history entries to save to disk

ZSH=~/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_UPDATE_PROMPT="true"

UPDATE_ZSH_DAYS=13
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
ZSH_AUTOSUGGEST_STRATEGY=(history)

alias cat="batcat --plain --color=always --paging=never "
alias icat="kitty +kitten icat --align left"
alias ls="ls --color"

DISABLE_MAGIC_FUNCTIONS=true
DOTNET_CLI_TELEMETRY_OPTOUT=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

zstyle ':autocomplete:*' widget-style menu-select
zstyle ':autocomplete:*' list-lines 16
zstyle ':autocomplete:history-search:*' list-lines 16  # int
zstyle ':autocomplete:history-incremental-search-*:*' list-lines 16 # int
zstyle ':autocomplete:*' insert-unambiguous yes
zstyle ':autocomplete:*' fzf-completion yes

FZF_DEFAULT_OPTS="--height 30 --ansi --layout=reverse --preview 'echo {} | batcat --color=always --language=bash --style=plain' --preview-window down:7:wrap"

if [ -d /usr/share/doc/fzf/examples ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
fi

PATH=~/.local/bin:$PATH
LESS="-iMFXRas"

[[ ! -f ~/.work.zshrc ]] || source ~/.work.zshrc

bindkey '^[[3~' delete-char           #enables DEL key proper behaviour
bindkey '^[[1;5C' forward-word        #[Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word       #[Ctrl-LeftArrow] - move backward one word
bindkey  "^[[H"   beginning-of-line   #[Home] - goes at the begining of the line
bindkey  "^[[F"   end-of-line         #[End] - goes at the end of the line

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt share_history

HISTSIZE=50000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000000              #Number of history entries to save to disk

ZSH=~/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_UPDATE_PROMPT="true"

UPDATE_ZSH_DAYS=13
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
ZSH_AUTOSUGGEST_STRATEGY=(history)

alias cats="highlight -O xterm256 --force"

DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

zstyle ':autocomplete:*' widget-style menu-select
zstyle ':autocomplete:*' list-lines 24
zstyle ':autocomplete:history-search:*' list-lines 24  # int
zstyle ':autocomplete:history-incremental-search-*:*' list-lines 24 # int

zstyle ':autocomplete:*' insert-unambiguous yes
zstyle ':autocomplete:*' fzf-completion no

plugins=(zsh-autosuggestions zsh-autocomplete z colored-man-pages docker git mercurial web-search zsh-syntax-highlighting )

source ~/.work.zshrc
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

PATH=~/.local/bin:$PATH

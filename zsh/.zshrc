setopt inc_append_history
setopt share_history

HISTSIZE=50000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000000              #Number of history entries to save to disk
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killedexport 

ZSH=~/.oh-my-zsh
ZSH_THEME="bureau"

DISABLE_UPDATE_PROMPT="true"

export UPDATE_ZSH_DAYS=13
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fig=3"

alias cats="highlight -O ansi --force"

DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

plugins=(zsh-peco-history z colored-man-pages docker git mercurial tmux zsh-autosuggestions zsh-syntax-highlighting)

source ~/.work.zshrc
source $ZSH/oh-my-zsh.sh

setopt inc_append_history
setopt share_history

export ZSH=~/.oh-my-zsh

ZSH_THEME="bureau"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

plugins=(git mercurial zsh-autosuggestions zsh-syntax-highlighting)


source $ZSH/oh-my-zsh.sh

source ~/.work.zshrc

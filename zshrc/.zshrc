export SUDO_EDITOR="nvim"
export PGHOST="/var/run/postgresql"

export PATH=$PATH:/usr/local/go/bin

HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

setopt inc_append_history

autoload -Uz compinit && compinit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Shared aliases, functions and tool init (stow package: zsh-common)
[ -f ~/.config/zsh/common.zsh ] && source ~/.config/zsh/common.zsh

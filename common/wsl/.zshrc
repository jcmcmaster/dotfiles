#-------------------------------------------------------------
# PATH
#-------------------------------------------------------------
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:"mnt/c/users/JimMcMaster/onedrive - medisked/scripts/bash"
export PATH=$PATH:"${projects}/jdb/jdb/bin/Release/netcoreapp2.1/win10-x64/"

#-------------------------------------------------------------
# Oh My Zsh Conf
#-------------------------------------------------------------
[ -f ~/.ohmyzshconf ] && source ~/.ohmyzshconf

#-------------------------------------------------------------
# Variables
#-------------------------------------------------------------
[ -f ~/.globals ] && source ~/.globals

#-------------------------------------------------------------
# Functions
#-------------------------------------------------------------
[ -f ~/.functions ] && source ~/.functions

#-------------------------------------------------------------
# Aliases
#-------------------------------------------------------------
[ -f ~/.aliases ] && source ~/.aliases

#-------------------------------------------------------------
# Startup
#-------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

cd

#-------------------------------------------------------------
# Keybindings
#-------------------------------------------------------------
bindkey -v # vim editing mode in zsh
zle -N ctrlp
bindkey "^p" ctrlp

[ -f ~/.path ] && source ~/.path
[ -f ~/.ohmyzshconf ] && source ~/.ohmyzshconf
[ -f ~/.globals ] && source ~/.globals
[ -f ~/.functions ] && source ~/.functions
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.startup ] && source ~/.startup
[ -f ~/.keybindings ] && source ~/.keybindings

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

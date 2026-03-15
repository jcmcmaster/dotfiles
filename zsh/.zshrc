ZDOTDIR="${ZDOTDIR:-$HOME}"

export PATH="${HOME}/bin:${PATH}"

# nvm
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && source "${NVM_DIR}/nvm.sh"
[ -s "${NVM_DIR}/bash_completion" ] && source "${NVM_DIR}/bash_completion"

export HISTFILE="${ZDOTDIR}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

export ZSH="${HOME}/.oh-my-zsh"
export EDITOR="nvim"

ZSH_THEME=""

HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source "${ZSH}/oh-my-zsh.sh"

eval "$(oh-my-posh init zsh --config "${HOME}/.cache/oh-my-posh/themes/material.omp.json")"

# source modular config files
for config_file in aliases functions keybindings completions; do
  [[ -f "${ZDOTDIR}/${config_file}.zsh" ]] && source "${ZDOTDIR}/${config_file}.zsh"
done

# blank line between prompts
_print_blank_line() { print "" }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _print_blank_line

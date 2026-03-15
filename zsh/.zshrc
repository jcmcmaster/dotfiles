ZDOTDIR="${ZDOTDIR:-$HOME}"

typeset -U path
path=("${HOME}/.dotnet" "${HOME}/.dotnet/tools" "${HOME}/.local/bin" "${HOME}/bin" $path)

# dotnet
export DOTNET_ROOT="${HOME}/.dotnet"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# nvm
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && source "${NVM_DIR}/nvm.sh"

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

if (( $+commands[oh-my-posh] )); then
  eval "$(oh-my-posh init zsh --config "${HOME}/.cache/oh-my-posh/themes/material.omp.json")"
fi

# source modular config files
for config_file in aliases functions keybindings completions; do
  [[ -f "${ZDOTDIR}/${config_file}.zsh" ]] && source "${ZDOTDIR}/${config_file}.zsh"
done

# blank line between prompts
_print_blank_line() { print "" }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _print_blank_line

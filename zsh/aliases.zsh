alias g="git"
alias vim="nvim"
alias vi="nvim"

# Pin copilot to the WSL-native binary (not the Windows one via /mnt/c)
alias copilot="$(command -v copilot 2>/dev/null || echo copilot)"

alias cl="clear && ls"
alias cs="clear && git status"
alias sz='source "${ZDOTDIR}/.zshrc"'

alias pth='echo $PATH | tr : "\n" | less'
alias sau="sudo apt update && sudo apt upgrade"

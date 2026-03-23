alias g="git"
alias vim="nvim"
alias vi="nvim"

# Pin copilot to the WSL-native binary (not the Windows one via /mnt/c)
copilot() {
  local wsl_bin
  wsl_bin="$(whence -p copilot | grep -v '^/mnt/c' | head -1)"
  "${wsl_bin:-copilot}" "$@"
}

alias avante='nvim -c "lua vim.defer_fn(function()local ok,avante=pcall(require,\"avante.api\");if ok and avante and avante.zen_mode then avante.zen_mode()end end, 100)"'

alias cl="clear && ls"
alias cs="clear && git status"
alias sz='source "${ZDOTDIR}/.zshrc"'

alias pth='echo $PATH | tr : "\n" | less'
alias sau="sudo apt update && sudo apt upgrade"

# dotnet CLI completion
_dotnet_zsh_complete() {
  local completions=("$(dotnet complete --position $CURSOR "$BUFFER" 2>/dev/null)")
  reply=(${(ps:\n:)completions})
}
if command -v dotnet &>/dev/null; then
  compctl -K _dotnet_zsh_complete dotnet
fi

# GitHub Copilot CLI
if command -v gh &>/dev/null; then
  eval "$(gh copilot alias -- zsh)"
fi

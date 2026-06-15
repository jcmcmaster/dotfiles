# dotnet CLI completion
_dotnet_zsh_complete() {
  local completions=("$(dotnet complete --position $CURSOR "$BUFFER" 2>/dev/null)")
  reply=(${(ps:\n:)completions})
}
if command -v dotnet &>/dev/null; then
  compctl -K _dotnet_zsh_complete dotnet
fi

# Copilot aliases
if command -v copilot &>/dev/null; then
  _copilot_aliases="$(copilot completion zsh 2>/dev/null)" && eval "${_copilot_aliases}"
  unset _copilot_aliases
fi

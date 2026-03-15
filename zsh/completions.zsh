# dotnet CLI completion
_dotnet_zsh_complete() {
  local completions=("$(dotnet complete --position $CURSOR "$BUFFER" 2>/dev/null)")
  reply=(${(ps:\n:)completions})
}
if command -v dotnet &>/dev/null; then
  compctl -K _dotnet_zsh_complete dotnet
fi

# GitHub Copilot CLI aliases
if command -v gh &>/dev/null; then
  local _copilot_aliases
  _copilot_aliases="$(gh copilot alias -- zsh 2>/dev/null)" && eval "${_copilot_aliases}"
  unset _copilot_aliases
fi

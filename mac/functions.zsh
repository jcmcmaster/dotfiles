find_dir() {
  local search_path="${1:-.}"
  local depth="${2:-0}"
  find "${search_path}" -maxdepth $((depth + 1)) -type d \
    -not -path '*/node_modules/*' \
    -not -path '*/.*' \
    -not -path '*/bin/*' \
    -not -path '*/obj/*' 2>/dev/null | fzf
}

find_dir_and_go() {
  local search_path="${1:-.}"
  local depth="${2:-0}"
  local choice
  choice=$(find_dir "${search_path}" "${depth}")
  [[ -n "${choice}" ]] && cd "${choice}"
}

alias fd="find_dir_and_go"

fp() {
  find_dir_and_go "${HOME}/projects" 0
}

fdx() {
  find_dir_and_go "${HOME}/Exercism" 1
}

fdev() {
  local search_path="${1:-${HOME}/projects}"
  local depth="${2:-0}"
  local session_name="${3:-}"

  local choice
  choice=$(find_dir "${search_path}" "${depth}")
  [[ -z "${choice}" ]] && return

  [[ -z "${session_name}" ]] && session_name=$(basename "${choice}")

  osascript <<EOF
tell application "iTerm2"
  activate
  tell current window
    create tab with default profile
    set newTab to current tab
    tell current session of newTab
      write text "cd '${choice}'"
    end tell
    set nvimSess to (split vertically with default profile of current session of newTab)
    tell nvimSess
      write text "cd '${choice}' && nvim"
    end tell
    tell current session of newTab
      select
    end tell
  end tell
end tell
EOF
}

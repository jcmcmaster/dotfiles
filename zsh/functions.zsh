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

  if [[ -z "${session_name}" ]]; then
    session_name=$(basename "${choice}")
  fi

  local win_path
  win_path=$(wslpath -w "${choice}")

  wt.exe new-tab -d "${win_path}" --title "${session_name}" --suppressApplicationTitle \; \
    split-pane -d "${win_path}" --vertical --size .7 --title "${session_name}" --suppressApplicationTitle wsl.exe -e nvim \; \
    move-focus left
}

owd() {
  explorer.exe "$(wslpath -w "$(pwd)")"
}

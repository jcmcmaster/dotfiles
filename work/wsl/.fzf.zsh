# Setup fzf
# ---------
if [[ ! "$PATH" == */home/phrosty/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/phrosty/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/phrosty/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/phrosty/.fzf/shell/key-bindings.zsh"

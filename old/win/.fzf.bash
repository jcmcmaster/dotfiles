# Setup fzf
# ---------
if [[ ! "$PATH" == */c/Users/Medisked/.fzf/bin* ]]; then
  export PATH="$PATH:/c/Users/Medisked/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/c/Users/Medisked/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/c/Users/Medisked/.fzf/shell/key-bindings.bash"


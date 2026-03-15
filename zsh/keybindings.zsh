bindkey -v

# reduce mode switch delay
export KEYTIMEOUT=1

# history search with up/down in vi mode
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey -a 'k' history-beginning-search-backward
bindkey -a 'j' history-beginning-search-forward

# autosuggestion navigation (mirrors PSReadLine Ctrl+n/p/y)
bindkey '^n' autosuggest-fetch
bindkey '^p' up-line-or-history
bindkey '^y' autosuggest-accept

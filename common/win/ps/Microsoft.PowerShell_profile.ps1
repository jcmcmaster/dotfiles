# Completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# OMP Theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/material-jcm.omp.json" | Invoke-Expression

# Aliases and alias functions
function cdp { Set-Location C:\Users\jmcmaster\projects }
function d { docker }
function dc { docker-compose }
function ga { git add }
function gac ($msg) { git add -A && git commit -m $msg }
function gacp ($msg) { git add -A && git commit -m $msg && git push }
function gbl { git branch --list }
function gap { git add -p }

# `gc` is a default alias
New-Alias -Name getc -Value "Get-Command" -Force
function gc ($1) { git checkout $1}

function gcdd { git checkout -- . }

# `gcm` is a default alias
New-Alias -Name getm -Value "Get-Command" -Force
function gcm ($msg) { git commit -m $msg}

function gcmp ($msg) { git commit -m $msg && git push}
function gd ($1) { git diff $1 }
function gdd ($1) { git difftool --dir-diff --no-symlinks $1}
function gdt { git difftool }
function gf { git fetch }

# `gl` is a default alias
New-Alias -Name getl -Value "Get-Location" -Force
function gl { git log }

function gmt { git mergetool }

# `gp` is a default alias
New-Alias -Name getp -Value "Get-ItemProperty" -Force
function gp { git pull }

function gs { git status }
function gsa { git stash apply }
function gsl { git stash list }
function gsp { git stash pop }
function gtree { git log --graph --oneline --decorate }
function py { python3 }
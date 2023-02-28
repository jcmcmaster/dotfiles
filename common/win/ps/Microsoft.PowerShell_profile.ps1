# Completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# OMP Theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/material-jcm.omp.json" | Invoke-Expression

# Aliases and alias functions
function cdp { Set-Location C:\Users\jmcmaster\projects }
function d { docker @args }
function dc { docker-compose @args }
function ga { git add @args }
function gac { git add -A && git commit -m @args }
function gacp { git add -A && git commit -m @args && git push }
function gbl { git branch --list @args }
function gap { git add -p }

# `gc` is a default alias
New-Alias -Name getc -Value "Get-Command" -Force
function gc { git checkout @args }

function gcdd { git checkout -- . }

# `gcm` is a default alias
New-Alias -Name getm -Value "Get-Command" -Force
function gcm { git commit -m @args }

function gcmp { git commit -m @args && git push }
function gd { git diff @args }
function gdd { git difftool --dir-diff --no-symlinks @args }
function gdt { git difftool @args }
function gf { git fetch @args }

# `gl` is a default alias
New-Alias -Name getl -Value "Get-Location" -Force
function gl { git log @args }

function gmt { git mergetool @args }

# `gp` is a default alias
New-Alias -Name getp -Value "Get-ItemProperty" -Force
function gp { git pull @args }

function gs { git status @args }
function gsa { git stash apply @args }
function gsl { git stash list @args }
function gsp { git stash pop @args }
function gtree { git log --graph --oneline --decorate @args }
function py { python3 }
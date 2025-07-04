Import-Module Terminal-Icons

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\material.omp.json" | Invoke-Expression

if ($host.Name -eq 'ConsoleHost')
{
  Import-Module PSReadLine -ErrorAction SilentlyContinue || Install-Module PSReadLine -Force
}

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine
Set-PSReadLineKeyHandler -Key Ctrl+k -Function ForwardDeleteLine

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -EditMode Vi

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  dotnet complete --position $cursorPosition "$commandAst" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

function fp {
  $projectsDir = "$HOME\Projects"
  $projects = Get-ChildItem -Directory -Path $projectsDir | ForEach-Object FullName
  $projects += @($projectsDir)
  $target = $projects | fzf
  if ($target) {
    Set-Location $target
  }
}

function gs { & git status $args }

function ga { & git add $args }

function gaa { & git add -A $args }

function gbl { & git branch --list $args }

function gap { & git add -p $args }

Remove-Alias gc -Force -ErrorAction SilentlyContinue
function gc { & git checkout $args }

function gcdd { & git checkout -- . }

Remove-Alias gcm -Force -ErrorAction SilentlyContinue
function gcm { & git commit -m $args }

function gd { & git diff $args }

function gdd { & git difftool --dir-diff $args }

function gdc { & git diff --cached $args }

function gddc { & git difftool --dir-diff --cached $args }

function gdt { & git difftool $args }

function gf { & git fetch $args }

Remove-Alias gl -Force -ErrorAction SilentlyContinue
function gl { & git log $args }

Remove-Alias gp -Force -ErrorAction SilentlyContinue
function gp { & git pull $args }

function gsl { & git stash list }

function gsp { & git stash pop $args }

function vim { & nvim $args }

function gacp {
  & git add -A
  & git commit -m "$args"
  & git push
}

New-Alias g git

Import-Module posh-git

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

function find-dir
{
  param(
    [string]$searchPath = "."
  )
  $options = Get-ChildItem -Directory -Path $searchPath | ForEach-Object FullName
  $options += @($searchPath)
  $choice = $options | fzf
  if ($choice)
  {
    Set-Location $choice
  }
}

function fd
{
  param(
    [string]$searchPath = "."
  )
  find-dir($searchPath)
}

function fp
{
  find-dir("$HOME\Projects")
}

function fe
{
  find-dir("$HOME\Exercism")
}

function gacp
{
  & git add -A
  & git commit -m "$args"
  & git push
}

New-Alias g git

New-Alias vim nvim
New-Alias vi nvim

Import-Module posh-git

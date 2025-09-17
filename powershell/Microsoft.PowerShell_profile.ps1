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

function Find-Dir
{ 
  param(
    [string]$SearchPath = ".",
    [int]$Depth = 0
  )

  $options = Get-ChildItem -Directory -Depth $Depth -Path $SearchPath | ForEach-Object FullName
  $options += @($SearchPath)
  $options | fzf
}

function Find-Dir-And-Go
{
  param(
    [string]$SearchPath = ".",
    [int]$Depth = 0
  )
  $choice = Find-Dir -SearchPath $SearchPath -Depth $Depth
  if ($choice)
  {
    Set-Location $choice
  }
}

Set-Alias fd Find-Dir-And-Go

function fp
{
  Find-Dir-And-Go -SearchPath "$HOME\Projects" -Depth 0
}

function fdev
{
  param(
    [string]$SearchPath = ".",
    [int]$Depth = 0,
    [string]$SessionName = ""
  )
  $choice = Find-Dir -SearchPath $SearchPath
  if (-not $choice) { return }
  if (-not $SessionName) 
  { 
    $SessionName = [System.IO.Path]::GetFileName($choice)
  }
  wt new-tab --startingDirectory $choice --title $SessionName --suppressApplicationTitle `; `
    split-pane --startingDirectory $choice --vertical --size .7 --title $SessionName --suppressApplicationTitle nvim
}

New-Alias g git
Import-Module posh-git

New-Alias vim nvim
New-Alias vi nvim

. "C:\Users\jcmcmaster\OneDrive\Documents\PowerShell\gh-copilot.ps1"

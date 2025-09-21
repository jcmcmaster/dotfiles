Import-Module Terminal-Icons

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\material.omp.json" | Invoke-Expression

if ($host.Name -eq 'ConsoleHost')
{
  Import-Module PSReadLine -ErrorAction SilentlyContinue || Install-Module PSReadLine -Force

  Set-PSReadLineOption -PredictionSource HistoryAndPlugin
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd
  Set-PSReadLineOption -EditMode Vi

  Set-PSReadLineKeyHandler -Key Ctrl+n -Function NextSuggestion
  Set-PSReadLineKeyHandler -Key Ctrl+p -Function PreviousSuggestion
  Set-PSReadLineKeyHandler -Key Ctrl+y -Function Complete
}

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
  $choice = Find-Dir -SearchPath $SearchPath -Depth $Depth
  if (-not $choice)
  {
    return 
  }
  if (-not $SessionName) 
  { 
    $SessionName = [System.IO.Path]::GetFileName($choice)
  }
  wt new-tab -d $choice --title $SessionName --suppressApplicationTitle `; `
    split-pane -d $choice --vertical --size .7 --title $SessionName --suppressApplicationTitle pwsh -c nvim `; `
    move-focus left `; `
    split-pane -d $choice --horizontal --title $SessionName --suppressApplicationTitle `; `
    move-focus up
}

New-Alias g git
Import-Module posh-git

New-Alias vim nvim
New-Alias vi nvim

. "$env:OneDrive\Documents\PowerShell\gh-copilot.ps1"

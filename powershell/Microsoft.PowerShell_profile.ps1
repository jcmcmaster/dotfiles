Import-Module Terminal-Icons
Import-Module posh-git

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

function Find-Project
{
  $projectsDir = "$HOME\Projects"
  $projects = Get-ChildItem -Directory -Path $projectsDir | ForEach-Object FullName
  $projects += @($projectsDir)
  $target = $projects | fzf
  if ($target)
  {
    Set-Location $target
  }
}
Set-Alias -Name fp -Value Find-Project

function GitStatus
{
  & git status $args
}
Set-Alias -Name gs -Value GitStatus

function GitAdd
{
  & git add $args
}
Set-Alias -Name ga -Value GitAdd

function GitAddAll
{
  & git add -A $args
}
Set-Alias -Name gaa -Value GitAddAll

function GitBranchList
{
  & git branch --list $args
}
Set-Alias -Name gbl -Value GitBranchList

function GitAddPatch
{
  & git add -p $args
}
Set-Alias -Name gap -Value GitAddPatch

function GitCheckout
{
  & git checkout $args
}
Remove-Alias gc -Force -ErrorAction SilentlyContinue
Set-Alias -Name gc -Value GitCheckout

function GitCheckoutDashDashDot
{
  & git checkout -- .
}
Set-Alias -Name gcdd -Value GitCheckoutDashDashDot

function GitCommitMessage
{
  & git commit -m $args
}
Remove-Alias gcm -Force -ErrorAction SilentlyContinue
Set-Alias -Name gcm -Value GitCommitMessage

function GitDiff
{
  & git diff $args
}
Set-Alias -Name gd -Value GitDiff

function GitDiffToolDirDiff
{
  & git difftool --dir-diff $args
}
Set-Alias -Name gdd -Value GitDiffToolDirDiff

function GitDiffCached
{
  & git diff --cached $args
}
Set-Alias -Name gdc -Value GitDiffCached

function GitDiffToolDirDiffCached
{
  & git difftool --dir-diff --cached $args
}
Set-Alias -Name gddc -Value GitDiffToolDirDiffCached

function GitDiffTool
{
  & git difftool $args
}
Set-Alias -Name gdt -Value GitDiffTool

function GitFetch
{
  & git fetch $args
}
Set-Alias -Name gf -Value GitFetch

function GitLog
{
  & git log $args
}
Remove-Alias gl -Force -ErrorAction SilentlyContinue
Set-Alias -Name gl -Value GitLog

function GitPull
{
  & git pull $args
}
Remove-Alias gp -Force -ErrorAction SilentlyContinue
Set-Alias -Name gp -Value GitPull

function StashList
{
  & git stash list
}
Set-Alias -Name gsl -Value StashList

function StashPop
{
  & git stash pop $args
}
Set-Alias -Name gsp -Value StashPop

function Neovim
{
  & nvim $args
}
Set-Alias -Name vim -Value Neovim

function GitAddAllAndPush
{
  & git add -A
  & git commit -m "$args"
  & git push
}
Set-Alias -Name gacp -Value GitAddAllAndPush

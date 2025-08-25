# PowerShell Profile Configuration
# Enhanced PowerShell experience with modern tools and productivity features

# Import Terminal-Icons for better file/folder icons in ls output
Import-Module Terminal-Icons

# Initialize Oh My Posh with Material theme for enhanced prompt
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\material.omp.json" | Invoke-Expression

# Enhanced command line editing with PSReadLine
if ($host.Name -eq 'ConsoleHost')
{
  Import-Module PSReadLine -ErrorAction SilentlyContinue || Install-Module PSReadLine -Force
}

# PSReadLine key bindings for enhanced command line experience
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete              # Tab completion menu
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward # Search history backward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward # Search history forward
Set-PSReadLineKeyHandler -Key RightArrow -Function ForwardWord        # Move forward by word
Set-PSReadLineKeyHandler -Key LeftArrow -Function BackwardWord        # Move backward by word
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord   # Ctrl+Left: backward word
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord   # Ctrl+Right: forward word
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine     # Ctrl+U: delete to beginning
Set-PSReadLineKeyHandler -Key Ctrl+k -Function ForwardDeleteLine      # Ctrl+K: delete to end

# PSReadLine options for intelligent suggestions and Vi mode
Set-PSReadLineOption -PredictionSource HistoryAndPlugin               # Intelligent predictions
Set-PSReadLineOption -PredictionViewStyle ListView                    # List view for predictions
Set-PSReadLineOption -HistorySearchCursorMovesToEnd                   # Move cursor to end on search
Set-PSReadLineOption -EditMode Vi                                     # Vi keybindings

# .NET CLI completion support
# Provides intelligent tab completion for dotnet commands
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  dotnet complete --position $cursorPosition "$commandAst" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# Custom Functions for Enhanced Productivity

# find-dir: Fuzzy find and navigate to directories using fzf
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

# fd: Short alias for find-dir
function fd
{
  param(
    [string]$searchPath = "."
  )
  find-dir($searchPath)
}

# fp: Quick navigation to Projects directory
function fp
{
  find-dir("$HOME\Projects")
}

# gacp: Git add, commit, and push in one command
function gacp
{
  & git add -A
  & git commit -m "$args"
  & git push
}

# Aliases for common tools
New-Alias g git           # Short git alias
Import-Module posh-git    # Git integration for PowerShell

New-Alias vim nvim        # Use Neovim instead of Vim
New-Alias vi nvim         # Vi alias to Neovim

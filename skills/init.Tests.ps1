$ErrorActionPreference = "Stop"

function Assert-Equal($Expected, $Actual) {
  if ($Expected -cne $Actual) {
    throw "Expected '$Expected', got '$Actual'."
  }
}

# Shadow gh so tests never download skills or modify user configuration.
$calls = [System.Collections.Generic.List[string[]]]::new()
$mock = @{ ExitCode = 0 }
$previousExitCode = $global:LASTEXITCODE

$mockGh = {
  $calls.Add([string[]]$args)
  $global:LASTEXITCODE = $mock.ExitCode
}.GetNewClosure()
Set-Item Function:gh $mockGh

try {
  & "$PSScriptRoot/init.ps1"
  Assert-Equal 6 $calls.Count

  $expectedSkills = @(
    "jcmcmaster/dotfiles skills/github-pr-follow-through",
    "jcmcmaster/dotfiles skills/grill-me",
    "jcmcmaster/dotfiles skills/handoff"
  )
  $index = 0
  foreach ($skill in $expectedSkills) {
    foreach ($agent in @("github-copilot", "opencode")) {
      Assert-Equal "skill install $skill --agent $agent --scope user" ($calls[$index] -join " ")
      $index++
    }
  }
  Write-Host "PASS: installs all three skills for both agents at user scope"

  $calls.Clear()
  & "$PSScriptRoot/init.ps1" -Force
  Assert-Equal 6 $calls.Count
  for ($index = 0; $index -lt $calls.Count; $index++) {
    $skill = $expectedSkills[[int][Math]::Floor($index / 2)]
    $agent = @("github-copilot", "opencode")[$index % 2]
    Assert-Equal "skill install $skill --agent $agent --scope user --force" ($calls[$index] -join " ")
  }
  Write-Host "PASS: only overwrites when -Force is supplied"

  $calls.Clear()
  & "$PSScriptRoot/init.ps1" -WhatIf -Force
  Assert-Equal 0 $calls.Count
  Write-Host "PASS: -WhatIf does not invoke gh, even with -Force"

  $calls.Clear()
  $mock.ExitCode = 17
  $failure = $null
  try {
    & "$PSScriptRoot/init.ps1"
  }
  catch {
    $failure = $_
  }
  Assert-Equal 1 $calls.Count
  Assert-Equal "Failed to install jcmcmaster/dotfiles/skills/github-pr-follow-through for github-copilot (user scope) (gh exited with 17)." $failure.Exception.Message
  Write-Host "PASS: stops immediately and reports failed installs"

  $calls.Clear()
  $previousPath = $env:PATH
  $failure = $null
  try {
    Remove-Item Function:gh
    $env:PATH = ""
    & "$PSScriptRoot/init.ps1"
  }
  catch {
    $failure = $_
  }
  finally {
    $env:PATH = $previousPath
    Set-Item Function:gh $mockGh
  }
  Assert-Equal 0 $calls.Count
  Assert-Equal "GitHub CLI (gh) is required. Install a version with 'gh skill install' support and run 'gh auth login'." $failure.Exception.Message
  Write-Host "PASS: explains the prerequisite when gh is missing"
}
finally {
  Remove-Item Function:gh
  $global:LASTEXITCODE = $previousExitCode
}

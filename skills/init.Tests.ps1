#requires -Modules powershell-yaml

$ErrorActionPreference = "Stop"

$skills = Get-Content -LiteralPath "$PSScriptRoot/skills.yml" -Raw | ConvertFrom-Yaml
$agents = @("github-copilot", "opencode")

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
  foreach ($force in @($false, $true)) {
    $calls.Clear()
    & "$PSScriptRoot/init.ps1" -Force:$force
    Assert-Equal ($skills.Count * $agents.Count) $calls.Count

    $index = 0
    foreach ($skill in $skills) {
      foreach ($agent in $agents) {
        $expected = "skill install $($skill.repository) $($skill.skill) --agent $agent --scope user"
        if ($force) {
          $expected += " --force"
        }
        Assert-Equal $expected ($calls[$index] -join " ")
        $index++
      }
    }
    Write-Host "PASS: installs manifest skills for both agents (Force=$force)"
  }

  $calls.Clear()
  & "$PSScriptRoot/init.ps1" -WhatIf -Force
  Assert-Equal 0 $calls.Count
  Write-Host "PASS: -WhatIf does not invoke gh, even with -Force"

  if ($skills.Count -gt 0) {
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
    $first = $skills[0]
    Assert-Equal "Failed to install $($first.repository)/$($first.skill) for $($agents[0]) (user scope) (gh exited with 17)." $failure.Exception.Message
    Write-Host "PASS: stops immediately and reports failed installs"
  }

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

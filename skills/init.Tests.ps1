#requires -Modules powershell-yaml

$ErrorActionPreference = "Stop"

$skills = Get-Content -LiteralPath "$PSScriptRoot/skills.yml" -Raw | ConvertFrom-Yaml
$agents = @("github-copilot", "opencode")

function Assert-Equal($Expected, $Actual) {
  if ($Expected -cne $Actual) {
    throw "Expected '$Expected', got '$Actual'."
  }
}

# Isolate instruction links and shadow gh so tests never modify user configuration.
$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) "skills-init-tests-$([guid]::NewGuid())"
$previousCopilotHome = $env:COPILOT_HOME
$previousConfigHome = $env:XDG_CONFIG_HOME
$env:COPILOT_HOME = Join-Path $testRoot "copilot home"
$env:XDG_CONFIG_HOME = Join-Path $testRoot "config home"
$instructionTargets = @(
  (Join-Path $env:COPILOT_HOME "copilot-instructions.md"),
  (Join-Path $env:XDG_CONFIG_HOME "opencode/AGENTS.md")
)

function Assert-InstructionLinks {
  foreach ($target in $instructionTargets) {
    $link = Get-Item -LiteralPath $target -Force
    Assert-Equal "SymbolicLink" $link.LinkType
    Assert-Equal (Join-Path $PSScriptRoot "AGENTS.md") $link.Target
    Assert-Equal (Get-Content -LiteralPath "$PSScriptRoot/AGENTS.md" -Raw) (Get-Content -LiteralPath $target -Raw)
  }
}

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
    & "$PSScriptRoot/init.ps1" -WhatIf -Force:$force
    Assert-Equal 0 $calls.Count
    Assert-Equal $false (Test-Path -LiteralPath $testRoot)
  }
  Write-Host "PASS: -WhatIf does not invoke gh or create instruction directories or links"

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
    Assert-InstructionLinks
    Write-Host "PASS: installs manifest skills and links global instructions for both agents (Force=$force)"
  }

  & "$PSScriptRoot/init.ps1"
  Assert-InstructionLinks
  Write-Host "PASS: existing instruction links can be reused without -Force"

  foreach ($target in $instructionTargets) {
    Remove-Item -LiteralPath $target -Force
    Set-Content -LiteralPath $target -Value "Existing instructions"
    $failure = $null
    try {
      & "$PSScriptRoot/init.ps1"
    }
    catch {
      $failure = $_
    }
    Assert-Equal "Global instructions already exist at '$target'. Use -Force to replace them." $failure.Exception.Message
    Assert-Equal "Existing instructions" (Get-Content -LiteralPath $target)

    & "$PSScriptRoot/init.ps1" -WhatIf -Force
    Assert-Equal "Existing instructions" (Get-Content -LiteralPath $target)

    & "$PSScriptRoot/init.ps1" -Force
    Assert-InstructionLinks
  }
  Write-Host "PASS: preserves existing instruction files unless -Force is used; -WhatIf never replaces them"

  $otherInstructions = Join-Path $testRoot "other-instructions.md"
  Set-Content -LiteralPath $otherInstructions -Value "Other instructions"
  foreach ($target in $instructionTargets) {
    Remove-Item -LiteralPath $target -Force
    New-Item -ItemType SymbolicLink -Path $target -Target $otherInstructions | Out-Null
  }
  & "$PSScriptRoot/init.ps1" -Force
  Assert-InstructionLinks
  Assert-Equal "Other instructions" (Get-Content -LiteralPath $otherInstructions)
  Write-Host "PASS: replaces conflicting symlinks without modifying their targets"

  Remove-Item -LiteralPath $otherInstructions
  foreach ($target in $instructionTargets) {
    Remove-Item -LiteralPath $target -Force
    New-Item -ItemType SymbolicLink -Path $target -Target $otherInstructions | Out-Null
  }
  $failure = $null
  try {
    & "$PSScriptRoot/init.ps1"
  }
  catch {
    $failure = $_
  }
  Assert-Equal "Global instructions already exist at '$($instructionTargets[0])'. Use -Force to replace them." $failure.Exception.Message
  & "$PSScriptRoot/init.ps1" -Force
  Assert-InstructionLinks
  Write-Host "PASS: detects dangling instruction links and replaces them only with -Force"

  foreach ($target in $instructionTargets) {
    Remove-Item -LiteralPath $target -Force
    New-Item -ItemType Directory -Path $target | Out-Null
    $failure = $null
    try {
      & "$PSScriptRoot/init.ps1" -Force
    }
    catch {
      $failure = $_
    }
    Assert-Equal "Cannot replace global instructions at '$target': it is a directory." $failure.Exception.Message
    Assert-Equal $true (Test-Path -LiteralPath $target -PathType Container)
    Remove-Item -LiteralPath $target
    & "$PSScriptRoot/init.ps1"
  }
  Write-Host "PASS: never replaces directories, even with -Force"

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
  $env:COPILOT_HOME = $previousCopilotHome
  $env:XDG_CONFIG_HOME = $previousConfigHome
  if (Test-Path -LiteralPath $testRoot) {
    Remove-Item -LiteralPath $testRoot -Recurse -Force
  }
}

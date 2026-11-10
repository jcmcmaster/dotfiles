#requires -Modules powershell-yaml

[CmdletBinding(SupportsShouldProcess)]
param(
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$skills = Get-Content -LiteralPath "$PSScriptRoot/skills.yml" -Raw | ConvertFrom-Yaml
if ($skills -isnot [System.Collections.IList]) {
  throw "skills.yml must contain a list of repository/skill pairs."
}
foreach ($skill in $skills) {
  if ($skill -isnot [System.Collections.IDictionary] -or
      [string]::IsNullOrWhiteSpace($skill.repository) -or
      [string]::IsNullOrWhiteSpace($skill.skill)) {
    throw "Each entry in skills.yml must specify repository and skill."
  }
}

$agents = @("github-copilot", "opencode")

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI (gh) is required. Install a version with 'gh skill install' support and run 'gh auth login'."
}

foreach ($skill in $skills) {
  foreach ($agent in $agents) {
    $installArguments = @(
      "skill", "install", $skill.repository, $skill.skill,
      "--agent", $agent, "--scope", "user"
    )

    if ($Force) {
      $installArguments += "--force"
    }

    $target = "$($skill.repository)/$($skill.skill) for $agent (user scope)"
    if ($PSCmdlet.ShouldProcess($target, "Install skill")) {
      & gh @installArguments
      if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $target (gh exited with $LASTEXITCODE)."
      }
    }
  }
}

$instructions = Join-Path $PSScriptRoot "AGENTS.md"
$copilotHome = if ($env:COPILOT_HOME) { $env:COPILOT_HOME } else { Join-Path $HOME ".copilot" }
$configHome = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path $HOME ".config" }
$instructionTargets = @(
  (Join-Path $copilotHome "copilot-instructions.md"),
  (Join-Path $configHome "opencode/AGENTS.md")
)

foreach ($target in $instructionTargets) {
  $existing = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
  if ($existing -and $existing.LinkType -eq "SymbolicLink" -and $existing.Target -eq $instructions) {
    continue
  }
  if ($existing -and $existing.PSIsContainer) {
    throw "Cannot replace global instructions at '$target': it is a directory."
  }
  if ($existing -and -not $Force) {
    throw "Global instructions already exist at '$target'. Use -Force to replace them."
  }

  if ($PSCmdlet.ShouldProcess($target, "Symlink global instructions to $instructions")) {
    New-Item -ItemType Directory -Path (Split-Path -Path $target -Parent) -Force -Confirm:$false | Out-Null
    New-Item -ItemType SymbolicLink -Path $target -Target $instructions -Force:$Force -Confirm:$false | Out-Null
  }
}

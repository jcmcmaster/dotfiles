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

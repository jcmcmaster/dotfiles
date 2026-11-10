[CmdletBinding(SupportsShouldProcess)]
param(
  [switch]$Force
)

$ErrorActionPreference = "Stop"

# Add repository/skill pairs here. Exact paths avoid scanning entire repositories.
$skills = @(
  @{ Repository = "jcmcmaster/dotfiles"; Skill = "skills/github-pr-follow-through" },
  @{ Repository = "jcmcmaster/dotfiles"; Skill = "skills/grill-me" },
  @{ Repository = "jcmcmaster/dotfiles"; Skill = "skills/handoff" }
)

$agents = @("github-copilot", "opencode")

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI (gh) is required. Install a version with 'gh skill install' support and run 'gh auth login'."
}

foreach ($skill in $skills) {
  foreach ($agent in $agents) {
    $installArguments = @(
      "skill", "install", $skill.Repository, $skill.Skill,
      "--agent", $agent, "--scope", "user"
    )

    if ($Force) {
      $installArguments += "--force"
    }

    $target = "$($skill.Repository)/$($skill.Skill) for $agent (user scope)"
    if ($PSCmdlet.ShouldProcess($target, "Install skill")) {
      & gh @installArguments
      if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $target (gh exited with $LASTEXITCODE)."
      }
    }
  }
}

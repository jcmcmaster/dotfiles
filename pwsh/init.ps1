$packages = @(
  "astral-sh.uv",
  "BurntSushi.ripgrep.MSVC",
  "Chocolatey.Chocolatey",
  "Docker.DockerDesktop",
  "Git.Git",
  "GitHub.cli",
  "Gleam.Gleam"
  "JanDeDobbeleer.OhMyPosh",
  "jqlang.jq",
  "junegunn.fzf",
  "Meld.Meld",
  "microsoft.azd",
  "Microsoft.AzureCLI"
  "Microsoft.PowerShell",
  "Neovim.Neovim",
  "Obsidian.Obsidian",
  "OpenJS.NodeJS",
  "Postman.Postman",
  "Python.Python.3.13",
  "zig.zig"
)

winget install --accept-package-agreements $packages

# not available via winget
choco install watchexec -y

uv tool install "vectorcode<1.0.0"
uv tool update-shell

npm install -g @github/copilot

gh auth login --web
gh extension install github/gh-copilot --force
$GH_COPILOT_PROFILE = Join-Path -Path $(Split-Path -Path $PROFILE -Parent) -ChildPath "gh-copilot.ps1"
gh copilot alias -- pwsh | Out-File ( New-Item -Path $GH_COPILOT_PROFILE -Force )

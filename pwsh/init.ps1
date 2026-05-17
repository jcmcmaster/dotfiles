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

gh auth login --web

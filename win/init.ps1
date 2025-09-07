$packages = @(
  "BurntSushi.ripgrep.MSVC",
  "Docker.DockerDesktop",
  "Git.Git",
  "GitHub.cli",
  "JanDeDobbeleer.OhMyPosh",
  "jqlang.jq",
  "junegunn.fzf",
  "Meld.Meld",
  "microsoft.azd",
  "Microsoft.PowerShell",
  "Neovim.Neovim",
  "Obsidian.Obsidian",
  "Postman.Postman",
  "zig.zig"
)

foreach ($pkg in $packages)
{
  winget install $pkg -e
}

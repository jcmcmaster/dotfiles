$packages = @(
  "BurntSushi.ripgrep.MSVC",
  "Docker.DockerDesktop",
  "Git.Git",
  "GitHub.cli",
  "JanDeDobbeleer.OhMyPosh",
  "Meld.Meld",
  "Microsoft.PowerShell",
  "Neovim.Neovim",
  "Obsidian.Obsidian",
  "Postman.Postman",
  "junegunn.fzf",
  "zig.zig"
)

foreach ($pkg in $packages)
{
  winget install $pkg -e
}

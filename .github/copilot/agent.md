# Agent Instructions

## Git Workflow

Use **trunk-based development** against `master`. Never commit directly to `master`.

- Create **feature branches** for each logical unit of work (e.g., `feat/zsh-core`, `fix/nvim-lsp`)
- Push the branch and **raise a PR** for review
- When work spans multiple PRs, **stack branches** (each based on the previous) and note dependencies in PR descriptions
- Always respond to PR review comments — reply to each thread explaining what was fixed or why feedback was declined
- Use conventional commit messages: `feat:`, `fix:`, `docs:`, `refactor:`, etc.

## PR Operations

- Before pushing, merge `master` into the feature branch to keep it up to date
- After addressing review feedback, commit and push the fixes, then reply to each comment thread
- After every push to a PR, poll for new review feedback and address it iteratively until there are no unresolved comments
- When creating PRs, include a summary table of changes and note any dependencies on other PRs

## Bootstrap Scripts

### `zsh/init.sh` — Linux/WSL bootstrap

Idempotent script for fresh Ubuntu/WSL installs. Safe to re-run. Installs:

| Category | Tools |
|----------|-------|
| apt packages | zsh, fzf, ripgrep, curl, wget, git, build-essential, unzip |
| Neovim | Latest stable from GitHub releases (supports `--force` for upgrades) |
| .NET SDK | Latest LTS via `dotnet-install.sh` to `~/.dotnet` (needed for csharp_ls, fsautocomplete) |
| nvm + Node | nvm + Node LTS (needed for Copilot CLI, Mason LSP servers) |
| Oh My Zsh | Framework + zsh-syntax-highlighting, zsh-autosuggestions plugins |
| GitHub CLI | `gh` from official apt repo |
| Copilot CLI | `@github/copilot` via npm |
| Oh My Posh | Prompt theme engine to `~/.local/bin` |

Also configures: `ZDOTDIR` via `~/.zshenv`, `~/.gitconfig` symlink, nvim config symlink, default shell to zsh.

When adding a new tool dependency (e.g., a new Mason LSP server that needs a runtime), add the install step to this script and ensure the runtime's bin directory is on PATH in both `init.sh` and `.zshrc`.

### `win/init.ps1` — Windows bootstrap

Installs dev tools via **winget** (primary) and **Chocolatey** (fallback). Includes Neovim, Git, Node, Python, Oh My Posh, GitHub CLI, and other dev tools. Does not currently install .NET SDK — add via winget if needed.

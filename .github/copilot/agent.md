# Agent Instructions

Active development is on `nix/`. The flake exports two independent outputs: `homeConfigurations` (standalone Home Manager for user profile) and `darwinConfigurations` (nix-darwin for system-level). Prefer declarative changes there over ad hoc setup elsewhere.

## User involvement — read this first

The user wants to understand and approve every non-trivial decision in this repo.

- **Propose before implementing.** For anything structural — adding a tool, changing a workflow, reorganising files — explain what you're thinking and why, then wait for approval.
- **Explain your reasoning.** Don't just make a change; say what it does and why it's the right call.
- **Ask when uncertain.** If there are multiple reasonable approaches, surface them. Don't pick one silently.
- **Never merge a PR.** The user merges everything.
- Small, obvious fixes (typos, broken paths, stale docs) can proceed without asking. Everything else: ask first.

## Collaboration expectations

- Keep commits small and focused on a single coherent change.
- Use conventional commit messages: `feat:`, `fix:`, `docs:`, `refactor:`, etc.
- Favor small, composable changes that are easy to review.

## Git Workflow

Use **trunk-based development** with `master` as the trunk, but do all work on feature branches. Never commit or push directly to `master`. Every change must go through a PR.

- Create **feature branches** for each logical unit of work (e.g., `feat/nix-packages`, `fix/nvim-lsp`)
- Push the branch and **raise a PR** for review before the work is considered complete
- Branch naming: `feat/<feature>`, `fix/<issue>`, `docs/<topic>`, `chore/<task>`
- **Do not rebase or force-push when addressing PR feedback.** Make separate commits for each fix. PRs are squash-merged.

## PR Operations

- Before pushing, merge `master` into the feature branch to keep it up to date
- **Use file-based input for PR bodies.** Write the body to a temp file and pass via `gh pr create --body-file`. Do not pass markdown inline — shells mangle backticks and special characters.
- The user reviews every PR before merge. Do not merge PRs without explicit user approval, and never bypass the PR flow with a direct commit to `master`.

## Post-push PR verification

After every push to a PR branch, verify the PR is healthy before considering the work done:

1. **Check CI and review status.** Use `gh pr checks --watch <PR_NUMBER>` to wait for CI, then inspect any Copilot code review for unresolved threads.
2. **Address all review feedback.** For each unresolved thread: fix, commit, push, reply with the commit SHA.
   - **Copilot threads:** Resolve via GraphQL `resolveReviewThread` after replying.
   - **Human threads:** Reply but **do not resolve** — let the reviewer do it.
3. **Iterate until clean.**

## Bootstrap Scripts

### `zsh/init.sh` — Linux/WSL bootstrap

Idempotent script for fresh Ubuntu/WSL installs. Safe to re-run. Installs:

| Category | Tools |
|----------|-------|
| apt packages | zsh, fzf, ripgrep, curl, wget, git, build-essential, unzip |
| Neovim | Latest stable from GitHub releases (supports `--force` for upgrades) |
| .NET SDK | Latest LTS via `dotnet-install.sh` to `~/.dotnet` (needed for csharp_ls, fsautocomplete) |
| nvm + Node | nvm + Node LTS (needed for Mason LSP servers) |
| Oh My Zsh | Framework + zsh-syntax-highlighting, zsh-autosuggestions plugins |
| GitHub CLI | `gh` from official apt repo |
| Azure CLI | From Microsoft's apt repo |
| Terraform | From HashiCorp's apt repo |
| GitHub CLI Copilot | Built-in `gh copilot` subcommand |
| Oh My Posh | Prompt theme engine to `~/.local/bin` |

Also configures: `ZDOTDIR` via `~/.zshenv`, `~/.gitconfig` symlink, nvim config symlink, default shell to zsh.

When adding a new tool dependency, add the install step to this script and ensure the runtime's bin directory is on PATH in both `init.sh` and `.zshrc`.

### `pwsh/init.ps1` — Windows bootstrap

Installs dev tools via **winget**: Neovim, Git, Node, Python, Oh My Posh, GitHub CLI, Docker, uv, zig, Gleam, Azure CLI, and others. Uses Chocolatey as a fallback for tools not on winget. Then wires up the built-in `gh copilot` aliases for PowerShell.

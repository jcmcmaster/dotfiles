# Agent Instructions

Active development is on `nix/`. Prefer declarative changes there over ad hoc setup elsewhere.

## Collaboration expectations

- Keep commits small and focused on a single coherent change.
- Use conventional commit messages: `feat:`, `fix:`, `docs:`, `refactor:`, etc.
- Favor small, composable changes that are easy to review.

## Git Workflow

Use **trunk-based development** against `master`. Never commit directly to `master`.

- Create **feature branches** for each logical unit of work (e.g., `feat/nix-packages`, `fix/nvim-lsp`)
- Push the branch and **raise a PR** for review
- Branch naming: `feat/<feature>`, `fix/<issue>`, `docs/<topic>`, `chore/<task>`
- **Do not rebase or force-push when addressing PR feedback.** Make separate commits for each fix. PRs are squash-merged.

## PR Operations

- Before pushing, merge `master` into the feature branch to keep it up to date
- **Use file-based input for PR bodies.** Write the body to a temp file and pass via `gh pr create --body-file`. Do not pass markdown inline — shells mangle backticks and special characters.
- The user reviews every PR before merge. Do not merge PRs without explicit user approval.

## Post-push PR verification

After every push to a PR branch, verify the PR is healthy before considering the work done:

1. **Run the verification script.** Use `scripts/wait-for-pr-reviews.sh <PR_NUMBER>` to wait for CI checks and Copilot code review, then check for unresolved review threads. It:
   - Waits for CI check runs via `gh pr checks --watch` (skips if no CI configured).
   - Polls for the "Copilot code review" workflow run and watches it to completion.
   - Queries unresolved review threads via GraphQL and reports them.
   - Exits 0 if clean, 1 if unresolved threads, 2 if CI failed, 3 if thread query failed.
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
| nvm + Node | nvm + Node LTS (needed for Copilot CLI, Mason LSP servers) |
| Oh My Zsh | Framework + zsh-syntax-highlighting, zsh-autosuggestions plugins |
| GitHub CLI | `gh` from official apt repo |
| Azure CLI | From Microsoft's apt repo |
| Terraform | From HashiCorp's apt repo |
| Copilot CLI | `@github/copilot` via npm |
| Oh My Posh | Prompt theme engine to `~/.local/bin` |

Also configures: `ZDOTDIR` via `~/.zshenv`, `~/.gitconfig` symlink, nvim config symlink, default shell to zsh.

When adding a new tool dependency, add the install step to this script and ensure the runtime's bin directory is on PATH in both `init.sh` and `.zshrc`.

### `pwsh/init.ps1` — Windows bootstrap

Installs dev tools via **winget**: Neovim, Git, Node, Python, Oh My Posh, GitHub CLI, Docker, uv, zig, Gleam, Azure CLI, and others. Uses Chocolatey as a fallback for tools not on winget. Also installs the Copilot CLI via npm.

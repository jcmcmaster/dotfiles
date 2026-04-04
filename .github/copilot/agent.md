# Agent Instructions

## Collaboration expectations

- Keep commits small and focused on a single coherent change.
- Use conventional commit messages: `feat:`, `fix:`, `docs:`, `refactor:`, etc.
- Favor small, composable changes that are easy to review.

## Git Workflow

Use **trunk-based development** against `master`. Never commit directly to `master`.

- Create **feature branches** for each logical unit of work (e.g., `feat/zsh-core`, `fix/nvim-lsp`)
- Push the branch and **raise a PR** for review
- When work spans multiple PRs, **stack branches** (each based on the previous) and note dependencies in PR descriptions
- Branch naming: `feat/<feature>`, `fix/<issue>`, `docs/<topic>`, `chore/<task>`
- **Do not rebase or force-push when addressing PR feedback.** Make separate commits for each fix so the review history is visible. PRs are squash-merged, so feature branch commit history does not need to be clean.

## PR Operations

- Before pushing, merge `master` into the feature branch to keep it up to date
- When creating PRs, include a summary of changes and note any dependencies on other PRs
- **Use file-based input for PR bodies.** Write the body to a temporary file and pass it via `gh pr create --body-file` or `gh api -F body=@file`. Do not pass markdown inline — shells mangle backticks and special characters.
- The user reviews every PR before merge. Do not merge PRs without explicit user approval.

## Post-push PR verification

After every push to a PR branch, verify the PR is healthy before considering the work done:

1. **Run the verification script.** Use `scripts/wait-for-pr-reviews.sh <PR_NUMBER>` to wait for CI checks and Copilot code review, then check for unresolved review threads. The script:
   - Waits for all CI check runs to complete via `gh pr checks --watch`.
   - Polls for the "Copilot code review" workflow run matching the PR's head SHA, then watches it until completion (default timeout: 5 minutes, configurable with `--timeout`). CI checks also have a timeout (default: 10 minutes, configurable with `--ci-timeout`).
   - Queries unresolved review threads via GraphQL (up to 100 threads per PR) and reports them.
   - Exits 0 if clean, 1 if unresolved threads exist, 2 if CI failed, 3 if the thread query failed.
2. **Address all review feedback.** For each unresolved review thread: fix the issue, commit, push, and reply to the comment thread explaining what changed and referencing the commit SHA.
   - **Copilot review threads:** After replying, resolve the thread using the GraphQL `resolveReviewThread` mutation so it collapses in the PR timeline.
   - **Human review threads:** Reply with the fix explanation but **do not resolve** the thread. The reviewer will resolve it after confirming the fix.
3. **Iterate until clean.** Each fix-and-push cycle triggers new CI runs and may trigger new reviews. Repeat steps 1–2 until all checks pass, all Copilot review threads are resolved, and all human review threads have been replied to.

This applies to every push — initial PR creation, feedback fixes, and follow-up commits alike.

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

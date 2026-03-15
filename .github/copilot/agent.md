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

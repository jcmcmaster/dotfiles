---
applyTo: "skills/**"
---

# Skill installer maintenance

- When adding, removing, renaming, or moving a skill (`skills/**/SKILL.md`),
  update the `$skills` repository/path list in `skills/init.ps1` in the same
  change. Also update entries when their installation source or version changes.
  Content-only skill edits do not require installer changes.
- Keep `skills/init.Tests.ps1` expectations and call counts, and the Agent Skills
  section in `README.md`, in sync with the install list and behavior.
- Preserve installs for both `github-copilot` and `opencode` at user scope,
  `-WhatIf`, opt-in overwrites with `-Force`, and fail-fast error handling unless
  the user explicitly requests a change.
- Verify a skill works with the selected list before switching its source.
  Keep this repo's self-contained `grill-me` copy unless its upstream alias's
  dependency on `grilling` is explicitly handled.
- Validate from the repository root with
  `pwsh -NoProfile -File ./skills/init.Tests.ps1` and
  `pwsh -NoProfile -File ./skills/init.ps1 -WhatIf`.
  Use mocks or temporary destinations for install tests; do not install or
  overwrite the user's skills just to validate changes.

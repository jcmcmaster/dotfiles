---
applyTo: "skills/**"
---

# Skill installer maintenance

- Update `skills/skills.yml` when adding, removing, renaming, or moving skills.
- Keep installer behavior, tests, and the README's Agent Skills section in sync.
- Run `pwsh -NoProfile -File ./skills/init.Tests.ps1`; do not install user skills for tests.

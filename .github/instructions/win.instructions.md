---
description: 'Windows configuration and bootstrap'
applyTo: 'win/**'
---

# Windows Configuration

- **`init.ps1`** — Bootstraps a Windows dev environment using **winget** (primary) and **Chocolatey** (fallback). Installs ~21 winget packages plus additional tools via choco, uv, npm, and gh. Does not currently install .NET SDK — add via winget if needed.
- **`.gitconfig`** — Short aliases for frequent operations (`a`, `c`, `d`, `s`, `b`, `l`) and composite aliases for workflows (`acp` = add all + commit + push). Diff/merge tool is **Meld**.
- **`.ideavimrc`** — Vim keybindings for JetBrains IDEs. Shares some Neovim leader key categories (`<leader>f*` for find, `<leader>t*` for test) but adapts others for IDE-specific actions (e.g., `<leader>b*` is Build/Rebuild/Clean vs Buffers in Neovim).

---
description: 'Neovim configuration conventions'
applyTo: 'nvim/**'
---

# Neovim Configuration

Cross-platform — works on both Windows (PowerShell) and Linux/WSL (ZSH). Built on **lazy.nvim** with a modular Lua architecture:

- `init.lua` → bootstraps `lua/config/lazy.lua`
- `lua/config/` — core settings split by concern:
  - `lazy.lua` — lazy.nvim bootstrap and plugin spec loading
  - `opts.lua` — editor options (indentation, search, clipboard, shell)
  - `maps.lua` — global keybindings
  - `auto.lua` — autocommands (format-on-save for ~15 filetypes)
- `lua/plugins/` — one file per plugin concern (lsp, completion, ai, git, etc.)

## Conventions

- **Plugin files return a table** (or list of tables) per lazy.nvim spec format.
- **Lazy load everything** — use `event`, `cmd`, `ft`, or `keys` to defer loading.
- **Leader key categories** follow a mnemonic grouping:
  - `<leader>l*` — LSP (format, rename, actions)
  - `<leader>f*` — Find/browse (files, grep, buffers)
  - `<leader>t*` — Testing (neotest)
  - `<leader>a*` — AI (Copilot, CodeCompanion)
  - `<leader>b*` — Buffers
- **Format-on-save** is configured via `BufWritePre` autocommands in `auto.lua`. When adding a new filetype, add it to the existing pattern list there.
- **LSP servers** are installed via Mason. The server list lives in `plugins/lsp.lua` inside the `ensure_installed` table.
- **UI borders** use `'rounded'` style consistently (LSP hover, signature help, completion).
- **Platform detection** — `opts.lua` detects Windows and configures PowerShell as the shell; on Linux/WSL it uses the system default. Preserve this cross-platform awareness when editing.

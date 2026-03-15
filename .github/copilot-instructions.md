# Copilot Instructions

## Repository Overview

This is a Windows-focused dotfiles repository managing configurations for Neovim, PowerShell, ZSH (WSL), Windows Terminal, Git, JetBrains IDEs (IdeaVim), and a QMK keyboard layout. There are no build/test/lint commands — this is a pure configuration repo deployed via symlinks.

The `archive/` directory contains legacy Linux configs that are no longer actively maintained. Focus work on the active top-level directories.

## Neovim Configuration (`nvim/`)

Built on **lazy.nvim** with a modular Lua architecture:

- `init.lua` → bootstraps `lua/config/lazy.lua`
- `lua/config/` — core settings split by concern:
  - `lazy.lua` — lazy.nvim bootstrap and plugin spec loading
  - `opts.lua` — editor options (indentation, search, clipboard, shell)
  - `maps.lua` — global keybindings
  - `auto.lua` — autocommands (format-on-save for ~15 filetypes)
- `lua/plugins/` — one file per plugin concern (lsp, completion, ai, git, etc.)

### Conventions

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
- **Platform detection** — `opts.lua` detects Windows and configures PowerShell as the shell. On Linux/WSL it uses the system default. Preserve this cross-platform awareness when editing.

## ZSH Configuration (`zsh/`)

Modular ZSH setup for Ubuntu/WSL using **Oh My Zsh** + **Oh My Posh** (material theme). Uses `ZDOTDIR` to load config directly from the repo — only `~/.zshenv` is needed in the home directory.

- `.zshrc` — main config: Oh My Zsh framework, Oh My Posh prompt, sources modular files
- `aliases.zsh`, `functions.zsh`, `keybindings.zsh`, `completions.zsh` — modular config files
- `init.sh` — bootstrap script for fresh WSL installs

### Conventions

- **ZDOTDIR must be defaulted** at the top of `.zshrc` (e.g., `ZDOTDIR="${ZDOTDIR:-$HOME}"`) since it's used for all path construction.
- **Use `add-zsh-hook`** instead of defining hook functions directly (e.g., `precmd`).
- **Use single quotes for aliases** that reference variables to defer expansion to runtime.
- **fzf functions** (`fd`, `fp`, `fdx`, `fdev`) mirror the PowerShell profile equivalents.
- **`fdev`** uses `wt.exe` from WSL for Windows Terminal tab+split management.

## PowerShell Profile (`powershell/`)

- Uses **Oh My Posh** (Material theme) for prompt styling and **PSReadLine in Vi mode**.
- Custom functions `fd`/`fdx`/`fp`/`fdev` use **fzf** for fuzzy directory navigation.
- Aliases: `g` → git, `vim`/`vi` → nvim.
- Sources a GitHub Copilot CLI script from the user's OneDrive Documents folder.

## Windows Init Script (`win/init.ps1`)

Bootstraps a Windows dev environment using **winget** (primary) and **Chocolatey** (fallback for packages not in winget). Installs ~21 winget packages plus additional tools via choco, uv, npm, and gh. Add new tools here following the existing patterns.

## Git Config (`win/.gitconfig`)

Uses short aliases for frequent operations (`a`, `c`, `d`, `s`, `b`, `l`) and composite aliases for workflows (`acp` = add all + commit + push). Diff/merge tool is **Meld**.

## IdeaVim Config (`win/.ideavimrc`)

Vim keybindings for JetBrains IDEs. Shares some Neovim leader key categories (`<leader>f*` for find, `<leader>t*` for test) but adapts others for IDE-specific actions (e.g., `<leader>b*` is Build/Rebuild/Clean in IdeaVim vs Buffers in Neovim). Custom commands are defined with `:command` for IDE actions.

## Deployment

Configs are deployed by **symlinking** from this repo to their expected system locations. On WSL, `zsh/init.sh` handles bootstrap and symlinks. For Windows, symlink manually or adapt the pattern from `archive/symlinkers/`.

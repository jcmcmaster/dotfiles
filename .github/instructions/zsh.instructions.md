---
description: 'ZSH configuration conventions and bootstrap'
applyTo: 'zsh/**'
---

# ZSH Configuration

Modular ZSH setup for Linux/WSL using **Oh My Zsh** + **Oh My Posh** (material theme). Uses `ZDOTDIR` to load config directly from the repo — only `~/.zshenv` is needed in the home directory.

- `.zshrc` — main config: Oh My Zsh framework, Oh My Posh prompt, sources modular files
- `aliases.zsh`, `functions.zsh`, `keybindings.zsh`, `completions.zsh` — modular config files
- `init.sh` — bootstrap script for fresh Linux/WSL installs

## Conventions

- **ZDOTDIR must be defaulted** at the top of `.zshrc` (e.g., `ZDOTDIR="${ZDOTDIR:-$HOME}"`) since it's used for all path construction.
- **Use `add-zsh-hook`** instead of defining hook functions directly (e.g., `precmd`).
- **Use single quotes for aliases** that reference variables to defer expansion to runtime.
- **fzf functions** (`fd`, `fp`, `fdx`, `fdev`) mirror the PowerShell profile equivalents.
- **`fdev`** uses `wt.exe` from WSL for Windows Terminal tab+split management.

## Bootstrap (`init.sh`)

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

Also configures: `ZDOTDIR` via `~/.zshenv`, nvim config symlink, default shell to zsh.

When adding a new tool dependency (e.g., a new Mason LSP server that needs a runtime), add the install step to this script and ensure the runtime's bin directory is on PATH in both `init.sh` and `.zshrc`.

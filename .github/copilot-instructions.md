# Copilot Instructions

## Repository Overview

Cross-platform dotfiles for macOS, Windows, and WSL/Linux. Configs are organized by the program they configure. Active development is on the macOS Nix config (`nix/`). There are no build/test/lint commands — this is a pure configuration repo.

| Directory | Platform | What it configures |
|---|---|---|
| `nix/` | macOS | nix-darwin + Home Manager: Fish shell, Starship prompt, packages, system settings |
| `nvim/` | All | Neovim — shared across all platforms |
| `pwsh/` | Windows | PowerShell profile + winget bootstrap script |
| `zsh/` | WSL/Linux | ZSH config + full bootstrap script |
| `wezterm/` | macOS | WezTerm terminal emulator |
| `wt/` | Windows | Windows Terminal settings |
| `idea/` | Windows | IdeaVim config for JetBrains IDEs |
| `archive/` | — | Legacy configs, not maintained |

## Deployment

| Platform | Method |
|---|---|
| macOS | `sudo darwin-rebuild switch --flake nix/#default --impure` (nix-darwin manages everything) |
| WSL/Linux | `zsh/init.sh` — installs tools and symlinks `.gitconfig` + `nvim/` into place |
| Windows | Symlink manually: `$PROFILE`, `$LOCALAPPDATA\nvim`, WT settings, `.ideavimrc` |

## Cross-platform consistency

The same patterns are implemented on every platform: vi keybindings, fzf-based directory navigation (`fd`/`fp`/`fdx`/`fdev`), the same git aliases, Neovim as the editor, and GitHub Copilot CLI. Changes that affect these shared patterns should be considered for all platforms.

## User involvement

The user must approve all non-trivial decisions. **Propose before implementing** anything structural — new tools, config reorganisation, workflow changes. Ask; don't assume.

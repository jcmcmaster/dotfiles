# dotfiles

Cross-platform dotfiles managing configurations for Neovim, PowerShell (Windows), ZSH (WSL), Fish (macOS via Nix), WezTerm, Windows Terminal, Git, and IdeaVim. Active development is on `nix/`.

## Quick Start

### macOS (nix-darwin + Home Manager)

```bash
# Install Nix if needed: https://nixos.org/download
git clone https://github.com/jcmcmaster/dotfiles ~/Projects/dotfiles
cd ~/Projects/dotfiles/nix
sudo darwin-rebuild switch --flake .#default --impure
```

The flake reads `SUDO_USER` via `builtins.getEnv` (hence `--impure`) so the config isn't tied to a specific user. Fish, Neovim, and dev tools are managed declaratively via Home Manager.

If you're behind a **corporate TLS inspection proxy**, see [Corporate SSL/TLS Setup](#corporate-ssltls-setup) before installing LSP servers or other tools.

### Windows (PowerShell)

```powershell
git clone https://github.com/jcmcmaster/dotfiles $HOME\Projects\dotfiles

# Install tools via winget
& $HOME\Projects\dotfiles\pwsh\init.ps1

# Symlink configs to their expected locations:
# - PowerShell profile → $PROFILE
# - Neovim config     → $env:LOCALAPPDATA\nvim
# - Windows Terminal   → WT settings path
# - .ideavimrc         → $HOME\.ideavimrc
```

### Ubuntu / WSL (ZSH)

```bash
git clone https://github.com/jcmcmaster/dotfiles ~/projects/dotfiles
chmod +x ~/projects/dotfiles/zsh/init.sh
~/projects/dotfiles/zsh/init.sh
exec zsh
```

The init script installs zsh, Oh My Zsh, Oh My Posh, Neovim, fzf, Azure CLI, Terraform, and plugins. It sets up `~/.zshenv` with `ZDOTDIR` pointing to the repo, symlinks `~/.gitconfig`, and symlinks the Neovim config.

## Structure

| Directory | Purpose |
|-----------|---------|
| `nix/` | nix-darwin + Home Manager config for macOS (Fish, Starship, packages, system settings) |
| `nvim/` | Neovim config (cross-platform, Lua) |
| `pwsh/` | PowerShell profile and Windows init script |
| `zsh/` | ZSH config for WSL (Oh My Zsh + Oh My Posh, vi mode, fzf) |
| `wezterm/` | WezTerm terminal config |
| `wt/` | Windows Terminal settings |
| `idea/` | IdeaVim config (`.ideavimrc`) |
| `archive/` | Legacy configs (no longer actively maintained) |

## ZSH Configuration (`zsh/`)

Modular ZSH setup for Ubuntu/WSL using **Oh My Zsh** as the framework and **Oh My Posh** (material theme) for the prompt.

### How it works

Uses ZSH's `ZDOTDIR` feature — a single `~/.zshenv` file sets `ZDOTDIR=~/projects/dotfiles/zsh`, and ZSH loads `.zshrc` and all config from the repo directory. No other files need to live in `~`.

### Files

| File | Purpose |
|------|---------|
| `.zshrc` | Main config: Oh My Zsh + Oh My Posh prompt, sources modular files |
| `.gitconfig` | Linux/WSL Git config with aliases, editor, credential helper, and difftool/mergetool setup |
| `aliases.zsh` | `g`→git, `vim`/`vi`→nvim, common shell aliases |
| `functions.zsh` | fzf directory navigation (`fd`, `fp`, `fdx`, `fdev`) |
| `keybindings.zsh` | Vi mode, Ctrl+n/p/y for autosuggestion navigation |
| `completions.zsh` | dotnet CLI + GitHub Copilot CLI completions |
| `init.sh` | Bootstrap script (installs everything, sets up symlinks) |

### Key functions

- **`fd [path] [depth]`** — Fuzzy find a directory and `cd` into it
- **`fp`** — Fuzzy find in `~/projects` and `cd` into it
- **`fdx`** — Fuzzy find in `~/Exercism` and `cd` into it
- **`fdev [path] [depth] [name]`** — Fuzzy find a directory, then open a Windows Terminal tab with a vertical split running nvim

## Neovim Configuration (`nvim/`)

Uses Neovim's **built-in package manager** (`vim.pack`, Neovim 0.11+) with no external plugin manager. Files in `nvim/plugin/` are auto-sourced at startup in numeric order.

| File | Purpose |
|------|---------|
| `plugin/01_opt.lua` | Editor options (indentation, search, display) |
| `plugin/02_map.lua` | Global keybindings and leader key setup |
| `plugin/03_auto.lua` | Autocommands (format-on-save, etc.) |
| `plugin/10_mini.lua` | mini.nvim suite (statusline, files, fuzzy find) |
| `plugin/11_color.lua` | Colorscheme |
| `plugin/12_git.lua` | Git integration |
| `plugin/13_treesitter.lua` | Treesitter syntax and highlighting |
| `plugin/14_lsp.lua` | LSP servers via Mason + nvim-lspconfig |
| `plugin/15_ai.lua` | AI tools (Copilot) |
| `plugin/16_markdown.lua` | Markdown rendering |
| `plugin/17_test.lua` | Test runner (neotest) |
| `plugin/20_completion.lua` | Completion (nvim-cmp) |
| `nvim-pack-lock.json` | Plugin lock file (pinned commits) |

## PowerShell Profile (`pwsh/`)

- **Oh My Posh** (material theme) for prompt styling
- **PSReadLine** in Vi mode with history predictions
- fzf directory navigation (`fd`, `fp`, `fdx`, `fdev`)
- Aliases: `g`→git, `vim`/`vi`→nvim
- `init.ps1` installs tools via winget: Neovim, Git, Node, Python, Oh My Posh, GitHub CLI, Docker, uv, zig, Gleam, Azure CLI, and more

## Deployment

Configs are deployed via **symlinks** from this repo to their expected system locations. `zsh/init.sh` handles this for WSL, including `~/.gitconfig` and `~/.config/nvim`. For Windows, symlink manually. On macOS, nix-darwin and Home Manager handle all config placement declaratively.

## Corporate SSL/TLS Setup

If you're on a corporate network with a **TLS inspection proxy** (e.g., Zscaler, Netskope), tools like curl, Mason, npm, and pip will fail with SSL errors.

### Fix

1. **Extract the proxy's root CA** from a live connection:

   ```bash
   echo | openssl s_client -connect github.com:443 -showcerts 2>/dev/null \
     | awk '/-----BEGIN CERTIFICATE-----/{n++} n==2' > ~/.corporate-ca.pem

   # Verify — subject and issuer should match your company's proxy CA:
   openssl x509 -in ~/.corporate-ca.pem -noout -subject -issuer
   ```

   > **Tip:** The proxy CA may differ from the general corporate root CA in your Keychain. Always extract from a live connection.

2. **Build a combined CA bundle:**

   ```bash
   cat /etc/ssl/certs/ca-certificates.crt > ~/.combined-ca-bundle.pem
   echo "" >> ~/.combined-ca-bundle.pem
   cat ~/.corporate-ca.pem >> ~/.combined-ca-bundle.pem
   ```

3. **Restart your terminal** and verify:

   ```bash
   curl -sS -o /dev/null -w "%{http_code}" https://api.github.com
   # Should print: 200
   ```

The env vars pointing tools at `~/.combined-ca-bundle.pem` are already configured in `nix/home.nix` (Fish `interactiveShellInit`). Rebuild the combined bundle after any `darwin-rebuild switch` that updates the Nix CA bundle or if your company rotates its proxy CA.

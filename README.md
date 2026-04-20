# dotfiles

Cross-platform dotfiles managing configurations for Neovim, PowerShell (Windows), ZSH (WSL), Fish (macOS via Nix), Windows Terminal, Git, and IdeaVim.

## Quick Start

### Windows (PowerShell)

```powershell
# Clone the repo
git clone https://github.com/jcmcmaster/dotfiles $HOME\projects\dotfiles

# Run the Windows init script (installs tools via winget/choco)
& $HOME\projects\dotfiles\win\init.ps1

# Symlink configs to their expected locations:
# - PowerShell profile → $PROFILE
# - Neovim config     → $env:LOCALAPPDATA\nvim
# - Windows Terminal   → WT settings path
# - .gitconfig         → $HOME\.gitconfig
# - .ideavimrc         → $HOME\.ideavimrc
```

### Ubuntu / WSL (ZSH)

```bash
# Clone the repo
git clone https://github.com/jcmcmaster/dotfiles ~/projects/dotfiles

# Run the bootstrap script
chmod +x ~/projects/dotfiles/zsh/init.sh
~/projects/dotfiles/zsh/init.sh

# Restart your terminal (or: exec zsh)
```

The init script installs zsh, Oh My Zsh, Oh My Posh, Neovim, fzf, and plugins. It sets up `~/.zshenv` with `ZDOTDIR` pointing to the repo, symlinks `~/.gitconfig`, and symlinks the Neovim config — so only bootstrap-managed files need to live in `~`.

### macOS (nix-darwin + Home Manager)

```bash
# Install Nix (if not already installed)
# See https://nixos.org/download

# Clone the repo
git clone https://github.com/jcmcmaster/dotfiles ~/Projects/dotfiles

# Build and activate (uses $USER for config parameterization)
cd ~/Projects/dotfiles/nix
sudo darwin-rebuild switch --flake .#default --impure
```

The Nix flake uses `builtins.getEnv` (requires `--impure`) to read the current username so the config isn't tied to a specific machine or user. Fish shell, Neovim, and dev tools are all managed declaratively via Home Manager.

If you're behind a **corporate TLS inspection proxy**, see [Corporate SSL/TLS Setup](#corporate-ssltls-setup) below before installing LSP servers or other tools that download from the internet.

## Structure

| Directory | Purpose |
|-----------|---------|
| `nvim/` | Neovim config (cross-platform, Lua) |
| `nix/` | nix-darwin + Home Manager config for macOS (Fish, packages, system settings) |
| `powershell/` | PowerShell profile (Oh My Posh, PSReadLine vi mode, fzf) |
| `zsh/` | ZSH config for WSL (Oh My Zsh + Oh My Posh, vi mode, fzf) |
| `win/` | Windows init script, `.gitconfig`, `.ideavimrc` |
| `wt/` | Windows Terminal settings |
| `keyboard/` | QMK keyboard layout |
| `archive/` | Legacy Linux configs (no longer actively maintained) |

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
- **`fdev [path] [depth] [name]`** — Fuzzy find a directory, then open a Windows Terminal tab with a vertical split running nvim (mirrors the PowerShell `fdev` function)

## Neovim Configuration (`nvim/`)

Built on **lazy.nvim** with a modular Lua architecture. Cross-platform — works on both Windows (PowerShell) and WSL (ZSH).

- `init.lua` → bootstraps `lua/config/lazy.lua`
- `lua/config/` — `opts.lua`, `maps.lua`, `auto.lua`
- `lua/plugins/` — one file per plugin concern (lsp, completion, ai, git, etc.)

Platform detection in `opts.lua` configures PowerShell as the shell on Windows; on Linux/WSL it uses the system default.

## PowerShell Profile (`powershell/`)

- **Oh My Posh** (material theme) for prompt styling
- **PSReadLine** in Vi mode with history predictions
- fzf directory navigation (`fd`, `fp`, `fdx`, `fdev`)
- Aliases: `g`→git, `vim`/`vi`→nvim

## Deployment

Configs are deployed via **symlinks** from this repo to their expected system locations. The `zsh/init.sh` script handles this for WSL, including `~/.gitconfig` and `~/.config/nvim`. For Windows, symlink manually or adapt the pattern from `archive/symlinkers/`. On macOS, nix-darwin and Home Manager handle all config placement declaratively.

## Corporate SSL/TLS Setup

If you're on a corporate network with a **TLS inspection proxy** (e.g., Zscaler, Netskope), tools like curl, Mason, npm, and pip will fail with SSL errors. The proxy re-signs HTTPS traffic with a corporate CA that isn't in the Nix certificate bundle.

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

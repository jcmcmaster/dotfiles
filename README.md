# dotfiles

Cross-platform dotfiles managing configurations for Neovim, PowerShell (Windows), ZSH (WSL/Linux), macOS (iTerm2), Windows Terminal, Git, and IdeaVim.

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

### macOS (iTerm2 + ZSH)

```bash
# Clone the repo
git clone https://github.com/jcmcmaster/dotfiles ~/projects/dotfiles

# Run the bootstrap script
chmod +x ~/projects/dotfiles/mac/init.sh
~/projects/dotfiles/mac/init.sh

# Restart your terminal (or: exec zsh)
```

The init script installs Homebrew packages, Oh My Zsh, Oh My Posh, Neovim, fzf, and plugins. It sets up `~/.zshenv` with `ZDOTDIR` pointing to `mac/`, symlinks `~/.gitconfig`, and symlinks the Neovim config.

After running init, import the iTerm2 profile:
1. **Preferences → Profiles → Other Actions → Import JSON Profiles** → select `mac/iterm2/Default.json`
2. Set the imported profile as default.

## Structure

| Directory | Purpose |
|-----------|---------|
| `nvim/` | Neovim config (lazy.nvim, Lua, cross-platform) |
| `mac/` | macOS ZSH config + iTerm2 profile (Oh My Zsh, Oh My Posh, fzf) |
| `powershell/` | PowerShell profile (Oh My Posh, PSReadLine vi mode, fzf) |
| `zsh/` | ZSH config for WSL (Oh My Zsh + Oh My Posh, vi mode, fzf) |
| `win/` | Windows init script, `.gitconfig`, `.ideavimrc` |
| `wt/` | Windows Terminal settings |
| `keyboard/` | QMK keyboard layout |
| `archive/` | Legacy Linux configs (no longer actively maintained) |

## Mac Configuration (`mac/`)

Modular ZSH setup for macOS using **Oh My Zsh** + **Oh My Posh** (material theme), identical in structure to `zsh/`.

### Files

| File | Purpose |
|------|---------|
| `.zshrc` | Main config: Homebrew PATH, Oh My Zsh + Oh My Posh, sources modular files |
| `.gitconfig` | macOS Git config (same aliases as WSL, uses `osxkeychain` credential helper) |
| `aliases.zsh` | `g`→git, `vim`/`vi`→nvim, `owd`→`open .`, `brew-up` for updates |
| `functions.zsh` | fzf directory navigation (`fd`, `fp`, `fdx`, `fdev`) |
| `keybindings.zsh` | Vi mode, Ctrl+n/p/y for autosuggestion navigation |
| `completions.zsh` | dotnet CLI + GitHub Copilot CLI completions |
| `init.sh` | Bootstrap script (Homebrew, tools, Oh My Zsh, symlinks) |
| `iterm2/` | iTerm2 color scheme and importable profile |

### Key functions

- **`fd [path] [depth]`** — Fuzzy find a directory and `cd` into it
- **`fp`** — Fuzzy find in `~/projects` and `cd` into it
- **`fdx`** — Fuzzy find in `~/Exercism` and `cd` into it
- **`fdev [path] [depth] [name]`** — Fuzzy find a directory, then open an iTerm2 tab with a vertical split running nvim (mirrors the PowerShell and WSL `fdev` function)

### iTerm2 Config (`mac/iterm2/`)

| File | Purpose |
|------|---------|
| `GitHub Dark.itermcolors` | GitHub Dark color scheme (import via Preferences → Profiles → Colors → Color Presets → Import) |
| `Default.json` | Full iTerm2 profile: FiraCode Nerd Font, GitHub Dark, 120×40 window, all key bindings from Windows Terminal translated |

**Key bindings** mirror Windows Terminal exactly:
- `shift+enter` → send ESC+Enter (useful in Neovim)
- `ctrl+shift+t` → new tab
- `ctrl+shift+w` → close pane
- `ctrl+home/end/pgup/pgdn` → move focus between panes
- `ctrl+shift+pgdn/pgup/home/end` → split pane down/up/left/right
- `alt+home/end` → previous/next tab
- `alt+shift+pgup/pgdn/home/end` → scroll up/down page/top/bottom

> **Mac keyboard note**: Home/End/PgUp/PgDn require Fn+arrows on laptop keyboards.

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

Configs are deployed via **symlinks** from this repo to their expected system locations. The `zsh/init.sh` script handles this for WSL, including `~/.gitconfig` and `~/.config/nvim`. For Windows, symlink manually or adapt the pattern from `archive/symlinkers/`.

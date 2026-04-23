# dotfiles

Cross-platform dotfiles. Configurations for macOS (Nix), Windows (PowerShell), and WSL/Linux (ZSH), with a shared Neovim config.

Active development is on the macOS Nix config. Everything is organized by the program it configures.

---

## What's Shared Across Platforms

The following work the same on all three platforms:

| Thing | macOS | Windows | WSL/Linux |
|---|---|---|---|
| Editor | Neovim | Neovim | Neovim |
| Vi bindings | Fish (vi mode) | PSReadLine vi | zsh vi mode |
| Prompt | Starship | Oh My Posh (material) | Oh My Posh (material) |
| Fuzzy nav | `fd`, `fp`, `fdx`, `fdev` | `fd`, `fp`, `fdx`, `fdev` | `fd`, `fp`, `fdx`, `fdev` |
| Git aliases | `g`, `acp`, `cm`, `d`, `dc`… | `g`, `acp`, `cm`, `d`, `dc`… | `g`, `acp`, `cm`, `d`, `dc`… |
| AI assistant | Copilot CLI + Neovim | Copilot CLI + Neovim | Copilot CLI + Neovim |

**Fuzzy nav functions** (`fd`/`fp`/`fdx`/`fdev`) use fzf to jump into directories. `fdev` opens the chosen directory in a terminal split with Neovim running alongside. Implemented independently in Fish, ZSH, and PowerShell.

---

## Quick Start

### macOS — Home Manager (standalone) + optional nix-darwin

```bash
# Install Nix first if needed: https://nixos.org/download
git clone https://github.com/jcmcmaster/dotfiles ~/Projects/dotfiles
cd ~/Projects/dotfiles/nix
```

**User profile** (packages, shell, git, programs — no sudo):

```bash
# First run (home-manager not yet on PATH):
nix run home-manager -- switch --flake .#default --impure

# Subsequent runs:
home-manager switch --flake .#default --impure
```

**System-level** (Homebrew casks, Fish login shell — only when needed):

```bash
# First run (darwin-rebuild not yet on PATH):
sudo nix run nix-darwin -- switch --flake .#default --impure

# Subsequent runs:
sudo darwin-rebuild switch --flake .#default --impure
```

`--impure` is required: the flake reads `$USER` / `$SUDO_USER` at eval time to avoid hardcoding a username.

> **Apple Silicon only.** The flake hardcodes `system = "aarch64-darwin"`. It will not evaluate on Intel Macs without modification.

> **Corporate proxy?** See [Corporate SSL/TLS Setup](#corporate-ssltls-setup) before running any Nix commands.

### Windows — PowerShell

```powershell
git clone https://github.com/jcmcmaster/dotfiles $HOME\Projects\dotfiles

# Install tools (winget + a few extras)
& $HOME\Projects\dotfiles\pwsh\init.ps1

# Symlink manually:
#   $PROFILE                         → pwsh/Microsoft.PowerShell_profile.ps1
#   $env:LOCALAPPDATA\nvim           → nvim/
#   Windows Terminal settings path   → wt/settings.json
#   $HOME\.ideavimrc                 → idea/.ideavimrc
```

### WSL / Ubuntu — ZSH

```bash
git clone https://github.com/jcmcmaster/dotfiles ~/projects/dotfiles
chmod +x ~/projects/dotfiles/zsh/init.sh
~/projects/dotfiles/zsh/init.sh
exec zsh
```

The bootstrap script handles everything: installs tools, sets ZSH as default, and symlinks `~/.gitconfig` and `~/.config/nvim` into the repo.

---

## Repository Layout

```
dotfiles/
├── nix/          macOS system + user environment (nix-darwin, Home Manager)
├── nvim/         Neovim config — cross-platform, pure Lua
├── pwsh/         PowerShell profile + Windows bootstrap script
├── zsh/          ZSH config + WSL bootstrap script
├── wezterm/      WezTerm terminal emulator config
├── wt/           Windows Terminal settings
├── idea/         IdeaVim config for JetBrains IDEs
└── archive/      Legacy configs, not maintained
```

---

## Neovim (`nvim/`)

Single config, runs everywhere. Uses Neovim's **built-in `vim.pack`** as the plugin manager — no lazy.nvim or packer.

Plugin files live in `nvim/plugin/` and are auto-sourced alphabetically at startup. They're numbered to enforce load order:

| Phase | Files | Purpose |
|---|---|---|
| `0*` | `01_opt`, `02_map`, `03_auto` | Options, keymaps, autocommands |
| `1*` | `10_mini` … `17_test` | Individual plugins |
| `2*` | `20_completion` | Higher-order plugins (wrap others) |

### Plugins

| Category | What |
|---|---|
| **UI** | Rose Pine colorscheme, mini.nvim (statusline, tabline, file explorer, icons) |
| **Fuzzy finding** | mini.pick (ripgrep-backed) — `<leader>f*` for files, grep, git, buffers, diagnostics |
| **Syntax** | Treesitter with 38 language parsers; AST-based text objects (`af/if`, `ac/ic`, `al/il`) |
| **LSP** | Mason + nvim-lspconfig; 16 servers: Bash, Bicep, C#, CSS, Docker, ESLint, F#, GraphQL, HTML, JSON, XML, Lua, PowerShell, Python, Vimscript, YAML |
| **Completion** | nvim-cmp; sources: Copilot → LSP → snippets → buffer → paths |
| **AI** | copilot.lua (inline) + CodeCompanion (chat via Copilot) |
| **Git** | Neogit (`<leader>gg`) + Diffview (side-by-side diffs, merge tool) |
| **Tests** | Neotest + neotest-vstest (C#/.NET) |
| **Markdown** | render-markdown.nvim (renders in-buffer) |
| **Editing** | mini.surround, mini.comment, mini.ai (text objects), mini.snippets + friendly-snippets |

### Key bindings (selected)

| Keys | Action |
|---|---|
| `<leader>ff` / `<leader>fg` | Find files / live grep |
| `<leader>ef` | Open file explorer |
| `gd` / `gi` / `gr` | LSP: definition / implementation / references |
| `K` | LSP hover |
| `<leader>lr` / `<leader>la` | Rename / code action |
| `ge` / `gE` | Next / previous diagnostic |
| `<leader>gg` | Open Neogit |
| `<leader>ac` / `<leader>ai` | AI chat / AI inline |
| `<leader>tf` / `<leader>tr` | Run file tests / nearest test |

Format on save is enabled for: Bicep, C#, F#, Gleam, JSON, Lua, Markdown, PowerShell, SQL, Terraform, YAML.

Lock file: `nvim-pack-lock.json` pins exact plugin commits for reproducible installs.

---

## macOS — Nix (`nix/`)

Declarative macOS setup with two independent paths:

- **Home Manager (standalone)** — manages the user profile: packages, shell, prompt, git, programs. Run with `home-manager switch` (no sudo).
- **nix-darwin** — manages system-level concerns only: Fish login shell, Homebrew casks, Determinate Nix compat. Run with `sudo darwin-rebuild switch` when needed.

The flake exports both `homeConfigurations` and `darwinConfigurations`. They are independent — Home Manager is **not** wired through nix-darwin.

```
nix/
├── flake.nix         Inputs (nixpkgs-unstable, nix-darwin, home-manager) + dual outputs
├── configuration.nix System-level only: user, Fish login shell, Homebrew, Determinate Nix compat
├── home.nix          User-level: packages, shell, prompt, git, programs
└── nix.conf          Enable flakes + nix-command
```

**Shell:** Fish with vi key bindings, zoxide (`cd → z`), fzf integration.

**Prompt:** Starship with `nerd-font-symbols` preset.

**Packages (selected):**

| Dev tools | CLI utilities | Desktop |
|---|---|---|
| GitHub CLI, Copilot CLI | ripgrep, fd, bat, jq, yq | WezTerm |
| Terraform | curl, wget, htop, tree | Chrome, Obsidian, Spotify |
| Mise (runtime versions) | — | Raycast, Rectangle |
| JetBrains Rider | — | Keeper (Homebrew cask) |

**Git** is configured declaratively in `home.nix`: user info, openpgp signing, and all aliases match the other platforms.

**Corporate SSL/TLS:** If `~/.corporate-ca.pem` exists, `home.nix` automatically injects `~/.combined-ca-bundle.pem` into `NIX_SSL_CERT_FILE`, `SSL_CERT_FILE`, and `GIT_SSL_CAINFO`, and sets `NODE_EXTRA_CA_CERTS` to `~/.corporate-ca.pem`. See [Corporate SSL/TLS Setup](#corporate-ssltls-setup).

---

## ZSH — WSL/Linux (`zsh/`)

**Oh My Zsh** as the plugin framework. **Oh My Posh** (material theme) for the prompt.

Config is loaded via ZSH's `ZDOTDIR` — a single `~/.zshenv` points ZSH at the repo, so nothing else needs to live in `~`.

| File | Purpose |
|---|---|
| `.zshrc` | Main entry: OMZ, Oh My Posh, sources the modules below |
| `aliases.zsh` | `g`→git, `vi`/`vim`→nvim, `acp`, `cl`, `cs`, `sz`, etc. |
| `functions.zsh` | `fd`, `fp`, `fdx`, `fdev`, `owd` (open in Explorer) |
| `keybindings.zsh` | Vi mode, `^n/^p/^y` for autosuggestions |
| `completions.zsh` | dotnet CLI + GitHub Copilot CLI tab completions |
| `.gitconfig` | Git: user, aliases, nvim as editor, Windows credential manager |
| `init.sh` | Full WSL bootstrap — see below |

### `init.sh` — What it installs

| Category | Tools |
|---|---|
| APT | zsh, fzf, ripgrep, curl, wget, git, build-essential, unzip, gnupg |
| Editor | Neovim (latest stable, from GitHub releases) |
| Runtimes | .NET SDK (LTS), nvm + Node LTS |
| Shell | Oh My Zsh, zsh-syntax-highlighting, zsh-autosuggestions, Oh My Posh |
| Cloud | GitHub CLI, Azure CLI, Terraform |
| AI | GitHub Copilot CLI (via npm) |

Also sets up: `ZDOTDIR` via `~/.zshenv`, `~/.gitconfig` symlink, `~/.config/nvim` symlink, default shell → zsh.

Idempotent — safe to re-run. Use `--force` to reinstall Neovim, `--upgrade` to also run `apt upgrade`.

---

## PowerShell — Windows (`pwsh/`)

**Oh My Posh** (material theme) + **posh-git** for the prompt. **PSReadLine** in vi mode.

### `Microsoft.PowerShell_profile.ps1`

| Feature | Detail |
|---|---|
| Prompt | Oh My Posh, material theme; Terminal-Icons for file icons |
| Editing | PSReadLine vi mode; `^n/^p` next/prev suggestion, `^y` accept |
| Git | posh-git module; `g` alias |
| Navigation | `fd`, `fp`, `fdx`, `fdev` — mirrors the ZSH/Fish implementations |
| Editor | `vim`/`vi` → nvim |
| Completions | dotnet CLI argument completer; Copilot CLI aliases |
| `fdev` | Finds a directory via fzf, opens Windows Terminal with a vertical split: folder pane + Neovim |

### `init.ps1` — What it installs (winget)

Docker, Neovim, Git, Node, Python 3.13, GitHub CLI, Oh My Posh, fzf, ripgrep, jq, Azure CLI, Azure Developer CLI, uv, zig, Gleam, Obsidian, Postman, Meld, PowerShell 7+, Chocolatey. Plus: `watchexec` (choco), `vectorcode` (uv), Copilot CLI (npm), `gh-copilot` extension.

---

## WezTerm (`wezterm/`)

Terminal emulator config for macOS. Lua-based.

- **Colorscheme:** Rose Pine (matches Neovim)
- **Default shell:** Fish (resolved from Nix profile path)
- **Font size:** 12; **Max FPS:** 120
- **Leader:** `Ctrl+A`
- **Startup:** Centered window, 70% of screen size
- **Pane keybindings:** `Ctrl+Home/End/PgUp/PgDn` to navigate; `Shift+…` to resize; `Ctrl+Shift+End/PgDn` to split; `Opt+Home/End` for tabs

---

## Windows Terminal (`wt/`)

Settings file for Windows Terminal. Covers custom keybindings for pane splitting, tab navigation, focus movement, and pane swapping — mirrors the WezTerm pane model on Windows.

---

## IdeaVim (`idea/`)

`.ideavimrc` for JetBrains IDEs (Rider, etc.). Space as leader — same as Neovim.

Key bindings map JetBrains actions to familiar vim motions:

| Keys | Action |
|---|---|
| `gd` / `gi` / `gy` | Declaration / Implementation / Symbol |
| `gr` / `ge` / `gE` | References / Next error / Prev error |
| `K` | Hover info |
| `<leader>ff` / `<leader>fg` | Goto file / Find in path |
| `<leader>r` / `<leader>ca` | Rename / Intentions |
| `<leader>cf` | Reformat |
| `<leader>ta` / `<leader>tc` | Run all tests / Run context tests |
| `<leader>bb` / `<leader>br` | Build / Rebuild solution |
| `<C-h>` / `<C-l>` | Previous / Next tab |
| `<leader>zm` | Zen mode |
| `<leader><leader>` | AceAction (jump) |

Also sets: relative line numbers, clipboard=unnamed, commentary, ideajoin, hlsearch/incsearch.

---

## Deployment

| Platform | How configs get deployed |
|---|---|
| macOS | `home-manager switch` for user profile; `sudo darwin-rebuild switch` for system-level (Homebrew, login shell) |
| WSL/Linux | `zsh/init.sh` symlinks `.gitconfig` and `nvim/` into place |
| Windows | Symlink manually from the repo to `$PROFILE`, `$LOCALAPPDATA\nvim`, etc. |

---

## Corporate SSL/TLS Setup

On a network with TLS inspection (Zscaler, Netskope, etc.), Nix, Mason, npm, and pip will fail with certificate errors. The proxy re-signs traffic with a corporate CA that isn't in system trust stores.

### Fix

**1. Extract the proxy's root CA:**

```bash
echo | openssl s_client -connect github.com:443 -showcerts 2>/dev/null \
  | awk '/-----BEGIN CERTIFICATE-----/{n++} n==2' > ~/.corporate-ca.pem

# Verify the subject/issuer look like your corporate proxy CA:
openssl x509 -in ~/.corporate-ca.pem -noout -subject -issuer
```

> The proxy CA often differs from the general corporate root CA in Keychain. Always extract from a live connection.

**2. Build a combined bundle:**

```bash
cat /etc/ssl/certs/ca-certificates.crt > ~/.combined-ca-bundle.pem
echo "" >> ~/.combined-ca-bundle.pem
cat ~/.corporate-ca.pem >> ~/.combined-ca-bundle.pem
```

**3. Verify:**

```bash
curl -sS -o /dev/null -w "%{http_code}" https://api.github.com
# 200
```

`nix/home.nix` automatically detects `~/.corporate-ca.pem` and injects `~/.combined-ca-bundle.pem` into `NIX_SSL_CERT_FILE`, `SSL_CERT_FILE`, and `GIT_SSL_CAINFO`. `NODE_EXTRA_CA_CERTS` is set to `~/.corporate-ca.pem` directly. Rebuild the bundle after any `darwin-rebuild switch` that updates the Nix CA store, or when your company rotates its proxy CA.

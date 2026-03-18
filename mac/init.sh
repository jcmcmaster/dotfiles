#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
MAC_DIR="${DOTFILES_DIR}/mac"

echo "=== Mac + Oh My Zsh + Oh My Posh Bootstrap ==="
echo "  Dotfiles: ${DOTFILES_DIR}"
echo "  Mac dir:  ${MAC_DIR}"
echo ""

# ── Homebrew ───────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed: $(brew --version | head -1)"
fi

# ── Homebrew packages ──────────────────────────────────────────────
echo "Installing brew packages..."
brew install \
  zsh \
  fzf \
  ripgrep \
  curl \
  wget \
  git \
  gh \
  neovim \
  azure-cli \
  terraform

# ── FiraCode Nerd Font ─────────────────────────────────────────────
if ! brew list --cask font-fira-code-nerd-font &>/dev/null; then
  echo "Installing FiraCode Nerd Font..."
  brew install --cask font-fira-code-nerd-font
else
  echo "FiraCode Nerd Font already installed."
fi

# ── iTerm2 ─────────────────────────────────────────────────────────
if ! brew list --cask iterm2 &>/dev/null; then
  echo "Installing iTerm2..."
  brew install --cask iterm2
else
  echo "iTerm2 already installed."
fi

# ── Neovim (via brew, already installed above) ─────────────────────
echo "Neovim: $(nvim --version | head -1)"

# ── .NET SDK (for csharp_ls / fsautocomplete LSP servers) ──────────
export DOTNET_ROOT="${HOME}/.dotnet"
export PATH="${DOTNET_ROOT}:${PATH}"

if ! command -v dotnet &>/dev/null; then
  echo "Installing .NET SDK (latest LTS)..."
  curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS --install-dir "${DOTNET_ROOT}"
  echo ".NET SDK installed: $(dotnet --version)"
else
  echo ".NET SDK already installed: $(dotnet --version)"
fi

# ── nvm (Node Version Manager) ─────────────────────────────────────
if [[ ! -d "${HOME}/.nvm" ]]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE=/dev/null bash
  export NVM_DIR="${HOME}/.nvm"
  [ -s "${NVM_DIR}/nvm.sh" ] && source "${NVM_DIR}/nvm.sh"
  echo "Installing latest Node LTS..."
  nvm install --lts
else
  echo "nvm already installed."
  export NVM_DIR="${HOME}/.nvm"
  [ -s "${NVM_DIR}/nvm.sh" ] && source "${NVM_DIR}/nvm.sh"
  if ! command -v node &>/dev/null; then
    echo "Node not found — installing latest LTS..."
    nvm install --lts
  fi
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed."
fi

# ── Oh My Zsh plugins ─────────────────────────────────────────────
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi

if [[ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi

# ── GitHub Copilot CLI ─────────────────────────────────────────────
if ! command -v copilot &>/dev/null; then
  echo "Installing GitHub Copilot CLI..."
  npm install -g @github/copilot
  echo "Copilot CLI installed: $(copilot --version)"
else
  echo "Copilot CLI already installed: $(copilot --version)"
fi

# ── Oh My Posh ─────────────────────────────────────────────────────
if ! command -v oh-my-posh &>/dev/null; then
  echo "Installing Oh My Posh..."
  brew install jandedobbeleer/oh-my-posh/oh-my-posh
else
  echo "Oh My Posh already installed: $(oh-my-posh --version)"
fi

# Download themes if not present
if [[ ! -f "${HOME}/.cache/oh-my-posh/themes/material.omp.json" ]]; then
  echo "Downloading Oh My Posh themes..."
  mkdir -p "${HOME}/.cache/oh-my-posh/themes"
  oh-my-posh get themes --path "${HOME}/.cache/oh-my-posh/themes" 2>/dev/null || true
fi

# ── ZDOTDIR setup (~/.zshenv) ──────────────────────────────────────
echo "Setting up ZDOTDIR in ~/.zshenv..."
if [[ -f "${HOME}/.zshenv" ]]; then
  echo "  Backing up existing ~/.zshenv to ~/.zshenv.bak"
  cp "${HOME}/.zshenv" "${HOME}/.zshenv.bak"
fi
echo "export ZDOTDIR=\"${MAC_DIR}\"" > "${HOME}/.zshenv"

# ── Git config symlink ─────────────────────────────────────────────
GITCONFIG_TARGET="${MAC_DIR}/.gitconfig"
if [[ -L "${HOME}/.gitconfig" && "$(readlink "${HOME}/.gitconfig")" == "${GITCONFIG_TARGET}" ]]; then
  echo "Git config symlink already correct."
else
  echo "Symlinking Git config..."
  if [[ -L "${HOME}/.gitconfig" ]]; then
    rm "${HOME}/.gitconfig"
  elif [[ -e "${HOME}/.gitconfig" ]]; then
    echo "  Backing up existing ~/.gitconfig to ~/.gitconfig.bak"
    mv "${HOME}/.gitconfig" "${HOME}/.gitconfig.bak"
  fi
  ln -s "${GITCONFIG_TARGET}" "${HOME}/.gitconfig"
fi

# ── Neovim config symlink ─────────────────────────────────────────
echo "Symlinking Neovim config..."
mkdir -p "${HOME}/.config"
if [[ -L "${HOME}/.config/nvim" ]]; then
  rm "${HOME}/.config/nvim"
elif [[ -d "${HOME}/.config/nvim" ]]; then
  echo "  Backing up existing nvim config to ~/.config/nvim.bak"
  mv "${HOME}/.config/nvim" "${HOME}/.config/nvim.bak"
fi
ln -s "${DOTFILES_DIR}/nvim" "${HOME}/.config/nvim"

# ── iTerm2 profile import ─────────────────────────────────────────
echo ""
echo "iTerm2 setup:"
echo "  1. Open iTerm2 → Preferences → Profiles → Other Actions → Import JSON Profiles"
echo "     Import: ${MAC_DIR}/iterm2/Default.json"
echo "  2. Open iTerm2 → Preferences → Profiles → Colors → Color Presets → Import"
echo "     Import: ${MAC_DIR}/iterm2/GitHub Dark.itermcolors"
echo "  3. Set the imported profile as default."

# ── Set ZSH as default shell ──────────────────────────────────────
ZSH_PATH="$(brew --prefix)/bin/zsh"
if [[ "$(basename "$SHELL")" != "zsh" ]] || [[ "$SHELL" != "${ZSH_PATH}" ]]; then
  echo "Setting Homebrew ZSH as default shell..."
  if ! grep -qF "${ZSH_PATH}" /etc/shells; then
    echo "${ZSH_PATH}" | sudo tee -a /etc/shells
  fi
  chsh -s "${ZSH_PATH}" || echo "  chsh failed — run manually: chsh -s ${ZSH_PATH}"
else
  echo "ZSH is already the default shell."
fi

echo ""
echo "=== Setup complete! ==="
echo ""
echo "What was set up:"
echo "  ~/.zshenv          → points ZDOTDIR to ${MAC_DIR}"
echo "  ~/.gitconfig       → symlinked to ${MAC_DIR}/.gitconfig"
echo "  ~/.config/nvim     → symlinked to ${DOTFILES_DIR}/nvim"
echo "  oh-my-zsh          → ${HOME}/.oh-my-zsh"
echo "  oh-my-posh         → $(command -v oh-my-posh 2>/dev/null || echo 'not found')"
echo "  gh                 → $(command -v gh 2>/dev/null || echo 'not found')"
echo "  az                 → $(command -v az 2>/dev/null || echo 'not found')"
echo "  terraform          → $(command -v terraform 2>/dev/null || echo 'not found')"
echo "  copilot            → $(command -v copilot 2>/dev/null || echo 'not found')"
echo "  nvm                → ${HOME}/.nvm"
echo "  dotnet             → $(command -v dotnet 2>/dev/null || echo 'not found')"
echo ""
echo "Restart your terminal or run: exec zsh"

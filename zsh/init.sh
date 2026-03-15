#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ZSH_DIR="${DOTFILES_DIR}/zsh"

echo "=== ZSH + Oh My Zsh + Oh My Posh Bootstrap ==="
echo "  Dotfiles: ${DOTFILES_DIR}"
echo "  ZSH dir:  ${ZSH_DIR}"
echo ""

# ── Prerequisites via apt ──────────────────────────────────────────
echo "Installing apt packages..."
sudo apt update -y && sudo apt install -y \
  zsh \
  fzf \
  ripgrep \
  curl \
  wget \
  git \
  build-essential \
  unzip

# ── Neovim (latest stable from GitHub releases) ───────────────────
if ! command -v nvim &>/dev/null; then
  echo "Installing Neovim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm nvim-linux-x86_64.tar.gz
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  echo "Neovim installed."
else
  echo "Neovim already installed: $(nvim --version | head -1)"
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

# ── Oh My Posh ─────────────────────────────────────────────────────
if ! command -v oh-my-posh &>/dev/null; then
  echo "Installing Oh My Posh..."
  curl -s https://ohmyposh.dev/install.sh | bash -s
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
echo "export ZDOTDIR=\"${ZSH_DIR}\"" > "${HOME}/.zshenv"

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

# ── Set ZSH as default shell ──────────────────────────────────────
if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  echo "Setting ZSH as default shell..."
  chsh -s "$(command -v zsh)" || echo "  chsh failed — run manually: chsh -s \$(command -v zsh)"
else
  echo "ZSH is already the default shell."
fi

echo ""
echo "=== Setup complete! ==="
echo ""
echo "What was set up:"
echo "  ~/.zshenv          → points ZDOTDIR to ${ZSH_DIR}"
echo "  ~/.config/nvim     → symlinked to ${DOTFILES_DIR}/nvim"
echo "  oh-my-zsh          → ${HOME}/.oh-my-zsh"
echo "  oh-my-posh         → $(command -v oh-my-posh 2>/dev/null || echo 'not found')"
echo ""
echo "Restart your terminal or run: exec zsh"

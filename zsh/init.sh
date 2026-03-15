#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ZSH_DIR="${DOTFILES_DIR}/zsh"

echo "=== ZSH + Oh My Zsh + Oh My Posh Bootstrap ==="
echo "  Dotfiles: ${DOTFILES_DIR}"
echo "  ZSH dir:  ${ZSH_DIR}"
echo ""

# ── System update ──────────────────────────────────────────────────
echo "Updating and upgrading system packages..."
sudo DEBIAN_FRONTEND=noninteractive apt update -y && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# ── Prerequisites via apt ──────────────────────────────────────────
echo "Installing apt packages..."
sudo apt install -y \
  zsh \
  fzf \
  ripgrep \
  curl \
  wget \
  git \
  build-essential \
  unzip

# ── Neovim (latest stable from GitHub releases) ───────────────────
install_neovim() {
  echo "Installing Neovim (latest stable)..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm nvim-linux-x86_64.tar.gz
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  echo "Neovim installed: $(nvim --version | head -1)"
}

if ! command -v nvim &>/dev/null; then
  install_neovim
elif [[ "${1:-}" == "--force" ]]; then
  echo "Force flag set — reinstalling Neovim..."
  install_neovim
else
  echo "Neovim already installed: $(nvim --version | head -1)"
fi

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

# ── GitHub CLI ─────────────────────────────────────────────────────
if ! command -v gh &>/dev/null; then
  echo "Installing GitHub CLI..."
  sudo mkdir -p -m 755 /etc/apt/keyrings
  wget -nv -O /tmp/githubcli-archive-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg
  sudo cp /tmp/githubcli-archive-keyring.gpg /etc/apt/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  ARCH=$(dpkg --print-architecture)
  echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli-stable.list > /dev/null
  sudo apt update -y && sudo apt install gh -y
  rm -f /tmp/githubcli-archive-keyring.gpg
  echo "GitHub CLI installed: $(gh --version | head -1)"
else
  echo "GitHub CLI already installed: $(gh --version | head -1)"
fi

# ── Azure CLI ──────────────────────────────────────────────────────
if ! command -v az &>/dev/null; then
  echo "Installing Azure CLI..."
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  echo "Azure CLI installed: $(az version --query '\"azure-cli\"' -o tsv)"
else
  echo "Azure CLI already installed: $(az version --query '\"azure-cli\"' -o tsv)"
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
# oh-my-posh installs to ~/.local/bin by default
case ":${PATH:-}:" in
  *:"${HOME}/.local/bin":*) ;;
  *) export PATH="${HOME}/.local/bin${PATH:+:${PATH}}" ;;
esac

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

# ── Git config symlink ─────────────────────────────────────────────
GITCONFIG_TARGET="${ZSH_DIR}/.gitconfig"
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
echo "  ~/.gitconfig       → symlinked to ${ZSH_DIR}/.gitconfig"
echo "  ~/.config/nvim     → symlinked to ${DOTFILES_DIR}/nvim"
echo "  oh-my-zsh          → ${HOME}/.oh-my-zsh"
echo "  oh-my-posh         → $(command -v oh-my-posh 2>/dev/null || echo 'not found')"
echo "  gh                 → $(command -v gh 2>/dev/null || echo 'not found')"
echo "  az                 → $(command -v az 2>/dev/null || echo 'not found')"
echo "  copilot            → $(command -v copilot 2>/dev/null || echo 'not found')"
echo "  nvm                → ${HOME}/.nvm"
echo "  dotnet             → $(command -v dotnet 2>/dev/null || echo 'not found')"
echo ""
echo "Restart your terminal or run: exec zsh"

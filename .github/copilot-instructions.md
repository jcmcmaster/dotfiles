# Copilot Instructions

## Repository Overview

Cross-platform dotfiles repository managing configurations for Neovim, PowerShell (Windows), ZSH (Linux/WSL), Windows Terminal, Git, JetBrains IDEs (IdeaVim), and a QMK keyboard layout. All platforms are equally supported — changes should preserve cross-platform compatibility. There are no build/test/lint commands — this is a pure configuration repo deployed via symlinks.

The `archive/` directory contains legacy configs that are no longer actively maintained. Focus work on the active top-level directories.

## Deployment

Configs are deployed by **symlinking** from this repo to their expected system locations. On Linux/WSL, `zsh/init.sh` handles bootstrap and symlinks. For Windows, symlink manually or adapt the pattern from `archive/symlinkers/`.

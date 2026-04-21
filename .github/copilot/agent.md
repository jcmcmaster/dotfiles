# Agent Instructions

This repo is Nix-first. Prefer declarative changes in `nix/` over ad hoc setup elsewhere.

## Working rules

- Start with `nix/flake.nix`, `nix/configuration.nix`, and `nix/home.nix`.
- Treat `archive/` as legacy unless the task explicitly targets it.
- Keep changes small, direct, and easy to review.
- Preserve the current Darwin flow: `flake.nix` uses `SUDO_USER`, so apply changes with `sudo darwin-rebuild switch --flake .#default --impure`.
- There are no repo-wide build, lint, or test commands.

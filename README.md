# dotfiles

Nix-first dotfiles for macOS. Active development is centered on `nix/`; the other top-level directories are supporting app configs or older platform-specific setup.

## Apply the config

```bash
git clone https://github.com/jcmcmaster/dotfiles ~/Projects/dotfiles
cd ~/Projects/dotfiles/nix
sudo darwin-rebuild switch --flake .#default --impure
```

`flake.nix` reads `SUDO_USER`, so `--impure` is required.

## Layout

| Path | Purpose |
| --- | --- |
| `nix/` | nix-darwin + Home Manager entrypoint |
| `nix/configuration.nix` | system-level macOS settings |
| `nix/home.nix` | user packages and program config |
| `nvim/`, `wezterm/`, `pwsh/`, `wt/`, `zsh/`, `idea/` | app-specific config kept in the repo |
| `archive/` | legacy config |

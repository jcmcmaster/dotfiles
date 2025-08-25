# Legacy Configurations

This directory contains historical configurations that are preserved for reference but **not actively maintained**. These files are from previous setups and should not be used for new installations.

## ⚠️ Important Notice

**DO NOT USE THESE CONFIGURATIONS FOR NEW SETUPS**

The configurations in this directory are outdated and may conflict with the current setup in the root directories. They are kept for:

- Historical reference
- Migration assistance
- Backup purposes
- Learning from previous configurations

## Directory Structure

### `linux/`
Legacy Linux-specific configurations including:
- Old `.bashrc`, `.zshrc`, and shell configurations
- Outdated Neovim configurations
- Old snippet files (replaced by mini.snippets in current setup)
- Legacy dotfiles and aliases

### `symlinkers/`
Old symlink creation scripts with hardcoded paths:
- `symlink_dotfiles.sh` - Legacy Linux symlinker
- `ubuntu_init.sh` - Old Ubuntu setup script
- `win_symlinker.bat` - Windows symlinker script

**Note:** These scripts reference hardcoded paths (`~/projects/dotfiles`) and may not work in all environments.

### `win/`
Legacy Windows configurations:
- `.hyper.js` - Old Hyper terminal configuration

## Current Alternatives

Instead of using these legacy files, use the current configurations:

| Legacy | Current Alternative |
|--------|-------------------|
| `linux/.config/nvim/` | `nvim/` (root directory) |
| `linux/.zshrc`, etc. | PowerShell profile in `powershell/` |
| `symlinkers/` scripts | Manual installation (see main README.md) |
| `win/.hyper.js` | Windows Terminal config in `wt/` |

## Migration Notes

If you're migrating from these old configurations:

1. **Don't symlink anything from this directory**
2. **Use the current configurations in the root directories**
3. **Follow the installation instructions in the main README.md**
4. **These files can be safely ignored for new setups**

## Cleanup Considerations

This directory could potentially be:
- Moved to a separate branch for archival
- Renamed to `archive/` or `legacy/` for clarity
- Removed entirely if no longer needed

For questions about migration or current setup, refer to the main [README.md](../README.md) in the root directory.
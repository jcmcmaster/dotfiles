# PowerShell Configuration

This directory contains PowerShell profile and configuration files for an enhanced command-line experience.

## Files

- `Microsoft.PowerShell_profile.ps1` - Main PowerShell profile with enhancements

## Features

### Core Enhancements
- **Oh My Posh** integration for beautiful, informative prompts
- **PSReadLine** with intelligent suggestions and Vi keybindings
- **Terminal-Icons** for better file/folder visualization
- **Git integration** with posh-git for repository status
- **Custom functions** for improved productivity

### Key Bindings
- `Tab` - Menu completion
- `Ctrl+U` - Delete to beginning of line
- `Ctrl+K` - Delete to end of line
- `Up/Down arrows` - History search
- `Ctrl+Left/Right` - Word navigation

### Custom Functions
- `fd [path]` - Fuzzy find and navigate to directories
- `fp` - Quick navigation to Projects folder
- `gacp <message>` - Git add, commit, and push in one command

### Aliases
- `g` → `git`
- `vim`/`vi` → `nvim`

## Installation

### Prerequisites
Install required PowerShell modules:
```powershell
Install-Module Terminal-Icons -Force
Install-Module PSReadLine -Force
Install-Module posh-git -Force
```

Install Oh My Posh:
```powershell
# Via winget
winget install JanDeDobbeleer.OhMyPosh

# Or via Scoop
scoop install oh-my-posh
```

### Automatic Installation (Recommended)
Use the main installation script:
```powershell
.\install.ps1 -Component powershell
```

### Manual Installation

1. **Find your PowerShell profile location:**
   ```powershell
   $PROFILE
   ```

2. **Backup existing profile (if any):**
   ```powershell
   if (Test-Path $PROFILE) {
       Copy-Item $PROFILE "$PROFILE.backup"
   }
   ```

3. **Create symbolic link:**
   ```powershell
   # As Administrator
   New-Item -ItemType SymbolicLink -Path $PROFILE -Target "path\to\dotfiles\powershell\Microsoft.PowerShell_profile.ps1" -Force
   ```

   Or copy the file:
   ```powershell
   Copy-Item "path\to\dotfiles\powershell\Microsoft.PowerShell_profile.ps1" $PROFILE -Force
   ```

4. **Restart PowerShell** to load the new profile

## Dependencies

### Required Modules
- **Terminal-Icons** - File and folder icons
- **PSReadLine** - Enhanced command line editing
- **posh-git** - Git status in prompt

### Required Tools
- **Oh My Posh** - Cross-platform prompt theming engine
- **fzf** - Fuzzy finder (for `fd` function)

### Optional but Recommended
- **Git** - Version control integration
- **Neovim** - For `vim`/`vi` aliases

## Customization

### Changing the Theme
Edit the Oh My Posh configuration:
```powershell
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\your-theme.omp.json" | Invoke-Expression
```

Available themes can be found in `$env:POSH_THEMES_PATH`.

### Adding Custom Functions
Add your functions to the profile file:
```powershell
function Your-Function {
    # Your code here
}
```

### Modifying Key Bindings
Customize PSReadLine key handlers:
```powershell
Set-PSReadLineKeyHandler -Key "Ctrl+YourKey" -Function YourFunction
```

## Troubleshooting

### Execution Policy Error
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Module Import Errors
Ensure modules are installed:
```powershell
Get-Module -ListAvailable Terminal-Icons, PSReadLine, posh-git
```

### Oh My Posh Not Found
Verify installation and PATH:
```powershell
Get-Command oh-my-posh
```

### Performance Issues
If the prompt is slow, try a simpler Oh My Posh theme or disable some features.

## Advanced Configuration

### Profile Loading Order
PowerShell has multiple profile files. This configuration targets the CurrentUser profile for all hosts.

### Vi Mode Customization
The profile enables Vi mode for PSReadLine. To switch to Emacs mode:
```powershell
Set-PSReadLineOption -EditMode Emacs
```

For more information, see the main [README.md](../README.md).
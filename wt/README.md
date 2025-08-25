# Windows Terminal Configuration

This directory contains Windows Terminal settings that provide an enhanced terminal experience.

## Files

- `settings.json` - Main Windows Terminal configuration file

## Features

The configuration includes:

- **Custom color schemes** optimized for coding
- **Enhanced key bindings** for productivity
- **Multiple profile configurations** for different shells
- **Optimized font settings** for better readability
- **Tab management** improvements
- **Integration** with PowerShell and other shells

## Installation

### Automatic (Recommended)
Use the main installation script:
```powershell
.\install.ps1 -Component wt
```

### Manual Installation

1. **Locate Windows Terminal settings:**
   ```powershell
   $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json
   ```

2. **Backup existing settings:**
   ```powershell
   copy "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json.backup"
   ```

3. **Copy new settings:**
   ```powershell
   copy "path\to\dotfiles\wt\settings.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json"
   ```

4. **Restart Windows Terminal** to apply changes

## Key Features

### Custom Key Bindings
- Enhanced copy/paste operations
- Improved tab management
- Better pane splitting and navigation

### Color Scheme
- Optimized colors for programming
- Better contrast for code readability
- Support for syntax highlighting

### Profile Integration
- PowerShell integration with the custom profile
- Support for multiple shell environments
- Consistent theming across profiles

## Customization

To customize the settings:

1. Edit `settings.json` with your preferences
2. Restart Windows Terminal to see changes
3. Reference the [Windows Terminal documentation](https://docs.microsoft.com/en-us/windows/terminal/) for available options

## Troubleshooting

### Settings not applying
- Verify the settings.json path is correct
- Check JSON syntax validity
- Restart Windows Terminal completely

### Color scheme issues
- Ensure your monitor supports the color depth
- Check if Windows Terminal is up to date
- Verify no conflicting themes are applied

For more help, see the main [README.md](../README.md).
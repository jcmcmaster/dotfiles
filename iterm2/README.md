# iTerm2 Configuration

This directory contains iTerm2 configuration files that mimic the Windows Terminal settings from the `wt/` directory as closely as possible.

## Files

- `DynamicProfiles.json` - Main profile configurations with GitHub Dark theme and shell profiles
- `ColorSchemes.json` - Additional color schemes (Everforest Dark Hard, Tokyo Night Moon)
- `KeyMappings.json` - Key mapping reference and setup instructions
- `README.md` - This file

## Installation

1. **Install FiraCode Nerd Font** (if not already installed):
   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-fira-code-nerd-font
   ```

2. **Import Dynamic Profiles**:
   - Open iTerm2
   - Go to iTerm2 > Preferences > Profiles
   - Click on "Other Actions..." (gear icon) > Import JSON Profiles...
   - Select `DynamicProfiles.json` and `ColorSchemes.json`

3. **Set Default Profile**:
   - In iTerm2 > Preferences > Profiles
   - Select "GitHub Dark Profile"
   - Click "Other Actions..." > Set as Default

## Configuration Details

### Window Settings
- **Size**: 120 columns × 55 rows (matches Windows Terminal)
- **Font**: FiraCode Nerd Font, size 10
- **Theme**: GitHub Dark (primary), with Everforest and Tokyo Night alternatives
- **Copy on Select**: Disabled (matches Windows Terminal setting)
- **Scrollbars**: Hidden

### Color Scheme Mapping

#### GitHub Dark (Primary)
Matches the Windows Terminal "GitHub Dark" color scheme:
- Background: `#0D1117`
- Foreground: `#C9D1D9`
- Cursor: `#C9D1D9`
- Selection: `#21262D`

#### Additional Schemes
- **Everforest Dark Hard**: Nature-inspired green theme
- **Tokyo Night Moon**: Purple-tinted dark theme

### Profiles

1. **GitHub Dark Profile** - Base profile with GitHub Dark theme
2. **PowerShell Profile** - For PowerShell (if installed via Homebrew)
3. **Bash Profile** - Standard bash shell
4. **Zsh Profile** - Zsh shell (macOS default)

### Key Mappings

While iTerm2 uses different key combinations than Windows Terminal, the functionality is similar:

| Windows Terminal | iTerm2 Equivalent | Function |
|------------------|-------------------|----------|
| `Ctrl+Shift+T` | `⌘+T` | New Tab |
| `Ctrl+Shift+W` | `⌘+W` | Close Pane |
| `Ctrl+Shift+D` | `⌘+D` | Split Pane |
| `Ctrl+Shift+F` | `⌘+F` | Find |
| `Alt+Home` | `⌘+⇧+[` | Previous Tab |
| `Alt+End` | `⌘+⇧+]` | Next Tab |

See `KeyMappings.json` for a complete reference.

## Manual Configuration Steps

After importing the profiles, you may want to adjust these settings manually:

1. **General Settings**:
   - iTerm2 > Preferences > General > Selection
   - Uncheck "Copy to pasteboard on selection"

2. **Appearance**:
   - iTerm2 > Preferences > Appearance > Panes
   - Check "Hide scrollbars"
   - Set "Status bar location" to "Bottom"

3. **Advanced Settings**:
   - Search for "copy" in Advanced preferences
   - Ensure copy behavior matches Windows Terminal

## Differences from Windows Terminal

Due to platform and application differences, some features cannot be perfectly replicated:

1. **Window Management**: iTerm2 handles window centering differently
2. **Key Bindings**: macOS uses ⌘ instead of Ctrl for most shortcuts
3. **Profile System**: iTerm2's profile inheritance works differently
4. **Font Rendering**: Slight differences in font rendering between platforms
5. **System Integration**: Different integration with macOS vs Windows

## Troubleshooting

### Font Issues
If FiraCode Nerd Font doesn't appear:
- Ensure it's installed system-wide
- Restart iTerm2 after font installation
- Check font name in iTerm2 preferences (might be "FiraCodeNerdFont-Regular")

### Profile Import Issues
- Ensure JSON files are valid (check with `jq` or online JSON validator)
- Import profiles one at a time if bulk import fails
- Check iTerm2 console for error messages

### Color Issues
- Verify terminal type is set to "xterm-256color"
- Enable "Use bright colors for bold text" if needed
- Check "Minimum contrast" setting in profile

## Customization

Feel free to modify these profiles:
- Adjust font sizes in each profile
- Change color schemes by modifying the RGB values
- Add additional shell profiles as needed
- Customize key bindings in iTerm2 preferences

The goal is to maintain consistency with the Windows Terminal configuration while adapting to macOS/iTerm2 conventions.
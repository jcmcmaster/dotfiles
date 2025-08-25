# Dotfiles

Personal dotfiles for cross-platform development environments. This repository contains configuration files for Neovim, PowerShell, Windows Terminal, and various development tools.

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jcmcmaster/dotfiles.git
   cd dotfiles
   ```

2. **Choose your platform and follow the setup instructions below**

## 📁 Repository Structure

```
dotfiles/
├── nvim/                    # Neovim configuration (Lua-based)
│   ├── init.lua            # Main Neovim entry point
│   ├── lua/
│   │   ├── config/         # Core configuration modules
│   │   └── plugins/        # Plugin configurations
│   ├── lazy-lock.json      # Plugin version lockfile
│   └── lazyvim.json        # LazyVim configuration
├── powershell/             # PowerShell profile and configurations
├── win/                    # Windows-specific configurations
├── wt/                     # Windows Terminal settings
├── keyboard/               # Keyboard layout configurations
├── old/                    # Legacy configurations (archived)
└── README.md              # This file
```

## 🔧 Components

### Neovim Configuration

Modern Neovim setup using [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager with:

- **LSP Integration:** Full language server support for multiple languages
- **Completion:** Advanced autocompletion with nvim-cmp and Copilot integration
- **File Management:** Mini.files for file exploration
- **Fuzzy Finding:** Mini.pick for files, buffers, and more
- **Git Integration:** Comprehensive git workflow support
- **Testing:** Built-in test runner support
- **AI Integration:** GitHub Copilot support

**Key Features:**
- Cross-platform compatibility (Windows PowerShell integration)
- Modern plugin ecosystem
- Extensive language support (C#, JavaScript/TypeScript, Lua, etc.)
- Custom start screen with animated logo
- Intelligent key mappings and shortcuts

### PowerShell Profile

Enhanced PowerShell experience with:
- Oh My Posh prompt theming
- PSReadLine enhancements
- Git integration with posh-git
- Custom functions for navigation and productivity
- .NET CLI completion support

### Windows Terminal

Customized Windows Terminal settings optimizing:
- Color schemes and appearance
- Key bindings and shortcuts
- Profile configurations
- Integration with PowerShell and other shells

## 🛠️ Installation

### Neovim Setup

1. **Install Neovim (0.9.0 or later):**
   ```bash
   # Windows (via Chocolatey)
   choco install neovim
   
   # Windows (via Scoop)
   scoop install neovim
   
   # macOS
   brew install neovim
   
   # Ubuntu/Debian
   sudo apt install neovim
   ```

2. **Backup existing configuration:**
   ```bash
   # Windows
   mv $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.backup
   
   # Unix-like systems
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

3. **Create symlink to Neovim configuration:**
   ```bash
   # Windows (PowerShell as Administrator)
   New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "path\to\dotfiles\nvim"
   
   # Unix-like systems
   ln -s /path/to/dotfiles/nvim ~/.config/nvim
   ```

### PowerShell Profile Setup

1. **Install required modules:**
   ```powershell
   Install-Module Terminal-Icons -Force
   Install-Module PSReadLine -Force
   Install-Module posh-git -Force
   ```

2. **Install Oh My Posh:**
   ```powershell
   # Windows
   winget install JanDeDobbeleer.OhMyPosh
   
   # Or via Scoop
   scoop install oh-my-posh
   ```

3. **Link PowerShell profile:**
   ```powershell
   # Create symbolic link to profile
   New-Item -ItemType SymbolicLink -Path $PROFILE -Target "path\to\dotfiles\powershell\Microsoft.PowerShell_profile.ps1" -Force
   ```

### Windows Terminal Setup

1. **Install Windows Terminal** from Microsoft Store or GitHub releases

2. **Copy settings:**
   ```powershell
   # Backup existing settings
   copy "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json.backup"
   
   # Copy new settings
   copy "path\to\dotfiles\wt\settings.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json"
   ```

## ⌨️ Key Mappings

### Neovim

| Mode | Key Binding | Action |
|------|-------------|--------|
| Normal | `<leader>` | Space (leader key) |
| Normal | `<A-Left/Right>` | Navigate buffers |
| Normal | `<C-Left/Right/Up/Down>` | Navigate windows |
| Normal | `<S-Left/Right/Up/Down>` | Resize windows |
| Normal | `<leader>ff` | Find files |
| Normal | `<leader>fg` | Live grep |
| Normal | `<leader>fb` | Find buffers |
| Normal | `<leader>ef` | Open file explorer |
| Normal | `<leader>s` | Search and replace word under cursor |

### PowerShell Functions

| Function | Description |
|----------|-------------|
| `fd [path]` | Fuzzy find and navigate to directory |
| `fp` | Navigate to Projects directory |
| `gacp <message>` | Git add, commit, and push |
| `g` | Git alias |
| `vim`/`vi` | Neovim aliases |

## 🎨 Customization

### Neovim Plugins

The configuration is modular and easily customizable. Key plugin categories:

- **Core:** lazy.nvim, mini.nvim suite
- **LSP:** Native LSP with various language servers
- **Completion:** nvim-cmp with multiple sources
- **Git:** Built-in git integration
- **AI:** GitHub Copilot integration
- **Testing:** Neotest framework

### Adding New Plugins

Create a new file in `nvim/lua/plugins/` or add to existing files:

```lua
return {
  'author/plugin-name',
  config = function()
    -- Plugin configuration
  end
}
```

### Modifying Key Mappings

Edit `nvim/lua/config/maps.lua` to customize key bindings:

```lua
vim.keymap.set('n', '<leader>custom', ':CustomCommand<CR>')
```

## 🧹 Legacy Files

The `old/` directory contains legacy configurations that are preserved for reference but not actively maintained:

- Old Linux-specific configurations
- Legacy Neovim snippets (replaced by mini.snippets)
- Old symlinker scripts
- Windows-specific legacy files

These files are kept for historical reference and migration purposes but should not be used for new installations.

## 🔄 Updates and Maintenance

### Updating Plugins

```bash
# In Neovim
:Lazy update
```

### Updating PowerShell Modules

```powershell
Update-Module Terminal-Icons, PSReadLine, posh-git
```

## 🐛 Troubleshooting

### Common Issues

1. **Neovim plugins not loading:**
   - Check Neovim version (requires 0.9.0+)
   - Run `:checkhealth` in Neovim
   - Ensure all dependencies are installed

2. **PowerShell profile errors:**
   - Check execution policy: `Set-ExecutionPolicy RemoteSigned`
   - Verify module installations
   - Check Oh My Posh installation

3. **Windows Terminal settings not applying:**
   - Verify settings.json path
   - Check JSON syntax validity
   - Restart Windows Terminal

### Getting Help

- Check Neovim documentation: `:help`
- Review plugin documentation
- Check issue trackers for specific tools

## 📄 License

This project is licensed under the MIT License - see the individual tools and plugins for their respective licenses.

## 🙏 Acknowledgments

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [mini.nvim](https://github.com/echasnovski/mini.nvim) - Comprehensive plugin suite
- [Oh My Posh](https://ohmyposh.dev/) - Cross-platform prompt theming
- All the amazing plugin authors and maintainers
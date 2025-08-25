#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Modern installation script for dotfiles configuration

.DESCRIPTION
    This script provides a cross-platform way to install dotfiles configurations.
    It handles backup of existing configurations and creates appropriate symlinks.

.PARAMETER Component
    Specify which component to install: nvim, powershell, wt, or all

.PARAMETER Force
    Overwrite existing configurations without prompting

.EXAMPLE
    .\install.ps1 -Component all
    .\install.ps1 -Component nvim
    .\install.ps1 -Component powershell -Force
#>

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("all", "nvim", "powershell", "wt")]
    [string]$Component = "all",
    
    [Parameter(Mandatory = $false)]
    [switch]$Force
)

# Get the directory where this script is located
$DotfilesRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-Status {
    param([string]$Message, [string]$Color = "Green")
    Write-Host "✓ $Message" -ForegroundColor $Color
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Backup-Path {
    param([string]$Path)
    
    if (Test-Path $Path) {
        $BackupPath = "$Path.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        if ($Force) {
            Move-Item $Path $BackupPath -Force
            Write-Status "Backed up existing config to: $BackupPath"
        } else {
            $response = Read-Host "Existing config found at $Path. Create backup? (y/N)"
            if ($response -eq 'y' -or $response -eq 'Y') {
                Move-Item $Path $BackupPath -Force
                Write-Status "Backed up existing config to: $BackupPath"
            } else {
                Write-Error "Installation cancelled. Use -Force to overwrite automatically."
                return $false
            }
        }
    }
    return $true
}

function Install-Neovim {
    Write-Host "`n🔧 Installing Neovim configuration..." -ForegroundColor Cyan
    
    $NvimSource = Join-Path $DotfilesRoot "nvim"
    
    if ($IsWindows -or $PSVersionTable.PSEdition -eq "Desktop") {
        $NvimTarget = Join-Path $env:LOCALAPPDATA "nvim"
    } else {
        $NvimTarget = Join-Path $HOME ".config/nvim"
        $ConfigDir = Split-Path $NvimTarget -Parent
        if (!(Test-Path $ConfigDir)) {
            New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
        }
    }
    
    if (!(Backup-Path $NvimTarget)) { return }
    
    try {
        if ($IsWindows -or $PSVersionTable.PSEdition -eq "Desktop") {
            # Windows: Create symbolic link (requires admin privileges)
            New-Item -ItemType SymbolicLink -Path $NvimTarget -Target $NvimSource -Force | Out-Null
        } else {
            # Unix: Create symbolic link
            & ln -sf $NvimSource $NvimTarget
        }
        Write-Status "Neovim configuration installed to: $NvimTarget"
    } catch {
        Write-Error "Failed to create symlink. On Windows, run as Administrator."
        Write-Warning "Alternative: Copy files manually from $NvimSource to $NvimTarget"
    }
}

function Install-PowerShell {
    Write-Host "`n🔧 Installing PowerShell profile..." -ForegroundColor Cyan
    
    $ProfileSource = Join-Path $DotfilesRoot "powershell" "Microsoft.PowerShell_profile.ps1"
    $ProfileTarget = $PROFILE
    $ProfileDir = Split-Path $ProfileTarget -Parent
    
    if (!(Test-Path $ProfileDir)) {
        New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    }
    
    if (!(Backup-Path $ProfileTarget)) { return }
    
    try {
        if ($IsWindows -or $PSVersionTable.PSEdition -eq "Desktop") {
            New-Item -ItemType SymbolicLink -Path $ProfileTarget -Target $ProfileSource -Force | Out-Null
        } else {
            & ln -sf $ProfileSource $ProfileTarget
        }
        Write-Status "PowerShell profile installed to: $ProfileTarget"
        Write-Warning "Install required modules: Terminal-Icons, PSReadLine, posh-git, oh-my-posh"
    } catch {
        Write-Error "Failed to create symlink. Copying file instead..."
        Copy-Item $ProfileSource $ProfileTarget -Force
        Write-Status "PowerShell profile copied to: $ProfileTarget"
    }
}

function Install-WindowsTerminal {
    Write-Host "`n🔧 Installing Windows Terminal configuration..." -ForegroundColor Cyan
    
    if (!($IsWindows -or $PSVersionTable.PSEdition -eq "Desktop")) {
        Write-Warning "Windows Terminal is only available on Windows. Skipping..."
        return
    }
    
    $WtSource = Join-Path $DotfilesRoot "wt" "settings.json"
    $WtPath = Get-ChildItem "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal*\LocalState" -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if (!$WtPath) {
        Write-Warning "Windows Terminal not found. Install from Microsoft Store or GitHub."
        return
    }
    
    $WtTarget = Join-Path $WtPath.FullName "settings.json"
    
    if (!(Backup-Path $WtTarget)) { return }
    
    Copy-Item $WtSource $WtTarget -Force
    Write-Status "Windows Terminal settings installed to: $WtTarget"
}

function Show-PostInstall {
    Write-Host "`n🎉 Installation Complete!" -ForegroundColor Green
    Write-Host "`n📋 Next Steps:" -ForegroundColor Cyan
    
    if ($Component -eq "all" -or $Component -eq "nvim") {
        Write-Host "• Start Neovim - plugins will install automatically"
        Write-Host "• Run ':checkhealth' in Neovim to verify setup"
    }
    
    if ($Component -eq "all" -or $Component -eq "powershell") {
        Write-Host "• Install PowerShell modules:"
        Write-Host "  Install-Module Terminal-Icons, PSReadLine, posh-git -Force"
        Write-Host "  winget install JanDeDobbeleer.OhMyPosh"
        Write-Host "• Restart PowerShell to apply changes"
    }
    
    if ($Component -eq "all" -or $Component -eq "wt") {
        Write-Host "• Restart Windows Terminal to apply new settings"
    }
    
    Write-Host "`n📖 See README.md for detailed setup instructions and troubleshooting"
}

# Main installation logic
Write-Host "🚀 Dotfiles Installation Script" -ForegroundColor Magenta
Write-Host "Installing from: $DotfilesRoot`n" -ForegroundColor Gray

switch ($Component) {
    "all" {
        Install-Neovim
        Install-PowerShell
        Install-WindowsTerminal
    }
    "nvim" { Install-Neovim }
    "powershell" { Install-PowerShell }
    "wt" { Install-WindowsTerminal }
}

Show-PostInstall
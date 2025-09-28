#!/bin/bash

# iTerm2 Configuration Installation Script
# This script helps set up iTerm2 to mimic Windows Terminal settings

set -e

echo "🚀 iTerm2 Configuration Setup"
echo "=============================="

# Check if iTerm2 is installed
if ! command -v osascript >/dev/null 2>&1; then
    echo "❌ This script requires macOS"
    exit 1
fi

# Check if iTerm2 is installed
if ! ls /Applications/iTerm.app >/dev/null 2>&1; then
    echo "❌ iTerm2 not found. Please install iTerm2 first:"
    echo "   brew install --cask iterm2"
    exit 1
fi

echo "✅ iTerm2 found"

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
    echo "⚠️  Homebrew not found. Skipping font installation."
    echo "   Install Homebrew and run: brew install --cask font-fira-code-nerd-font"
    SKIP_FONT=true
else
    echo "✅ Homebrew found"
    SKIP_FONT=false
fi

# Install FiraCode Nerd Font if Homebrew is available
if [ "$SKIP_FONT" = false ]; then
    echo "📦 Installing FiraCode Nerd Font..."
    if brew list --cask font-fira-code-nerd-font >/dev/null 2>&1; then
        echo "✅ FiraCode Nerd Font already installed"
    else
        brew tap homebrew/cask-fonts 2>/dev/null || true
        brew install --cask font-fira-code-nerd-font
        echo "✅ FiraCode Nerd Font installed"
    fi
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validate JSON files
echo "🔍 Validating configuration files..."
if command -v jq >/dev/null 2>&1; then
    for json_file in "$SCRIPT_DIR"/*.json; do
        if [ -f "$json_file" ]; then
            if jq . "$json_file" >/dev/null 2>&1; then
                echo "✅ $(basename "$json_file") is valid"
            else
                echo "❌ $(basename "$json_file") has invalid JSON"
                exit 1
            fi
        fi
    done
else
    echo "⚠️  jq not found. Skipping JSON validation."
    echo "   Install with: brew install jq"
fi

# Copy files to iTerm2 DynamicProfiles directory
ITERM_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$ITERM_PROFILES_DIR"

echo "📁 Copying profiles to iTerm2..."
cp "$SCRIPT_DIR/DynamicProfiles.json" "$ITERM_PROFILES_DIR/"
cp "$SCRIPT_DIR/ColorSchemes.json" "$ITERM_PROFILES_DIR/"

echo "✅ Profiles copied to $ITERM_PROFILES_DIR"

# Instructions for manual steps
echo ""
echo "📋 Manual Setup Steps Required:"
echo "==============================="
echo "1. Open iTerm2"
echo "2. Go to iTerm2 > Preferences > Profiles"
echo "3. Your new profiles should appear automatically"
echo "4. Select 'GitHub Dark Profile' and click 'Other Actions...' > 'Set as Default'"
echo "5. Go to iTerm2 > Preferences > General > Selection"
echo "6. Uncheck 'Copy to pasteboard on selection'"
echo "7. Go to iTerm2 > Preferences > Appearance > Panes"
echo "8. Check 'Hide scrollbars'"
echo ""
echo "🎨 Available Profiles:"
echo "   • GitHub Dark Profile (main)"
echo "   • PowerShell Profile"
echo "   • Bash Profile"
echo "   • Zsh Profile"
echo "   • Everforest Dark Hard"
echo "   • Tokyo Night Moon"
echo ""
echo "📖 See README.md for detailed configuration instructions"
echo "🔧 See KeyMappings.json for key binding reference"
echo ""
echo "✨ Setup complete! Restart iTerm2 to see all changes."

# Offer to open iTerm2
read -p "🚀 Open iTerm2 now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open -a iTerm
fi
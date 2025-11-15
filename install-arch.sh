#!/bin/bash

# Dotfiles installation script for Arch Linux
# This script sets up the dotfiles environment with all necessary dependencies

set -e

echo "🚀 Setting up dotfiles for Arch Linux..."

# Check if we're in the dotfiles directory
if [[ ! -f "README.md" ]] || [[ ! -d "tmux" ]]; then
    echo "❌ Please run this script from the dotfiles directory"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install required tools
echo "📦 Installing required tools..."
yay -S --needed stow fzf zsh-autosuggestions zsh-syntax-highlighting gum tmux posting neovim

# Check for sesh - try AUR
if ! command_exists sesh; then
    echo "📦 Installing sesh..."
    yay -S --needed sesh || echo "⚠️  Could not install sesh from AUR, you may need to install it manually"
fi

# Install configurations using stow
echo "🔗 Creating symlinks with stow..."

# Install tmux configuration
if [[ -d "tmux" ]]; then
    echo "  📁 Installing tmux config..."
    stow tmux
fi

# Install nvim configuration
if [[ -d "nvim" ]]; then
    echo "  📁 Installing nvim config..."
    stow nvim
fi

# Install zsh configuration
if [[ -d "zsh" ]]; then
    echo "  📁 Installing zsh config..."
    stow zsh
fi

# Install posting configuration
if [[ -d "posting" ]]; then
    echo "  📁 Installing posting config..."
    stow posting
fi

# Install tmux plugins
echo "🔌 Installing tmux plugins..."
if [[ ! -d "$HOME/.config/tmux/plugins/tpm" ]]; then
    echo "  ✅ TPM already cloned as submodule"
fi
~/.config/tmux/plugins/tpm/bin/install_plugins

echo "✅ Dotfiles installation complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open tmux and press Ctrl+A + I to ensure all plugins are loaded"
echo "  3. Open nvim - plugins should install automatically"
echo ""
echo "🎉 Happy coding!"

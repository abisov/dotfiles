#!/bin/bash

# Dotfiles installation script
# This script sets up the dotfiles environment with all necessary dependencies

set -e

echo "🚀 Setting up dotfiles..."

# Check if we're in the dotfiles directory
if [[ ! -f "README.md" ]] || [[ ! -d "tmux" ]]; then
    echo "❌ Please run this script from the dotfiles directory"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not present
if ! command_exists brew; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install required tools
echo "📦 Installing required tools..."
brew install stow

# Handle sesh installation (may need to switch taps)
if brew list sesh >/dev/null 2>&1; then
    echo "  ✅ sesh already installed"
else
    brew install joshmedeski/sesh/sesh
fi

brew install gum
brew install fzf
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

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

# Install tmux plugins
echo "🔌 Installing tmux plugins..."
if [[ ! -d "$HOME/.config/tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
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
#!/bin/bash

# Dotfiles Installation Script
# This script creates symlinks from your home directory to the dotfiles

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "🚀 Installing dotfiles from $DOTFILES_DIR"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "📦 Backup directory created at $BACKUP_DIR"

# Function to backup and symlink
backup_and_link() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Backup existing file/directory if it exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "📋 Backing up existing $target"
        mv "$target" "$BACKUP_DIR/"
    fi
    
    # Create symlink
    echo "🔗 Linking $source -> $target"
    ln -sf "$source" "$target"
}

# Shell configurations
echo "🐚 Installing shell configurations..."
backup_and_link "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/shell/.zprofile" "$HOME/.zprofile"
backup_and_link "$DOTFILES_DIR/shell/.tmux.conf" "$HOME/.tmux.conf"

# Neovim configuration
echo "📝 Installing Neovim configuration..."
backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Terminal tools
echo "🛠️  Installing terminal tools configurations..."
backup_and_link "$DOTFILES_DIR/terminal-tools/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"

# Oh My Posh configurations
echo "🎨 Installing Oh My Posh configurations..."
backup_and_link "$DOTFILES_DIR/prompt/.oh-my-posh-config.json" "$HOME/.oh-my-posh-config.json"
backup_and_link "$DOTFILES_DIR/prompt/tokyonight_storm.omp.json" "$HOME/.config/tokyonight_storm.omp.json"

echo "✅ Dotfiles installation complete!"
echo "🔄 Please restart your terminal or run 'source ~/.zshrc' to apply changes"
echo "📦 Original files backed up to: $BACKUP_DIR"

# Check for required dependencies
echo ""
echo "🔍 Checking dependencies..."

check_dependency() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "✅ $1 is installed"
    else
        echo "❌ $1 is not installed - please install it"
    fi
}

check_dependency "oh-my-posh"
check_dependency "bat"
check_dependency "eza"
check_dependency "lazygit"
check_dependency "yazi"
check_dependency "zoxide"
check_dependency "tmux"
check_dependency "nvim"

echo ""
echo "📝 Don't forget to:"
echo "   - Set your PULUMI_CONFIG_PASSPHRASE environment variable"
echo "   - Install Homebrew packages: zsh-autosuggestions, zsh-syntax-highlighting"
echo "   - Install Nerd Fonts for proper icon display"
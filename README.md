# 🏠 Dotfiles

My personal configuration files for macOS development environment.

## 📦 What's Included

### Shell & Terminal
- **Zsh** - Shell configuration with vim mode, aliases, and oh-my-posh integration
- **Tmux** - Terminal multiplexer with vim-style navigation and custom status bar
- **Oh My Posh** - Custom prompt themes (Tokyo Night Storm)

### Editors
- **Neovim** - Complete IDE-like setup with LSP, plugins, and custom keybindings

### Terminal Tools
- **Yazi** - File manager configuration
- **Lazygit** - Git TUI (uses default configuration)

## 🚀 Quick Install

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## 📋 Prerequisites

Install these tools via Homebrew:

```bash
# Core tools
brew install oh-my-posh bat eza lazygit yazi zoxide tmux neovim

# Zsh plugins
brew install zsh-autosuggestions zsh-syntax-highlighting

# Optional: Nerd Fonts for icons
brew install --cask font-fira-code-nerd-font
```

## 🔧 Manual Setup

### Environment Variables
Add to your shell profile:
```bash
export PULUMI_CONFIG_PASSPHRASE="your-passphrase-here"
```

### Node.js (via NVM)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

## 📁 Structure

```
dotfiles/
├── shell/
│   ├── .zshrc          # Zsh configuration
│   ├── .zprofile       # Zsh profile
│   └── .tmux.conf      # Tmux configuration
├── nvim/               # Complete Neovim setup
├── terminal-tools/
│   ├── yazi/           # File manager config
│   └── lazygit/        # Git TUI config
├── prompt/
│   ├── .oh-my-posh-config.json
│   └── tokyonight_storm.omp.json
├── install.sh          # Installation script
└── README.md
```

## ✨ Features

### Zsh Configuration
- **Vim mode** with visual cursor changes
- **Smart completion** with menu navigation
- **History management** with deduplication
- **Useful aliases** (bat, eza, lazygit)
- **Auto-suggestions** and syntax highlighting
- **Tmux auto-start** (except in VS Code)

### Tmux Configuration
- **Prefix**: `Ctrl+A` (instead of Ctrl+B)
- **Vim-style navigation**: `h/j/k/l` for pane switching
- **Smart splits**: `|` for vertical, `-` for horizontal
- **Mouse support** enabled
- **Status bar** with session info and time

### Neovim Setup
- **LSP support** for multiple languages
- **Plugin management** with Lazy.nvim
- **File explorer** and fuzzy finding
- **Git integration** with diffview and gitsigns
- **Custom keybindings** and workflows

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/dotfiles
git pull
./install.sh
```

## 🛠️ Customization

### Adding New Configurations
1. Add files to appropriate directories
2. Update `install.sh` to include new symlinks
3. Document changes in this README

### Modifying Existing Configs
Edit files in the dotfiles directory - changes will be reflected immediately due to symlinks.

## 📝 Notes

- **Sensitive data**: The Pulumi passphrase has been removed from `.zshrc` - set it as an environment variable
- **Backups**: The install script automatically backs up existing configurations
- **Dependencies**: Check the dependency list in the install script output

## 🤝 Contributing

Feel free to fork and adapt these configurations for your own use!

## 📄 License

MIT License - feel free to use and modify as needed.
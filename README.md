# Dotfiles

My personal dotfiles managed with GNU Stow.

## Prerequisites

- GNU Stow: `brew install stow`
- Required tools:
  - [sesh](https://github.com/joshmedeski/sesh): `brew install joshmedeski/sesh/sesh`
  - [gum](https://github.com/charmbracelet/gum): `brew install gum`
  - [fzf](https://github.com/junegunn/fzf): `brew install fzf`

## Installation

1. Clone this repository with submodules:
   ```bash
   git clone --recurse-submodules <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Install configurations:
   ```bash
   # Install tmux configuration
   stow tmux
   
   # Install nvim configuration  
   stow nvim
   ```

3. Install tmux plugins:
   - Open tmux: `tmux`
   - Press `Ctrl+A + I` to install plugins via TPM

4. Install nvim plugins:
   - Open nvim: `nvim`
   - Plugins should install automatically via Lazy.nvim

## Tmux Configuration

### Key Bindings

- **Prefix**: `Ctrl+A`
- **Split panes**: 
  - `Ctrl+A + |` - Split horizontally
  - `Ctrl+A + -` - Split vertically
- **Navigate panes**: `Ctrl+A + h/j/k/l` (vim-style)
- **Session manager**: `Ctrl+A + K` (sesh + gum)
- **Floating pane**: `Ctrl+A + p`
- **Tinycode AI**: `Ctrl+A + q`

### Plugins Included

- tmux-sensible
- tmux-yank
- tmux-resurrect
- tmux-continuum
- tmux-thumbs
- tmux-fzf
- tmux-fzf-url
- tmux-gruvbox (theme)
- tmux-floax

## Neovim Configuration

The nvim configuration is managed as a separate repository ([aqua-vim](https://github.com/abisov/aqua-vim)) included as a git submodule. This approach allows:
- Independent development of the nvim config
- Version control of nvim config changes
- Easy updates via git submodule commands

### Updating nvim config:
```bash
cd ~/dotfiles
git submodule update --remote nvim/.config/nvim
git add nvim/.config/nvim
git commit -m "Update nvim config"
```

## Directory Structure

```
~/dotfiles/
├── tmux/
│   └── .config/
│       └── tmux/
│           ├── tmux.conf
│           └── plugins/
│               └── tpm/ (submodule)
└── nvim/
    └── .config/
        └── nvim/ (submodule -> aqua-vim repo)
```

## Uninstalling

To remove symlinks:
```bash
cd ~/dotfiles
stow -D tmux
stow -D nvim
```
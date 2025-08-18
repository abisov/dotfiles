# Dotfiles

My personal dotfiles managed with GNU Stow.

## Prerequisites

- GNU Stow: `brew install stow`
- Required tools:
  - [sesh](https://github.com/joshmedeski/sesh): `brew install joshmedeski/sesh/sesh`
  - [gum](https://github.com/charmbracelet/gum): `brew install gum`
  - [fzf](https://github.com/junegunn/fzf): `brew install fzf`

## Installation

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Install tmux configuration:
   ```bash
   stow tmux
   ```

3. Install tmux plugins:
   - Open tmux: `tmux`
   - Press `Ctrl+A + I` to install plugins via TPM

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

## Directory Structure

```
~/dotfiles/
└── tmux/
    └── .config/
        └── tmux/
            ├── tmux.conf
            └── plugins/
                └── tpm/
```

## Uninstalling

To remove symlinks:
```bash
cd ~/dotfiles
stow -D tmux
```
# === Early Setup ===
# Terminal and color support - optimized for kitty
export TERM=${TERM:-xterm-kitty}
export COLORTERM=truecolor

# Set up fpath before anything else
fpath=(~/.zsh $fpath)

# === PATH Setup ===
# Homebrew paths - only set once
if [[ -z "$HOMEBREW_PREFIX" ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        export HOMEBREW_PREFIX="/opt/homebrew"
    elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
        export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
    fi
    
    if [[ -n "$HOMEBREW_PREFIX" ]]; then
        export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
    fi
fi

# Other PATH additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/bin"

# === Completion Setup ===
autoload -Uz compinit
# Speed up compinit by checking cache once per day
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Load completion menu
zmodload zsh/complist

# === Plugins ===
# Load autosuggestions first
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# === History ===
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# === Key Bindings ===
bindkey '^ ' autosuggest-accept  # Ctrl+Space to accept suggestion

# === Vim Mode ===
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Change cursor shape for different vi modes
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# Start with beam cursor
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' ;}

# Edit command line in vim with Ctrl+X Ctrl+E
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# === Prompt ===
# Use local Catppuccin Mocha theme
if [[ -f ~/.config/catppuccin-mocha.omp.json ]]; then
    eval "$(oh-my-posh init zsh --config ~/.config/catppuccin-mocha.omp.json)"
else
    eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json)"
fi

# === Aliases ===
alias cat="bat"
alias ls="eza -lh --icons"
alias ll="eza -la --icons"
alias ..="cd .."
alias ...="cd ../.."
alias lg="lazygit" 
alias grep="grep --color=auto"

# OS-specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS aliases
    alias wild="cd ~/Projects/wildstate/"
    alias wildios="cd ~/Projects/wildstate/wild"
    alias wildapi="cd ~/Projects/wildstate/wild-api"
    alias nvc="cd ~/.config/nvim/"
    alias blender="/Applications/Blender.app/Contents/MacOS/Blender"
    alias docker="/Applications/Docker.app/Contents/Resources/bin/docker"
    alias xcodetui="/Users/ab-macbook/Projects/tuis/XcodeTUI/.build/debug/XcodeTUI"
    export PATH="/Users/ab-macbook/tmux-tinycode/bin:$PATH"
else
    # Linux aliases
    alias x5="cd ~/projects/xnet/x5/web-bff-monorepo"
    alias dotf="cd ~/projects/dotfiles/"
    alias nvc="cd ~/projects/dotfiles/nvim"
    
    # Hyprland workspace management
    change-workspace-dp() {
        if [[ $# -ne 2 ]]; then
            echo "Usage: change-workspace-dp <workspace_number> <monitor_name>"
            echo "Example: change-workspace-dp 3 DP-2"
            return 1
        fi
        hyprctl dispatch moveworkspacetomonitor $1 $2
    }
fi

# === Tool Initialization ===
# zoxide initialization
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# === Language-specific setup ===
alias python=/usr/bin/python3

# OS-specific Python paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="$HOME/Library/Python/3.9/bin:$PATH"
fi

# Ruby path
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$HOMEBREW_PREFIX/lib/ruby/gems/3.4.0/bin:$PATH"
fi

# === OS-specific configurations ===
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PULUMI_CONFIG_PASSPHRASE="Pavgo1-paxnit-byxdij"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export NODE_OPTIONS="--max-old-space-size=4096"
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
    export LIBGL_ALWAYS_INDIRECT=1
fi

# === Lazy loading functions ===
# NVM lazy loading
nvm() {
    unset -f nvm
    export NVM_DIR="$HOME/.nvm"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
        [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    else
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi
    nvm "$@"
}

# === Session management ===
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# === tmux auto-start (disabled for faster startup) ===
# Uncomment to auto-start tmux:
# if [ -z "$TMUX" ] && [ -z "$VSCODE_INJECTION" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
#     tmux attach-session -t default || tmux new-session -s default
# fi

# === Load syntax highlighting LAST ===
if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    
    # Configure syntax highlighting colors to work with any theme
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=blue
    ZSH_HIGHLIGHT_STYLES[alias]=fg=green
    ZSH_HIGHLIGHT_STYLES[builtin]=fg=green
    ZSH_HIGHLIGHT_STYLES[function]=fg=green
    ZSH_HIGHLIGHT_STYLES[command]=fg=green
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green
    ZSH_HIGHLIGHT_STYLES[commandseparator]=none
    ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=green
    ZSH_HIGHLIGHT_STYLES[path]=none
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=cyan
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[redirection]=none
    ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export EDITOR='nvim'

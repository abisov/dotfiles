# === PATH Setup ===
# Conditional Homebrew paths for macOS/Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

# === Plugins ===
# Load plugins after zsh initialization
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# === Completion ===
autoload -Uz compinit
compinit

# Load completion menu
zmodload zsh/complist

# === History ===
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# === Key Bindings ===
bindkey '^ ' autosuggest-accept  # Ctrl+Space to accept suggestion

# === Vim Mode ===
# Enable vim mode in zsh (must be after completion setup)
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

# Use beam cursor for each new prompt
preexec() { echo -ne '\e[5 q' ;}

# Edit command line in vim with Ctrl+X Ctrl+E
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# === Prompt ===
eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/gruvbox.omp.json)"

# === Aliases ===
alias cat="bat"
alias ls="eza -lh --icons"
alias ll="eza -la --icons"
# alias cd="z"
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
else
    # Linux aliases
    alias x5="cd ~/projects/xnet/x5/web-bff-monorepo"
    alias dotf="cd ~/projects/dotfiles/"
    alias nvc="cd ~/projects/dotfiles/nvim"
fi
# === Useful tools ===
# zoxide initialization
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi


# OS-specific application aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias blender="/Applications/Blender.app/Contents/MacOS/Blender"
    alias docker="/Applications/Docker.app/Contents/Resources/bin/docker"
fi
# NVM setup - OS specific
export NVM_DIR="$HOME/.nvm"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS with Homebrew NVM
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
else
    # Linux with standard NVM installation
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi
export PATH=$PATH:/usr/local/bin 
alias python=/usr/bin/python3

# OS-specific Python paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="$HOME/Library/Python/3.9/bin:$PATH"
fi
export PATH="$HOME/.local/bin:$PATH"
# OS-specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific
    export PULUMI_CONFIG_PASSPHRASE="Pavgo1-paxnit-byxdij"
else
    # Linux specific
    # TODO: Set PULUMI_CONFIG_PASSPHRASE environment variable
fi

# Ruby path (works on both systems)
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$HOMEBREW_PREFIX/lib/ruby/gems/3.4.0/bin:$PATH"
fi

# Linux specific configurations
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export NODE_OPTIONS="--max-old-space-size=4096"
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
    export LIBGL_ALWAYS_INDIRECT=1
fi
# macOS specific development tools
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias xcodetui="/Users/ab-macbook/Projects/tuis/XcodeTUI/.build/debug/XcodeTUI"
fi

# === tmux auto-start ===
# Auto-start tmux if not already in tmux and not in VS Code terminal
if [ -z "$TMUX" ] && [ -z "$VSCODE_INJECTION" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    tmux attach-session -t default || tmux new-session -s default
fi

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
# macOS specific tools
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/Users/ab-macbook/tmux-tinycode/bin:$PATH"
fi


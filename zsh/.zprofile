# Homebrew setup - conditional for macOS/Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# macOS specific Python path
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Setting PATH for Python 3.12
    # The original version is saved in .zprofile.pysave
    PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
    export PATH
fi

# macOS specific OrbStack
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Added by OrbStack: command-line tools and integration
    # This won't be added again if you remove it.
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi

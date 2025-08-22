#!/bin/bash

# 🐚 ZSH Extras Module
# Enhanced ZSH with completions, syntax highlighting, autosuggestions

install_zsh_extras_module() {
    log "Installing ZSH Extras module"
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#ff8c00" --bold "🐚 Installing ZSH Extras Module"
    else
        echo "🐚 Installing ZSH Extras Module"
    fi
    
    local zsh_packages=(
        "zsh-completions"
        "zsh-syntax-highlighting"
        "zsh-autosuggestions"
    )
    
    # Install packages
    install_packages "${zsh_packages[@]}"
    
    # Setup enhanced ZSH environment
    setup_zsh_extras_environment
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" "✓ ZSH extras module installed successfully"
    else
        echo "✓ ZSH extras module installed successfully"
    fi
}

setup_zsh_extras_environment() {
    log "Setting up enhanced ZSH environment"
    
    # Update .zshrc with enhanced features
    if [[ -f ~/.zshrc ]]; then
        # Backup existing .zshrc
        cp ~/.zshrc ~/.zshrc.backup.$(date +%s)
        log "Backed up existing .zshrc"
    fi
    
    # Create enhanced .zshrc
    cat > ~/.zshrc << 'EOF'
# Anarchy Enhanced ZSH Configuration

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt EXTENDED_HISTORY

# Completion settings
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Load additional completions
if [[ -d /usr/share/zsh/site-functions ]]; then
    fpath=(/usr/share/zsh/site-functions $fpath)
fi

# Enable syntax highlighting
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Enable autosuggestions
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
fi

# Key bindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# Atuin shell history
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"
fi

# Zoxide for better cd
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Mise for version management
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

# Enhanced aliases
alias ls='eza --color=auto --icons'
alias ll='eza -la --color=auto --icons'
alias la='eza -a --color=auto --icons'
alias lt='eza --tree --color=auto --icons'
alias grep='ripgrep'
alias cat='bat'
alias find='fd'
alias rm='trash'
alias vi='nvim'
alias vim='nvim'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias lg='lazygit'

# Docker aliases (if docker module is installed)
if command -v docker &>/dev/null; then
    alias d='docker'
    alias dc='docker-compose'
    alias lzd='lazydocker'
fi

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Environment variables
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER="bat"

# FZF settings
if command -v fzf &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
EOF
    
    log "Created enhanced .zshrc"
    
    echo ""
    echo "🐚 Enhanced ZSH features installed:"
    echo "   • Advanced completions with menu selection"
    echo "   • Syntax highlighting for commands"
    echo "   • Intelligent autosuggestions"
    echo "   • Enhanced history search"
    echo "   • Useful aliases and functions"
    echo ""
    echo "💡 Tips:"
    echo "   • Use arrow keys in completions menu"
    echo "   • Press Ctrl+R for history search with atuin"
    echo "   • Use 'z <directory>' for quick navigation"
    echo ""
}
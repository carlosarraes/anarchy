#!/bin/bash

# 🔒 Security Module  
# 1Password and security tools

install_security_module() {
    log "Installing Security module"
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#007acc" --bold "🔒 Installing Security Module"
    else
        echo "🔒 Installing Security Module"
    fi
    
    local security_packages=(
        "1password-beta"
        "1password-cli"
    )
    
    # Install packages
    install_packages "${security_packages[@]}"
    
    # Setup security environment
    setup_security_environment
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" "✓ Security module installed successfully"
    else
        echo "✓ Security module installed successfully"
    fi
}

setup_security_environment() {
    log "Setting up security environment"
    
    # Create 1Password config directory
    mkdir -p ~/.config/1Password
    
    echo ""
    echo "🔐 1Password installed:"
    echo "   • Desktop app: 1password"
    echo "   • CLI tool: op"
    echo ""
    echo "💡 Setup tips:"
    echo "   1. Launch 1Password and sign in to your account"
    echo "   2. Enable desktop app integration for browser"
    echo "   3. Use 'op' command for CLI access after authentication"
    echo ""
}
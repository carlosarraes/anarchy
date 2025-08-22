#!/bin/bash

# 💻 Development Extras Module  
# Tree-sitter CLI and Lua development tools

install_dev_extras_module() {
    log "Installing Development Extras module"
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#4b0082" --bold "💻 Installing Development Extras Module"
    else
        echo "💻 Installing Development Extras Module"
    fi
    
    local dev_packages=(
        "tree-sitter-cli"
        "luarocks"
    )
    
    # Install packages
    install_packages "${dev_packages[@]}"
    
    # Setup development environment
    setup_dev_extras_environment
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" "✓ Development extras module installed successfully"
    else
        echo "✓ Development extras module installed successfully"
    fi
}

setup_dev_extras_environment() {
    log "Setting up development extras environment"
    
    # Setup luarocks user tree
    if command -v luarocks &>/dev/null; then
        # Configure luarocks for user installation
        mkdir -p ~/.luarocks
        
        # Add luarocks user path to shell
        if [[ -f ~/.zshrc ]] && ! grep -q "luarocks" ~/.zshrc; then
            cat >> ~/.zshrc << 'EOF'

# Luarocks user tree
if command -v luarocks &>/dev/null; then
    eval "$(luarocks path)"
fi
EOF
            log "Added luarocks path to .zshrc"
        fi
    fi
    
    echo ""
    echo "💻 Development extras installed:"
    echo "   • tree-sitter-cli - Syntax tree parser generator"
    echo "   • luarocks - Lua package manager"
    echo ""
    echo "💡 Usage:"
    echo "   • tree-sitter --help - View tree-sitter commands"
    echo "   • luarocks install <package> --local - Install Lua packages"
    echo ""
}
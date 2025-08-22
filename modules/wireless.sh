#!/bin/bash

# 📡 Wireless Module
# Advanced WiFi management tools

install_wireless_module() {
    log "Installing Wireless module"
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#32cd32" --bold "📡 Installing Wireless Module"
    else
        echo "📡 Installing Wireless Module"
    fi
    
    local wireless_packages=(
        "iwd"
        "plymouth"
    )
    
    # Install packages
    install_packages "${wireless_packages[@]}"
    
    # Setup wireless environment
    setup_wireless_environment
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" "✓ Wireless module installed successfully"
    else
        echo "✓ Wireless module installed successfully"
    fi
}

setup_wireless_environment() {
    log "Setting up wireless environment"
    
    # Enable iwd service (but don't conflict with NetworkManager)
    sudo systemctl enable iwd.service
    
    # Configure iwd settings
    sudo mkdir -p /etc/iwd
    if [[ ! -f /etc/iwd/main.conf ]]; then
        sudo tee /etc/iwd/main.conf > /dev/null << 'EOF'
[General]
EnableNetworkConfiguration=true
AddressRandomization=once

[Network]
NameResolvingService=systemd
EOF
        log "Created iwd configuration"
    fi
    
    echo ""
    echo "📡 Wireless tools configured:"
    echo "   • iwd - Intel's WiFi daemon"
    echo "   • impala - Terminal WiFi manager (already installed)"
    echo ""
    echo "💡 Usage:"
    echo "   • Use 'impala' for terminal WiFi management"
    echo "   • Use 'iwctl' for iwd command line interface"
    echo ""
    echo "⚠️  Note: You may need to disable NetworkManager if it conflicts with iwd"
    echo ""
}
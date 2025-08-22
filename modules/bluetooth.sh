#!/bin/bash

# 📶 Bluetooth Module
# Bluetooth management with GUI

install_bluetooth_module() {
    log "Installing Bluetooth module"
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#0066cc" --bold "📶 Installing Bluetooth Module"
    else
        echo "📶 Installing Bluetooth Module"
    fi
    
    local bluetooth_packages=(
        "blueberry"
    )
    
    # Install packages
    install_packages "${bluetooth_packages[@]}"
    
    # Setup Bluetooth environment
    setup_bluetooth_environment
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" "✓ Bluetooth module installed successfully"
    else
        echo "✓ Bluetooth module installed successfully"
    fi
}

setup_bluetooth_environment() {
    log "Setting up Bluetooth environment"
    
    # Enable and start Bluetooth service
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    
    echo ""
    echo "📶 Bluetooth configured:"
    echo "   • Bluetooth GUI: blueberry"
    echo "   • Command line: bluetoothctl"
    echo ""
    echo "💡 Usage:"
    echo "   • Launch blueberry for graphical management"
    echo "   • Use bluetoothctl for command line control"
    echo ""
}
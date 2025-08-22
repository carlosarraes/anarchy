#!/bin/bash

# 🖨️ Printing Module
# CUPS printing system with GUI configuration

install_printing_module() {
    log "Installing Printing module"
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#8b4513" --bold "🖨️ Installing Printing Module"
    else
        echo "🖨️ Installing Printing Module"
    fi
    
    local printing_packages=(
        "cups"
        "cups-pdf"
        "cups-filters"
        "cups-browsed"
        "system-config-printer"
        "avahi"
        "nss-mdns"
    )
    
    # Install packages
    install_packages "${printing_packages[@]}"
    
    # Setup printing environment
    setup_printing_environment
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" "✓ Printing module installed successfully"
    else
        echo "✓ Printing module installed successfully"
    fi
}

setup_printing_environment() {
    log "Setting up printing environment"
    
    # Enable and start CUPS service
    sudo systemctl enable cups.service
    sudo systemctl start cups.service
    
    # Enable Avahi for network printer discovery
    sudo systemctl enable avahi-daemon.service
    sudo systemctl start avahi-daemon.service
    
    # Add user to lp group
    sudo usermod -aG lp "$USER"
    
    # Configure mDNS resolution for .local domains
    if ! grep -q "mdns" /etc/nsswitch.conf; then
        sudo sed -i 's/hosts: files dns/hosts: files mdns_minimal [NOTFOUND=return] dns/' /etc/nsswitch.conf
        log "Configured mDNS resolution"
    fi
    
    echo ""
    echo "🖨️ Printing system configured:"
    echo "   • CUPS server: http://localhost:631"
    echo "   • Printer setup GUI: system-config-printer"
    echo "   • PDF printing available"
    echo ""
    echo "💡 Tips:"
    echo "   • Access CUPS web interface at http://localhost:631"
    echo "   • Use system-config-printer to add printers"
    echo "   • Network printers should be auto-discovered"
    echo ""
}
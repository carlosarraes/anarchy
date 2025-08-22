#!/bin/bash

# 🎬 Media Production Module
# OBS Studio, screen recording tools

install_media_module() {
    log "Installing Media module"
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#ff6b6b" --bold "🎬 Installing Media Production Module"
    else
        echo "🎬 Installing Media Production Module"
    fi
    
    local media_packages=(
        "obs-studio"
        "wf-recorder"
        "wl-screenrec"
    )
    
    # Install packages
    install_packages "${media_packages[@]}"
    
    # Setup media environment
    setup_media_environment
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" "✓ Media production module installed successfully"
    else
        echo "✓ Media production module installed successfully"
    fi
}

setup_media_environment() {
    log "Setting up media environment"
    
    # Create OBS config directory
    mkdir -p ~/.config/obs-studio
    
    # Add user to video group (for hardware encoding)
    sudo usermod -aG video "$USER"
    
    # Create recordings directory
    mkdir -p ~/Videos/Recordings
    mkdir -p ~/Videos/Screenshots
    
    # Create basic wf-recorder script
    mkdir -p ~/.local/bin
    cat > ~/.local/bin/record-screen << 'EOF'
#!/bin/bash
# Simple screen recording script using wf-recorder

SAVE_DIR="$HOME/Videos/Recordings"
FILENAME="recording-$(date +%Y%m%d-%H%M%S).mp4"

# Ensure save directory exists
mkdir -p "$SAVE_DIR"

# Record with wf-recorder
wf-recorder -f "$SAVE_DIR/$FILENAME" "$@"

echo "Recording saved to: $SAVE_DIR/$FILENAME"
EOF
    chmod +x ~/.local/bin/record-screen
    
    log "Created screen recording script"
    
    echo ""
    echo "📹 Media tools installed:"
    echo "   • OBS Studio - Professional streaming/recording"
    echo "   • wf-recorder - Wayland screen recording"  
    echo "   • record-screen - Simple recording script"
    echo ""
    echo "💡 Tip: Use 'record-screen' command for quick screen recordings"
}
#!/bin/bash

# 🐳 Docker Development Module
# Container development with Docker, Docker Compose, and Lazydocker

install_docker_module() {
    log "Installing Docker module"
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#0db7ed" --bold "🐳 Installing Docker Development Module"
    else
        echo "🐳 Installing Docker Development Module"
    fi
    
    local docker_packages=(
        "docker"
        "docker-compose" 
        "docker-buildx"
        "lazydocker-bin"
    )
    
    # Install packages
    install_packages "${docker_packages[@]}"
    
    # Post-installation setup
    setup_docker_environment
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" "✓ Docker module installed successfully"
    else
        echo "✓ Docker module installed successfully"
    fi
}

setup_docker_environment() {
    log "Setting up Docker environment"
    
    # Enable and start Docker service
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    
    # Add user to docker group
    sudo usermod -aG docker "$USER"
    
    # Create docker config directory
    mkdir -p ~/.docker
    
    # Configure Docker CLI
    if [[ ! -f ~/.docker/config.json ]]; then
        cat > ~/.docker/config.json << 'EOF'
{
    "auths": {},
    "credsStore": "",
    "experimental": "enabled",
    "features": {
        "buildkit": true
    }
}
EOF
        log "Created Docker CLI config"
    fi
    
    echo ""
    echo "⚠️  Important: You need to log out and back in (or reboot) for Docker group membership to take effect."
    echo ""
}
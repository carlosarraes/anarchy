#!/bin/bash

# ⚙️ Anarchy Configuration Management
# Handles system configuration, Git setup, shell setup, themes, and preferences

# Configuration functions

configure_git() {
    if [[ "$NO_PROMPTS" == "true" ]]; then
        return
    fi
    
    log "Configuring Git"
    
    # Check if Git is already configured
    if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
        local current_name
        local current_email
        current_name=$(git config --global user.name)
        current_email=$(git config --global user.email)
        
        if command -v gum &>/dev/null; then
            gum style --foreground="#D3D3D3" "Git already configured:"
            gum style --foreground="#50C878" "  Name: $current_name"
            gum style --foreground="#50C878" "  Email: $current_email"
            
            if ! gum confirm "Update Git configuration?"; then
                return
            fi
        else
            echo "Git already configured: $current_name <$current_email>"
            echo -n "Update Git configuration? (y/N): "
            read -r response
            if [[ ! "$response" =~ ^[Yy] ]]; then
                return
            fi
        fi
    fi
    
    # Get Git configuration
    local git_name git_email
    
    if command -v gum &>/dev/null; then
        git_name=$(gum input --placeholder "Enter your Git name (e.g., John Doe)")
        git_email=$(gum input --placeholder "Enter your Git email (e.g., john@example.com)")
    else
        echo -n "Enter your Git name: "
        read -r git_name
        echo -n "Enter your Git email: "
        read -r git_email
    fi
    
    # Configure Git
    if [[ -n "$git_name" && -n "$git_email" ]]; then
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        
        # Set some sensible Git defaults
        git config --global init.defaultBranch main
        git config --global pull.rebase true
        git config --global push.autoSetupRemote true
        git config --global core.editor nvim
        
        log "Configured Git: $git_name <$git_email>"
        echo "✓ Git configured successfully"
    fi
}

configure_shell() {
    log "Configuring shell"
    
    local current_shell
    current_shell=$(basename "$SHELL")
    
    if [[ "$NO_PROMPTS" == "true" ]]; then
        if [[ "$DEFAULT_SHELL" == "zsh" && "$current_shell" != "zsh" ]]; then
            change_shell_to_zsh
        fi
        return
    fi
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#D3D3D3" "Current shell: $current_shell"
        
        if [[ "$current_shell" != "zsh" ]]; then
            local shell_choice
            shell_choice=$(gum choose --header="Select default shell:" \
                "ZSH (recommended)" \
                "Keep current ($current_shell)")
            
            if [[ "$shell_choice" == "ZSH"* ]]; then
                change_shell_to_zsh
            fi
        else
            gum style --foreground="#50C878" "✓ Already using ZSH"
        fi
    else
        echo "Current shell: $current_shell"
        if [[ "$current_shell" != "zsh" ]]; then
            echo -n "Change to ZSH? (Y/n): "
            read -r response
            if [[ "$response" =~ ^[Yy] ]] || [[ -z "$response" ]]; then
                change_shell_to_zsh
            fi
        fi
    fi
}

change_shell_to_zsh() {
    log "Changing shell to ZSH"
    
    if command -v zsh &>/dev/null; then
        chsh -s /usr/bin/zsh
        echo "✓ Default shell changed to ZSH (takes effect on next login)"
    else
        echo "⚠️  ZSH not found, keeping current shell"
    fi
}

configure_theme() {
    log "Configuring theme"
    
    if [[ "$NO_PROMPTS" == "true" ]]; then
        set_theme "$THEME"
        return
    fi
    
    local available_themes=(
        "catppuccin|Catppuccin Mocha - Dark purple theme"
        "gruvbox|Gruvbox Dark - Retro groove colors"
        "nord|Nord - Arctic, north-bluish color palette"
        "everforest|Everforest Dark - Comfortable green theme"
        "tokyo-night|Tokyo Night - Dark theme inspired by Tokyo's night"
    )
    
    if command -v gum &>/dev/null; then
        echo ""
        gum style --foreground="#89CFF0" --bold "🎨 Theme Selection"
        echo ""
        
        # Show theme descriptions
        for theme_info in "${available_themes[@]}"; do
            local name="${theme_info%|*}"
            local desc="${theme_info#*|}"
            gum style --foreground="#FFD700" "• $desc"
        done
        
        echo ""
        local theme_choice
        theme_choice=$(gum choose --header="Select your preferred theme:" \
            "${available_themes[@]%|*}")
        
        if [[ -n "$theme_choice" ]]; then
            set_theme "$theme_choice"
        fi
    else
        echo ""
        echo "Available themes:"
        for i in "${!available_themes[@]}"; do
            local theme_info="${available_themes[$i]}"
            local desc="${theme_info#*|}"
            echo "$((i+1)). $desc"
        done
        
        echo -n "Select theme (1-${#available_themes[@]}): "
        read -r theme_num
        
        if [[ "$theme_num" =~ ^[0-9]+$ ]] && [[ "$theme_num" -ge 1 ]] && [[ "$theme_num" -le ${#available_themes[@]} ]]; then
            local selected_theme="${available_themes[$((theme_num-1))]%|*}"
            set_theme "$selected_theme"
        fi
    fi
}

set_theme() {
    local theme="$1"
    log "Setting theme: $theme"
    
    # Create theme symlink (will be used by configuration deployment)
    mkdir -p ~/.config/anarchy
    echo "$theme" > ~/.config/anarchy/current_theme
    
    echo "✓ Theme set to: $theme"
    echo "  (Theme will be applied when configurations are deployed)"
}

configure_preferences() {
    if [[ "$NO_PROMPTS" == "true" ]]; then
        return
    fi
    
    log "Configuring user preferences"
    
    if command -v gum &>/dev/null; then
        echo ""
        gum style --foreground="#89CFF0" --bold "🔧 System Preferences"
        echo ""
        
        # Auto-login option
        if gum confirm "Enable auto-login to Hyprland? (Recommended for single-user systems)"; then
            setup_autologin
        fi
        
        # Auto-updates option
        if gum confirm "Setup automatic system updates? (Updates packages weekly)"; then
            setup_auto_updates
        fi
        
        # Firewall option
        if gum confirm "Enable UFW firewall? (Recommended for security)"; then
            setup_firewall
        fi
    else
        echo ""
        echo "System Preferences:"
        
        echo -n "Enable auto-login to Hyprland? (y/N): "
        read -r response
        if [[ "$response" =~ ^[Yy] ]]; then
            setup_autologin
        fi
        
        echo -n "Setup automatic system updates? (y/N): "
        read -r response
        if [[ "$response" =~ ^[Yy] ]]; then
            setup_auto_updates
        fi
        
        echo -n "Enable UFW firewall? (y/N): "
        read -r response
        if [[ "$response" =~ ^[Yy] ]]; then
            setup_firewall
        fi
    fi
}

setup_autologin() {
    log "Setting up auto-login to Hyprland"
    
    # Simple approach: Auto-login via getty + shell profile
    # This is simpler than omarchy's UWSM+Plymouth approach
    
    # Configure auto-login via getty
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
    sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf > /dev/null << EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin $USER %I \$TERM
EOF
    
    # Add Hyprland auto-start to shell profile
    local shell_profile=""
    if [[ -f ~/.zshrc ]]; then
        shell_profile="$HOME/.zshrc"
    elif [[ -f ~/.bashrc ]]; then
        shell_profile="$HOME/.bashrc"
    fi
    
    if [[ -n "$shell_profile" ]] && ! grep -q "exec Hyprland" "$shell_profile"; then
        cat >> "$shell_profile" << 'EOF'

# Auto-start Hyprland on TTY1 (Anarchy)
if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
    exec Hyprland
fi
EOF
        log "Added Hyprland auto-start to $shell_profile"
    fi
    
    # Enable getty service
    sudo systemctl enable getty@tty1.service
    
    echo "✓ Auto-login configured - Hyprland will start automatically"
    echo "  (After reboot, you'll boot directly into Hyprland desktop)"
    log "Auto-login configured for user $USER"
}

setup_auto_updates() {
    log "Setting up automatic updates"
    
    # Create update script
    mkdir -p ~/.local/bin
    cat > ~/.local/bin/anarchy-auto-update << 'EOF'
#!/bin/bash
# Anarchy automatic update script

LOG_FILE="$HOME/.local/state/anarchy/auto-update.log"
mkdir -p "$(dirname "$LOG_FILE")"

{
    echo "$(date): Starting automatic update"
    
    # Update package database
    sudo pacman -Sy
    
    # Update packages (excluding AUR for safety)
    sudo pacman -Su --noconfirm
    
    # Clean package cache
    sudo pacman -Sc --noconfirm
    
    echo "$(date): Automatic update completed"
} >> "$LOG_FILE" 2>&1
EOF
    chmod +x ~/.local/bin/anarchy-auto-update
    
    # Create systemd timer
    mkdir -p ~/.config/systemd/user
    
    cat > ~/.config/systemd/user/anarchy-auto-update.service << 'EOF'
[Unit]
Description=Anarchy Automatic Update
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=%h/.local/bin/anarchy-auto-update
EOF
    
    cat > ~/.config/systemd/user/anarchy-auto-update.timer << 'EOF'
[Unit]
Description=Run Anarchy auto-update weekly
Requires=anarchy-auto-update.service

[Timer]
OnCalendar=weekly
Persistent=true

[Install]
WantedBy=timers.target
EOF
    
    # Enable timer
    systemctl --user enable anarchy-auto-update.timer
    
    echo "✓ Automatic updates configured (weekly)"
    log "Automatic updates configured"
}

setup_firewall() {
    log "Setting up UFW firewall"
    
    # Install UFW if not present (should be installed by modules if selected)
    if ! command -v ufw &>/dev/null; then
        echo "⚠️  UFW not installed, skipping firewall setup"
        return
    fi
    
    # Configure UFW
    sudo ufw --force reset
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    
    # Allow common services
    sudo ufw allow ssh
    
    # Enable UFW
    sudo ufw --force enable
    
    echo "✓ UFW firewall enabled"
    log "UFW firewall configured and enabled"
}

# Deploy configuration files
deploy_configurations() {
    log "Deploying configuration files"
    
    echo "🔧 Deploying Anarchy configurations..."
    
    # Create config directories
    mkdir -p ~/.config/{hypr,waybar,wofi,mako,ghostty}
    
    # Deploy configurations
    deploy_hyprland_config
    deploy_waybar_config
    deploy_wofi_config
    deploy_mako_config
    deploy_ghostty_config
    
    echo "✓ Configurations deployed successfully"
}

deploy_hyprland_config() {
    log "Deploying Hyprland configuration"
    
    # Copy configuration from config/ directory
    if [[ -d "$SCRIPT_DIR/config/hypr" ]]; then
        cp -r "$SCRIPT_DIR/config/hypr"/* ~/.config/hypr/
        log "Deployed Hyprland configuration"
    fi
}

deploy_waybar_config() {
    log "Deploying Waybar configuration"
    
    if [[ -d "$SCRIPT_DIR/config/waybar" ]]; then
        cp -r "$SCRIPT_DIR/config/waybar"/* ~/.config/waybar/
        log "Deployed Waybar configuration"
    fi
}

deploy_wofi_config() {
    log "Deploying Wofi configuration"
    
    if [[ -d "$SCRIPT_DIR/config/wofi" ]]; then
        cp -r "$SCRIPT_DIR/config/wofi"/* ~/.config/wofi/
        log "Deployed Wofi configuration"
    fi
}

deploy_mako_config() {
    log "Deploying Mako configuration"
    
    if [[ -d "$SCRIPT_DIR/config/mako" ]]; then
        cp -r "$SCRIPT_DIR/config/mako"/* ~/.config/mako/
        log "Deployed Mako configuration"
    fi
}

deploy_ghostty_config() {
    log "Deploying Ghostty configuration"
    
    if [[ -d "$SCRIPT_DIR/config/ghostty" ]]; then
        cp -r "$SCRIPT_DIR/config/ghostty"/* ~/.config/ghostty/
        log "Deployed Ghostty configuration"
    fi
}
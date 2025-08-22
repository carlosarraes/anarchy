#!/bin/bash

# 🏴‍☠️ Anarchy Core Package Installation
# Installs essential packages for the base system

# Core package categories
SYSTEM_UTILS=(
    "wget" "curl" "unzip" "inetutils" "fd" "eza" "fzf" "ripgrep"
    "zoxide" "bat" "jq" "wl-clipboard" "fastfetch" "btop" "man"
    "tealdeer" "less" "whois" "bash-completion" "plocate" "impala"
    "wikiman" "xdg-utils" "trash-cli" "grim"
)

TERMINAL_SHELL=(
    "ghostty" "zsh" "starship" "atuin"
)

DEVELOPMENT=(
    "cargo" "clang" "llvm" "imagemagick" "postgresql-libs"
    "github-cli" "lazygit" "neovim" "mise"
)

HYPRLAND_CORE=(
    "hyprland" "hyprshot" "hyprpicker" "hyprlock" "hypridle"
    "hyprsunset" "polkit-gnome" "hyprland-qtutils" "walker-bin"
    "libqalculate" "waybar" "mako" "swaybg" "swayosd" "wofi"
    "xdg-desktop-portal-hyprland" "xdg-desktop-portal-gtk"
)

MEDIA_CONTROLS=(
    "brightnessctl" "playerctl" "pamixer" "wireplumber"
    "mpv" "zathura" "zathura-pdf-poppler" "imv" "chromium"
)

INPUT_FILE_MGMT=(
    "fcitx5" "fcitx5-gtk" "fcitx5-qt" "wl-clip-persist"
    "thunar" "ffmpegthumbnailer" "gvfs-mtp"
)

SCREEN_TOOLS=(
    "slurp" "satty"
)

SECURITY_SYSTEM=(
    "gnome-keyring" "power-profiles-daemon" "tzupdate"
)

THEMING=(
    "kvantum-qt5" "gnome-themes-extra" "yaru-icon-theme"
)

FONTS=(
    "ttf-font-awesome" "ttf-cascadia-mono-nerd" "ttf-ia-writer"
    "noto-fonts" "noto-fonts-emoji"
)

# Install packages with progress display
install_with_progress() {
    local category="$1"
    shift
    local packages=("$@")
    local total=${#packages[@]}
    local current=0
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#89CFF0" "Installing $category ($total packages)..."
    else
        echo "Installing $category ($total packages)..."
    fi
    
    for package in "${packages[@]}"; do
        ((current++))
        
        if command -v gum &>/dev/null; then
            gum style --foreground="#D3D3D3" "[$current/$total] $package"
        else
            echo "[$current/$total] Installing $package..."
        fi
        
        # Check if package is already installed
        if pacman -Q "$package" &>/dev/null; then
            if command -v gum &>/dev/null; then
                gum style --foreground="#FFD700" "  ↳ Already installed"
            else
                echo "  ↳ Already installed"
            fi
            continue
        fi
        
        # Try to install package
        if yay -S --noconfirm --needed "$package" &>/dev/null; then
            if command -v gum &>/dev/null; then
                gum style --foreground="#50C878" "  ✓ Installed successfully"
            else
                echo "  ✓ Installed successfully"
            fi
        else
            if command -v gum &>/dev/null; then
                gum style --foreground="#FF6B6B" "  ✗ Failed to install"
            else
                echo "  ✗ Failed to install"
            fi
            log "Failed to install package: $package"
        fi
    done
    
    echo ""
}

# Install all core packages
install_core_packages() {
    log "Starting core package installation"
    
    echo "📦 Installing Anarchy core packages..."
    echo "This may take several minutes depending on your internet connection."
    echo ""
    
    # Update package database
    echo "🔄 Updating package database..."
    sudo pacman -Sy
    echo ""
    
    # Install packages by category
    install_with_progress "System Utilities" "${SYSTEM_UTILS[@]}"
    install_with_progress "Terminal & Shell" "${TERMINAL_SHELL[@]}"
    install_with_progress "Development Tools" "${DEVELOPMENT[@]}"
    install_with_progress "Hyprland Core" "${HYPRLAND_CORE[@]}"
    install_with_progress "Media & Controls" "${MEDIA_CONTROLS[@]}"
    install_with_progress "Input & File Management" "${INPUT_FILE_MGMT[@]}"
    install_with_progress "Screen Tools" "${SCREEN_TOOLS[@]}"
    install_with_progress "Security & System" "${SECURITY_SYSTEM[@]}"
    install_with_progress "Theming" "${THEMING[@]}"
    install_with_progress "Fonts" "${FONTS[@]}"
    
    # Post-installation setup
    post_install_setup
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" --bold "✅ Core packages installed successfully!"
    else
        echo "✅ Core packages installed successfully!"
    fi
    
    log "Core package installation completed"
}

# Post-installation setup for core packages
post_install_setup() {
    echo "🔧 Running post-installation setup..."
    
    # Enable essential services
    setup_essential_services
    
    # Configure shell
    setup_shell_basics
    
    # Setup clipboard manager
    setup_clipboard_manager
    
    echo "✓ Post-installation setup completed"
}

# Setup essential system services
setup_essential_services() {
    log "Setting up essential services"
    
    # Enable power management
    if systemctl list-unit-files | grep -q power-profiles-daemon; then
        sudo systemctl enable power-profiles-daemon.service
        log "Enabled power-profiles-daemon"
    fi
    
    # Enable Bluetooth (if available)
    if systemctl list-unit-files | grep -q bluetooth; then
        sudo systemctl enable bluetooth.service
        log "Enabled bluetooth service"
    fi
    
    # Configure time synchronization
    sudo timedatectl set-ntp true
    log "Enabled NTP time synchronization"
    
    # Setup user groups
    sudo usermod -aG input,video "$USER" || true
    log "Added user to input and video groups"
}

# Setup basic shell configuration
setup_shell_basics() {
    log "Setting up shell basics"
    
    # Create basic zsh config if it doesn't exist
    if [[ ! -f ~/.zshrc ]]; then
        cat > ~/.zshrc << 'EOF'
# Anarchy ZSH Configuration
# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Enable completion
autoload -Uz compinit && compinit

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

# Aliases
alias ls='eza --color=auto'
alias ll='eza -la --color=auto'
alias la='eza -a --color=auto'
alias grep='ripgrep'
alias cat='bat'
alias find='fd'
alias rm='trash'

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
EOF
        log "Created basic .zshrc"
    fi
    
    # Create basic starship config
    mkdir -p ~/.config
    if [[ ! -f ~/.config/starship.toml ]]; then
        cat > ~/.config/starship.toml << 'EOF'
# Anarchy Starship Configuration
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$character"""

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[directory]
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = " "

[git_status]
conflicted = "⚡"
ahead = "⇡"
behind = "⇣"
diverged = "⇕"
untracked = "?"
stashed = "$"
modified = "!"
staged = "+"
renamed = "»"
deleted = "✘"
EOF
        log "Created basic starship config"
    fi
}

# Setup clipboard manager
setup_clipboard_manager() {
    log "Setting up clipboard manager"
    
    # Create clipboard history directory
    mkdir -p ~/.local/share/cliphist
    
    # Note: cliphist will be started by Hyprland autostart
    log "Clipboard manager configured"
}

# Verify installation
verify_core_installation() {
    log "Verifying core installation"
    
    local essential_commands=(
        "ghostty" "zsh" "starship" "hyprland" "waybar" "wofi"
        "thunar" "mpv" "chromium" "git" "nvim"
    )
    
    local missing_commands=()
    
    for cmd in "${essential_commands[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing_commands+=("$cmd")
        fi
    done
    
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        echo "⚠️  Warning: Some essential commands are missing:"
        printf '  - %s\n' "${missing_commands[@]}"
        echo ""
        echo "The installation may not work correctly."
        return 1
    else
        echo "✓ All essential commands are available"
        return 0
    fi
}
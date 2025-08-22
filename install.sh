#!/bin/bash

set -e

# 🏴‍☠️ Anarchy Installer
# Main installation script with interactive prompts

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANARCHY_DIR="$HOME/.local/share/anarchy"
STATE_DIR="$HOME/.local/state/anarchy"
LOG_FILE="$STATE_DIR/install.log"

# Installation modes
INSTALL_MODE="interactive"
INSTALL_MODULES=""
NO_PROMPTS=false
THEME="catppuccin"
DEFAULT_SHELL="zsh"

# Create state directory
mkdir -p "$STATE_DIR"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
    echo "$@"
}

# Error handling
error_exit() {
    log "ERROR: $1"
    echo "❌ Installation failed: $1"
    echo "📋 Check log file: $LOG_FILE"
    exit 1
}

# Checkpoint system
create_checkpoint() {
    local phase="$1"
    local checkpoint_dir="$STATE_DIR/checkpoints/$phase"
    
    log "Creating checkpoint: $phase"
    mkdir -p "$checkpoint_dir"
    
    # Backup package state
    pacman -Q > "$checkpoint_dir/packages.txt" 2>/dev/null || true
    
    # Backup configs if they exist
    if [[ -d ~/.config ]]; then
        rsync -a ~/.config/ "$checkpoint_dir/config/" 2>/dev/null || true
    fi
    
    echo "✓ Checkpoint created: $phase"
}

# Rollback function
rollback_to_checkpoint() {
    local phase="$1"
    local checkpoint_dir="$STATE_DIR/checkpoints/$phase"
    
    if [[ -d "$checkpoint_dir" ]]; then
        echo "🔄 Rolling back to checkpoint: $phase"
        if [[ -d "$checkpoint_dir/config" ]]; then
            rsync -a "$checkpoint_dir/config/" ~/.config/
        fi
        echo "✓ Rollback completed"
    else
        error_exit "Checkpoint $phase not found"
    fi
}

# Safe package installation
install_packages() {
    local packages=("$@")
    local failed_packages=()
    local available_packages=()
    
    log "Checking package availability: ${packages[*]}"
    
    # Check package availability
    for pkg in "${packages[@]}"; do
        if pacman -Si "$pkg" &>/dev/null || yay -Si "$pkg" &>/dev/null; then
            available_packages+=("$pkg")
        else
            echo "⚠️  Package $pkg not found, skipping"
            failed_packages+=("$pkg")
        fi
    done
    
    # Install available packages
    if [[ ${#available_packages[@]} -gt 0 ]]; then
        log "Installing packages: ${available_packages[*]}"
        
        if command -v gum &>/dev/null; then
            echo ""
            gum style --foreground="#89CFF0" "📦 Installing ${#available_packages[@]} packages..."
        fi
        
        if yay -S --noconfirm --needed "${available_packages[@]}"; then
            log "Successfully installed: ${available_packages[*]}"
            echo "✓ Packages installed successfully"
        else
            error_exit "Package installation failed"
        fi
    fi
    
    # Report failed packages
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log "Failed to find packages: ${failed_packages[*]}"
        echo "⚠️  Skipped packages: ${failed_packages[*]}"
    fi
}

# Usage information
usage() {
    cat << 'EOF'
🏴‍☠️ Anarchy - Lightweight Arch + Hyprland

Usage: ./install.sh [OPTIONS]

Options:
  --minimal           Install core system only
  --full              Install all modules
  --modules LIST      Install specific modules (comma-separated)
  --no-prompts        Skip all interactive prompts
  --theme THEME       Set theme (catppuccin|gruvbox|nord|everforest|tokyo-night)
  --shell SHELL       Set default shell (zsh|bash)
  --rollback PHASE    Rollback to checkpoint (preflight|core|config)
  --help              Show this help

Examples:
  ./install.sh                                    # Interactive installation
  ./install.sh --minimal                          # Core only
  ./install.sh --modules docker,media             # Core + specific modules
  ./install.sh --full --no-prompts --theme nord   # Full automated install
  ./install.sh --rollback core                    # Rollback to core checkpoint

Available modules:
  docker, media, security, fonts-extra, printing, bluetooth, wireless, zsh-extras, dev-extras
EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --minimal)
                INSTALL_MODE="minimal"
                shift ;;
            --full)
                INSTALL_MODE="full"
                shift ;;
            --modules)
                INSTALL_MODULES="$2"
                shift 2 ;;
            --no-prompts)
                NO_PROMPTS=true
                shift ;;
            --theme)
                THEME="$2"
                shift 2 ;;
            --shell)
                DEFAULT_SHELL="$2"
                shift 2 ;;
            --rollback)
                rollback_to_checkpoint "$2"
                exit 0 ;;
            --help)
                usage
                exit 0 ;;
            *)
                echo "❌ Unknown option: $1"
                usage
                exit 1 ;;
        esac
    done
}

# Install gum for better UI (if not present)
install_gum() {
    if ! command -v gum &>/dev/null; then
        echo "📦 Installing gum for better UI..."
        sudo pacman -Sy --noconfirm gum || {
            yay -Sy --noconfirm gum
        }
    fi
}

# Preflight checks
preflight_checks() {
    log "Starting preflight checks"
    echo "🔍 Running preflight checks..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        error_exit "Do not run as root!"
    fi
    
    # Check if Arch Linux
    if ! grep -q "^ID=arch$" /etc/os-release 2>/dev/null; then
        error_exit "This installer is for Arch Linux only"
    fi
    
    # Check architecture
    if [[ $(uname -m) != "x86_64" ]]; then
        error_exit "Only x86_64 architecture is supported"
    fi
    
    # Check internet connectivity
    if ! ping -c 1 archlinux.org &>/dev/null; then
        error_exit "Internet connection required"
    fi
    
    # Check disk space (5GB minimum)
    local available_space
    available_space=$(df ~ | awk 'NR==2 {print int($4/1024/1024)}')
    if [[ $available_space -lt 5 ]]; then
        error_exit "At least 5GB free space required (found ${available_space}GB)"
    fi
    
    echo "✓ All preflight checks passed"
    create_checkpoint "preflight"
}

# Setup package manager
setup_package_manager() {
    log "Setting up package manager"
    echo "📦 Setting up package manager..."
    
    # Update package database
    sudo pacman -Sy
    
    # Install yay if not present
    if ! command -v yay &>/dev/null; then
        echo "Installing yay AUR helper..."
        sudo pacman -S --noconfirm base-devel git
        
        # Clone and build yay
        local temp_dir
        temp_dir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$temp_dir/yay"
        cd "$temp_dir/yay"
        makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
        rm -rf "$temp_dir"
    fi
    
    echo "✓ Package manager ready"
}

# Source module installation scripts
source_modules() {
    for module_file in "$SCRIPT_DIR"/modules/*.sh; do
        if [[ -f "$module_file" ]]; then
            source "$module_file"
        fi
    done
}

# Module selection interface
select_optional_modules() {
    if [[ "$NO_PROMPTS" == "true" ]]; then
        case "$INSTALL_MODE" in
            "full") install_all_modules ;;
            "minimal") return ;;
            *) install_selected_modules "$INSTALL_MODULES" ;;
        esac
        return
    fi
    
    echo ""
    gum style --foreground="#89CFF0" --bold "📦 Optional Modules"
    echo ""
    
    local modules_info=(
        "docker|Container development with Docker, Docker Compose, and Lazydocker TUI"
        "media|OBS Studio for streaming/recording, screen recording tools"
        "security|1Password desktop app and CLI tools"
        "fonts-extra|Additional fonts including CJK languages and JetBrains Mono"
        "printing|CUPS printing system with GUI configuration"
        "bluetooth|Bluetooth management with Blueberry GUI"
        "wireless|Advanced WiFi management with iwd and GUI tools"
        "zsh-extras|Enhanced ZSH with completions, syntax highlighting, autosuggestions"
        "dev-extras|Tree-sitter CLI and Lua development tools"
    )
    
    # Show module details
    if gum confirm "View module descriptions before selecting?"; then
        echo ""
        for info in "${modules_info[@]}"; do
            local name="${info%|*}"
            local desc="${info#*|}"
            gum style --foreground="#50C878" --bold "• $name"
            gum style --foreground="#D3D3D3" "  $desc"
            echo ""
        done
    fi
    
    # Multi-select modules
    echo ""
    local selected_modules
    selected_modules=$(gum choose --no-limit \
        --header="🎯 Select modules to install (SPACE to select, ENTER to confirm):" \
        "${modules_info[@]%|*}" \
        "None - Skip all modules") || true
    
    # Install selected modules
    if [[ -n "$selected_modules" && "$selected_modules" != "None - Skip all modules" ]]; then
        echo ""
        gum style --foreground="#89CFF0" "Installing selected modules..."
        while IFS= read -r module; do
            [[ -n "$module" ]] && install_module "$module"
        done <<< "$selected_modules"
    fi
}

# Install all modules
install_all_modules() {
    local all_modules=("docker" "media" "security" "fonts-extra" "printing" "bluetooth" "wireless" "zsh-extras" "dev-extras")
    for module in "${all_modules[@]}"; do
        install_module "$module"
    done
}

# Install selected modules from comma-separated list
install_selected_modules() {
    local modules_list="$1"
    IFS=',' read -ra modules <<< "$modules_list"
    for module in "${modules[@]}"; do
        module=$(echo "$module" | tr -d ' ')  # Remove spaces
        [[ -n "$module" ]] && install_module "$module"
    done
}

# Install specific module
install_module() {
    local module="$1"
    log "Installing module: $module"
    
    case "$module" in
        "docker") install_docker_module ;;
        "media") install_media_module ;;
        "security") install_security_module ;;
        "fonts-extra") install_fonts_extra_module ;;
        "printing") install_printing_module ;;
        "bluetooth") install_bluetooth_module ;;
        "wireless") install_wireless_module ;;
        "zsh-extras") install_zsh_extras_module ;;
        "dev-extras") install_dev_extras_module ;;
        *) echo "⚠️  Unknown module: $module" ;;
    esac
}

# System configuration
configure_system() {
    log "Configuring system"
    echo ""
    gum style --foreground="#89CFF0" --bold "⚙️  System Configuration"
    echo ""
    
    # Source configuration script
    source "$SCRIPT_DIR/core/config.sh"
    
    # Git configuration
    configure_git
    
    # Shell configuration  
    configure_shell
    
    # Theme configuration
    configure_theme
    
    # Additional preferences
    configure_preferences
}

# Main installation flow
main() {
    log "Starting Anarchy installation"
    
    # Parse arguments
    parse_args "$@"
    
    # Show welcome message
    echo "🏴‍☠️ Welcome to Anarchy - Lightweight Arch + Hyprland"
    echo "========================================================="
    echo ""
    
    # Install gum for better UI
    install_gum
    
    # Preflight checks
    preflight_checks
    
    # Setup package manager
    setup_package_manager
    
    # Source module scripts
    source_modules
    
    # Install core system
    echo ""
    gum style --foreground="#89CFF0" --bold "🚀 Installing Core System"
    source "$SCRIPT_DIR/core/packages.sh"
    install_core_packages
    create_checkpoint "core"
    
    # Optional modules
    if [[ "$INSTALL_MODE" != "minimal" ]]; then
        echo ""
        select_optional_modules
    fi
    
    # Configure system
    configure_system
    
    # Deploy configurations
    deploy_configurations
    create_checkpoint "config"
    
    # Final steps
    echo ""
    gum style --foreground="#50C878" --bold "🎉 Anarchy Installation Complete!"
    echo ""
    echo "📋 Next steps:"
    echo "   1. Reboot your system: sudo reboot"
    echo "   2. Log in and enjoy your new Hyprland setup!"
    echo ""
    echo "📚 Documentation: ~/.local/share/anarchy/README.md"
    echo "🔧 Configuration: ~/.config/"
    echo "📋 Logs: $LOG_FILE"
    
    log "Anarchy installation completed successfully"
}

# Run main function
main "$@"
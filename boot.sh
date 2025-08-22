#!/bin/bash

set -e

# 🏴‍☠️ Anarchy Bootstrapper
# Downloads and launches the Anarchy installer

ANARCHY_REPO="${ANARCHY_REPO:-https://github.com/carlosarraes/anarchy.git}"
ANARCHY_REF="${ANARCHY_REF:-main}"
ANARCHY_DIR="$HOME/.local/share/anarchy"

echo "🏴‍☠️ Anarchy - Lightweight Arch + Hyprland"
echo "============================================="
echo ""

# Ensure git is installed
if ! command -v git &>/dev/null; then
    echo "📦 Installing git..."
    sudo pacman -Sy --noconfirm git
fi

# Configure git for anonymous clones (no auth required)
export GIT_TERMINAL_PROMPT=0
export GIT_ASKPASS=true
git config --global credential.helper ""
git config --global --unset-all credential.helper 2>/dev/null || true

# Create directory
mkdir -p "$(dirname "$ANARCHY_DIR")"

# Clone or update repository
if [[ -d "$ANARCHY_DIR" ]]; then
    echo "🔄 Updating existing Anarchy installation..."
    cd "$ANARCHY_DIR"
    
    # Make sure we're using HTTPS origin (not SSH)
    git remote set-url origin "$ANARCHY_REPO"
    
    if ! git fetch origin 2>/dev/null; then
        echo "❌ Failed to update repository. Trying fresh clone..."
        cd ..
        rm -rf "$ANARCHY_DIR"
    else
        git reset --hard "origin/$ANARCHY_REF"
    fi
fi

# Fresh clone if directory doesn't exist or update failed
if [[ ! -d "$ANARCHY_DIR" ]]; then
    echo "📥 Downloading Anarchy..."
    
    # Try clone with explicit HTTPS and no credential prompting
    if ! env GIT_TERMINAL_PROMPT=0 GIT_ASKPASS=true git clone --depth=1 --branch="$ANARCHY_REF" "$ANARCHY_REPO" "$ANARCHY_DIR" 2>/dev/null; then
        echo "⚠️  Git clone failed, trying alternative download method..."
        
        # Fallback: Download via curl + unzip
        local temp_zip="/tmp/anarchy-main.zip"
        if curl -fsSL "https://github.com/carlosarraes/anarchy/archive/refs/heads/main.zip" -o "$temp_zip"; then
            echo "📥 Downloading via ZIP archive..."
            if command -v unzip &>/dev/null; then
                unzip -q "$temp_zip" -d /tmp/
                mv "/tmp/anarchy-main" "$ANARCHY_DIR"
                rm "$temp_zip"
                echo "✓ Download successful via ZIP"
            else
                echo "❌ unzip command not found. Installing..."
                sudo pacman -Sy --noconfirm unzip
                unzip -q "$temp_zip" -d /tmp/
                mv "/tmp/anarchy-main" "$ANARCHY_DIR"
                rm "$temp_zip"
                echo "✓ Download successful via ZIP"
            fi
        else
            echo "❌ All download methods failed. This might be because:"
            echo "   1. Repository is private (needs to be public)"
            echo "   2. Repository doesn't exist"
            echo "   3. Network connection issues"
            echo ""
            echo "🔧 Troubleshooting:"
            echo "   • Make sure the repository 'carlosarraes/anarchy' exists and is public"
            echo "   • Check your internet connection"
            echo "   • Try manual clone: git clone $ANARCHY_REPO"
            exit 1
        fi
    fi
    
    cd "$ANARCHY_DIR"
fi

echo ""
echo "🚀 Starting Anarchy installer..."
echo ""

# Make installer executable and run it
chmod +x install.sh
exec ./install.sh "$@"
#!/bin/bash

set -e

# 🏴‍☠️ Anarchy Bootstrapper
# Downloads and launches the Anarchy installer

ANARCHY_REPO="${ANARCHY_REPO:-https://github.com/carraes/anarchy.git}"
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

# Create directory
mkdir -p "$(dirname "$ANARCHY_DIR")"

# Clone or update repository
if [[ -d "$ANARCHY_DIR" ]]; then
    echo "🔄 Updating existing Anarchy installation..."
    cd "$ANARCHY_DIR"
    git fetch origin
    git reset --hard "origin/$ANARCHY_REF"
else
    echo "📥 Downloading Anarchy..."
    git clone "$ANARCHY_REPO" "$ANARCHY_DIR"
    cd "$ANARCHY_DIR"
    git checkout "$ANARCHY_REF"
fi

echo ""
echo "🚀 Starting Anarchy installer..."
echo ""

# Make installer executable and run it
chmod +x install.sh
exec ./install.sh "$@"
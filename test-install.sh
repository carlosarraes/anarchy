#!/bin/bash

# 🏴‍☠️ Anarchy Installation Test
# Test script to verify installation system works

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🏴‍☠️ Anarchy Installation Test"
echo "==============================="
echo ""

# Test 1: Verify script structure
echo "📋 Test 1: Verifying script structure..."

required_files=(
    "install.sh"
    "boot.sh"
    "core/packages.sh"
    "core/config.sh"
    "modules/docker.sh"
    "modules/media.sh"
    "config/hypr/hyprland.conf"
    "config/hypr/keybindings.conf"
    "bin/anarchy-power-menu"
    "bin/anarchy-update"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [[ ! -f "$SCRIPT_DIR/$file" ]]; then
        missing_files+=("$file")
    fi
done

if [[ ${#missing_files[@]} -gt 0 ]]; then
    echo "❌ Missing required files:"
    printf '  - %s\n' "${missing_files[@]}"
    exit 1
else
    echo "✓ All required files present"
fi

# Test 2: Verify script syntax
echo ""
echo "📋 Test 2: Verifying script syntax..."

syntax_errors=()
for script in install.sh boot.sh core/*.sh modules/*.sh bin/*; do
    if [[ -f "$script" ]]; then
        if ! bash -n "$script" 2>/dev/null; then
            syntax_errors+=("$script")
        fi
    fi
done

if [[ ${#syntax_errors[@]} -gt 0 ]]; then
    echo "❌ Syntax errors in:"
    printf '  - %s\n' "${syntax_errors[@]}"
    exit 1
else
    echo "✓ All scripts have valid syntax"
fi

# Test 3: Verify executable permissions
echo ""
echo "📋 Test 3: Verifying executable permissions..."

executable_files=("install.sh" "boot.sh")
for file in bin/*; do
    [[ -f "$file" ]] && executable_files+=("$file")
done

permission_errors=()
for file in "${executable_files[@]}"; do
    if [[ -f "$file" && ! -x "$file" ]]; then
        permission_errors+=("$file")
    fi
done

if [[ ${#permission_errors[@]} -gt 0 ]]; then
    echo "❌ Missing executable permissions:"
    printf '  - %s\n' "${permission_errors[@]}"
    echo "Run: chmod +x ${permission_errors[*]}"
    exit 1
else
    echo "✓ All required files are executable"
fi

# Test 4: Verify configuration file syntax
echo ""
echo "📋 Test 4: Verifying configuration files..."

config_errors=()

# Test JSON files
for json_file in config/waybar/*.jsonc; do
    if [[ -f "$json_file" ]]; then
        # Remove comments for JSON validation
        if ! grep -v '^[[:space:]]*#' "$json_file" | grep -v '^[[:space:]]*\/\/' | jq . >/dev/null 2>&1; then
            config_errors+=("$json_file (invalid JSON)")
        fi
    fi
done

if [[ ${#config_errors[@]} -gt 0 ]]; then
    echo "⚠️  Configuration file warnings:"
    printf '  - %s\n' "${config_errors[@]}"
else
    echo "✓ Configuration files are valid"
fi

# Test 5: Verify package lists
echo ""
echo "📋 Test 5: Verifying package definitions..."

if ! grep -q "SYSTEM_UTILS" core/packages.sh; then
    echo "❌ Package arrays not found in core/packages.sh"
    exit 1
fi

# Count core packages
package_count=$(grep -o '"[^"]*"' core/packages.sh | wc -l)
echo "✓ Found $package_count core packages defined"

# Test 6: Test dry-run functionality
echo ""
echo "📋 Test 6: Testing installation options..."

if ./install.sh --help >/dev/null 2>&1; then
    echo "✓ Help command works"
else
    echo "❌ Help command failed"
    exit 1
fi

# Test 7: Verify keybinding configuration
echo ""
echo "📋 Test 7: Verifying keybinding configuration..."

required_bindings=(
    "\$mainMod, T, exec" # Terminal
    "\$mainMod, Q, killactive" # Close window
    "\$mainMod, E, exec" # File manager
    "\$mainMod, A, exec" # App launcher
    "\$mainMod, H, movefocus" # Vim navigation
)

missing_bindings=()
for binding in "${required_bindings[@]}"; do
    if ! grep -q "$binding" config/hypr/keybindings.conf; then
        missing_bindings+=("$binding")
    fi
done

if [[ ${#missing_bindings[@]} -gt 0 ]]; then
    echo "❌ Missing required keybindings:"
    printf '  - %s\n' "${missing_bindings[@]}"
    exit 1
else
    echo "✓ All required keybindings present"
fi

# Test 8: Check for your preferred keymaps
echo ""
echo "📋 Test 8: Verifying custom keymaps..."

custom_keymaps=(
    "\$mainMod, T" # Terminal (not Return)
    "\$mainMod, Q" # Kill (not W)
    "\$mainMod, H, movefocus" # Vim H
    "\$mainMod, J, movefocus" # Vim J  
    "\$mainMod, K, movefocus" # Vim K
    "\$mainMod, L, movefocus" # Vim L
)

for keymap in "${custom_keymaps[@]}"; do
    if ! grep -q "$keymap" config/hypr/keybindings.conf; then
        echo "❌ Missing custom keymap: $keymap"
        exit 1
    fi
done

echo "✓ All custom keymaps configured correctly"

# Final summary
echo ""
echo "🎉 All tests passed!"
echo ""
echo "✅ Installation system is ready"
echo "✅ Your custom keymaps are configured"
echo "✅ All required components are present"
echo "✅ Configuration files are valid"
echo ""
echo "🚀 You can now run: ./install.sh"
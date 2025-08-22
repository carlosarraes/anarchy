#!/bin/bash

# 🔤 Extra Fonts Module
# Additional fonts including CJK and JetBrains Mono

install_fonts_extra_module() {
    log "Installing Extra Fonts module"
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#9370db" --bold "🔤 Installing Extra Fonts Module"
    else
        echo "🔤 Installing Extra Fonts Module"
    fi
    
    local font_packages=(
        "ttf-jetbrains-mono"
        "noto-fonts-cjk"
        "noto-fonts-extra"
    )
    
    # Install packages
    install_packages "${font_packages[@]}"
    
    # Refresh font cache
    refresh_font_cache
    
    if command -v gum &>/dev/null; then
        gum style --foreground="#50C878" "✓ Extra fonts module installed successfully"
    else
        echo "✓ Extra fonts module installed successfully"
    fi
}

refresh_font_cache() {
    log "Refreshing font cache"
    
    echo "🔄 Refreshing font cache..."
    fc-cache -fv >/dev/null 2>&1
    
    echo ""
    echo "🔤 Additional fonts installed:"
    echo "   • JetBrains Mono - Programming font with ligatures"
    echo "   • Noto CJK - Chinese, Japanese, Korean language support"
    echo "   • Noto Extra - Extended Unicode coverage"
    echo ""
}
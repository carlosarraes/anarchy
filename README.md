# 🏴‍☠️ Anarchy

**Lightweight Arch Linux + Hyprland Configuration**

Anarchy is a minimal, fast, and clean Arch Linux distribution configuration that transforms a fresh Arch installation into a fully-configured Hyprland desktop environment with vim-style keybindings and modular components.

## ✨ Features

- 🚀 **Fast & Lightweight** - Only 75 essential packages, optional modules
- ⌨️  **Vim-style Navigation** - H/J/K/L keybindings for window management  
- 🎨 **Beautiful Themes** - 5 pre-configured themes (Catppuccin, Gruvbox, Nord, etc.)
- 📦 **Modular Design** - Install only what you need, when you need it
- 🔧 **Smart Defaults** - Sensible configurations out of the box
- 🛡️  **Safe Installation** - Rollback points, checkpoints, and error handling
- 🎯 **Your Preferences** - Respects existing keybindings and workflow

## 🚀 Quick Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/carraes/anarchy/main/boot.sh)
```

> **Note**: Replace `carraes/anarchy` with your actual GitHub username/repository when you publish this.

## 📦 Core Components

### Essential Applications
- **Terminal**: Ghostty with ZSH + Starship + Atuin
- **Shell**: ZSH with enhanced completions and history
- **File Manager**: Thunar with thumbnails
- **App Launcher**: Wofi + Walker (with calculator)
- **PDF Viewer**: Zathura (lightweight, keyboard-driven)
- **Image Viewer**: IMV (fast Wayland image viewer)
- **Video Player**: MPV (minimal, powerful)
- **Editor**: Neovim (vanilla, no LazyVim)
- **Browser**: Chromium

### Hyprland Desktop Stack
- **Window Manager**: Hyprland with custom configs
- **Status Bar**: Waybar with beautiful modules
- **Notifications**: Mako with themed styling
- **Screenshots**: Hyprshot + Slurp + Satty workflow
- **Lock Screen**: Hyprlock with user info
- **Idle Management**: Hypridle with smart timeouts
- **Clipboard**: Cliphist with wofi integration

### Development Tools
- **Version Control**: Git + Lazygit TUI
- **Package Manager**: Mise for language versions
- **Build Tools**: Cargo, Clang, LLVM
- **File Search**: fd, ripgrep, fzf, zoxide
- **System Info**: btop, fastfetch
- **Documentation**: tealdeer (tldr), wikiman (Arch Wiki)

## 🎮 Your Custom Keybindings

| Key Combination | Action | Notes |
|----------------|--------|-------|
| `SUPER + T` | Open Terminal | Ghostty (not Return key) |
| `SUPER + Q` | Close Window | (not W key) |
| `SUPER + M` | Exit Hyprland | |
| `SUPER + E` | File Manager | Thunar |
| `SUPER + A` | App Launcher | Wofi |
| `SUPER + F` | Fullscreen | |
| `SUPER + V` | Toggle Floating | |
| `SUPER + P` | Screenshot Region | |
| `SUPER + R` | Clipboard History | |
| `SUPER + H/J/K/L` | Move Focus | Vim-style navigation |
| `SUPER + SHIFT + H/J/K/L` | Move Window | |
| `SUPER + 1-0` | Switch Workspace | |
| `SUPER + SHIFT + 1-0` | Move to Workspace | |
| `SUPER + Escape` | Power Menu | |
| `SUPER + Print` | Color Picker | |

### Additional Utilities
| Key | Action |
|-----|--------|
| `SUPER + Comma` | Dismiss Notification |
| `SUPER + SHIFT + Comma` | Theme Switcher |
| `SUPER + CTRL + I` | Toggle Idle Lock |
| `SUPER + CTRL + N` | Toggle Nightlight |

## 🧩 Optional Modules

Choose exactly what you need:

| Module | Description | Packages |
|--------|-------------|----------|
| **docker** | Container development | Docker, Docker Compose, Lazydocker |
| **media** | Content creation | OBS Studio, screen recording tools |
| **security** | Password management | 1Password desktop + CLI |
| **fonts-extra** | Additional fonts | JetBrains Mono, CJK languages |
| **printing** | Printing support | CUPS system + GUI tools |
| **bluetooth** | Bluetooth management | Blueberry GUI manager |
| **wireless** | Advanced WiFi | iwd daemon + tools |
| **zsh-extras** | Enhanced shell | Syntax highlighting, autosuggestions |
| **dev-extras** | Development tools | Tree-sitter CLI, Luarocks |

## 🛠️ Installation Options

### Interactive Installation (Recommended)
```bash
./install.sh
```
- Guides you through module selection
- Configures Git, shell, and themes
- Shows progress and provides help

### Automated Installation
```bash
# Minimal (core only)
./install.sh --minimal

# Full installation (all modules)
./install.sh --full

# Custom modules
./install.sh --modules docker,media,security

# Fully automated
./install.sh --full --no-prompts --theme catppuccin --shell zsh
```

### Available Options
```bash
./install.sh [OPTIONS]

Options:
  --minimal           Install core system only
  --full              Install all modules
  --modules LIST      Install specific modules (comma-separated)
  --no-prompts        Skip all interactive prompts
  --theme THEME       Set theme (catppuccin|gruvbox|nord|everforest|tokyo-night)
  --shell SHELL       Set default shell (zsh|bash)
  --rollback PHASE    Rollback to checkpoint
  --help              Show help
```

## 🎨 Available Themes

1. **Catppuccin Mocha** - Dark purple theme (default)
2. **Gruvbox Dark** - Retro groove colors
3. **Nord** - Arctic, north-bluish color palette  
4. **Everforest Dark** - Comfortable green theme
5. **Tokyo Night** - Dark theme inspired by Tokyo's night

Switch themes anytime with `SUPER + SHIFT + Comma` or `anarchy-theme-switch`.

## 📋 Requirements

- **OS**: Fresh Arch Linux installation (not derivatives)
- **Architecture**: x86_64 only
- **Disk Space**: 5GB free space minimum
- **Network**: Internet connection required
- **Permissions**: Non-root user with sudo access
- **Arch Installation**: Any archinstall profile works (minimal, desktop, server, etc.)

## 🔄 Post-Installation

### Useful Commands
```bash
# Update Anarchy + system packages
anarchy-update

# Switch themes
anarchy-theme-switch

# Power menu
anarchy-power-menu

# Toggle features
anarchy-toggle-idle
anarchy-toggle-nightlight
```

### Configuration Locations
- **Anarchy**: `~/.local/share/anarchy/`
- **Hyprland**: `~/.config/hypr/`
- **Waybar**: `~/.config/waybar/`
- **Shell**: `~/.zshrc`
- **Logs**: `~/.local/state/anarchy/`

## 🆚 Anarchy vs Omarchy

| Feature | Omarchy | Anarchy |
|---------|---------|---------|
| **Core Packages** | 100+ | 75 |
| **Web Apps** | 12 auto-installed | None (optional) |
| **Terminal** | Alacritty | Ghostty |
| **Navigation** | Arrow keys | Vim H/J/K/L |
| **PDF Viewer** | Evince (heavy) | Zathura (light) |
| **Shell** | Bash | ZSH + enhancements |
| **History** | Basic | Atuin (sync capable) |
| **Installation** | All-or-nothing | Modular choice |
| **File Search** | Basic locate | fd + ripgrep |
| **Keybindings** | Omarchy style | Your preferences |

## 🧪 Testing

Test the installation system before running:

```bash
./test-install.sh
```

This verifies:
- ✅ All required files present
- ✅ Script syntax validity  
- ✅ Configuration file structure
- ✅ Your custom keybindings
- ✅ Package definitions

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Test with `./test-install.sh`
4. Submit a pull request

## 📚 Documentation

- **Installation Guide**: This README
- **Keybindings**: `config/hypr/keybindings.conf`
- **Package Lists**: `core/packages.sh` and `modules/`
- **Configuration**: `config/` directory
- **Utilities**: `bin/` directory

## 🙏 Credits

Inspired by [Omarchy](https://github.com/2kabhishek/omarchy) by 2KAbhishek, but redesigned for:
- Minimalism and speed
- Vim-style workflows  
- Modular architecture
- User choice and customization

## 📄 License

MIT License - See LICENSE file for details

---

**🏴‍☠️ Anarchy: Lightweight. Fast. Yours.**
# 🚀 Anarchy Quick Start Guide

Get up and running with Anarchy in 5 minutes!

## 🏁 Step 1: Prerequisites

Ensure you have:
- ✅ Fresh Arch Linux installation
- ✅ Non-root user with sudo access
- ✅ Internet connection
- ✅ 5GB+ free disk space

## 🏁 Step 2: Install Anarchy

### Option A: Remote Install (Recommended)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/carraes/anarchy/main/boot.sh)
```

### Option B: Manual Install
```bash
git clone https://github.com/carraes/anarchy.git ~/.local/share/anarchy
cd ~/.local/share/anarchy
./install.sh
```

## 🏁 Step 3: Choose Your Installation

The installer will ask you to select optional modules:

### 🎯 Recommended for Most Users
```
✅ zsh-extras     (Enhanced shell experience)
✅ fonts-extra    (Better font support)
⬜ docker         (Only if you develop with containers)
⬜ media          (Only if you create content)
```

### 🖥️ For Developers
```
✅ zsh-extras
✅ fonts-extra  
✅ docker
✅ dev-extras
⬜ security       (If you use 1Password)
```

### 🎬 For Content Creators
```
✅ zsh-extras
✅ fonts-extra
✅ media
✅ printing       (If you print documents)
```

## 🏁 Step 4: Configure

The installer will ask:

1. **Git Configuration**
   - Enter your name: `John Doe`
   - Enter your email: `john@example.com`

2. **Shell Choice**
   - Choose: `ZSH (recommended)`

3. **Theme Selection**
   - Recommended: `Catppuccin Mocha`
   - Also great: `Gruvbox Dark`, `Nord`

4. **System Preferences**
   - Auto-login: `Yes` (if single user system)
   - Auto-updates: `Yes` (recommended)
   - Firewall: `Yes` (recommended)

## 🏁 Step 5: Reboot & Enjoy!

```bash
sudo reboot
```

After reboot, you'll automatically log into your new Hyprland desktop!

## 🎮 Essential Keybindings

| Key | Action |
|-----|--------|
| `SUPER + T` | Terminal |
| `SUPER + A` | App Launcher |
| `SUPER + E` | File Manager |
| `SUPER + Q` | Close Window |
| `SUPER + H/J/K/L` | Navigate Windows (Vim-style) |
| `SUPER + P` | Screenshot |
| `SUPER + Escape` | Power Menu |

## 🔧 Post-Install Tips

### Update System
```bash
anarchy-update
```

### Switch Themes
```bash
anarchy-theme-switch
# or press SUPER + SHIFT + Comma
```

### Install More Modules Later
```bash
cd ~/.local/share/anarchy
./install.sh --modules docker,media
```

### Troubleshooting
```bash
# Check logs
tail -f ~/.local/state/anarchy/install.log

# Test installation
./test-install.sh

# Rollback if needed
./install.sh --rollback core
```

## 🎉 You're Done!

Welcome to your new lightweight, fast, and beautiful Arch + Hyprland desktop!

### What's Installed
- ✨ Modern terminal with Ghostty + ZSH
- 📁 Thunar file manager with previews
- 🌐 Chromium browser
- 📝 Neovim editor
- 🎨 Beautiful Waybar status bar
- 🔔 Mako notifications
- 📸 Screenshot tools
- 🎨 Theme system

### Next Steps
- Explore the `bin/anarchy-*` utilities
- Customize configs in `~/.config/`
- Add your own applications
- Enjoy your vim-style workflow!

---

**Need help?** Check the full [README.md](README.md) or open an issue!
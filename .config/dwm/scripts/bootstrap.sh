#!/usr/bin/env bash
# ── DWM & Desktop Bootstrap Script ──
# Color tokens
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BLUE}${BOLD}=================================================="
echo -e "          DWM & DESKTOP ENVIRONMENT BOOTSTRAP       "
echo -e "==================================================${NC}\n"

# 1. Detect OS
if [ -f /etc/arch-release ]; then
    OS="Arch"
elif [ -f /etc/debian_version ]; then
    OS="Debian"
else
    echo -e "${RED}Unsupported OS. This script only supports Arch and Debian-based systems.${NC}"
    exit 1
fi
echo -e "${GREEN}Detected OS: ${BOLD}$OS${NC}\n"

# 2. Define dependencies
declare -A DEPS_MAP
if [ "$OS" = "Arch" ]; then
    # Format: [binary/library_to_check]="package_name"
    DEPS_MAP=(
        ["make"]="base-devel"
        ["Xorg"]="xorg-server"
        ["startx"]="xorg-xinit"
        ["/usr/include/X11/Xlib.h"]="libx11"
        ["/usr/include/X11/extensions/Xinerama.h"]="libxinerama"
        ["/usr/include/X11/Xft/Xft.h"]="libxft"
        ["/usr/include/X11/extensions/shape.h"]="libxext"
        ["/usr/include/X11/extensions/Xrandr.h"]="libxrandr"
        ["/usr/include/freetype2/ft2build.h"]="freetype2"
        ["pkg-config"]="pkgconf"
        ["zsh"]="zsh"
        ["eza"]="eza"
        ["kitty"]="kitty"
        ["yazi"]="yazi"
        ["chromium"]="chromium"
        ["flameshot"]="flameshot"
        ["picom"]="picom"
        ["dunst"]="dunst"
        ["notify-send"]="libnotify"
        ["rofi"]="rofi"
        ["feh"]="feh"
        ["xss-lock"]="xss-lock"
        ["nmcli"]="networkmanager"
        ["nm-applet"]="network-manager-applet"
        ["bluetoothctl"]="bluez-utils"
        ["brightnessctl"]="brightnessctl"
        ["playerctl"]="playerctl"
        ["pavucontrol"]="pavucontrol"
        ["pactl"]="pipewire-pulse"
        ["/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf"]="ttf-jetbrains-mono-nerd"
    )
    INSTALL_CMD="sudo pacman -S --needed"
else
    DEPS_MAP=(
        ["make"]="build-essential"
        ["Xorg"]="xorg"
        ["startx"]="xinit"
        ["/usr/include/X11/Xlib.h"]="libx11-dev"
        ["/usr/include/X11/extensions/Xinerama.h"]="libxinerama-dev"
        ["/usr/include/X11/Xft/Xft.h"]="libxft-dev"
        ["/usr/include/X11/extensions/shape.h"]="libxext-dev"
        ["/usr/include/X11/extensions/Xrandr.h"]="libxrandr-dev"
        ["/usr/include/freetype2/ft2build.h"]="libfreetype6-dev"
        ["pkg-config"]="pkg-config"
        ["zsh"]="zsh"
        ["kitty"]="kitty"
        ["flameshot"]="flameshot"
        ["picom"]="picom"
        ["dunst"]="dunst"
        ["notify-send"]="libnotify-bin"
        ["rofi"]="rofi"
        ["feh"]="feh"
        ["xss-lock"]="xss-lock"
        ["nmcli"]="network-manager"
        ["nm-applet"]="network-manager-gnome"
        ["bluetoothctl"]="bluez-tools"
        ["brightnessctl"]="brightnessctl"
        ["playerctl"]="playerctl"
        ["pavucontrol"]="pavucontrol"
        ["pactl"]="pulseaudio-utils"
        ["/usr/share/fonts/truetype/fonts-visual-studio-code/JetBrainsMono.ttf"]="fonts-jetbrains-mono"
    )
    INSTALL_CMD="sudo apt install --no-install-recommends"
fi

# 3. Scan dependencies
echo -e "${BOLD}Scanning system dependencies...${NC}"
MISSING_DEPS=()
for key in "${!DEPS_MAP[@]}"; do
    pkg="${DEPS_MAP[$key]}"
    
    # Check by path or command name
    if [[ "$key" == /* ]]; then
        if [ -e "$key" ]; then
            echo -e "  [${GREEN}✓${NC}] $pkg"
        else
            echo -e "  [${RED}✗${NC}] $pkg"
            MISSING_DEPS+=("$pkg")
        fi
    else
        if command -v "$key" &>/dev/null; then
            echo -e "  [${GREEN}✓${NC}] $pkg"
        else
            echo -e "  [${RED}✗${NC}] $pkg"
            MISSING_DEPS+=("$pkg")
        fi
    fi
done

# 4. Install missing dependencies
if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}Great news! All required packages are already installed.${NC}\n"
else
    echo -e "\n${YELLOW}${BOLD}Missing packages (${#MISSING_DEPS[@]}): ${MISSING_DEPS[*]}${NC}"
    read -rp "Would you like to install the missing packages? [y/N]: " install_confirm
    if [[ "$install_confirm" =~ ^[Yy]$ ]]; then
        $INSTALL_CMD "${MISSING_DEPS[@]}"
    else
        echo -e "${YELLOW}Skipping dependency installation.${NC}"
    fi
fi

# 5. Compile & Install Suckless Builds
echo -e "${BOLD}Checking Suckless source directories...${NC}"
SUCKLESS_BUILDS=("dwm" "dwmblocks" "st" "slock" "dmenu")
BUILDS_TO_COMPILE=()

for build in "${SUCKLESS_BUILDS[@]}"; do
    if [ -d "$HOME/.config/$build" ]; then
        echo -e "  [${GREEN}Found${NC}] $build source in ~/.config/$build"
        BUILDS_TO_COMPILE+=("$build")
    else
        echo -e "  [${RED}Missing${NC}] $build source directory"
    fi
done

if [ ${#BUILDS_TO_COMPILE[@]} -gt 0 ]; then
    echo ""
    read -rp "Would you like to compile and install found builds? (${BUILDS_TO_COMPILE[*]}) [y/N]: " build_confirm
    if [[ "$build_confirm" =~ ^[Yy]$ ]]; then
        for build in "${BUILDS_TO_COMPILE[@]}"; do
            echo -e "\n${BLUE}${BOLD}Building and installing $build...${NC}"
            cd "$HOME/.config/$build" || continue
            if sudo make clean install; then
                echo -e "${GREEN}✓ Successfully installed $build${NC}"
            else
                echo -e "${RED}✗ Failed to compile $build${NC}"
            fi
        done
    else
        echo -e "${YELLOW}Skipping compilation.${NC}"
    fi
fi

echo -e "\n${GREEN}${BOLD}Bootstrap session finished!${NC}"

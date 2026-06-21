#!/bin/sh
# ── dmenu-configs: Quick config file editor ──

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

# Define config files with nice labels
CONFIGS="  DWM config           | $HOME/.config/dwm/config.def.h
  dmenu config          | $HOME/.config/dmenu/config.def.h
  Picom                 | $HOME/.config/picom/picom.conf
  Kitty                 | $HOME/.config/kitty/kitty.conf
  Neovim init           | $HOME/.config/custom-nvim/init.lua
  Zsh config            | $HOME/.zshrc
  DWM autostart         | $HOME/.config/dwm/scripts/run.sh
  dmenu scripts         | $HOME/.config/dmenu/scripts/
  Xresources            | $HOME/.Xresources
  dunst                 | $HOME/.config/dunst/dunstrc
  Yazi                  | $HOME/.config/yazi/yazi.toml"

choice=$(echo "$CONFIGS" | dmenu_styled -p "  Edit Config")
[ -z "$choice" ] && exit 0

FILE=$(echo "$choice" | awk -F'|' '{print $2}' | xargs)

if [ -d "$FILE" ]; then
    $TERMINAL -e yazi "$FILE"
elif [ -f "$FILE" ]; then
    $TERMINAL -e nvim "$FILE"
else
    notify "  Config" "File not found: $FILE"
fi

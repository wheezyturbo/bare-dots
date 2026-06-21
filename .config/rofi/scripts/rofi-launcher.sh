#!/bin/sh
# ── rofi-launcher: Master launcher hub ──
# Acts as a rofi-style meta launcher — pick what you want to do

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/rofi-common.sh"

choice=$(printf "  Apps\n  Power\n  WiFi\n  Bluetooth\n  Screenshot\n  Clipboard\n  Emoji\n  Calculator\n  Kill Process\n  Configs\n  Bookmarks\n  Display" | rofi_styled -p "  Menu")

case "$choice" in
    *Apps)       rofi -show drun -p "  Apps" ;;
    *Power)      "$SCRIPT_DIR/rofi-power.sh" ;;
    *WiFi)       "$SCRIPT_DIR/rofi-wifi.sh" ;;
    *Bluetooth)  "$SCRIPT_DIR/rofi-bluetooth.sh" ;;
    *Screenshot) "$SCRIPT_DIR/rofi-screenshot.sh" ;;
    *Clipboard)  "$SCRIPT_DIR/rofi-clipboard.sh" ;;
    *Emoji)      "$SCRIPT_DIR/rofi-emoji.sh" ;;
    *Calculator) "$SCRIPT_DIR/rofi-calc.sh" ;;
    *Kill*)      "$SCRIPT_DIR/rofi-kill.sh" ;;
    *Configs)    "$SCRIPT_DIR/rofi-configs.sh" ;;
    *Bookmarks)  "$SCRIPT_DIR/rofi-bookmarks.sh" ;;
    *Display)    "$SCRIPT_DIR/rofi-display.sh" ;;
esac

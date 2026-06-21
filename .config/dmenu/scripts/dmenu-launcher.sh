#!/bin/sh
# ── dmenu-launcher: Master launcher hub ──
# Acts as a rofi-style meta launcher — pick what you want to do

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

choice=$(printf "  Apps\n  Power\n  WiFi\n  Bluetooth\n  Screenshot\n  Clipboard\n  Emoji\n  Calculator\n  Kill Process\n  Configs\n  Bookmarks\n  Display" | dmenu_styled -p "  Menu")

case "$choice" in
    *Apps)       dmenu_run -i -c -l "$LINES" -h "$HEIGHT" -bw "$BORDER" -fn "$FONT" -nb "$BG" -nf "$FG" -sb "$SB" -sf "$SF" -nhf "$NHF" -nhb "$NHB" -shf "$SHF" -shb "$SHB" -p "  Run" ;;
    *Power)      "$SCRIPT_DIR/dmenu-power.sh" ;;
    *WiFi)       "$SCRIPT_DIR/dmenu-wifi.sh" ;;
    *Bluetooth)  "$SCRIPT_DIR/dmenu-bluetooth.sh" ;;
    *Screenshot) "$SCRIPT_DIR/dmenu-screenshot.sh" ;;
    *Clipboard)  "$SCRIPT_DIR/dmenu-clipboard.sh" ;;
    *Emoji)      "$SCRIPT_DIR/dmenu-emoji.sh" ;;
    *Calculator) "$SCRIPT_DIR/dmenu-calc.sh" ;;
    *Kill*)      "$SCRIPT_DIR/dmenu-kill.sh" ;;
    *Configs)    "$SCRIPT_DIR/dmenu-configs.sh" ;;
    *Bookmarks)  "$SCRIPT_DIR/dmenu-bookmarks.sh" ;;
    *Display)    "$SCRIPT_DIR/dmenu-display.sh" ;;
esac

#!/bin/sh
# ── rofi-power: Power menu ──

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/rofi-common.sh"

choice=$(printf "  Lock\n  Suspend\n  Logout\n  Reboot\n  Shutdown" | rofi_styled -p "  Power")

case "$choice" in
    *Lock)
        slock ;;
    *Suspend)
        confirm=$(printf "Yes\nNo" | rofi_styled -p "  Suspend?")
        [ "$confirm" = "Yes" ] && systemctl suspend ;;
    *Logout)
        confirm=$(printf "Yes\nNo" | rofi_styled -p "  Logout?")
        [ "$confirm" = "Yes" ] && touch "/tmp/dwm-logout-$USER" && pkill -TERM dwm ;;
    *Reboot)
        confirm=$(printf "Yes\nNo" | rofi_styled -p "  Reboot?")
        [ "$confirm" = "Yes" ] && systemctl reboot ;;
    *Shutdown)
        confirm=$(printf "Yes\nNo" | rofi_styled -p "  Shutdown?")
        [ "$confirm" = "Yes" ] && systemctl poweroff ;;
esac

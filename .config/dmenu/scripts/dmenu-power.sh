#!/bin/sh
# ── dmenu-power: Power menu ──

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

choice=$(printf "  Lock\n  Suspend\n  Logout\n  Reboot\n  Shutdown" | dmenu_styled -p "  Power")

case "$choice" in
    *Lock)
        slock ;;
    *Suspend)
        confirm=$(printf "Yes\nNo" | dmenu_styled -p "  Suspend?")
        [ "$confirm" = "Yes" ] && systemctl suspend ;;
    *Logout)
        confirm=$(printf "Yes\nNo" | dmenu_styled -p "  Logout?")
        [ "$confirm" = "Yes" ] && touch "/tmp/dwm-logout-$USER" && pkill -TERM dwm ;;
    *Reboot)
        confirm=$(printf "Yes\nNo" | dmenu_styled -p "  Reboot?")
        [ "$confirm" = "Yes" ] && systemctl reboot ;;
    *Shutdown)
        confirm=$(printf "Yes\nNo" | dmenu_styled -p "  Shutdown?")
        [ "$confirm" = "Yes" ] && systemctl poweroff ;;
esac

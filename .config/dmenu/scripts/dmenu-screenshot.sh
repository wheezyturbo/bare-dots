#!/bin/sh
# ── dmenu-screenshot: Screenshot menu ──

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILENAME="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

choice=$(printf "  Fullscreen\n  Select Area\n  Fullscreen → Clipboard\n  Area → Clipboard\n  Flameshot GUI" | dmenu_styled -p "  Screenshot")

case "$choice" in
    *"Fullscreen")
        sleep 0.3
        flameshot full -p "$SCREENSHOT_DIR" 2>/dev/null || \
        import -window root "$FILENAME"
        notify "  Screenshot" "Saved to $SCREENSHOT_DIR" ;;
    *"Select Area")
        flameshot gui -p "$SCREENSHOT_DIR" 2>/dev/null || {
            import "$FILENAME"
            notify "  Screenshot" "Saved to $SCREENSHOT_DIR"
        } ;;
    *"Fullscreen → Clipboard")
        sleep 0.3
        flameshot full -c 2>/dev/null || {
            import -window root png:- | xclip -selection clipboard -t image/png
            notify "  Screenshot" "Copied to clipboard"
        } ;;
    *"Area → Clipboard")
        flameshot gui -c 2>/dev/null || {
            import png:- | xclip -selection clipboard -t image/png
            notify "  Screenshot" "Copied to clipboard"
        } ;;
    *"Flameshot GUI")
        flameshot gui ;;
esac

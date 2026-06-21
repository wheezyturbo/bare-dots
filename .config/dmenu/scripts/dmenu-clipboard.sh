#!/bin/sh
# ── dmenu-clipboard: Clipboard history manager ──
# Uses cliphist (which you have installed)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

choice=$(printf "  Paste from history\n  Clear history\n  Clear last item" | dmenu_styled -p "  Clipboard")

case "$choice" in
    *"Paste from history"*)
        # cliphist list | dmenu -> cliphist decode -> xclip
        SELECTED=$(cliphist list | dmenu_styled -p "  History" -l 15)
        [ -z "$SELECTED" ] && exit 0
        echo "$SELECTED" | cliphist decode | xclip -selection clipboard
        notify "  Clipboard" "Pasted from history" ;;
    *"Clear history"*)
        confirm=$(printf "Yes\nNo" | dmenu_styled -p "  Clear all?")
        if [ "$confirm" = "Yes" ]; then
            cliphist wipe
            notify "  Clipboard" "History cleared"
        fi ;;
    *"Clear last"*)
        SELECTED=$(cliphist list | dmenu_styled -p "  Delete which?")
        [ -z "$SELECTED" ] && exit 0
        echo "$SELECTED" | cliphist delete
        notify "  Clipboard" "Item removed" ;;
esac

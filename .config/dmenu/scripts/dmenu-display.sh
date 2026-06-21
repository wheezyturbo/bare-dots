#!/bin/sh
# ── dmenu-display: Display/monitor management ──

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

# Get connected monitors
MONITORS=$(xrandr --query | grep " connected" | awk '{print $1}')
MONITOR_COUNT=$(echo "$MONITORS" | wc -l)

# Current brightness
BRIGHTNESS=$(brightnessctl g 2>/dev/null)
MAX_BRIGHTNESS=$(brightnessctl m 2>/dev/null)
if [ -n "$MAX_BRIGHTNESS" ] && [ "$MAX_BRIGHTNESS" -gt 0 ]; then
    BRIGHTNESS_PCT=$((BRIGHTNESS * 100 / MAX_BRIGHTNESS))
else
    BRIGHTNESS_PCT="N/A"
fi

choice=$(printf "  Brightness: %s%%\n  Night Mode (warm)\n  Night Mode (off)\n  Mirror Displays\n  Extend Right\n  Extend Left\n  Single Monitor" "$BRIGHTNESS_PCT" | dmenu_styled -p "  Display")

case "$choice" in
    *"Brightness"*)
        LEVEL=$(printf "10\n20\n30\n40\n50\n60\n70\n80\n90\n100" | dmenu_styled -p "  Brightness %")
        [ -z "$LEVEL" ] && exit 0
        brightnessctl s "${LEVEL}%"
        notify "  Display" "Brightness set to ${LEVEL}%" ;;
    *"Night Mode (warm)"*)
        # Use xrandr gamma for warm/night mode
        PRIMARY=$(echo "$MONITORS" | head -1)
        xrandr --output "$PRIMARY" --gamma 1.0:0.85:0.7
        notify "  Display" "Night mode enabled" ;;
    *"Night Mode (off)"*)
        PRIMARY=$(echo "$MONITORS" | head -1)
        xrandr --output "$PRIMARY" --gamma 1.0:1.0:1.0
        notify "  Display" "Night mode disabled" ;;
    *"Mirror"*)
        if [ "$MONITOR_COUNT" -ge 2 ]; then
            PRIMARY=$(echo "$MONITORS" | head -1)
            SECONDARY=$(echo "$MONITORS" | tail -1)
            xrandr --output "$SECONDARY" --same-as "$PRIMARY" --auto
            notify "  Display" "Mirroring displays"
        else
            notify "  Display" "Only one monitor detected"
        fi ;;
    *"Extend Right"*)
        if [ "$MONITOR_COUNT" -ge 2 ]; then
            PRIMARY=$(echo "$MONITORS" | head -1)
            SECONDARY=$(echo "$MONITORS" | tail -1)
            xrandr --output "$SECONDARY" --right-of "$PRIMARY" --auto
            notify "  Display" "Extended right"
        fi ;;
    *"Extend Left"*)
        if [ "$MONITOR_COUNT" -ge 2 ]; then
            PRIMARY=$(echo "$MONITORS" | head -1)
            SECONDARY=$(echo "$MONITORS" | tail -1)
            xrandr --output "$SECONDARY" --left-of "$PRIMARY" --auto
            notify "  Display" "Extended left"
        fi ;;
    *"Single"*)
        PRIMARY=$(echo "$MONITORS" | head -1)
        echo "$MONITORS" | tail -n +2 | while read -r MON; do
            xrandr --output "$MON" --off
        done
        xrandr --output "$PRIMARY" --auto
        notify "  Display" "Single monitor mode" ;;
esac

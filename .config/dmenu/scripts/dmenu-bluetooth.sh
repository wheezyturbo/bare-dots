#!/bin/sh
# ── dmenu-bluetooth: Bluetooth device manager ──

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

# Check if bluetooth is powered on
BT_POWER=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')

TOGGLE="  Bluetooth: $BT_POWER"
SCAN="  Scan for devices"

if [ "$BT_POWER" = "yes" ]; then
    # Get paired devices
    PAIRED=$(bluetoothctl devices Paired 2>/dev/null | while read -r _ MAC NAME; do
        CONNECTED=$(bluetoothctl info "$MAC" 2>/dev/null | grep "Connected:" | awk '{print $2}')
        if [ "$CONNECTED" = "yes" ]; then
            printf "  %s [connected]\n" "$NAME"
        else
            printf "  %s\n" "$NAME"
        fi
    done)

    # Get available (non-paired) devices from scan cache
    AVAILABLE=$(bluetoothctl devices 2>/dev/null | while read -r _ MAC NAME; do
        IS_PAIRED=$(bluetoothctl devices Paired 2>/dev/null | grep -c "$MAC")
        if [ "$IS_PAIRED" = "0" ]; then
            printf "  %s\n" "$NAME"
        fi
    done)

    MENU="$TOGGLE"
    [ -n "$PAIRED" ] && MENU="$MENU\n$PAIRED"
    MENU="$MENU\n$SCAN"
    [ -n "$AVAILABLE" ] && MENU="$MENU\n$AVAILABLE"

    choice=$(printf "%b" "$MENU" | dmenu_styled -p "  BT")
else
    choice=$(printf "%s\n%s" "$TOGGLE" "$SCAN" | dmenu_styled -p "  BT")
fi

case "$choice" in
    *"Bluetooth: yes"*)
        bluetoothctl power off
        notify "  Bluetooth" "Bluetooth disabled" ;;
    *"Bluetooth: no"*)
        bluetoothctl power on
        notify "  Bluetooth" "Bluetooth enabled"
        sleep 1
        exec "$0" ;;
    *"Scan for devices"*)
        notify "  Bluetooth" "Scanning for 5s..."
        bluetoothctl --timeout 5 scan on 2>/dev/null
        exec "$0" ;;
    *"[connected]"*)
        DEVNAME=$(echo "$choice" | sed 's/^[^ ]* //' | sed 's/ \[connected\]//')
        MAC=$(bluetoothctl devices 2>/dev/null | grep "$DEVNAME" | awk '{print $2}')
        action=$(printf "Disconnect\nRemove" | dmenu_styled -p "  $DEVNAME")
        case "$action" in
            Disconnect) bluetoothctl disconnect "$MAC" && notify "  BT" "Disconnected $DEVNAME" ;;
            Remove) bluetoothctl remove "$MAC" && notify "  BT" "Removed $DEVNAME" ;;
        esac ;;
    "")
        exit 0 ;;
    *)
        # Try to connect to a device
        DEVNAME=$(echo "$choice" | sed 's/^[^ ]* //')
        MAC=$(bluetoothctl devices 2>/dev/null | grep "$DEVNAME" | awk '{print $2}')
        if [ -n "$MAC" ]; then
            notify "  BT" "Connecting to $DEVNAME..."
            # Try to pair first, then connect
            bluetoothctl pair "$MAC" 2>/dev/null
            bluetoothctl trust "$MAC" 2>/dev/null
            bluetoothctl connect "$MAC" 2>/dev/null && \
                notify "  BT" "Connected to $DEVNAME" || \
                notify "  BT" "Failed to connect to $DEVNAME"
        fi ;;
esac

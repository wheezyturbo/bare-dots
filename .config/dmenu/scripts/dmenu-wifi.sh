#!/bin/sh
# ── dmenu-wifi: WiFi network selector ──

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

# Check WiFi status
WIFI_STATE=$(nmcli radio wifi)

# Get current connection
CURRENT=$(nmcli -t -f NAME connection show --active 2>/dev/null | head -1)

# Build menu
TOGGLE="  WiFi: $WIFI_STATE"
RESCAN="  Rescan"

if [ "$WIFI_STATE" = "enabled" ]; then
    # Scan and list networks
    NETWORKS=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list 2>/dev/null | \
        awk -F: '!seen[$1]++ && $1!="" {
            lock = ($3 != "" && $3 != "--") ? "  " : "  ";
            bar = "";
            if ($2+0 >= 75) bar = "▂▄▆█";
            else if ($2+0 >= 50) bar = "▂▄▆_";
            else if ($2+0 >= 25) bar = "▂▄__";
            else bar = "▂___";
            marker = "";
            printf "%s %s %s %s%s\n", lock, $1, bar, $2"%", marker
        }')

    choice=$(printf "%s\n%s\n%s\n%s" "$TOGGLE" "$RESCAN" "  Disconnect" "$NETWORKS" | dmenu_styled -p "  WiFi")
else
    choice=$(printf "%s" "$TOGGLE" | dmenu_styled -p "  WiFi")
fi

case "$choice" in
    *"WiFi: enabled"*)
        nmcli radio wifi off
        notify "  WiFi" "WiFi disabled" ;;
    *"WiFi: disabled"*)
        nmcli radio wifi on
        notify "  WiFi" "WiFi enabled" ;;
    *Rescan*)
        nmcli device wifi rescan 2>/dev/null
        notify "  WiFi" "Scanning..."
        sleep 2
        exec "$0" ;;
    *Disconnect*)
        nmcli connection down "$CURRENT" 2>/dev/null
        notify "  WiFi" "Disconnected from $CURRENT" ;;
    "")
        exit 0 ;;
    *)
        # Extract SSID (second field after the lock icon)
        SSID=$(echo "$choice" | sed 's/^[^ ]* //' | awk '{print $1}')

        # Check if we have a saved connection
        if nmcli -t -f NAME connection show 2>/dev/null | grep -qx "$SSID"; then
            nmcli connection up "$SSID" 2>/dev/null && \
                notify "  WiFi" "Connected to $SSID" || \
                notify "  WiFi" "Failed to connect to $SSID"
        else
            # Need password
            PASS=$(echo "" | dmenu_styled -p "  Password for $SSID")
            [ -z "$PASS" ] && exit 0
            nmcli device wifi connect "$SSID" password "$PASS" 2>/dev/null && \
                notify "  WiFi" "Connected to $SSID" || \
                notify "  WiFi" "Failed to connect to $SSID"
        fi ;;
esac

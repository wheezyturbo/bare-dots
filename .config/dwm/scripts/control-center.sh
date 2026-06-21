#!/bin/sh
# Control Center for DWM — rofi-based quick settings

# ── Gather system info ──

# Volume
vol_mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
vol_pct=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oP '\d+%' | head -1)
if [ "$vol_mute" = "yes" ]; then
    vol_icon="󰝟"
    vol_status="$vol_icon  Muted"
else
    vol_icon="󰕾"
    vol_status="$vol_icon  Volume: $vol_pct"
fi

# Brightness
bright=$(brightnessctl -m 2>/dev/null | cut -d, -f4)
bright_status="󰃟  Brightness: $bright"

# WiFi
wifi_info=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:')
if [ -n "$wifi_info" ]; then
    ssid=$(echo "$wifi_info" | cut -d: -f2)
    wifi_status="󰤥  WiFi: $ssid"
else
    eth=$(nmcli -t -f TYPE,STATE dev 2>/dev/null | grep '^ethernet:connected')
    if [ -n "$eth" ]; then
        wifi_status="󰈀  Ethernet: Connected"
    else
        wifi_status="󰤭  Network: Disconnected"
    fi
fi

# Bluetooth
bt_powered=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
bt_device=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)
if [ -n "$bt_device" ]; then
    bt_status="󰂯  Bluetooth: $bt_device"
elif [ "$bt_powered" = "yes" ]; then
    bt_status="󰂳  Bluetooth: On"
else
    bt_status="󰂲  Bluetooth: Off"
fi

# Battery
BAT=""
for bat in /sys/class/power_supply/BAT* /sys/class/power_supply/CMB*; do
    [ -d "$bat" ] && BAT="$bat" && break
done
if [ -n "$BAT" ]; then
    cap=$(cat "$BAT/capacity" 2>/dev/null)
    bat_state=$(cat "$BAT/status" 2>/dev/null)
    bat_status="󰁹  Battery: ${cap}% ($bat_state)"
else
    bat_status="󰂑  Battery: N/A"
fi

# Now Playing — build media section
player=$(playerctl -l 2>/dev/null | head -1)
media_lines=""
if [ -n "$player" ]; then
    p_status=$(playerctl status 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null | cut -c1-40)
    artist=$(playerctl metadata artist 2>/dev/null | cut -c1-30)

    if [ "$p_status" = "Playing" ]; then
        media_lines="󰎈  $title"
        [ -n "$artist" ] && media_lines="$media_lines\n     $artist"
        media_lines="$media_lines\n󰏤  Pause    󰒮  Prev    󰒭  Next"
    elif [ "$p_status" = "Paused" ]; then
        media_lines="󰎊  $title"
        [ -n "$artist" ] && media_lines="$media_lines\n     $artist"
        media_lines="$media_lines\n󰐊  Play     󰒮  Prev    󰒭  Next"
    else
        media_lines="󰎇  No media playing"
    fi
else
    media_lines="󰎇  No media playing"
fi

# ── Build menu ──
chosen=$(printf "%b\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s" \
    "$media_lines" \
    "─────────────────────────────" \
    "$vol_status" \
    "$bright_status" \
    "─────────────────────────────" \
    "$wifi_status" \
    "$bt_status" \
    "─────────────────────────────" \
    "$bat_status" \
    "⏻  Power Menu" \
    | rofi -dmenu -p "  Control Center" -i -no-custom \
           -theme-str 'window { width: 420px; } listview { lines: 12; }')

# ── Handle selection ──
case "$chosen" in
    *"Pause"*|*"Play"*)
        playerctl play-pause
        # Re-open control center to show updated state
        exec "$0"
        ;;
    *"Prev"*)
        playerctl previous
        sleep 0.3
        exec "$0"
        ;;
    *"Next"*)
        playerctl next
        sleep 0.3
        exec "$0"
        ;;
    *"Volume"*|*"Muted"*)
        pavucontrol &
        ;;
    *"Brightness"*)
        cur=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
        if [ "$cur" -gt 50 ]; then
            brightnessctl s 30%
        else
            brightnessctl s 100%
        fi
        pkill -RTMIN+2 dwmblocks
        exec "$0"
        ;;
    *"WiFi"*|*"Ethernet"*|*"Network"*)
        st -e nmtui &
        ;;
    *"Bluetooth"*)
        st -e bluetoothctl &
        ;;
    *"Power Menu"*)
        power=$(printf "  Lock\n  Logout\n  Reboot\n⏻  Shutdown" \
            | rofi -dmenu -p "⏻ Power" -i -no-custom \
                   -theme-str 'window { width: 250px; } listview { lines: 4; }')
        case "$power" in
            *"Lock"*)     slock & ;;
            *"Logout"*)   touch "/tmp/dwm-logout-$USER" && killall dwm ;;
            *"Reboot"*)   systemctl reboot ;;
            *"Shutdown"*) systemctl poweroff ;;
        esac
        ;;
esac

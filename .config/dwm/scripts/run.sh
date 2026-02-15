#!/bin/sh

# ---- Autostart ----
# Kill existing instances
killall -q dwmblocks dunst picom

# Wait for processes to die
while pgrep -x dwmblocks >/dev/null; do sleep 0.1; done

# Compositor
picom &

# Notification daemon
dunst &

# Status bar
dwmblocks &

# System tray applets (optional)
nm-applet &
# blueman-applet &

# Wallpaper (uncomment and set your wallpaper)
# feh --bg-scale /home/rubyciide/Pictures/fc_3.jpg &

# ---- DWM Loop ----
# Mod+Shift+Q = hot-reload (restarts DWM, keeps session)
# To logout: run 'pkill -f run.sh' or use control center power menu
LOGOUT_FLAG="/tmp/dwm-logout-$USER"
rm -f "$LOGOUT_FLAG"

while true; do
    dwm 2>/tmp/dwm.log

    # If logout flag exists, actually exit
    if [ -f "$LOGOUT_FLAG" ]; then
        rm -f "$LOGOUT_FLAG"
        break
    fi
done

#!/bin/sh

# ---- Session Setup ----
export XDG_CURRENT_DESKTOP=dwm
export XDG_SESSION_DESKTOP=dwm
export XDG_SESSION_TYPE=x11
export GTK_USE_PORTAL=1

xss-lock --transfer-sleep-lock -- slock &

# Update DBus with session vars so portals know where we are
dbus-update-activation-environment --all

# ---- Start Portals ----
# Always start portals manually in background
# This works even if systemd --user isn't running
/usr/lib/xdg-desktop-portal &
/usr/lib/xdg-desktop-portal-gtk &

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

feh --bg-fill /home/rubyciide/Pictures/fc_3.jpg

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

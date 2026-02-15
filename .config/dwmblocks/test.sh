#!/bin/sh

# Directory for scripts
BIN_DIR="./scripts/"

echo "Creating scripts directory at $BIN_DIR…"
mkdir -p "$BIN_DIR"

# ===== battery =====
cat >"$BIN_DIR/batt" <<'EOF'
#!/bin/sh
bat=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
[ -z "$bat" ] && exit 0
printf "%s%% (%s)" "$bat" "$status"
EOF

# ===== volume =====
cat >"$BIN_DIR/vol" <<'EOF'
#!/bin/sh
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' 2>/dev/null)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}' 2>/dev/null)
if [ "$mute" = "yes" ]; then
  echo "MUTED"
else
  echo "${vol}"
fi
EOF

# ===== brightness =====
cat >"$BIN_DIR/bright" <<'EOF'
#!/bin/sh
cur=$(cat /sys/class/backlight/*/brightness 2>/dev/null)
max=$(cat /sys/class/backlight/*/max_brightness 2>/dev/null)
if [ -z "$cur" ] || [ -z "$max" ]; then
  echo "N/A"
else
  perc=$(awk "BEGIN {printf \"%d%%\", ($cur/$max)*100}")
  echo "$perc"
fi
EOF

# ===== wifi =====
cat >"$BIN_DIR/wifi" <<'EOF'
#!/bin/sh
ssid=$(iw dev wlp3s0 link 2>/dev/null | awk -F': ' '/SSID/ {print $2}')
if [ -z "$ssid" ]; then
  echo "Disconnected"
else
  echo "$ssid"
fi
EOF

# ===== cpu_mem =====
cat >"$BIN_DIR/cpu_mem" <<'EOF'
#!/bin/sh
cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%d%%", usage}')
mem=$(free -h | awk '/^Mem:/ {printf "%s/%s", $3,$2}')
echo "CPU:$cpu MEM:$mem"
EOF

echo "Making scripts executable…"
chmod +x "$BIN_DIR"/{batt,vol,bright,wifi,cpu_mem}

echo "Done! Scripts are in $BIN_DIR"

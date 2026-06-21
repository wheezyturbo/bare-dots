#!/bin/sh
# ── dmenu-kill: Process killer ──

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

# List processes sorted by CPU usage, exclude trivial ones
PROC=$(ps axo pid,user,%cpu,%mem,comm --sort=-%cpu | \
    awk 'NR>1 && $3+0 > 0.0 {printf "%-7s %-10s %5s%% CPU  %5s%% MEM  %s\n", $1, $2, $3, $4, $5}' | \
    head -30)

choice=$(echo "$PROC" | dmenu_styled -p "  Kill" -l 15)
[ -z "$choice" ] && exit 0

PID=$(echo "$choice" | awk '{print $1}')
PNAME=$(echo "$choice" | awk '{print $5}')

signal=$(printf " SIGTERM (graceful)\n SIGKILL (force)\n SIGSTOP (pause)\n SIGCONT (resume)" | dmenu_styled -p "  $PNAME ($PID)")

case "$signal" in
    *SIGTERM*) kill -TERM "$PID" && notify "  Kill" "$PNAME ($PID) terminated" ;;
    *SIGKILL*) kill -KILL "$PID" && notify "  Kill" "$PNAME ($PID) killed" ;;
    *SIGSTOP*) kill -STOP "$PID" && notify "  Kill" "$PNAME ($PID) paused" ;;
    *SIGCONT*) kill -CONT "$PID" && notify "  Kill" "$PNAME ($PID) resumed" ;;
esac

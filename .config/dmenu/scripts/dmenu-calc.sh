#!/bin/sh
# ── dmenu-calc: Calculator ──
# Type math expressions, get results. Results are copied to clipboard.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/dmenu-common.sh"

RESULT=""

while true; do
    if [ -n "$RESULT" ]; then
        EXPR=$(echo "" | dmenu_styled -p "  = $RESULT │ ")
    else
        EXPR=$(echo "" | dmenu_styled -p "  Calc")
    fi

    [ -z "$EXPR" ] && break

    # Evaluate with python for full math support
    RESULT=$(python3 -c "
import math
try:
    result = eval('$EXPR')
    if isinstance(result, float) and result == int(result):
        print(int(result))
    else:
        print(result)
except Exception as e:
    print('Error: ' + str(e))
" 2>&1)

    # Copy result to clipboard
    printf "%s" "$RESULT" | xclip -selection clipboard
done

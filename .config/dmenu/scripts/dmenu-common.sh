#!/bin/sh
# ── dmenu rice: common settings ──
# All scripts source this for consistent styling

# Kanagawa colors (refined)
BG="#1F1F28"
FG="#DCD7BA"
SB="#2A2A37"   # sumiInk3 (subtle selection bg)
SF="#7E9CD8"   # crystalBlue (selection text accent)
NHF="#FF9E3B"  # surimiOrange (normal highlight fg)
NHB="#1F1F28"  # sumiInk1 (normal highlight bg)
SHF="#FF9E3B"  # surimiOrange (selected highlight fg)
SHB="#2A2A37"  # sumiInk3 (selected highlight bg)
FONT="JetBrainsMono Nerd Font Mono:size=13"
BORDER=2
HEIGHT=40
LINES=10
TERMINAL="kitty"

# Standard dmenu invocation with full rice
dmenu_styled() {
    dmenu -i -c -l "$LINES" -h "$HEIGHT" -bw "$BORDER" \
        -fn "$FONT" \
        -nb "$BG" -nf "$FG" -sb "$SB" -sf "$SF" \
        -nhf "$NHF" -nhb "$NHB" -shf "$SHF" -shb "$SHB" \
        "$@"
}

# Notification helper
notify() {
    dunstify -a "dmenu" -u normal -t 3000 "$@" 2>/dev/null || \
    notify-send "$@" 2>/dev/null
}

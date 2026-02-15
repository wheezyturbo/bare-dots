#!/bin/sh
# Keybindings viewer for DWM — shown via rofi

rofi -dmenu -p "⌨ Keybindings" -i -markup-rows -no-custom -theme-str 'window { width: 600px; }' << 'EOF'
<b>── Window Management ──</b>
Super + Return         Open terminal (st)
Super + a              App launcher (rofi)
Super + Shift + a      Dmenu (fallback)
Super + q              Close window
Super + Shift + Q      Reload DWM

<b>── Navigation (HJKL) ──</b>
Super + h              Shrink master ←
Super + l              Grow master →
Super + j              Focus next window ↓
Super + k              Focus previous window ↑
Super + Tab            Toggle last tag

<b>── Layout ──</b>
Super + Shift + Return Promote to master
Super + i / d          Add / Remove master windows
Super + t              Tiled layout []=
Super + f              Floating layout ><>
Super + m              Monocle layout [M]
Super + Space          Toggle layout
Super + Shift + Space  Toggle window floating

<b>── Tags ──</b>
Super + 1-9            Switch to tag
Super + Shift + 1-9    Move window to tag
Super + 0              View all tags
Super + Shift + 0      Tag window on all

<b>── Monitors ──</b>
Super + , / .          Focus prev / next monitor
Super + Shift + , / .  Send window to monitor

<b>── Media ──</b>
Volume Up / Down       ±5% (capped 100%)
Mute                   Toggle mute
Brightness Up / Down   ±5%
Play / Pause           Toggle media
Next / Prev            Skip tracks
Print Screen           Flameshot screenshot

<b>── Quick Access ──</b>
Super + e              File Manager (yazi in kitty)
Super + b              Browser (Chromium)
Super + n              Network Manager (nmtui)
Super + v              Volume Mixer (pavucontrol)
Super + ?              This keybindings viewer
Super + x              Control Center
Super + Shift + b      Toggle bar
EOF

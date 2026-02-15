# DWM — Custom Build

My personal DWM (Dynamic Window Manager) 6.8 build with a **Kanagawa** color scheme, a **system tray**, media key support, and a modular status bar powered by **dwmblocks**.

---

## Required Packages

Install these before building:

```bash
# Arch / Manjaro
sudo pacman -S base-devel libx11 libxinerama libxft freetype2 \
               networkmanager brightnessctl playerctl flameshot \
               pavucontrol ttf-jetbrains-mono-nerd dunst rofi picom

# Debian / Ubuntu
sudo apt install build-essential libx11-dev libxinerama-dev libxft-dev libfreetype-dev \
                 network-manager brightnessctl playerctl flameshot \
                 pavucontrol fonts-jetbrains-mono dunst rofi picom
```

| Package | Purpose |
|---|---|
| `libx11`, `libxinerama`, `libxft` | Core X11 libs required to compile DWM |
| `ttf-jetbrains-mono-nerd` | Nerd Font — renders icons in the status bar |
| `brightnessctl` | Screen brightness control |
| `playerctl` | MPRIS media player control (play/pause/skip) |
| `flameshot` | Screenshot tool |
| `pavucontrol` | PulseAudio/PipeWire GUI volume mixer |
| `NetworkManager` + `nmtui` | Network management (CLI/TUI) |
| `pactl` | Volume control (comes with PulseAudio/PipeWire) |
| `bluetoothctl` | Bluetooth status (comes with BlueZ) |
| `dunst` | Notification daemon |
| `rofi` | App launcher (replaces dmenu) |
| `picom` | Compositor (shadows, animations, blur, transparency) |

---

## Building & Installing

```bash
# Build and install DWM
cd ~/.config/dwm
sudo make clean install

# Build and install dwmblocks
cd ~/.config/dwmblocks
sudo make clean install
```

After installing, press **`Mod+Shift+Q`** to hot-reload DWM (restarts the WM without logging out).

---

## Patches Applied

| Patch | Description |
|---|---|
| **Systray** | Native system tray embedded in the bar — supports nm-applet, blueman, Discord, etc. |
| **Shiftview** | Cycle through tags with H/L keys |

---

## Color Scheme — Kanagawa

The theme uses the [Kanagawa](https://github.com/rebelot/kanagawa.nvim) palette:

| Element | Color | Hex |
|---|---|---|
| Background | Sumi Ink | `#1F1F28` |
| Foreground | Fuji White | `#DCD7BA` |
| Selected | Dragon Blue | `#7E9CD8` |
| Urgent | Autumn Red | `#C34043` |
| Inactive border | Wave Blue | `#223249` |

---

## Keybindings

`Mod` key is **Super** (Windows key).

### Window Management

| Keybinding | Action |
|---|---|
| `Mod + Return` | Open terminal (`st`) |
| `Mod + a` | Open app launcher (rofi) |
| `Mod + Shift + a` | Open dmenu (fallback launcher) |
| `Mod + e` | File manager (yazi in kitty) |
| `Mod + b` | Browser (Ungoogled Chromium) |
| `Mod + q` | Close focused window |
| `Mod + Shift + Q` | Reload DWM (hot-reload) |
| `Mod + j / k` | Focus next / previous window in stack |
| `Mod + h / l` | Shrink / grow master area |
| `Mod + i / d` | Increase / decrease number of master windows |
| `Mod + Shift + Return` | Promote focused window to master |
| `Mod + Tab` | Toggle to last viewed tag |
| `Mod + Shift + b` | Toggle bar visibility |

### Layouts

| Keybinding | Action |
|---|---|
| `Mod + t` | Tiled layout `[]=` (default) |
| `Mod + f` | Floating layout `><>` |
| `Mod + m` | Monocle layout `[M]` (fullscreen stack) |
| `Mod + Space` | Toggle between last two layouts |
| `Mod + Shift + Space` | Toggle focused window floating |

### Tags (Workspaces)

| Keybinding | Action |
|---|---|
| `Mod + 1-9` | Switch to tag 1–9 |
| `Mod + Shift + 1-9` | Move focused window to tag 1–9 |
| `Mod + 0` | View all tags |
| `Mod + Shift + 0` | Tag window on all tags |
| `Mod + Ctrl + 1-9` | Toggle tag view (show multiple) |

### Multi-Monitor

| Keybinding | Action |
|---|---|
| `Mod + ,` | Focus previous monitor |
| `Mod + .` | Focus next monitor |
| `Mod + Shift + ,` | Send window to previous monitor |
| `Mod + Shift + .` | Send window to next monitor |

### Media & System

| Keybinding | Action |
|---|---|
| `Volume Up` | Volume +5% (capped at 100%) |
| `Volume Down` | Volume -5% |
| `Mute` | Toggle mute |
| `Brightness Up` | Brightness +5% |
| `Brightness Down` | Brightness -5% |
| `Play/Pause` | Toggle media playback |
| `Next Track` | Skip to next track |
| `Prev Track` | Go to previous track |
| `Print Screen` | Screenshot with Flameshot |
| `Mod + n` | Network Manager (nmtui in terminal) |
| `Mod + v` | Volume Mixer (pavucontrol) |
| `Mod + ?` | Keybindings cheatsheet |
| `Mod + x` | Control Center |

### Mouse

| Click Target | Button | Action |
|---|---|---|
| Tag bar | Left click | View tag |
| Tag bar | Right click | Toggle tag view |
| Window title | Middle click | Promote to master |
| Status text | Middle click | Open terminal |
| Client window | `Mod + Left` | Move window |
| Client window | `Mod + Middle` | Toggle floating |
| Client window | `Mod + Right` | Resize window |

---

## Status Bar — dwmblocks

The status bar uses [dwmblocks](https://github.com/torrinfail/dwmblocks) with modular shell scripts. Each block is a standalone script in `~/.config/dwmblocks/scripts/`.

### Modules (left → right)

| Module | Script | Updates | Signal | Description |
|---|---|---|---|---|
| CPU | `sb-cpu` | 5s | — | CPU usage % (delta-based) |
| Memory | `sb-memory` | 10s | — | Used / Total RAM |
| Disk | `sb-disk` | 300s | — | Root partition usage |
| Network | `sb-network` | 5s | 4 | WiFi SSID + signal or Ethernet |
| Net Speed | `sb-netspeed` | 2s | — | Download / Upload speed |
| Bluetooth | `sb-bluetooth` | — | 5 | Connected device or off |
| Brightness | `sb-brightness` | — | 2 | Screen brightness % |
| Volume | `sb-volume` | — | 1 | Volume % or muted |
| Battery | `sb-battery` | 30s | 3 | Battery %, charging state |
| Date/Time | `sb-datetime` | 60s | — | Date and time |

### Signal-Based Updates

Blocks with a signal number update **instantly** when triggered:

```bash
pkill -RTMIN+1 dwmblocks   # Refresh volume
pkill -RTMIN+2 dwmblocks   # Refresh brightness
pkill -RTMIN+3 dwmblocks   # Refresh battery
pkill -RTMIN+4 dwmblocks   # Refresh network
pkill -RTMIN+5 dwmblocks   # Refresh bluetooth
```

---

## File Structure

```
~/.config/dwm/
├── config.def.h       # All keybindings, colors, appearance settings
├── dwm.c              # DWM source (patched with systray + shiftview)
├── drw.c / drw.h      # Drawing library
├── util.c / util.h    # Utility functions
├── config.mk          # Build configuration
├── Makefile            # Build system
├── README.md          # This file
└── scripts/
    ├── run.sh            # Session startup (autostart)
    ├── keybinds.sh       # Keybindings viewer (Super+?)
    └── control-center.sh # Control center (Super+x)

~/.config/dwmblocks/
├── blocks.h           # Block definitions (which scripts, intervals, signals)
├── dwmblocks.c        # dwmblocks source
├── Makefile           # Build system
└── scripts/
    ├── sb-battery      # Battery with contextual icons
    ├── sb-bluetooth    # Bluetooth status
    ├── sb-brightness   # Screen brightness
    ├── sb-cpu          # CPU usage (delta calculation)
    ├── sb-datetime     # Date and time
    ├── sb-disk         # Disk usage
    ├── sb-memory       # RAM usage
    ├── sb-netspeed     # Download/Upload speed
    ├── sb-network      # WiFi/Ethernet status
    └── sb-volume       # Volume/mute status
```

---

## Session Management

Your display manager (SDDM) shows two DWM options:
- **dwm** → ChadWM (`~/.config/chadwm/scripts/run.sh`)
- **DWM (Custom)** → This build (`~/.config/dwm/scripts/run.sh`)

The session script (`scripts/run.sh`) automatically starts:
- `picom` — compositor (shadows, blur, animations)
- `dunst` — notification daemon
- `dwmblocks` — status bar
- `nm-applet` — network tray icon

DWM runs in a loop, so `Mod+Shift+Q` hot-reloads instead of logging out.

**To log out:**
- `Mod+x` → ⏻ Power Menu → Logout
- Or from a terminal: `pkill -f run.sh`

---

## Notifications — Dunst

Notifications are handled by [dunst](https://dunst-project.org/), configured at `~/.config/dunst/dunstrc` with Kanagawa colors.

Test it:
```bash
notify-send "Hello" "This is a test notification"
notify-send -u critical "Warning" "Battery low!"
```

---

## App Launcher — Rofi

Rofi is configured at `~/.config/rofi/config.rasi` with a custom Kanagawa theme at `~/.local/share/rofi/themes/kanagawa.rasi`.

- **`Mod + a`** — Launch apps (drun mode)
- **`Mod + Shift + a`** — Fallback to dmenu
- Type to fuzzy-search, Enter to launch

---

## Compositor — Picom

Picom provides compositing effects, configured at `~/.config/picom.conf`:
- **Shadows** — subtle drop shadows on windows
- **Animations** — zoom on open, slide-down on minimize, zoom on workspace switch
- **Fading** — smooth fade in/out transitions
- **Blur** — dual kawase background blur
- **Transparency** — 95% opacity on inactive windows
- **Backend** — GLX with VSync

---

## Control Center

A rofi-based quick settings panel (`Mod+x`) showing:
- 🎵 **Now Playing** — current media with play/pause toggle
- 🔊 **Volume** — click to open pavucontrol
- 🔅 **Brightness** — click to toggle 30%/100%
- 📶 **WiFi/Ethernet** — click to open nmtui
- 🔗 **Bluetooth** — click to open bluetoothctl
- 🔋 **Battery** — current charge and status
- ⏻ **Power Menu** — lock, logout, reboot, shutdown

Config: `~/.config/dwm/scripts/control-center.sh`

---

## Terminal — st

The terminal (`~/.config/st/`) is also riced with Kanagawa:
- **Font**: JetBrainsMono Nerd Font Mono 14pt
- **Colors**: Full Kanagawa palette
- **Cursor**: Bar (thin line)
- **Padding**: 12px
- **Shell**: zsh
- **Scrollback**: 2000 lines (mouse wheel or Shift+PageUp/Down)
- **Font zoom**: Ctrl+Shift+Plus/Minus/0

---

## Customization

- **Add a new status block**: Create a script in `scripts/`, add an entry to `blocks.h`, recompile dwmblocks.
- **Change keybindings**: Edit `config.def.h`, recompile DWM.
- **Change colors**: Edit the `col_*` variables in `config.def.h`, recompile DWM.
- **Change font/size**: Edit the `fonts[]` array in `config.def.h`, recompile DWM.

After any change: `sudo make clean install` → `Mod+Shift+Q` to reload.

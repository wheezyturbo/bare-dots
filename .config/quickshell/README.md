# Quickshell Configuration

A modern, feature-rich shell configuration for [Quickshell](https://github.com/quickshell-mirror/quickshell) — a Qt6/QML-based shell framework for Wayland compositors. This configuration is designed for **Hyprland** and provides a sleek, customizable status bar, application launcher, and notification system.

![Wayland](https://img.shields.io/badge/Wayland-Compatible-blue?style=flat-square)
![Hyprland](https://img.shields.io/badge/Hyprland-Supported-purple?style=flat-square)
![QML](https://img.shields.io/badge/Qt6-QML-green?style=flat-square)

---

## ✨ Features

- **🖥️ Status Bar** — Bottom panel with workspaces, system stats, media controls, system tray, and clock
- **🚀 Application Launcher** — Overlay launcher with search functionality and keyboard navigation
- **🔔 Notifications** — Native notification server with auto-dismiss and click-to-dismiss
- **📊 System Monitoring** — Real-time CPU, RAM, and network (download/upload) statistics
- **🎵 Media Controls** — MPRIS-compatible media player controls with track info
- **🔋 Battery Indicator** — Animated battery status with charging indication (optional)
- **🎨 Customizable** — Centralized configuration for colors, fonts, spacing, and features

---

## 📁 Project Structure

```
~/.config/quickshell/
├── shell.qml                 # Main entry point
├── README.md                 # This documentation
│
├── config/
│   └── Config.qml            # Global configuration (colors, fonts, toggles)
│
├── modules/
│   ├── bar/                  # Status bar components
│   │   ├── Bar.qml           # Main bar container
│   │   ├── BarContent.qml    # Bar layout (left, center, right)
│   │   ├── BarLeft.qml       # Left section (workspaces, system stats)
│   │   ├── BarCenter.qml     # Center section (media controls)
│   │   ├── BarRight.qml      # Right section (notifications, tray, time)
│   │   ├── BarWorkspaces.qml # Hyprland workspace indicators with icons
│   │   ├── BarSystemStats.qml# CPU, RAM, and network stats display
│   │   ├── BarMediaControls.qml # Media section container
│   │   ├── BarPlayerControls.qml # Play/pause/next/prev buttons
│   │   ├── BarTrackInfo.qml  # Current track title and artist
│   │   ├── BarNotifications.qml # Dismiss notifications button
│   │   ├── BarTray.qml       # System tray icons
│   │   ├── BarBattery.qml    # Battery indicator (optional)
│   │   └── BarTime.qml       # Clock display
│   │
│   ├── launcher/
│   │   └── Launcher.qml      # Application launcher overlay
│   │
│   ├── notifications/
│   │   └── Notifications.qml # Notification popup system
│   │
│   └── common/               # Shared components
│
├── services/
│   ├── SystemStats.qml       # CPU, RAM, and network monitoring service
│   ├── MediaPlayer.qml       # MPRIS media player integration
│   ├── FormattedTime.qml     # System clock formatting
│   └── NotificationsManager.qml # Notification handling service
│
└── ui/
    ├── StyledPanelWindow.qml # Styled window wrapper
    ├── StyledTextField.qml   # Styled text input
    └── StyledListView.qml    # Styled list view
```

---

## 🔧 Configuration

All configuration options are centralized in [`config/Config.qml`](config/Config.qml).

### Colors

| Property | Default | Description |
|----------|---------|-------------|
| `color_background` | `#1E1E1E` | Panel/widget background |
| `color_foreground` | `#ffffff` | Primary text color |
| `color_muted_foreground` | `gray` | Secondary/muted text |
| `color_primary` | `#3498db` | Primary accent (blue) |
| `color_secondary` | `#2ecc71` | Secondary accent (green) |
| `color_accent` | `#e74c3c` | Highlight accent (red) |
| `color_border` | `gray` | Border color |

### Status Colors

| Property | Default | Description |
|----------|---------|-------------|
| `color_green` | `#2ecc71` | Success/healthy state |
| `color_amber` | `#f39c12` | Warning state |
| `color_red` | `#e74c3c` | Critical/error state |
| `color_blue` | `#3498db` | Info state |
| `color_yellow` | `#F7D720` | Highlight state |

### System Stats Palette

Dynamic coloring for CPU/RAM usage indicators:

| Level | Color | Threshold |
|-------|-------|-----------|
| `low` | `#4FC3F7` | < 40% |
| `medium` | `#2ECC71` | 40-70% |
| `high` | `#F1C40F` | 70-85% |
| `critical` | `#E74C3C` | > 85% |

### Feature Toggles

| Property | Default | Description |
|----------|---------|-------------|
| `show_system_stats` | `true` | Show CPU/RAM/Network stats |
| `colorize_system_stats` | `true` | Enable usage-based coloring |
| `show_media_track_info` | `true` | Show current track info |
| `show_media_controls` | `true` | Show playback controls |
| `show_media_time` | `false` | Show playback position |
| `notification_timeout` | `3000` | Auto-dismiss delay (ms), 0 to disable |

### Sizing

| Property | Default | Description |
|----------|---------|-------------|
| `bar_height` | `30` | Status bar height (px) |
| `hyprland_gap` | `8` | Margin matching Hyprland gaps |

### Typography Scale

| Property | Size | Description |
|----------|------|-------------|
| `font_xxs` | 8 | Extra extra small |
| `font_xs` | 10 | Extra small |
| `font_sm` | 12 | Small |
| `font_base` | 14 | Base size |
| `font_lg` | 16 | Large |
| `font_xl` | 18 | Extra large |
| `font_2xl` | 22 | 2x large |

### Spacing Scale

| Property | Size | Description |
|----------|------|-------------|
| `spacing_base` | 6 | Base spacing |
| `spacing_md` | 8 | Medium |
| `spacing_lg` | 10 | Large |
| `spacing_xl` | 12 | Extra large |
| `spacing_2xl` - `spacing_5xl` | 14-20 | Larger increments |

### Border Radius

| Property | Size | Description |
|----------|------|-------------|
| `radius_sm` | 4 | Small radius |
| `radius` / `radius_base` | 6 | Default radius |
| `radius_lg` | 8 | Large radius |

---

## 📊 Services

### SystemStats

**File:** `services/SystemStats.qml`

Provides real-time system monitoring by reading from `/proc` filesystem.

**Properties:**
- `cpuUsage` — CPU utilization percentage (0-100)
- `memoryUsage` — RAM utilization percentage (0-100)
- `downloadSpeed` — Network download speed (bytes/second)
- `uploadSpeed` — Network upload speed (bytes/second)

**Update Interval:** 1000ms (1 second)

**Implementation Details:**
- CPU stats from `/proc/stat`
- Memory stats from `/proc/meminfo`
- Network stats from `/proc/net/dev` (excludes loopback)

---

### MediaPlayer

**File:** `services/MediaPlayer.qml`

MPRIS-compatible media player integration using `playerctl`.

**Properties:**
- `isAvailable` — Whether playerctl is installed and working
- `isPlaying` — Current playback state
- `hasMetadata` — Whether track info is available
- `title` — Current track title
- `artist` — Current track artist
- `status` — Playback status string
- `positionSeconds` — Current playback position
- `lengthSeconds` — Track duration
- `displayText` — Formatted "Title - Artist" string
- `timeDisplay` — Formatted "current/total" time

**Functions:**
- `playPause()` — Toggle playback
- `play()` — Start playback
- `pause()` — Pause playback
- `next()` — Skip to next track
- `previous()` — Go to previous track

**Requirements:** `playerctl` must be installed.

---

### FormattedTime

**File:** `services/FormattedTime.qml`

System clock service with formatted time string.

**Properties:**
- `time` — Formatted time string (`hh:mm   dd MMM yyyy`)

**Update Precision:** Minutes

---

### NotificationsManager

**File:** `services/NotificationsManager.qml`

Native notification server implementation.

**Properties:**
- `items` — List of active notifications
- `count` — Number of pending notifications

**Functions:**
- `dismissAll()` — Clear all notifications
- `dismissOne(notification)` — Dismiss specific notification

**Supported Features:**
- Actions, hyperlinks, images, markup, persistence

---

## 🖥️ Bar Components

### BarWorkspaces

Displays Hyprland workspace indicators with Nerd Font icons.

**Workspace Icons:**

| Workspace | Icon | Theme |
|-----------|------|-------|
| 1 | `` | Terminal |
| 2 | `` | Development |
| 3 | `` | Browser |
| 4 | `` | Files |
| 5 | `` | Music |
| 6 | `` | Video |
| 7 | `` | Chat |
| 8 | `` | Gaming |
| 9 | `` | Tools |
| 10 | `` | More |

**Interactions:**
- **Click** — Switch to workspace
- **Hover** — Highlight effect

---

### BarSystemStats

Displays system resource usage with color-coded indicators.

**Display Format:**
- ` CPU XX%` — CPU usage with dynamic color
- `󰍛 RAM XX%` — Memory usage with dynamic color
- `↓ X.XX MB/s` — Download speed (green)
- `↑ X.XX MB/s` — Upload speed (blue)

---

### BarPlayerControls

Media playback controls with styled buttons.

**Buttons:**
- `⏮` Previous track
- `⏯` Play/Pause (larger)
- `⏭` Next track

**Font:** Symbols Nerd Font Mono

---

### BarBattery

Battery indicator with visual fill and animations.

**Features:**
- Visual battery icon with fill level
- Percentage text
- Charging bolt icon with pulse animation
- Color-coded status (green/amber/red)

**Note:** Currently commented out in `BarRight.qml`. Uncomment to enable:
```qml
BarBattery {}
```

---

### BarTray

System tray integration using Quickshell's SystemTray service.

**Interactions:**
- **Left Click** — Activate tray item
- **Right Click** — Open context menu

---

## 🚀 Application Launcher

**Trigger:** IPC call to `launcher:toggle`

**Example Hyprland binding:**
```bash
bind = SUPER, Space, exec, qs ipc call launcher toggle
```

**Features:**
- Fuzzy search through installed applications
- Keyboard navigation (↑/↓ or Ctrl+K/J)
- Enter to launch, Escape to close
- Application icons and descriptions

**Dimensions:**
- Width: 700px
- Max Height: 400px

---

## 🔔 Notifications

**Features:**
- Overlay notifications on focused monitor
- App icon, title, and body display
- Auto-dismiss after configurable timeout
- Click anywhere to dismiss
- Smooth fade-out animation

**Styling:**
- Width: 400px
- Rounded corners with border
- Positioned top-right with gap margin

---

## 📋 Requirements

### Core Dependencies
- [Quickshell](https://github.com/quickshell-mirror/quickshell) — Qt6/QML shell framework
- [Hyprland](https://hyprland.org/) — Wayland compositor
- Qt 6.x with QML support

### Fonts
- **Nerd Font** (e.g., `Symbols Nerd Font`, `JetBrainsMono Nerd Font`)
  - Required for workspace icons and media control icons
  - Install from [Nerd Fonts](https://www.nerdfonts.com/)

### Optional
- `playerctl` — For media player controls
- UPower — For battery status

---

## 🛠️ Installation

1. **Install Quickshell** following the [official instructions](https://github.com/quickshell-mirror/quickshell)

2. **Clone/copy this configuration:**
   ```bash
   cp -r ./quickshell ~/.config/quickshell
   ```

3. **Install a Nerd Font:**
   ```bash
   # Example: JetBrainsMono Nerd Font
   yay -S ttf-jetbrains-mono-nerd
   ```

4. **Start Quickshell:**
   ```bash
   quickshell
   ```

5. **Add to Hyprland autostart** (`~/.config/hyprland/hyprland.conf`):
   ```bash
   exec-once = quickshell
   ```

---

## ⌨️ Keybindings (Hyprland)

Add these to your Hyprland config:

```bash
# Toggle application launcher
bind = SUPER, Space, exec, qs ipc call launcher toggle

# Reload Quickshell
bind = SUPER SHIFT, R, exec, quickshell --reload
```

---

## 🎨 Customization

### Changing Workspace Icons

Edit `modules/bar/BarWorkspaces.qml`:

```qml
function workspaceIcon(name) {
    var icons = {
        "1": "\uf120",   // Terminal → change to your icon
        "2": "\ue795",   // Code
        // Add more mappings...
    };
    return icons[name] || name;
}
```

Find icons at [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet).

### Changing Time Format

Edit `services/FormattedTime.qml`:

```qml
readonly property string time: {
    Qt.formatDateTime(clock.date, "hh:mm     dd MMM yyyy");
    // Examples:
    // "hh:mm" → 14:30
    // "hh:mm:ss" → 14:30:45
    // "ddd d MMM" → Sat 11 Jan
}
```

### Changing Bar Position

Edit `modules/bar/Bar.qml`:

```qml
anchors {
    bottom: true   // Change to 'top: true' for top bar
    left: true
    right: true
}
```

### Enabling Battery Indicator

Edit `modules/bar/BarRight.qml`:

```qml
RowLayout {
    // ...
    BarTray {}
    BarBattery {}  // Uncomment this line
    BarTime {}
}
```

---

## 📝 Time Formatting Reference

| Format | Output |
|--------|--------|
| `hh:mm` | 14:30 |
| `hh:mm:ss` | 14:30:45 |
| `h:mm AP` | 2:30 PM |
| `ddd` | Sat |
| `dddd` | Saturday |
| `d` | 11 |
| `dd` | 11 |
| `MMM` | Jan |
| `MMMM` | January |
| `MM` | 01 |
| `yyyy` | 2026 |
| `yy` | 26 |

---

## 🐛 Troubleshooting

### Icons not displaying
- Ensure a Nerd Font is installed
- Check `font.family` in QML files matches your installed font name
- Run `fc-list | grep -i nerd` to verify installation

### Media controls not working
- Install `playerctl`: `sudo pacman -S playerctl`
- Test with: `playerctl status`

### Bar not appearing
- Check Quickshell logs: `quickshell 2>&1 | tee qs.log`
- Verify Hyprland is running: `hyprctl version`

### Network stats showing 0
- Verify `/proc/net/dev` is readable
- Check active interfaces: `cat /proc/net/dev`

---

## 📄 License

This configuration is provided as-is for personal use and modification.

---

## 🙏 Credits

- [Quickshell](https://github.com/quickshell-mirror/quickshell) — The amazing shell framework
- [Hyprland](https://hyprland.org/) — Dynamic tiling Wayland compositor
- [Nerd Fonts](https://www.nerdfonts.com/) — Iconic font aggregator

---

**Happy ricing! 🎨**

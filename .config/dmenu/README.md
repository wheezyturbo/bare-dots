# 🌊 dmenu Rice — Kanagawa Edition

A modern, patched dmenu build with a full script suite that turns dmenu into a
rofi-killing powerhouse. Built for DWM on Arch.

## ✨ Patches Applied

| Patch | Description |
|-------|-------------|
| **Alpha** | Translucent background with opaque text — gorgeous with picom blur |
| **Center** | Centered floating menu instead of screen-edge bar |
| **Fuzzy Highlight** | Matching characters highlighted in carpYellow |
| **Border** | 3px crystalBlue accent border |
| **Line Height** | 38px tall lines for a roomy, modern feel |
| **Case Insensitive** | Case-insensitive matching by default |

## 🎨 Color Scheme — Kanagawa

```
Background:       #1F1F28  (sumiInk1)
Foreground:       #C8C093  (fujiGray)
Selected BG:      #7E9CD8  (crystalBlue)
Selected FG:      #1F1F28  (sumiInk1)
Highlight:        #E6C384  (carpYellow)
Border:           #7E9CD8  (crystalBlue)
Opacity:          ~85%     (0xD9)
```

## 🛠️ Script Suite

All scripts live in `scripts/` and use consistent styling via `dmenu-common.sh`.

| Script | Key | Description |
|--------|-----|-------------|
| `dmenu-launcher.sh` | `Super+A` | **Master hub** — access everything from one menu |
| `dmenu-power.sh` | — | Lock, suspend, logout, reboot, shutdown with confirmations |
| `dmenu-wifi.sh` | — | Scan, connect, disconnect WiFi (nmcli) with signal bars |
| `dmenu-bluetooth.sh` | — | Scan, pair, connect/disconnect BT devices |
| `dmenu-screenshot.sh` | — | Fullscreen/area screenshots → file or clipboard |
| `dmenu-clipboard.sh` | — | Clipboard history via cliphist |
| `dmenu-emoji.sh` | — | Emoji picker → clipboard |
| `dmenu-calc.sh` | — | Calculator (Python math, results → clipboard) |
| `dmenu-kill.sh` | — | Process killer with signal selection |
| `dmenu-configs.sh` | — | Quick-edit dotfiles in nvim |
| `dmenu-bookmarks.sh` | — | Browser bookmarks (add new ones too) |
| `dmenu-display.sh` | — | Brightness, night mode, multi-monitor management |

## ⌨️ Suggested DWM Keybindings

Add these to your DWM `config.def.h`:

```c
static const char *dmenulauncher[] = { "/home/rubyciide/.config/dmenu/scripts/dmenu-launcher.sh", NULL };

/* In keys[] array: */
{ MODKEY,                       XK_a,      spawn,          {.v = dmenulauncher } },
```

Or bind individual scripts:

```c
static const char *dmenupower[]  = { "/home/rubyciide/.config/dmenu/scripts/dmenu-power.sh", NULL };
static const char *dmenuwifi[]   = { "/home/rubyciide/.config/dmenu/scripts/dmenu-wifi.sh", NULL };
static const char *dmenuclip[]   = { "/home/rubyciide/.config/dmenu/scripts/dmenu-clipboard.sh", NULL };
static const char *dmenuscrot[]  = { "/home/rubyciide/.config/dmenu/scripts/dmenu-screenshot.sh", NULL };
```

## 📦 Build

```sh
cd ~/.config/dmenu
make clean && make
sudo make install
```

## 🔧 Customization

- **Colors**: Edit `config.def.h` → `colors[]` and `alphas[]`
- **Opacity**: Change `alpha` value (0x00 = invisible, 0xff = opaque)
- **Font**: Change `fonts[]` array
- **Line height**: Adjust `lineheight` (default: 38)
- **Border**: Adjust `border_width` (default: 3)
- **Lines**: Adjust `lines` (default: 8 vertical items)
- **Bookmarks**: Edit `scripts/bookmarks.txt`
- **Emoji list**: Edit `scripts/emoji-list.txt`

After changes: `cp config.def.h config.h && make clean && sudo make install`

# Dotfiles (Bare Git Repo)

This repository manages my dotfiles using a **bare git repository** technique. No symlinks are required — the working tree is simply `$HOME`.

## 📂 Structure

- **`.cfg/`**: The bare git directory (where `.git` normally lives).
- **`.config/`**: Most config files reside here, directly tracked.
- **`README.md`**: Provides documentation (this file).

Key components:
- **WM**: [DWM](https://dwm.suckless.org/) (custom build in `.config/dwm`)
- **Term**: [st](https://st.suckless.org/) (custom build in `.config/st`)
- **Bar**: [dwmblocks](https://github.com/torrinfail/dwmblocks) (custom build in `.config/dwmblocks`)
- **Compositor**: [picom](https://github.com/yshui/picom) (`.config/picom/picom.conf`)
- **Notification**: [dunst](https://dunst-project.org/) (`.config/dunst/dunstrc`)
- **Launcher**: [rofi](https://github.com/davatorium/rofi) (`.config/rofi/`)

---

## 🚀 Installation on a New Machine

### 1. Prerequisites

Install required packages (Arch Linux example):

```bash
# Core tools
sudo pacman -S git base-devel

# DWM dependencies
sudo pacman -S libx11 libxinerama libxft freetype2 \
               networkmanager brightnessctl playerctl flameshot \
               pavucontrol ttf-jetbrains-mono-nerd dunst rofi picom
```

### 2. Clone the Repository

We clone the bare repository into `~/.cfg`:

```bash
git clone --bare <your-repo-url> $HOME/.cfg
```

### 3. Define Alias

Temporarily define the `config` alias for the current shell session:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

### 4. Checkout

Checkout the content into your home directory:

```bash
config checkout
```

> **Note**: If you get an error about existing files being overwritten (e.g. `.bashrc` or `.config/`), back them up or delete them:
> ```bash
> mkdir -p .config-backup && \
> config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
> xargs -I{} mv {} .config-backup/{}
> ```
> Then run `config checkout` again.

### 5. Configure Git Locally

Hide untracked files to keep `status` clean:

```bash
config config --local status.showUntrackedFiles no
```

---

## 🛠️ Post-Installation Build

Since DWM, st, and dwmblocks are compiled from source, you must build them:

```bash
# Build DWM
cd ~/.config/dwm
sudo make clean install

# Build st
cd ~/.config/st
sudo make clean install

# Build dwmblocks
cd ~/.config/dwmblocks
sudo make clean install
```

---

## ⌨️ Usage

### DWM Keybindings
- **Super + Return**: Terminal (st)
- **Super + a**: Launcher (rofi)
- **Super + Shift + Q**: Reload DWM
- **Super + ?**: Show keybindings cheatsheet
- **Super + x**: Control Center

### Git Operations
Manage dotfiles using the `config` alias:

```bash
config status
config add .vimrc
config commit -m "Update vimrc"
config push
```

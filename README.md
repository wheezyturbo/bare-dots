# 🌊 rubyciide's Dotfiles

A custom, keyboard-driven Linux setup using **DWM** (Dynamic Window Manager), **st** (Simple Terminal), and a curated **Kanagawa** color palette.

---

## 🖥️ System Specifications

* **OS**: Arch Linux
* **Window Manager**: [dwm](file:///.config/dwm) (patched with Systray, Shiftview, & custom layout rules)
* **Status Bar**: [dwmblocks](file:///.config/dwmblocks) (modular blocks written in Shell)
* **Terminal**: [st](file:///.config/st) (Simple Terminal) & [kitty](file:///.config/kitty)
* **Compositor**: [picom](file:///.config/picom) (configured for low-latency GLX rendering)
* **App Launcher / Menus**: [rofi](file:///.config/rofi) (custom Kanagawa themes)
* **Shell**: Zsh (with Oh-My-Zsh & Powerlevel10k theme)
* **Text Editor**: Neovim (LazyVim-based config)
* **Colorscheme**: **Kanagawa (Sumi Ink / Fuji White / Dragon Blue)**

---

## 📂 Repository Structure

| Path | Description |
| :--- | :--- |
| [`.config/dwm`](file:///.config/dwm) | Custom DWM window manager source and startup scripts |
| [`.config/dwmblocks`](file:///.config/dwmblocks) | Status bar blocks (CPU, Memory, Net, Volume, Battery, DateTime) |
| [`.config/st`](file:///.config/st) | Suckless Simple Terminal build with scrollback support |
| [`.config/slock`](file:///.config/slock) | Secure X11 screen locker |
| [`.config/picom`](file:///.config/picom) | Picom compositor settings optimized for Intel GPUs |
| [`.config/rofi`](file:///.config/rofi) | App launchers, control centers, and keybinding viewers |
| [`.config/nvim`](file:///.config/nvim) | Main Neovim configuration |
| [`.config/zsh`](file:///.config/zsh) | Zsh configuration, themes, and plugins |
| [`.tmux.conf`](file:///.tmux.conf) | Tmux terminal multiplexer settings |

---

## 🚀 Installation & Bootstrapping

These dotfiles are managed using the **bare repository** method. This allows you to track and version-control files directly in your home directory without symlink clutter.

### 1. Clone the repository
Clone the bare repository to a hidden directory (`.cfg`) in your home folder:
```bash
git clone --bare <your-dotfiles-repo-url> $HOME/.cfg
```

### 2. Set up the alias
Define a temporary alias to interact with the bare repository:
```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

### 3. Checkout the dotfiles
Checkout the files into your home directory (force overwrite if there are default config conflicts):
```bash
config checkout
# If there are conflicts:
# config checkout -f
```

### 4. Hide untracked files
Prevent `git status` from displaying all untracked files in your home folder:
```bash
config config --local status.showUntrackedFiles no
```

---

## ⚡ Run the Bootstrap Helper

Once checked out, you can automatically install all system dependencies and compile your window manager and terminal builds using the included interactive installer:

```bash
~/.config/dwm/scripts/bootstrap.sh
```

This helper will scan your system, verify missing packages, and handle the builds for `dwm`, `dwmblocks`, `st`, `slock`, and `dmenu` in one go.

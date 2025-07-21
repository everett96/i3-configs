# i3-configs
Various configuration files for i3 and i3blocks intended for Arch Linux systems. Scripts were designed with low power usage as a priority.

## Required Packages (for Arch Linux)

These are the packages needed to run the i3blocks setup and scripts correctly on a fresh Arch Linux install using `archinstall` with i3 selected.

### Core Requirements
These may already be installed if you installed with the `i3` desktop profile:

- `i3-wm` – Window manager
- `i3blocks` – Status bar
- `xorg` – X server
- `xorg-xinit` – X session initializer
- `xorg-xrandr` – Monitor and resolution control
- `xterm` or `alacritty` – Terminal emulator (this setup uses `alacritty`)

### i3blocks Script Dependencies

- `pamixer` – CLI volume control
- `pavucontrol` – Audio mixer GUI
- `htop` – System monitor
- `procps-ng` – Provides `free` and other memory tools
- `coreutils` – Shell utilities (e.g., `date`)
- `bash` – Required for running shell scripts
- `util-linux` – Includes `setsid`, used to launch apps cleanly
- `ttf-font-awesome` – Icon glyphs
- `ttf-nerd-fonts-symbols` or `ttf-nerd-fonts-symbols-mono` – For icons used in i3blocks

### Date/Time Utilities

- `coreutils` – Provides `date`
- `tzdata` – Timezone data

### Visual Utilities

- `feh` – Wallpaper setting tool
- `xwallpaper` or `nitrogen` – Alternative wallpaper managers (optional)

### Optional (Recommended, you will have to change the config if you don't use them)

- `alacritty` – Terminal emulator
- `thunar` – Lightweight file manager
- `flameshot` – Screenshot tool
- `xdg-desktop-portal` – Integration layer for non-DE apps
- `xdg-utils` – For opening URLs and files

### Fonts & Theming

- `ttf-font-awesome` – Icon font
- `ttf-nerd-fonts-symbols` or `ttf-nerd-fonts-symbols-mono` – Extended icons
- `lxappearance` – GTK theme configurator

---

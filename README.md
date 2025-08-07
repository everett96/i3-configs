# i3-configs
Configuration files and scripts for i3 and i3blocks intended for Arch Linux systems. Scripts were designed with low power usage as a priority. The appearance adheres to the [Dracula](https://github.com/dracula/dracula-theme) color palette.

![Screenshot](result.png)

## Required Packages (for Arch Linux)

These are the pacman packages needed to run the i3blocks setup and scripts correctly on a fresh Arch Linux install using `archinstall` with i3 selected. No AUR packages are required. 

### Core Requirements
These may already be installed if you installed with the `i3` desktop profile:

- `i3-wm` – Window manager
- `i3blocks` – Status bar
- `xorg` – X server
- `xorg-xinit` – X session initializer
- `xorg-xrandr` – Monitor and resolution control
- `alacritty` (or your favorite terminal) – Terminal emulator

### i3blocks Script Dependencies

- `pamixer` – CLI volume control
- `pavucontrol` – Audio mixer GUI
- `htop` – System monitor
- `calcurse` – Terminal-based calendar
- `procps-ng` – Provides `free` and other memory tools
- `python-xlib` - Required for window listener
- `coreutils` – Shell utilities (e.g., `date`)
- `bash` – Required for running shell scripts
- `util-linux` – Includes `setsid`, used to launch apps cleanly
- `ttf-font-awesome` – Icon glyphs
- `ttf-nerd-fonts-symbols` or `ttf-nerd-fonts-symbols-mono` – For icons used in i3blocks
- `ttf-firacode-nerd` (or any other font) – Font used by default in i3/config
- `tzdata` – Timezone data

### Optional (Recommended / Used in Config)

- `thunar` – Lightweight file manager
- `flameshot` – Screenshot tool
- `xdg-desktop-portal` – Integration layer for non-DE apps
- `xdg-utils` – For opening URLs and files
- `feh` – Wallpaper setting tool
- `lxappearance` – GTK theme configurator

## License

This project is licensed under the [MIT License](LICENSE).

---

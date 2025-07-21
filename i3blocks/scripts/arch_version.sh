#!/bin/bash

# If the block was clicked (button 1 = left click)
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    # Open Arch Wiki in your default browser
    xdg-open "https://wiki.archlinux.org" >/dev/null 2>&1 &
fi

# Get kernel version
version=$(uname -r)

bg="#44475a"         # A nice light grey/blue bubble
fg="#1793d0"
# Output as a full bubble
# a subtle grey for the pill edges
echo "<span foreground='$bg'></span><span background='$bg' foreground='$fg'> " Arch Linux v$version" </span><span foreground='$bg'></span>"
# Output for i3blocks


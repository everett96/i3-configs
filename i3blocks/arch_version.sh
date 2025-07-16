#!/bin/bash

# If the block was clicked (button 1 = left click)
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    # Open Arch Wiki in your default browser
    xdg-open "https://wiki.archlinux.org" >/dev/null 2>&1 &
fi

# Get kernel version
version=$(uname -r)

# Output for i3blocks
echo " Arch Linux v$version"
echo
echo "#1793d0"


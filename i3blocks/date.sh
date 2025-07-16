$!/bin/bash

# Open htop on left-click
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    setsid alacritty -e calcurse >/dev/null 2>&1 &
fi

# Output date and time
date '+%Y-%m-%d %H:%M'

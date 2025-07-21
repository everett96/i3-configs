#!/bin/bash
#
# i3blocks date/time widget (pill style)
# Displays current date and time, opens calcurse on click

# Launch calcurse in terminal on left-click
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    setsid alacritty -e calcurse >/dev/null 2>&1 &
fi

# Style configuration
bg="#44475a"         # Bubble background
cap_color="$bg"      # Rounded cap color (can be customized)
fg="#bc94fc"         # Foreground/text color

# Icon and formatted time string
icon=""
text=$(date '+%a %b %d %H:%M')

# Output with powerline-style rounded edges
echo "<span foreground='$cap_color'></span><span background='$bg' foreground='$fg'> $icon $text </span><span foreground='$cap_color'></span>"

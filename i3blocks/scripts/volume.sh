#!/bin/bash
#
# i3blocks volume widget (pill style)
# Displays current volume level and icon, opens pavucontrol on click

# Launch PulseAudio mixer on left-click
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    setsid pavucontrol >/dev/null 2>&1 &
fi

# Get volume and mute status
volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

# Determine icon based on volume level
if [ "$muted" = "true" ]; then
    icon=""
elif [ "$volume" -ge 70 ]; then
    icon=""
elif [ "$volume" -ge 30 ]; then
    icon=""
else
    icon=""
fi

# Style configuration
bg="#44475a"         # Bubble background
cap_color="$bg"      # Rounded cap color (can be changed)
fg="#ff79c6"          # Foreground/text color

# Output with powerline-style rounded edges
echo "<span foreground='$cap_color'></span><span background='$bg' foreground='$fg'> $icon ${volume}% </span><span foreground='$cap_color'></span>"

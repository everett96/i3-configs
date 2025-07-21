#!/bin/bash
#
# i3blocks battery status widget (pill style)
# Shows battery percentage with icon and color based on charge level

BAT_PATH="/sys/class/power_supply/BAT1"

# Exit if battery info is not available
if [ ! -d "$BAT_PATH" ]; then
    echo "No battery"
    exit 1
fi

# Read battery capacity and charging status
capacity=$(<"$BAT_PATH/capacity")
status=$(<"$BAT_PATH/status")

# Style colors
bg="#44475a"        # Pill background
cap_color="#44475a" # Rounded cap color (matches bg)

# Determine icon and text color
if [ "$status" = "Charging" ]; then
    icon=""
    color="#8be9fd"  # Bright blue while charging
elif [ "$capacity" -ge 90 ]; then
    icon=""
    color="#50fa7b"  # Green
elif [ "$capacity" -ge 70 ]; then
    icon=""
    color="#50fa7b"  # Green
elif [ "$capacity" -ge 51 ]; then
    icon=""
    color="#f1fa8c"  # Yellow
elif [ "$capacity" -ge 30 ]; then
    icon=""
    color="#ffb86c"  # Orange
elif [ "$capacity" -ge 10 ]; then
    icon=""
    color="#ff5555"  # Red
else
    icon=""
    color="#ff5555"  # Red
fi

# Print output with powerline-style rounded caps
echo "<span foreground='$cap_color'></span><span background='$bg' foreground='$color'> $icon ${capacity}% </span><span foreground='$cap_color'></span>"


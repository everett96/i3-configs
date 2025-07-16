#!/bin/bash

BAT_PATH="/sys/class/power_supply/BAT1"

if [ ! -d "$BAT_PATH" ]; then
    echo "No battery"
    exit 1
fi

capacity=$(cat "$BAT_PATH/capacity")
status=$(cat "$BAT_PATH/status")

# Icon based on level
if [ "$capacity" -ge 90 ]; then
    icon=""   # Full
    color="#00ff00"
elif [ "$capacity" -ge 70 ]; then
    icon=""   # 3/4
    color="#aaff00"
elif [ "$capacity" -ge 51 ]; then
    icon=""   # 3/4
    color="#ffee00"
elif [ "$capacity" -ge 30 ]; then
    icon=""   # Half
    color="#ffaa00"
elif [ "$capacity" -ge 10 ]; then
    icon=""   # Low
    color="#ff5500"
else
    icon=""   # Empty
    color="#ff0000"
fi

# If charging, use bolt icon
if [ "$status" = "Charging" ]; then
    icon=""
fi

if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
    echo "$icon $capacity% ($status)"
    echo "$status"
    echo "$color"
else
    echo "$icon $capacity%"
    echo "$status"
    echo "$color"
fi

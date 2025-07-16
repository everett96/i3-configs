#!/bin/bash

# Open PulseAudio mixer on click
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    setsid pavucontrol >/dev/null 2>&1 &
fi

# Get current volume and mute status
volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
    icon=""
    color="#888888"
else
    if [ "$volume" -ge 70 ]; then
        icon=""
        color="#00ffcc"
    elif [ "$volume" -ge 30 ]; then
        icon=""
        color="#33ffaa"
    else
        icon=""
        color="#99ffcc"
    fi
fi

echo "$icon ${volume}%"
echo "$volume"
echo "$color"


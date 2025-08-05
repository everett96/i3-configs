#!/bin/bash

# Save window title in a temp file so i3blocks can read it quickly
STATE_FILE="/tmp/i3blocks_active_window"

# Get the active window ID
get_active_window_id() {
    xprop -root _NET_ACTIVE_WINDOW | awk '{print $NF}'
}

# Update the window title
get_title() {
    win_id=$(get_active_window_id)

    # If no window is focused (e.g., all apps are closed)
    if [[ "$win_id" == "0x0" || -z "$win_id" ]]; then
        echo "" > "$STATE_FILE"
        pkill -SIGRTMIN+2 i3blocks
        return
    fi

    # Get the window title (WM_NAME)
    title=$(xprop -id "$win_id" WM_NAME 2>/dev/null | sed -n 's/.*= "\(.*\)"/\1/p')

    # If title is empty or just "Desktop", clear it
    if [[ -z "$title" || "$title" == "Desktop" ]]; then
        title=""
    else
        # Truncate if too long
        if [ ${#title} -gt 75 ]; then
            title="${title:0:72}..."
        fi
        # Add styling
        title="<span foreground='#f8f8f2' size='medium'>$title</span>"
    fi

    echo "$title" > "$STATE_FILE"
    pkill -SIGRTMIN+2 i3blocks
}

# Watch title changes on the current focused window
watch_active_window() {
    while true; do
        win_id=$(get_active_window_id)

        # If no active window, wait and retry
        if [[ "$win_id" == "0x0" || -z "$win_id" ]]; then
            sleep 0.5
            continue
        fi

        # Listen for title changes (_NET_WM_NAME or WM_NAME) on the window
        xprop -id "$win_id" -spy _NET_WM_NAME WM_NAME | while read -r _; do
            get_title
        done
    done
}

# Initial update
get_title &

# Watch for active window changes (focus)
xprop -spy -root _NET_ACTIVE_WINDOW | while read -r _; do
    # Stop any previous window title watchers
    pkill -f "xprop -id" 2>/dev/null
    get_title
    watch_active_window &
done


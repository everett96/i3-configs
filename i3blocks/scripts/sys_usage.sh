#!/bin/bash
#
# i3blocks CPU & RAM widget (pill style)
# Shows real-time CPU and RAM usage, opens htop on left-click

# Launch htop on left-click
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    setsid alacritty -e htop >/dev/null 2>&1 &
fi

# --- CPU Usage Calculation ---
PREV=($(head -n1 /proc/stat))
sleep 0.5
CURR=($(head -n1 /proc/stat))

# Calculate total and idle time deltas
PREV_TOTAL=0
CURR_TOTAL=0
for i in "${PREV[@]:1}"; do PREV_TOTAL=$((PREV_TOTAL + i)); done
for i in "${CURR[@]:1}"; do CURR_TOTAL=$((CURR_TOTAL + i)); done

PREV_IDLE=$((PREV[4] + PREV[5]))  # idle + iowait
CURR_IDLE=$((CURR[4] + CURR[5]))

TOTAL_DIFF=$((CURR_TOTAL - PREV_TOTAL))
IDLE_DIFF=$((CURR_IDLE - PREV_IDLE))

CPU_USAGE=$(awk "BEGIN { if ($TOTAL_DIFF > 0) printf \"%.1f\", 100 * ($TOTAL_DIFF - $IDLE_DIFF) / $TOTAL_DIFF; else print \"0.0\" }")

# --- RAM Usage Calculation ---
# --- RAM Usage Calculation (excludes cache/buffers) ---
read total available <<< $(free -m | awk '/^Mem:/ {print $2, $7}')
RAM_USAGE=$(( (total - available) * 100 / total ))

# --- Style Configuration ---
bg="#44475a"          # Pill background
cap_color="$bg"       # Rounded cap color (can be customized)
fg_cpu="#f8f8f2"       # CPU text (white)
fg_ram="#ffb86c"       # RAM text (orange)

# --- Icons ---
icon_cpu=""
icon_ram=""

# --- Build Content ---
content_cpu="<span foreground='$fg_cpu'>$icon_cpu ${CPU_USAGE}%</span>"
content_ram="<span foreground='$fg_ram'>$icon_ram ${RAM_USAGE}%</span>"

# --- Output pill with powerline-style caps ---
echo -e "<span foreground='$cap_color'></span><span background='$bg'> $content_cpu  $content_ram </span><span foreground='$cap_color'></span>"

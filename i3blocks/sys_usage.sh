#!/bin/bash

# Open htop on left-click
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    setsid alacritty -e htop >/dev/null 2>&1 &
fi

# --- CPU usage ---
PREV=($(head -n1 /proc/stat))
sleep 0.5
CURR=($(head -n1 /proc/stat))

# Total and idle deltas
PREV_TOTAL=0
CURR_TOTAL=0

for i in "${PREV[@]:1}"; do
    PREV_TOTAL=$((PREV_TOTAL + i))
done
for i in "${CURR[@]:1}"; do
    CURR_TOTAL=$((CURR_TOTAL + i))
done

PREV_IDLE=$((PREV[4] + PREV[5]))  # idle + iowait
CURR_IDLE=$((CURR[4] + CURR[5]))

TOTAL_DIFF=$((CURR_TOTAL - PREV_TOTAL))
IDLE_DIFF=$((CURR_IDLE - PREV_IDLE))

CPU_USAGE=$(awk "BEGIN {printf \"%.1f\", 100 * ($TOTAL_DIFF - $IDLE_DIFF) / $TOTAL_DIFF}")

# --- RAM usage ---
read total used <<< $(free -m | awk '/^Mem:/ {print $2, $3}')
RAM_USAGE=$(( used * 100 / total ))

# --- Output ---
printf " %d%%   %d%%\n" "$CPU_USAGE" "$RAM_USAGE"

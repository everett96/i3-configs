#!/usr/bin/env python3
"""
i3blocks Active Window Title Listener with Debounce

This script listens for changes to the active window on the X11 server,
fetches the active window's title, writes it to a temp file with Pango markup,
and signals i3blocks to update the status bar.

Debounce logic prevents excessive updates when switching windows rapidly.

Requirements:
- python-xlib
- i3blocks configured with:
    signal=2
    markup=pango
    interval=once
"""

import os
import signal
import subprocess
import time
from threading import Timer

from Xlib import X, display, error

STATE_FILE = "/tmp/i3blocks_active_window"
DEBOUNCE_DELAY = 0.1  # seconds to wait before processing event

# Initialize X display and atoms
d = display.Display()
root = d.screen().root

NET_ACTIVE_WINDOW = d.intern_atom('_NET_ACTIVE_WINDOW')
NET_WM_NAME = d.intern_atom('_NET_WM_NAME')  # UTF-8 window title
WM_NAME = d.intern_atom('WM_NAME')          # Legacy window title

class DebouncedUpdater:
    """Helper class to debounce window title updates."""

    def __init__(self, delay, callback):
        self.delay = delay
        self.callback = callback
        self.timer = None

    def schedule(self, *args, **kwargs):
        if self.timer:
            self.timer.cancel()
        self.timer = Timer(self.delay, self.callback, args=args, kwargs=kwargs)
        self.timer.start()

def get_active_window():
    """Return the currently active window object, or None if none."""
    try:
        prop = root.get_full_property(NET_ACTIVE_WINDOW, X.AnyPropertyType)
        if prop:
            win_id = prop.value[0]
            return d.create_resource_object('window', win_id)
    except Exception:
        pass
    return None

def get_window_title(win):
    """
    Get the window's title, trying UTF-8 _NET_WM_NAME first, then legacy WM_NAME.

    Returns empty string if no title is found.
    """
    if not win:
        return ""
    try:
        for atom in (NET_WM_NAME, WM_NAME):
            prop = win.get_full_property(atom, X.AnyPropertyType)
            if prop:
                return prop.value.decode('utf-8', errors='ignore')
    except error.XError:
        pass
    return ""

def write_title(title):
    """
    Write the styled window title to the STATE_FILE and signal i3blocks.

    Skips writing if the content hasn't changed to reduce I/O and signals.
    """
    if not title or title == "Desktop":
        title = ""
    elif len(title) > 75:
        title = title[:72] + "..."
    styled = f"<span foreground='#f8f8f2' size='medium'>{title}</span>\n"

    try:
        with open(STATE_FILE, 'r') as f:
            if f.read() == styled:
                return  # No change, skip update
    except FileNotFoundError:
        pass

    with open(STATE_FILE, 'w') as f:
        f.write(styled)

    # Signal i3blocks to refresh this block (signal=2 → SIGRTMIN+2)
    subprocess.run(['pkill', '-SIGRTMIN+2', 'i3blocks'],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def main():
    """
    Main event loop listening for active window changes and title changes.

    Uses debounce to batch rapid events.
    """
    root.change_attributes(event_mask=X.PropertyChangeMask)

    last_win = None
    last_title = ""

    updater = DebouncedUpdater(DEBOUNCE_DELAY, write_title)

    while True:
        event = d.next_event()

        if event.type == X.PropertyNotify and event.atom == NET_ACTIVE_WINDOW:
            # Active window changed
            current_win = get_active_window()
            current_title = get_window_title(current_win)

            # Only schedule update if window or title changed
            if current_win != last_win or current_title != last_title:
                last_win = current_win
                last_title = current_title
                updater.schedule(current_title)

            # Update event mask on new window to catch title changes
            if current_win:
                try:
                    current_win.change_attributes(event_mask=X.PropertyChangeMask)
                except error.XError:
                    pass

        elif event.type == X.PropertyNotify:
            # Possibly title changed on the current window
            if last_win:
                current_title = get_window_title(last_win)
                if current_title != last_title:
                    last_title = current_title
                    updater.schedule(current_title)

if __name__ == "__main__":
    main()


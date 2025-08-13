#!/usr/bin/env python3
"""
i3blocks Active Window Title Listener
"""

import os
import signal
import subprocess
import getpass
import threading
import select
from threading import Timer
from Xlib import X, display, error

# ----------------------------
# State file location
# ----------------------------
runtime_dir = os.environ.get("XDG_RUNTIME_DIR", f"/tmp/{getpass.getuser()}")
STATE_FILE = os.path.join(runtime_dir, "i3blocks_active_window")
os.makedirs(runtime_dir, exist_ok=True)

# ----------------------------
# Config
# ----------------------------
DEBOUNCE_DELAY = 0.1  # seconds
TITLE_MAX_LENGTH = 80  # max characters including ellipsis

# ----------------------------
# X11 setup
# ----------------------------
d = display.Display()
root = d.screen().root

NET_ACTIVE_WINDOW = d.intern_atom('_NET_ACTIVE_WINDOW')
NET_WM_NAME = d.intern_atom('_NET_WM_NAME')
WM_NAME = d.intern_atom('WM_NAME')

write_lock = threading.Lock()
running = True


class DebouncedUpdater:
    """Helper to debounce updates to avoid excessive writes/signals."""
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
    """Return the currently active window object, or None."""
    try:
        prop = root.get_full_property(NET_ACTIVE_WINDOW, X.AnyPropertyType)
        if prop and prop.value and prop.value[0] != 0:
            return d.create_resource_object('window', prop.value[0])
    except error.XError:
        pass
    return None


def get_window_title(win):
    """Get window's title, UTF-8 first then fallback to legacy WM_NAME."""
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


def safe_truncate(text, max_length):
    """
    Truncate a string to max_length characters, appending '…' if truncated.
    Safe for multi-byte UTF-8 characters.
    """
    if len(text) <= max_length:
        return text
    return text[:max_length - 1] + "…"


def format_title(title):
    """Return the styled title string for i3blocks."""
    if not title or title == "Desktop":
        return ""
    title = safe_truncate(title, TITLE_MAX_LENGTH)
    return f"<span foreground='#f8f8f2' size='medium'>{title}</span>\n"


def write_title(title):
    """
    Write styled window title to STATE_FILE and signal i3blocks.
    Skip writing if the content hasn’t changed.
    """
    styled = format_title(title)

    with write_lock:
        try:
            with open(STATE_FILE, 'r', encoding='utf-8') as f:
                if f.read() == styled:
                    return  # No change, skip update
        except FileNotFoundError:
            pass

        with open(STATE_FILE, 'w', encoding='utf-8') as f:
            f.write(styled)

    subprocess.run(
        ['pkill', '-SIGRTMIN+2', 'i3blocks'],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )


def handle_exit(signum, frame):
    """Signal handler for clean shutdown."""
    global running
    running = False


def watch_window(win):
    """Subscribe to title changes on the given window."""
    try:
        win.change_attributes(event_mask=X.PropertyChangeMask)
    except error.XError:
        pass


def unwatch_window(win):
    """Unsubscribe from events on the given window."""
    try:
        win.change_attributes(event_mask=0)
    except error.XError:
        pass


def main():
    """Main event loop: track active window and its title."""
    root.change_attributes(event_mask=X.PropertyChangeMask)

    last_win = None
    last_styled = ""
    updater = DebouncedUpdater(DEBOUNCE_DELAY, write_title)

    # Initial write at startup
    current_win = get_active_window()
    current_title = get_window_title(current_win)
    last_win = current_win
    last_styled = format_title(current_title)
    updater.schedule(current_title)
    if current_win:
        watch_window(current_win)

    # Event loop
    while running:
        r, _, _ = select.select([d.fileno()], [], [], 0.5)
        if not r:
            continue

        while d.pending_events():
            event = d.next_event()

            # Active window changed
            if event.type == X.PropertyNotify and event.atom == NET_ACTIVE_WINDOW:
                if last_win:
                    unwatch_window(last_win)

                current_win = get_active_window()
                current_title = get_window_title(current_win)
                current_styled = format_title(current_title)

                if current_styled != last_styled:
                    last_styled = current_styled
                    updater.schedule(current_title)

                last_win = current_win
                if current_win:
                    watch_window(current_win)

            # Title changed for current window
            elif event.type == X.PropertyNotify and last_win:
                if event.atom in (NET_WM_NAME, WM_NAME):
                    current_title = get_window_title(last_win)
                    current_styled = format_title(current_title)
                    if current_styled != last_styled:
                        last_styled = current_styled
                        updater.schedule(current_title)


if __name__ == "__main__":
    signal.signal(signal.SIGINT, handle_exit)
    signal.signal(signal.SIGTERM, handle_exit)
    main()


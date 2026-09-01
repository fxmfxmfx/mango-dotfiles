#!/usr/bin/env python3
"""Reminder widget for rs-yambar.

Opens on hover over the bell icon. Shows the reminder list, lets you add a
line of plain text (Enter), delete an entry (x), and closes on Esc or the
close button.

Data is stored as plain text, one reminder per line, in:
    ~/.config/rs-yambar/reminders.txt  (override via $RS_YAMBAR_REMINDERS)
"""

import atexit
import os
import signal
import sys
from pathlib import Path

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk, Gtk

STORE = Path(
    os.environ.get(
        "RS_YAMBAR_REMINDERS",
        str(Path.home() / ".config" / "rs-yambar" / "reminders.txt"),
    )
)
LOCK = STORE.with_suffix(STORE.suffix + ".lock")

CSS = b"""
window {
    background-color: #161616;
    color: #e0e0e0;
    font-family: "DejaVu Sans";
    font-size: 13px;
}
.header {
    padding: 8px 12px 6px 12px;
    color: #bdbdbd;
    font-weight: bold;
}
.header-close {
    padding: 0px;
    color: #8f8f8f;
}
.header-close:hover {
    color: #e0e0e0;
}
.row {
    padding: 4px 8px;
    background-color: #161616;
}
.row:hover {
    background-color: #1e1e1e;
}
.empty-row {
    padding: 10px;
    color: #8f8f8f;
}
.entry, .entry:focus {
    background-color: #0d0d0d;
    color: #e0e0e0;
}
"""


def load_reminders():
    if not STORE.is_file():
        return []
    text = STORE.read_text(encoding="utf-8")
    return [line.strip() for line in text.splitlines() if line.strip()]


def save_reminders(items):
    STORE.parent.mkdir(parents=True, exist_ok=True)
    STORE.write_text("\n".join(items) + ("\n" if items else ""), encoding="utf-8")


def acquire_instance():
    if LOCK.exists():
        try:
            pid = int(LOCK.read_text().strip())
            os.kill(pid, 0)
            os.kill(pid, signal.SIGTERM)
        except (ValueError, ProcessLookupError, PermissionError):
            LOCK.unlink(missing_ok=True)
    LOCK.write_text(str(os.getpid()))
    signal.signal(signal.SIGTERM, lambda *_args: sys.exit(0))
    signal.signal(signal.SIGINT, lambda *_args: sys.exit(0))
    atexit.register(_cleanup_lock)
    return True


def _cleanup_lock():
    try:
        if LOCK.read_text().strip() == str(os.getpid()):
            LOCK.unlink(missing_ok=True)
    except OSError:
        pass


def main():
    acquire_instance()

    win = Gtk.Window(type=Gtk.WindowType.TOPLEVEL)
    win.set_title("rs-yambar reminders")
    win.set_decorated(False)
    win.set_resizable(False)
    win.set_skip_taskbar_hint(True)
    win.set_skip_pager_hint(True)
    win.set_position(Gtk.WindowPosition.CENTER)
    win.set_size_request(340, -1)

    provider = Gtk.CssProvider()
    provider.load_from_data(CSS)
    Gtk.StyleContext.add_provider_for_screen(
        Gdk.Screen.get_default(),
        provider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
    )

    items = load_reminders()

    outer = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
    win.add(outer)

    header = Gtk.Label(label="")
    header.get_style_context().add_class("header")
    header.set_halign(Gtk.Align.START)
    header.set_hexpand(True)

    close_btn = Gtk.Button(label="×")
    close_btn.get_style_context().add_class("header-close")
    close_btn.set_relief(Gtk.ReliefStyle.NONE)
    close_btn.set_focus_on_click(False)
    close_btn.connect("clicked", lambda _b: Gtk.main_quit())

    header_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
    header_row.pack_start(header, True, True, 0)
    header_row.pack_start(close_btn, False, False, 0)
    outer.pack_start(header_row, False, False, 0)

    listbox = Gtk.ListBox()
    listbox.set_selection_mode(Gtk.SelectionMode.NONE)
    scrolled = Gtk.ScrolledWindow()
    scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
    scrolled.set_min_content_height(70)
    scrolled.set_max_content_height(240)
    scrolled.add(listbox)
    outer.pack_start(scrolled, True, True, 0)

    entry = Gtk.Entry()
    entry.set_placeholder_text("Новое напоминание…  (Enter — добавить, Esc — закрыть)")
    entry.get_style_context().add_class("entry")
    entry.set_margin_start(8)
    entry.set_margin_end(8)
    entry.set_margin_top(4)
    entry.set_margin_bottom(8)
    outer.pack_start(entry, False, False, 0)

    def refresh():
        header.set_text(f"Напоминания ({len(items)})")
        for child in listbox.get_children():
            listbox.remove(child)
        if not items:
            empty = Gtk.Label(label="Пока пусто")
            empty.get_style_context().add_class("empty-row")
            listbox.add(empty)
            return
        for i, text in enumerate(items):
            row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
            row.get_style_context().add_class("row")
            label = Gtk.Label(label=text)
            label.set_halign(Gtk.Align.START)
            label.set_xalign(0.0)
            label.set_line_wrap(True)
            label.set_ellipsize(0)
            del_btn = Gtk.Button(label="×")
            del_btn.set_relief(Gtk.ReliefStyle.NONE)
            del_btn.connect("clicked", lambda _b, idx=i: delete(idx))
            row.pack_start(label, True, True, 0)
            row.pack_start(del_btn, False, False, 0)
            listbox.add(row)
        listbox.show_all()

    def delete(index):
        if 0 <= index < len(items):
            del items[index]
            save_reminders(items)
            refresh()

    def on_add(_entry):
        text = entry.get_text().strip()
        if not text:
            return
        items.append(text)
        save_reminders(items)
        entry.set_text("")
        refresh()

    entry.connect("activate", on_add)

    # Close on Esc
    def on_key(_w, event):
        if event.keyval == Gdk.KEY_Escape:
            Gtk.main_quit()
            return True
        return False

    win.connect("key-press-event", on_key)

    refresh()
    win.show_all()
    win.present()
    entry.grab_focus()
    Gtk.main()


if __name__ == "__main__":
    main()
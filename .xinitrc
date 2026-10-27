#!/bin/sh

# Identify the desktop session
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_DESKTOP=i3
export DESKTOP_SESSION=i3

# Load CachyOS/Arch X session initialization scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Import the session environment for D-Bus and systemd services
systemctl --user import-environment \
    DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP \
    XDG_SESSION_DESKTOP DESKTOP_SESSION

dbus-update-activation-environment --systemd \
    DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP \
    XDG_SESSION_DESKTOP DESKTOP_SESSION

# Import XAUTHORITY when it is set
if [ -n "${XAUTHORITY:-}" ]; then
    systemctl --user import-environment XAUTHORITY
    dbus-update-activation-environment --systemd XAUTHORITY
fi

# Start the window manager
exec i3

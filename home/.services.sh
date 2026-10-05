#!/bin/sh
# This file initializes the user services(no X11)

# mpd --no-daemon &
pipewire &
pipewire-pulse &
wireplumber &

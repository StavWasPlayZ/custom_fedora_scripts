#!/bin/bash

# Toggles hiding the org.gnome.shell.extensions.trayIconsReloaded system tray icons.
# Necessary because of https://github.com/martinpl/tray-icons-reloaded/issues/138

readonly LIMIT_COUNT=10

toggle_visibility() {
    # Command usage source: https://askubuntu.com/a/1008879
    curr_val=$(gsettings \
        --schemadir /home/stavlpc/.local/share/gnome-shell/extensions/trayIconsReloaded@selfmade.pl/schemas/ \
        get org.gnome.shell.extensions.trayIconsReloaded icons-limit
    )

    if [ $curr_val -ne 1 ]; then
        set_hidden
    else
        set_visible
    fi
}

set_hidden() {
    gsettings \
        --schemadir /home/stavlpc/.local/share/gnome-shell/extensions/trayIconsReloaded@selfmade.pl/schemas/ \
        set org.gnome.shell.extensions.trayIconsReloaded icons-limit 1

    echo -n "Hid "
}

set_visible() {
    gsettings \
        --schemadir /home/stavlpc/.local/share/gnome-shell/extensions/trayIconsReloaded@selfmade.pl/schemas/ \
        set org.gnome.shell.extensions.trayIconsReloaded icons-limit $LIMIT_COUNT
    
    echo -n "Shown "
}

#TODO use command arguments to call set functions alike
toggle_visibility
echo tray icons
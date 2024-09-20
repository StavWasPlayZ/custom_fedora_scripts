#!/bin/bash

# List all Wacom styluses.
# The output of the initial command might look like:
#
# Wacom Intuos S Pad pad          	id: 10	type: PAD       
# Wacom Intuos S Pen stylus       	id: 11	type: STYLUS
# ...
#
# Thus, grep all that match the type STYLUS,
# then apply the following regex to get all numbers
# after the string "id: " (cut everything before and after):

devices=$(xsetwacom --list devices | grep STYLUS | sed -r "s/.*id: ([0-9]+).*/\1/")

echo "$devices" | while read stylus_id; do
    xsetwacom --set "$stylus_id" MapToOutput next
done

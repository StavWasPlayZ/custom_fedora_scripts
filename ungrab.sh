#!/bin/bash

setxkbmap -option grab:break_actions
xdotool key XF86Ungrab
setxkbmap -option
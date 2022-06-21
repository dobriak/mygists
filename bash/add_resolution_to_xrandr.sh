#!/bin/bash
# == Adds a new mode for xrandr ==
# Use case: 14 inch laptop (eDP-1) and external monitor (DP-1) 
# Laptop and monitor are 4K, so the text on eDP-1 is tiny
# If we set eDP-1 to 1600x900@60Hz they will match ok size-wize
# Out of the box, xrandr doesn't seem to have that resolution by default

laptop_monitor="eDP-1"
X=1600
Y=900
Hz=60

mode=$(cvt ${X} ${Y} ${Hz})
modeline=${mode#*Modeline}
modename=$(echo ${modeline} | grep -oP '(?<=").*(?=")')
xrandr --newmode ${modeline}
xrandr --addmode ${laptop_monitor} ${modename}

echo "You should now be able to set your ${laptop_monitor} screen to ${modename}"

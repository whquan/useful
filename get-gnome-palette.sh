#!/bin/bash
# get gnome-terminal profiles
echo "use_theme_background:"
gconftool-2 --get "/apps/gnome-terminal/profiles/Default/use_theme_background"
echo "use_theme_background:"
gconftool-2 --get "/apps/gnome-terminal/profiles/Default/use_theme_colors"
echo "palette:"
gconftool-2 --get "/apps/gnome-terminal/profiles/Default/palette"
echo "background_color:"
gconftool-2 --get "/apps/gnome-terminal/profiles/Default/background_color"
echo "foreground_color:"
gconftool-2 --get "/apps/gnome-terminal/profiles/Default/foreground_color"

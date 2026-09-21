#!/usr/bin/env bash

# Считываем текущую цветовую схему из gsettings
CURRENT_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")

if [ "$CURRENT_SCHEME" = "prefer-dark" ]; then
    ~/.local/bin/switch-theme.sh light
    notify-send -u low -h string:x-canonical-private-synchronous:osd_theme "Смена темы" "Включена светлая тема (Everforest)"
else
    ~/.local/bin/switch-theme.sh dark
    notify-send -u low -h string:x-canonical-private-synchronous:osd_theme "Смена темы" "Включена тёмная тема (Gruvbox)"
fi

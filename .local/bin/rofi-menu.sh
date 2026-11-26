#!/usr/bin/env bash

mode_file="$HOME/.config/hypr/current_theme_mode"

if [ -r "$mode_file" ]; then
    mode=$(head -n 1 "$mode_file" | tr -d '\r\n')
else
    case "$(gsettings get org.gnome.desktop.interface color-scheme)" in
        *prefer-light*) mode=light ;;
        *)              mode=dark ;;
    esac
fi

case "$mode" in
    light) theme="$HOME/.config/rofi/launchers/type-1/theme-light.rasi" ;;
    dark)  theme="$HOME/.config/rofi/launchers/type-1/theme-dark.rasi" ;;
    *)     theme="$HOME/.config/rofi/launchers/type-1/theme-dark.rasi" ;;
esac

exec rofi "$@" -theme "$theme"

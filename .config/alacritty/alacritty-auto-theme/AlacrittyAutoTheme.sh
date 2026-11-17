#!/bin/bash

THEME_FILE="$HOME/.config/alacritty/alacritty-auto-theme/theme.toml"

apply_theme() {
    local theme
    theme="$(gsettings get org.gnome.desktop.interface color-scheme)"
    
    if [[ "$theme" == *'prefer-dark'* ]]; then
        echo "general.import = ['$HOME/.config/alacritty/alacritty-auto-theme/dark_theme.toml']" > "$THEME_FILE"
    else
        echo "general.import = ['$HOME/.config/alacritty/alacritty-auto-theme/light_theme.toml']" > "$THEME_FILE"
    fi
}

# Применяем тему сразу при старте
apply_theme

# Мониторим изменения gsettings напрямую без громоздкого dbus-monitor
gsettings monitor org.gnome.desktop.interface color-scheme | while read -r _; do
    apply_theme
done

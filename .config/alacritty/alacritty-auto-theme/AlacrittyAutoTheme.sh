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

# применяем тему сразу при запуске скрипта
apply_theme

# слушаем изменения D-Bus в реальном времени
interface="org.freedesktop.portal.Settings"
monitor_path="/org/freedesktop/portal/desktop"
monitor_member="SettingChanged"

dbus-monitor --profile "interface='$interface',path=$monitor_path,member=$monitor_member" |
    while read -r line; do
        # каждое изменение цветовой схемы вызывает событие color-scheme
        if echo "$line" | grep -q "color-scheme"; then
            # небольшая задержка, чтобы D-Bus успел полностью записать состояние
            sleep 0.2
            apply_theme
        fi
    done

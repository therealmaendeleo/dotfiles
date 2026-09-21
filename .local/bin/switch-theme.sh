#!/usr/bin/env bash

MODE=$1
AUTO_FLAG="/tmp/theme-manual-override"

# 1. Логика определения режима
if [ "$MODE" = "auto" ]; then
    if [ -f "$AUTO_FLAG" ]; then
        exit 0
    fi
    
    HOUR=$(date +%H)
    if [ "$HOUR" -ge 8 ] && [ "$HOUR" -lt 20 ]; then
        TARGET_MODE="light"
    else
        TARGET_MODE="dark"
    fi
elif [ "$MODE" = "light" ] || [ "$MODE" = "dark" ]; then
    touch "$AUTO_FLAG"
    TARGET_MODE="$MODE"
elif [ "$MODE" = "enable-auto" ]; then
    rm -f "$AUTO_FLAG"
    exec "$0" auto
else
    echo "Использование:"
    echo "  $0 auto        - Автопереключение по времени"
    echo "  $0 light       - Включить светлую"
    echo "  $0 dark        - Включить тёмную"
    echo "  $0 enable-auto - Вернуть автоматический режим"
    exit 1
fi

# 2. Настройка названий тем и обоев (с использованием $HOME)
if [ "$TARGET_MODE" = "light" ]; then
    GTK_THEME="Everforest-B-MB-Light"
    COLOR_SCHEME="prefer-light"
    WALLPAPER="$HOME/Pictures/wallpaper-light.jpeg"
    SWAYOSD_STYLE="$HOME/.config/swayosd/style-light.css"
elif [ "$TARGET_MODE" = "dark" ]; then
    GTK_THEME="Gruvbox-Green-Dark"
    COLOR_SCHEME="prefer-dark"
    WALLPAPER="$HOME/Pictures/wallpaper-dark.jpg"
    SWAYOSD_STYLE="$HOME/.config/swayosd/style-dark.css"
fi

# 3. Применение темы через gsettings и GTK3
gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"

GTK3_CONF="$HOME/.config/gtk-3.0/settings.ini"
if [ -f "$GTK3_CONF" ]; then
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$GTK_THEME/" "$GTK3_CONF"
    if [ "$TARGET_MODE" = "dark" ]; then
        sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=1/" "$GTK3_CONF"
    else
        sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=0/" "$GTK3_CONF"
    fi
fi

# 4. Смена обоев
if [ -f "$WALLPAPER" ]; then
    pkill swaybg 2>/dev/null
    swaybg -i "$WALLPAPER" -m fill >/dev/null 2>&1 &
fi

# 5. Надежный перезапуск swayosd-server
killall -9 swayosd-server 2>/dev/null
sleep 0.5

# Запуск сервера с валидными флагами
swayosd-server --top-margin 0.85 --style "$SWAYOSD_STYLE" >/dev/null 2>&1 &

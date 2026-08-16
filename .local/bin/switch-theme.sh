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
    echo "  $0 light       - Включить светлую (до перезагрузки)"
    echo "  $0 dark        - Включить тёмную (до перезагрузки)"
    echo "  $0 enable-auto - Вернуть автоматический режим"
    exit 1
fi

# 2. Настройка названий тем, обоев и палитры Waybar
WAYBAR_CONF="$HOME/.config/waybar"

if [ "$TARGET_MODE" = "light" ]; then
    GTK_THEME="Everforest-B-MB-Light"
    COLOR_SCHEME="prefer-light"
    WALLPAPER="/home/maendeleo/Pictures/wallpaper-light.jpeg"
    WAYBAR_COLOR="$WAYBAR_CONF/color-light.css"
elif [ "$TARGET_MODE" = "dark" ]; then
    GTK_THEME="Gruvbox-Green-Dark"
    COLOR_SCHEME="prefer-dark"
    WALLPAPER="/home/maendeleo/Pictures/wallpaper-dark.jpg"
    WAYBAR_COLOR="$WAYBAR_CONF/color-dark.css"
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

# 4. Обновление стилей GTK4 из системной директории (ОТКЛЮЧЕНО)
# THEME_DIR="/usr/share/themes/$GTK_THEME"
# SOURCE_DIR=""

# if [ -d "$THEME_DIR/gtk-4.0" ]; then
#     SOURCE_DIR="$THEME_DIR/gtk-4.0"
# elif [ -d "$THEME_DIR/gtk-3.0" ]; then
#     SOURCE_DIR="$THEME_DIR/gtk-3.0"
# fi

# if [ -n "$SOURCE_DIR" ]; then
#     rm -rf ~/.config/gtk-4.0
#     mkdir -p ~/.config/gtk-4.0
#     cp -rL "$SOURCE_DIR/"* ~/.config/gtk-4.0/ 2>/dev/null
# fi

# 5. Обновление палитры Waybar и его перезапуск
if [ -f "$WAYBAR_COLOR" ]; then
    cp "$WAYBAR_COLOR" "$WAYBAR_CONF/colors.css"
    pkill waybar
    nohup waybar >/dev/null 2>&1 &
fi

# 6. Смена обоев
if [ -f "$WALLPAPER" ]; then
    pkill swaybg
    nohup swaybg -i "$WALLPAPER" -m fill >/dev/null 2>&1 &
fi

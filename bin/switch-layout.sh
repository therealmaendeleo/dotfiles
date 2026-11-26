#!/usr/bin/env bash

# 1. Переключаем раскладку конкретно для клавиатуры ноутбука
hyprctl switchxkblayout at-translated-set-2-keyboard next > /dev/null 2>&1

# 2. Считываем активную раскладку именно для at-translated-set-2-keyboard
LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.name == "at-translated-set-2-keyboard") | .active_keymap' | head -n 1)

# 3. Форматируем вывод
case "$LAYOUT" in
    *Russian*|*ru*|*RU*)
        LANG_TEXT="Russian (RU)"
        ;;
    *English*|*us*|*US*)
        LANG_TEXT="English (US)"
        ;;
    *)
        LANG_TEXT="$LAYOUT"
        ;;
esac

# 4. Выводим центральный OSD виджет
swayosd-client --custom-icon "input-keyboard" --custom-progress 1.0 --custom-progress-text "$LANG_TEXT"

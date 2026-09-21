#!/usr/bin/env bash

BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)

if [ -n "$BAT_PATH" ]; then
    STATUS=$(cat "$BAT_PATH/status")
    CAPACITY=$(cat "$BAT_PATH/capacity")
    PROGRESS=$(awk "BEGIN {print $CAPACITY/100}")

    # Выбираем иконку в зависимости от статуса и уровня
    if [ "$STATUS" = "Charging" ]; then
        ICON="battery-charging"
        TEXT="Зарядка: ${CAPACITY}%"
    elif [ "$CAPACITY" -le 15 ]; then
        ICON="battery-caution"
        TEXT="Батарея: ${CAPACITY}%"
    elif [ "$CAPACITY" -le 30 ]; then
        ICON="battery-low"
        TEXT="Батарея: ${CAPACITY}%"
    else
        ICON="battery-good"
        TEXT="Батарея: ${CAPACITY}%"
    fi

    swayosd-client --custom-icon "$ICON" --custom-progress "$PROGRESS" --custom-progress-text "$TEXT"
fi

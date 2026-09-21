#!/usr/bin/env bash

CHECK_INTERVAL=60
WARNING_LEVEL=20
CRITICAL_LEVEL=10

NOTIFIED_WARNING=false
NOTIFIED_CRITICAL=false

while true; do
    BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)
    
    if [ -n "$BAT_PATH" ]; then
        STATUS=$(cat "$BAT_PATH/status")
        CAPACITY=$(cat "$BAT_PATH/capacity")

        if [ "$STATUS" = "Discharging" ]; then
            # Переводим 0-100% в формат 0.00-1.00 для swayosd
            PROGRESS=$(awk "BEGIN {print $CAPACITY/100}")

            # 1. Критический уровень (<= 10%)
            if [ "$CAPACITY" -le "$CRITICAL_LEVEL" ]; then
                if [ "$NOTIFIED_CRITICAL" = false ]; then
                    swayosd-client --custom-icon "battery-caution" --custom-progress "$PROGRESS" --custom-progress-text "Критический заряд: ${CAPACITY}%" 2>/dev/null || \
                    notify-send -u critical -i battery-caution "Критический заряд!" "Осталось ${CAPACITY}%. Подключите зарядное устройство."
                    NOTIFIED_CRITICAL=true
                fi
            # 2. Предупредительный уровень (<= 20%)
            elif [ "$CAPACITY" -le "$WARNING_LEVEL" ]; then
                if [ "$NOTIFIED_WARNING" = false ]; then
                    swayosd-client --custom-icon "battery-low" --custom-progress "$PROGRESS" --custom-progress-text "Низкий заряд: ${CAPACITY}%" 2>/dev/null || \
                    notify-send -u normal -i battery-low "Низкий заряд батареи" "Осталось ${CAPACITY}%."
                    NOTIFIED_WARNING=true
                fi
            fi
        else
            NOTIFIED_WARNING=false
            NOTIFIED_CRITICAL=false
        fi
    fi

    sleep "$CHECK_INTERVAL"
done

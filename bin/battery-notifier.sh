#!/usr/bin/env bash

CHECK_INTERVAL=60
ALERT_THRESHOLD=25
PREV_CAPACITY=-1

while true; do
    BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)
    
    if [ -n "$BAT_PATH" ]; then
        STATUS=$(cat "$BAT_PATH/status")
        CAPACITY=$(cat "$BAT_PATH/capacity")

        if [ "$STATUS" = "Discharging" ]; then
            # переводим 0-100% в формат 0.00-1.00 для swayosd
            PROGRESS=$(awk "BEGIN {print $CAPACITY/100}")

            if [ "$CAPACITY" -le "$ALERT_THRESHOLD" ] && [ "$CAPACITY" -lt "$PREV_CAPACITY" ]; then
                swayosd-client --custom-icon "battery-low" --custom-progress "$PROGRESS" --custom-progress-text "Заряд батареи: ${CAPACITY}%" 2>/dev/null
                canberra-gtk-play -i dialog-warning 2>/dev/null || printf '\a'
            fi

            PREV_CAPACITY="$CAPACITY"
        else
            PREV_CAPACITY=-1
        fi
    fi

    sleep "$CHECK_INTERVAL"
done

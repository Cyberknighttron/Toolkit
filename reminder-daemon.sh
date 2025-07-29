#!/bin/bash

REMINDER_FILE="$HOME/.local/share/toolkit/reminders.txt"

while true; do
    CURRENT_TIME=$(date +"%H:%M")
    if [[ -f "$REMINDER_FILE" ]]; then
        grep -F "$CURRENT_TIME" "$REMINDER_FILE" | while read -r line; do
            REMINDER_TIME=$(echo "$line" | awk '{print $1}')
            REMINDER_MSG=$(echo "$line" | cut -d' ' -f2-)
            notify-send "⏰ Reminder: $REMINDER_MSG"
            sed -i "/^$REMINDER_TIME $REMINDER_MSG$/d" "$REMINDER_FILE"
        done
    fi
    sleep 60
done


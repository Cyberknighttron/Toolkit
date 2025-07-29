#!/bin/bash

DB="./data/reminders.db"
mkdir -p "$(dirname "$DB")"
touch "$DB"

show_help() {
    echo "Usage:"
    echo "  remindme \"Reminder message\" in 10m"
    echo "  remindme \"Reminder message\" at 13:00"
    echo "  remindme \"Reminder message\" tomorrow at 09:00"
    echo "  remindme list"
    echo "  remindme cancel"
}

# Helper to decode time
parse_time() {
    if [[ "$1" == "in" ]]; then
        date -d "now + $2" "+%s"
    elif [[ "$1" == "at" ]]; then
        local target_time="$2"
        local now_hour=$(date +%H)
        local now_min=$(date +%M)
        local target_epoch=$(date -d "$target_time" +%s 2>/dev/null)

        if [[ $? -ne 0 ]]; then
            echo "Invalid time format. Use HH:MM (24h format)"
            exit 1
        fi

        # If time already passed today, set for tomorrow
        if [[ "$target_epoch" -le "$(date +%s)" ]]; then
            date -d "tomorrow $target_time" "+%s"
        else
            echo "$target_epoch"
        fi
    elif [[ "$1" == "tomorrow" && "$2" == "at" ]]; then
        date -d "tomorrow $3" "+%s"
    else
        echo "Invalid time syntax."
        exit 1
    fi
}

case "$1" in
    list)
        if [[ ! -s "$DB" ]]; then
            echo "📭 No reminders scheduled."
            exit 0
        fi

        echo "📅 Scheduled Reminders:"
        nl -w2 -s'. ' "$DB" | while read -r line; do
            timestamp=$(echo "$line" | cut -d '|' -f1 | awk '{print $2}')
            msg=$(echo "$line" | cut -d '|' -f2-)
            datetime=$(date -d "@$timestamp" "+%Y-%m-%d %H:%M")
            echo "⏰ $datetime — $msg"
        done
        ;;

    cancel)
        if [[ ! -s "$DB" ]]; then
            echo "❌ No reminders to cancel."
            exit 0
        fi

        echo "📋 Select a reminder to delete:"
        nl -w2 -s'. ' "$DB"
        read -rp "Enter number to delete: " num
        if [[ "$num" =~ ^[0-9]+$ ]]; then
            sed -i "${num}d" "$DB"
            echo "✅ Reminder #$num deleted."
        else
            echo "❌ Invalid selection."
        fi
        ;;

    *)
        if [[ -z "$1" || -z "$2" ]]; then
            show_help
            exit 1
        fi

        msg="$1"
        time_type="$2"
        time_value="$3"
        extra="$4"

        reminder_time=$(parse_time "$time_type" "$time_value" "$extra")
        [[ -z "$reminder_time" ]] && exit 1

        echo "${reminder_time}|${msg}" >> "$DB"
        echo "🔔 Reminder set for $(date -d "@$reminder_time" "+%Y-%m-%d %H:%M")"
        ;;
esac

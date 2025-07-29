#!/bin/bash

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SNIPPET_DB="${TOOLKIT_DIR}/data/snippets.db"

mkdir -p "$(dirname "$SNIPPET_DB")"
touch "$SNIPPET_DB"

print_usage() {
    echo "Usage:"
    echo "  toolkit snippet add <title> <language>"
    echo "  toolkit snippet list [language]"
    echo "  toolkit snippet view <title>"
    echo "  toolkit snippet delete <title>"
}

add_snippet() {
    local title="$1"
    local lang="$2"

    echo "Enter your snippet content (press CTRL+D to save):"
    content=$(</dev/stdin)
    encoded=$(echo "$content" | base64 -w 0)

    if grep -q "^${title}|" "$SNIPPET_DB"; then
        echo "❌ Snippet with this title already exists."
        exit 1
    fi

    echo "${title}|${lang}|${encoded}" >> "$SNIPPET_DB"
    echo "✅ Snippet '${title}' added."
}

list_snippets() {
    local filter_lang="$1"
    if [[ ! -s "$SNIPPET_DB" ]]; then
        echo "📭 No snippets found."
        return
    fi

    while IFS='|' read -r title lang _; do
        if [[ -z "$filter_lang" || "$filter_lang" == "$lang" ]]; then
            printf "🔹 %-20s [%s]\n" "$title" "$lang"
        fi
    done < "$SNIPPET_DB"
}

view_snippet() {
    local title="$1"
    local match
    match=$(grep "^${title}|" "$SNIPPET_DB")
    if [[ -z "$match" ]]; then
        echo "❌ Snippet not found: $title"
        return
    fi

    IFS='|' read -r _ lang encoded <<< "$match"
    echo "📄 Title: $title"
    echo "📚 Language: $lang"
    echo "-------------------------"
    echo "$encoded" | base64 -d
    echo
}

delete_snippet() {
    local title="$1"
    if grep -q "^${title}|" "$SNIPPET_DB"; then
        grep -v "^${title}|" "$SNIPPET_DB" > "${SNIPPET_DB}.tmp" && mv "${SNIPPET_DB}.tmp" "$SNIPPET_DB"
        echo "🗑️ Snippet '${title}' deleted."
    else
        echo "❌ Snippet not found."
    fi
}

case "$1" in
    add)
        [[ $# -ne 3 ]] && print_usage && exit 1
        add_snippet "$2" "$3"
        ;;
    list)
        list_snippets "$2"
        ;;
    view)
        [[ $# -ne 2 ]] && print_usage && exit 1
        view_snippet "$2"
        ;;
    delete)
        [[ $# -ne 2 ]] && print_usage && exit 1
        delete_snippet "$2"
        ;;
    *)
        print_usage
        ;;
esac

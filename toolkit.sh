#!/bin/bash

# Define paths
BASE_DIR="$(dirname "$(realpath "$0")")"
COMMANDS_DIR="$BASE_DIR/commands"
MODULES_DIR="$BASE_DIR/Modules"
UTILS_DIR="$BASE_DIR/utils"
DATA_DIR="$BASE_DIR/data"

# Main dispatcher
case "$1" in
  quickrun)
    shift
    bash "$COMMANDS_DIR/quickrun.sh" "$@"
    ;;

  remindme)
    shift
    bash "$COMMANDS_DIR/remindme.sh" "$@"
    ;;

  cleanup)
    shift
    bash "$COMMANDS_DIR/cleanup.sh" "$@"
    ;;

  snippet)
    shift
    bash "$COMMANDS_DIR/snippet.sh" "$@"
    ;;

  modmap)
    shift
    bash "$BASE_DIR/modmap.sh" "$@"
    ;;

  help|--help|-h)
    echo "📦 Toolkit CLI - Developer Utilities"
    echo
    echo "Usage: ./toolkit.sh <command> [options]"
    echo
    echo "Available commands:"
    echo "  quickrun <file>           - Run code files instantly"
    echo "  remindme <add|list|remove> - Add/list/remove reminders"
    echo "  cleanup                   - Clean temp/cache files"
    echo "  snippet                   - Manage code snippets"
    echo "  modmap <file>             - Show defined functions/packages"
    echo
    ;;

  *)
    echo "❌ Unknown command: $1"
    echo "Try './toolkit.sh help' for usage."
    exit 1
    ;;
esac

#!/bin/bash

set -e

TOOLKIT_DIR="$(pwd)"
TOOLKIT_BIN="/usr/local/bin/toolkit"
SERVICE_NAME="toolkit-reminder.service"
SYSTEMD_DIR="$HOME/.config/systemd/user"

# Required packages
PKGS=(at coreutils)

# Detect package manager
detect_package_manager() {
    if command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v apt &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    else
        echo "Unsupported package manager. Please install dependencies manually." >&2
        exit 1
    fi
}

# Install required packages
install_dependencies() {
    local manager
    manager=$(detect_package_manager)

    echo "[+] Installing dependencies using $manager..."

    case "$manager" in
        pacman)
            sudo pacman -Sy --noconfirm "${PKGS[@]}"
            ;;
        apt)
            sudo apt update
            sudo apt install -y "${PKGS[@]}"
            ;;
        dnf)
            sudo dnf install -y "${PKGS[@]}"
            ;;
    esac
}

# Create data and config dirs
setup_files_and_dirs() {
    echo "[+] Creating required directories..."

    mkdir -p "$TOOLKIT_DIR/data"
    mkdir -p "$TOOLKIT_DIR/themes"
    mkdir -p "$TOOLKIT_DIR/utils"

    touch "$TOOLKIT_DIR/data/reminders.db"
    touch "$TOOLKIT_DIR/data/snippets.db"
    touch "$TOOLKIT_DIR/data/modmaps.db"
    touch "$TOOLKIT_DIR/themes/default.theme"
    touch "$TOOLKIT_DIR/utils/logger.sh"
}

# Create symlink
setup_symlink() {
    if [[ -L "$TOOLKIT_BIN" ]]; then
        echo "[i] Removing old symlink..."
        sudo rm "$TOOLKIT_BIN"
    fi

    echo "[+] Linking toolkit.sh to /usr/local/bin/toolkit"
    sudo ln -s "$TOOLKIT_DIR/toolkit.sh" "$TOOLKIT_BIN"
    sudo chmod +x "$TOOLKIT_BIN"
}

# Setup systemd service
setup_reminder_service() {
    echo "[+] Setting up systemd reminder service..."

    mkdir -p "$SYSTEMD_DIR"

    cat > "$SYSTEMD_DIR/$SERVICE_NAME" <<EOF
[Unit]
Description=Toolkit Reminder Daemon
After=default.target

[Service]
ExecStart=$TOOLKIT_DIR/reminder-daemon.sh
Restart=on-failure

[Install]
WantedBy=default.target
EOF

    systemctl --user daemon-reexec
    systemctl --user daemon-reload
    systemctl --user enable --now "$SERVICE_NAME"
    echo "[✔] Reminder daemon enabled and running."
}

# MAIN
echo "🔧 Starting Toolkit Installation..."
install_dependencies
setup_files_and_dirs
setup_symlink
setup_reminder_service

echo "✅ Installation Complete! You can now use 'toolkit' globally."

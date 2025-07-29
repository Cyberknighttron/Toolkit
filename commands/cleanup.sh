#!/bin/bash

mode="$1"

detect_pkg_manager() {
  if command -v apt &>/dev/null; then
    echo "apt"
  elif command -v pacman &>/dev/null; then
    echo "pacman"
  else
    echo "unknown"
  fi
}

basic_cleanup() {
  echo "🧹 Cleaning user cache..."
  rm -rf ~/.cache/*
  rm -rf ~/.thumbnails/* 2>/dev/null
  echo "✅ Basic cleanup complete."
}

full_cleanup() {
  basic_cleanup
  pkg_mgr=$(detect_pkg_manager)

  echo "🔍 Detected package manager: $pkg_mgr"
  case "$pkg_mgr" in
    apt)
      echo "🗑 Removing apt cache and unused packages..."
      sudo apt autoremove -y
      sudo apt clean
      sudo journalctl --vacuum-time=7d
      ;;
    pacman)
      echo "🗑 Removing pacman cache and orphaned packages..."
      sudo pacman -Rns $(pacman -Qdtq) --noconfirm 2>/dev/null
      sudo pacman -Sc --noconfirm
      sudo journalctl --vacuum-time=7d
      ;;
    *)
      echo "❌ Unsupported package manager. Skipping system cleanup."
      ;;
  esac

  echo "✅ Full cleanup complete."
}

# Entry point
case "$mode" in
  basic)
    basic_cleanup
    ;;
  full)
    full_cleanup
    ;;
  *)
    echo "Usage: $0 {basic|full}"
    ;;
esac


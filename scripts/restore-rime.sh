#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: ./scripts/restore-rime.sh <backup_dir> [rime_dir]"
  exit 1
fi

BACKUP_DIR="$1"
RIME_DIR="${2:-${RIME_DIR:-}}"

if [[ -z "$RIME_DIR" ]]; then
  case "$(uname -s)" in
    Darwin) RIME_DIR="$HOME/Library/Rime" ;;
    Linux)
      if [[ -d "$HOME/.local/share/fcitx5/rime" ]]; then
        RIME_DIR="$HOME/.local/share/fcitx5/rime"
      else
        RIME_DIR="$HOME/.config/ibus/rime"
      fi
      ;;
    *) echo "Unsupported platform"; exit 1 ;;
  esac
fi

mkdir -p "$RIME_DIR"
cp -R "$BACKUP_DIR"/. "$RIME_DIR"/
echo "Backup restored from $BACKUP_DIR"

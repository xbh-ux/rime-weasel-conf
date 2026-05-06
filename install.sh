#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS_NAME="$(uname -s)"

case "$OS_NAME" in
  Darwin)
    RIME_DIR="${RIME_DIR:-$HOME/Library/Rime}"
    FRONTEND_FILE="squirrel.custom.yaml"
    ;;
  Linux)
    if [[ -d "$HOME/.local/share/fcitx5/rime" ]]; then
      RIME_DIR="${RIME_DIR:-$HOME/.local/share/fcitx5/rime}"
    else
      RIME_DIR="${RIME_DIR:-$HOME/.config/ibus/rime}"
    fi
    FRONTEND_FILE=""
    ;;
  *)
    echo "Unsupported platform: $OS_NAME"
    exit 1
    ;;
esac

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$RIME_DIR/backup-from-github-$STAMP"

copy_config_file() {
  local relative_path="$1"
  local source="$REPO_ROOT/$relative_path"
  local target="$RIME_DIR/$relative_path"

  if [[ ! -f "$source" ]]; then
    echo "Missing source file: $source" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$target")"
  if [[ -f "$target" ]]; then
    mkdir -p "$(dirname "$BACKUP_DIR/$relative_path")"
    cp "$target" "$BACKUP_DIR/$relative_path"
  fi
  cp "$source" "$target"
}

mkdir -p "$RIME_DIR" "$BACKUP_DIR"

copy_config_file "default.custom.yaml"
copy_config_file "rime_ice.custom.yaml"
copy_config_file "rime_ice.dict.yaml"
copy_config_file "custom_phrase.txt"

if [[ -n "$FRONTEND_FILE" ]]; then
  copy_config_file "$FRONTEND_FILE"
fi

for file in "$REPO_ROOT"/cn_dicts/*.dict.yaml; do
  copy_config_file "cn_dicts/$(basename "$file")"
done

echo "Installed Rime config to $RIME_DIR"
echo "Backup saved to $BACKUP_DIR"

"$REPO_ROOT/scripts/redeploy-rime.sh" "$RIME_DIR"

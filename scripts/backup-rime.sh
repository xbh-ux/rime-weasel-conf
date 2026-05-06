#!/usr/bin/env bash
set -euo pipefail

RIME_DIR="${1:-${RIME_DIR:-}}"
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

STAMP="$(date +%Y%m%d-%H%M%S)"
OUTPUT_DIR="$RIME_DIR/manual-backup-$STAMP"
mkdir -p "$OUTPUT_DIR"

for path in default.custom.yaml rime_ice.custom.yaml rime_ice.dict.yaml custom_phrase.txt squirrel.custom.yaml weasel.custom.yaml cn_dicts user.yaml build; do
  if [[ -e "$RIME_DIR/$path" ]]; then
    mkdir -p "$OUTPUT_DIR/$(dirname "$path")"
    cp -R "$RIME_DIR/$path" "$OUTPUT_DIR/$path"
  fi
done

find "$RIME_DIR" -maxdepth 1 -type d -name "*.userdb" -exec cp -R {} "$OUTPUT_DIR/" \;
echo "Backup created at $OUTPUT_DIR"

#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-dark}"
if [[ "$MODE" != "dark" && "$MODE" != "light" ]]; then
  echo "Usage: ./scripts/switch-theme.sh [dark|light]"
  exit 1
fi

RIME_DIR="${RIME_DIR:-$HOME/Library/Rime}"
case "$(uname -s)" in
  Darwin)
    CONFIG_FILE="$RIME_DIR/squirrel.custom.yaml"
    TARGET_KEY="purity_of_form_custom"
    ;;
  Linux)
    echo "Theme switching script currently targets macOS Squirrel front-end only."
    exit 0
    ;;
  *)
    echo "Unsupported platform"
    exit 1
    ;;
esac

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Theme config not found: $CONFIG_FILE"
  exit 1
fi

if [[ "$MODE" == "dark" ]]; then
  sed -i.bak 's/"style\/color_scheme":.*/"style\/color_scheme": '"$TARGET_KEY"'/' "$CONFIG_FILE"
  sed -i.bak 's/"style\/color_scheme_dark":.*/"style\/color_scheme_dark": '"$TARGET_KEY"'/' "$CONFIG_FILE"
else
  sed -i.bak 's/"style\/color_scheme":.*/"style\/color_scheme": '"$TARGET_KEY"'/' "$CONFIG_FILE"
  sed -i.bak 's/"style\/color_scheme_dark":.*/"style\/color_scheme_dark": '"$TARGET_KEY"'/' "$CONFIG_FILE"
fi

rm -f "$CONFIG_FILE.bak"
echo "Switched Squirrel theme mode to $MODE"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/redeploy-rime.sh" "$RIME_DIR"

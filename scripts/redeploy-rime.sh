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
    *)
      echo "Unsupported platform"
      exit 1
      ;;
  esac
fi

assert_file() {
  local path="$1"
  if [[ ! -e "$path" ]]; then
    echo "Required file not found: $path" >&2
    exit 1
  fi
}

assert_file "$RIME_DIR"
assert_file "$RIME_DIR/rime_ice.custom.yaml"
assert_file "$RIME_DIR/rime_ice.dict.yaml"
assert_file "$RIME_DIR/custom_phrase.txt"
assert_file "$RIME_DIR/cn_dicts/mydict.dict.yaml"

if [[ "$(uname -s)" == "Darwin" ]]; then
  DEPLOY_CMD="/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel"
  if [[ -x "$DEPLOY_CMD" ]]; then
    "$DEPLOY_CMD" --reload || true
  fi
elif command -v fcitx5-remote >/dev/null 2>&1; then
  fcitx5-remote -r || true
elif command -v ibus restart >/dev/null 2>&1; then
  ibus restart || true
fi

SCHEMA="$RIME_DIR/build/rime_ice.schema.yaml"
assert_file "$SCHEMA"

if grep -q 'language: "wanxiang-lts-zh-hans"\|language: wanxiang-lts-zh-hans' "$SCHEMA"; then
  echo "[OK] wanxiang grammar"
else
  echo "[FAIL] wanxiang grammar"
  exit 1
fi

grep -q "contextual_suggestions: true" "$SCHEMA" && echo "[OK] context suggestions" || { echo "[FAIL] context suggestions"; exit 1; }
grep -q "enable_user_dict: true" "$SCHEMA" && grep -q "enable_encoder: true" "$SCHEMA" && echo "[OK] user learning" || { echo "[FAIL] user learning"; exit 1; }
grep -q "encode_commit_history: true" "$SCHEMA" && echo "[OK] commit history learning" || { echo "[FAIL] commit history learning"; exit 1; }
grep -q "cn_dicts/mydict" "$RIME_DIR/rime_ice.dict.yaml" && echo "[OK] personal dict entry" || { echo "[FAIL] personal dict entry"; exit 1; }

echo "Schema: $SCHEMA"
echo "Rime deploy checks passed."

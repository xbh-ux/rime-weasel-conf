#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_FILE="${1:-$REPO_ROOT/custom_phrase.txt}"
PHRASE_DIR="$REPO_ROOT/phrases"

if [[ ! -d "$PHRASE_DIR" ]]; then
  echo "Phrase directory not found: $PHRASE_DIR" >&2
  exit 1
fi

> "$OUTPUT_FILE"
for file in "$PHRASE_DIR"/*.txt; do
  cat "$file" >> "$OUTPUT_FILE"
  printf '\n' >> "$OUTPUT_FILE"
done

echo "Generated custom phrases: $OUTPUT_FILE"

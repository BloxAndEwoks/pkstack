#!/usr/bin/env bash
# Verify every wire registered in PATCHES.md still hits its file.
# A vendor merge can be textually clean and still drop a patch; this is the alarm.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 2
PATCHES="PATCHES.md"
[ -f "$PATCHES" ] || { echo "wire-check: $PATCHES not found" >&2; exit 2; }

fail=0
checked=0
in_comment=0
id=""
file=""

while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    *'<!--'*) in_comment=1 ;;
  esac
  case "$line" in
    *'-->'*) in_comment=0; continue ;;
  esac
  [ "$in_comment" -eq 1 ] && continue

  case "$line" in
    '### '*)
      rest="${line#\#\#\# }"
      case "$rest" in
        *' — '*)
          id="${rest%% — *}"
          file="${rest#* — }"
          file="${file//\`/}"
          ;;
        *) id=""; file="" ;;
      esac
      ;;
    'grep: '*)
      [ -n "$file" ] || continue
      pat="${line#grep: }"
      checked=$((checked + 1))
      if [ ! -f "$file" ]; then
        printf 'FAIL  %-28s %s  (file missing)\n' "$id" "$file"
        fail=1
      elif grep -qF -- "$pat" "$file"; then
        printf 'PASS  %-28s %s\n' "$id" "$file"
      else
        printf 'FAIL  %-28s %s  (not found: %s)\n' "$id" "$file" "$pat"
        fail=1
      fi
      id=""
      file=""
      ;;
  esac
done < "$PATCHES"

echo "---"
if [ "$checked" -eq 0 ]; then
  echo "wire-check: no wires registered"
  exit 0
fi
if [ "$fail" -ne 0 ]; then
  echo "wire-check: $checked wires checked, at least one DEAD"
else
  echo "wire-check: $checked wires checked, all live"
fi
exit "$fail"

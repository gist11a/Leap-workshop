#!/usr/bin/env bash
# Rebuilds dashboard/data.js from the Shopee HQ folder and deletes data older than 30 days.
# Usage: bash refresh-dashboard.sh "<full path to Shopee HQ>"
# Works on Mac (bash 3.2) and on Windows Git Bash. Needs no extra software.

HQ="${1:-.}"
KEEP_DAYS=30
OUT="$HQ/dashboard/data.js"
TMP="$OUT.tmp"

# --- 1. Keep 30 days: delete day files older than the cutoff (by the date in the file name) ---
CUTOFF=$(date -v-"$KEEP_DAYS"d +%Y-%m-%d 2>/dev/null || date -d "$KEEP_DAYS days ago" +%Y-%m-%d)
if [ -d "$HQ/data" ]; then
  for f in "$HQ"/data/*/*.json; do
    [ -e "$f" ] || continue
    name=$(basename "$f" .json)
    case "$name" in
      [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])
        if [[ "$name" < "$CUTOFF" ]]; then rm -f "$f"; fi ;;
    esac
  done
fi

# --- 2. Build data.js ---
emit_file() {  # prints the file's JSON, or null if missing/empty
  if [ -s "$1" ]; then cat "$1"; else printf 'null'; fi
}

mkdir -p "$HQ/dashboard"
{
  printf 'window.SHOP_HQ = {\n'
  printf '"generated": "%s",\n' "$(date '+%Y-%m-%d %H:%M')"
  printf '"keep_days": %s,\n' "$KEEP_DAYS"

  printf '"rules": {'
  first=1
  for f in "$HQ"/rules/*.json; do
    [ -e "$f" ] || continue
    [ $first -eq 1 ] || printf ','
    first=0
    printf '\n"%s": ' "$(basename "$f" .json)"
    emit_file "$f"
  done
  printf '\n},\n'

  printf '"automations": '; emit_file "$HQ/automations.json"; printf ',\n'
  printf '"approvals": ';   emit_file "$HQ/approvals.json";   printf ',\n'
  printf '"alerts": ';      emit_file "$HQ/alerts.json";      printf ',\n'
  printf '"layout": ';      emit_file "$HQ/dashboard/layout.json"; printf ',\n'

  printf '"data": {'
  tfirst=1
  for d in "$HQ"/data/*/; do
    [ -d "$d" ] || continue
    topic=$(basename "$d")
    [ $tfirst -eq 1 ] || printf ','
    tfirst=0
    printf '\n"%s": {' "$topic"
    dfirst=1
    for f in "$d"*.json; do
      [ -e "$f" ] || continue
      [ $dfirst -eq 1 ] || printf ','
      dfirst=0
      printf '\n"%s": ' "$(basename "$f" .json)"
      emit_file "$f"
    done
    printf '\n}'
  done
  printf '\n}\n};\n'
} > "$TMP" && mv "$TMP" "$OUT"

echo "Dashboard refreshed ($(date '+%H:%M')). Data kept from $CUTOFF."

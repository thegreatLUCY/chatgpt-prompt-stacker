#!/usr/bin/env bash
# Render the real panel through tools/harness.html in headless Chrome and
# auto-crop each shot to the panel. Usage: tools/shoot.sh
set -euo pipefail
cd "$(dirname "$0")/.."
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
HARNESS="file://$PWD/tools/harness.html"
OUT="screenshots"
TMP="$(mktemp -d)"

shot() { # name  querystring  windowsize
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --force-device-scale-factor=2 --window-size="$3" \
    --screenshot="$TMP/$1.png" "$HARNESS?$2" >/dev/null 2>&1
  python3 tools/crop.py "$TMP/$1.png" "$OUT/$1.png"
  echo "  ✓ $OUT/$1.png"
}

# ChatGPT green, running, options open
shot queue-dark  "theme=dark&action=1&platform=ChatGPT&accent=%2319c37d"  "760,900"
# Claude clay, light
shot queue-light "theme=light&action=1&platform=Claude&accent=%23d97757"  "760,900"
# Gemini blue-violet, library
shot library-dark "theme=dark&tab=library&platform=Gemini&accent=%234b8bf5&dot=linear-gradient(135deg%2C%234b8bf5%2C%239168f0)" "760,760"
# Collapsed pill
shot pill-dark   "theme=dark&collapsed=1&platform=ChatGPT&accent=%2319c37d" "760,420"

rm -rf "$TMP"

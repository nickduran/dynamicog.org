#!/usr/bin/env bash
# Headless-Chrome screenshots of the home page at three widths, plus a no-webfonts run.
# Usage: bash test/dynamicog/screenshots.sh <outdir>   (BASE=http://host:port to override)
set -eu
OUT="${1:?outdir required}"; BASE="${BASE:-http://localhost:4000}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
FLAGS=(--headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=6000)
mkdir -p "$OUT"
# Caveat: headless Chrome enforces a minimum window width (~500px), so the 375 capture is
# CROPPED to 375px of a wider layout, not a true mobile render. Treat it as a smoke test only.
# The authoritative narrow-viewport check is a same-origin 375px iframe measured with JS
# (scrollWidth == clientWidth, no element right edge past the viewport); see the plan's Task 6.
for w in 375 768 1280; do
  "$CHROME" "${FLAGS[@]}" --window-size="$w,2200" --screenshot="$OUT/home-$w.png" "$BASE/" >/dev/null 2>&1
done
"$CHROME" "${FLAGS[@]}" --window-size=1280,2200 \
  --host-rules="MAP fonts.googleapis.com 127.0.0.1,MAP fonts.gstatic.com 127.0.0.1" \
  --screenshot="$OUT/home-1280-nofonts.png" "$BASE/" >/dev/null 2>&1
ls -la "$OUT"

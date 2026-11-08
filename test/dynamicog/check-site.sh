#!/usr/bin/env bash
# DynamiCog site checks: curl the local Jekyll preview and assert on served HTML/CSS.
# Usage: bash test/dynamicog/check-site.sh   (BASE=http://host:port to override)
set -u
BASE="${BASE:-http://localhost:4000}"
PASS=0; FAIL=0

fetch() { curl -s "$1"; }

assert_status() { # url code
  local got; got=$(curl -s -o /dev/null -w '%{http_code}' "$1")
  if [ "$got" = "$2" ]; then PASS=$((PASS+1)); echo "ok   status $2 $1"
  else FAIL=$((FAIL+1)); echo "FAIL status $1 (want $2, got $got)"; fi
}

assert_contains() { # name url pattern(grep -E)
  if fetch "$2" | tr '\n' ' ' | grep -Eq -- "$3"; then PASS=$((PASS+1)); echo "ok   $1"
  else FAIL=$((FAIL+1)); echo "FAIL $1"; fi
}

assert_count() { # name url pattern expected
  local got; got=$(fetch "$2" | grep -Eo -- "$3" | wc -l | tr -d ' ')
  if [ "$got" = "$4" ]; then PASS=$((PASS+1)); echo "ok   $1 ($got)"
  else FAIL=$((FAIL+1)); echo "FAIL $1 (want $4, got $got)"; fi
}

# ---- Task 1: fonts, tokens, ground -----------------------------------------
assert_status   "$BASE/" 200
assert_contains "fonts: Fraunces+Inter in head" "$BASE/" 'fonts\.googleapis\.com/css2\?family=Fraunces.*Inter'
assert_count    "no pinned footer"              "$BASE/" 'footer class="fixed-bottom"' 0
assert_contains "css: dc tokens defined"        "$BASE/assets/css/main.css" '--dc-ground:\s*#f6f1e7'
assert_contains "css: dark ground"              "$BASE/assets/css/main.css" 'html\[data-theme="?dark"?\].*--dc-ground:\s*#121212'
assert_contains "css: theme color is gold-deep" "$BASE/assets/css/main.css" '--global-theme-color:\s*var\(--dc-gold-deep\)'
assert_contains "css: body font Inter"          "$BASE/assets/css/main.css" 'html body\s*\{\s*font-family:\s*Inter'
assert_contains "css: brand font Fraunces"      "$BASE/assets/css/main.css" '\.navbar-brand\.title\s*\{\s*font-family:\s*Fraunces'

# ---- Task 2: footer ---------------------------------------------------------
assert_contains "footer: dc-footer present"   "$BASE/" '<footer class="dc-footer"'
assert_contains "footer: UT lockup"           "$BASE/" 'dc-footer__lockup[^>]*ut_psychology_logo\.png'
assert_contains "footer: credit line"         "$BASE/" 'Nick D\. Duran · DynamiCog Lab · Built with'
assert_count    "footer: no Jekyll/GitHub Pages credit" "$BASE/" 'Powered by' 0
assert_contains "footer: also on publications" "$BASE/publications/" '<footer class="dc-footer"'
assert_contains "dark: lockup inverted"       "$BASE/assets/css/main.css" 'html\[data-theme="?dark"?\] \.dc-footer__lockup\s*\{[^}]*invert'

echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]

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

# ---- Task 3: hero -----------------------------------------------------------
assert_contains "hero: eyebrow name"        "$BASE/" 'dc-hero__eyebrow[^<]*DynamiCog Lab'
assert_contains "hero: eyebrow aCDC"        "$BASE/" 'dc-hero__eyebrow-sub[^<]*\(applied\) Cognitive Dynamics and Communication'
assert_contains "hero: headline accent"     "$BASE/" '<em class="dc-hero__accent">as it happens\.</em>'
assert_contains "hero: methods line"        "$BASE/" 'dc-hero__methods[^<]*Movement tracking · Conversation analysis · Language models · Dynamical systems'
assert_contains "hero: scholar link"        "$BASE/" 'href="https://scholar\.google\.com/citations\?user=dU26pfIAAAAJ"'
assert_contains "hero: github link"         "$BASE/" 'href="https://github\.com/nickduran"'
assert_contains "hero: orcid link"          "$BASE/" 'href="https://orcid\.org/0000-0002-8872-5617"'
assert_contains "hero: email link"          "$BASE/" 'href="mailto:nicholas\.duran@utexas\.edu"'
assert_count    "hero: no RSS icon"         "$BASE/" 'fa-(square-)?rss' 0
assert_count    "home: gem social block gone" "$BASE/" 'class="contact-icons"' 0
assert_contains "hero: recruiting line"     "$BASE/" 'dc-hero__recruiting.*href="/get-involved/"'
assert_contains "hero: photo"               "$BASE/" 'dc-hero__photo.*prof_pic'
assert_count    "home: old banner gone"     "$BASE/" 'dynamicog-hero' 0
assert_count    "home: old prose gone"      "$BASE/" 'biggish data' 0
assert_count    "home: lockup not in body"  "$BASE/" 'class="ut-logo"' 0

echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]

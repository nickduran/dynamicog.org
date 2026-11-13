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

assert_cmd() { # name command expected-stdout
  local got; got=$(bash -c "$2" 2>/dev/null | tr -d '[:space:]')
  if [ "$got" = "$3" ]; then PASS=$((PASS+1)); echo "ok   $1 ($got)"
  else FAIL=$((FAIL+1)); echo "FAIL $1 (want $3, got $got)"; fi
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
assert_contains "footer: credit line"         "$BASE/" 'Nick D\. Duran · DynamiCog Lab'
assert_count    "footer: no Jekyll/GitHub Pages credit" "$BASE/" 'Powered by' 0
assert_contains "footer: also on publications" "$BASE/publications/" '<footer class="dc-footer"'
assert_contains "dark: lockup inverted"       "$BASE/assets/css/main.css" 'html\[data-theme="?dark"?\] \.dc-footer__lockup\s*\{[^}]*invert'

# ---- Task 3: hero -----------------------------------------------------------
assert_contains "hero: eyebrow name"        "$BASE/" 'dc-hero__eyebrow[^<]*DynamiCog Lab'
assert_contains "hero: eyebrow aCDC"        "$BASE/" 'dc-hero__eyebrow-sub[^<]*\(applied\) Cognitive Dynamics and Communication'
assert_contains "hero: headline accent"     "$BASE/" '<em class="dc-hero__accent">as it happens\.</em>'
assert_contains "hero: methods line"        "$BASE/" 'dc-hero__methods.*Movement tracking</span>.* · .*Conversation analysis</span>.* · .*Language models</span>.* · .*Dynamical systems</span>'
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

# ---- Task 4: theme rows -----------------------------------------------------
assert_count    "themes: four rows"               "$BASE/" '<article class="dc-theme"' 4
assert_contains "themes: titles in order"         "$BASE/" 'Communication and coordination.*Natural behavior in the wild.*Computation for behavior.*People and machines, adapting'
assert_count    "themes: no placeholders (all four have art)" "$BASE/" 'dc-tile--placeholder' 0
assert_contains "themes: chip links to project"   "$BASE/" 'class="dc-chip" href="/projects/cps-coordination/"[^>]*>Coordination in Collaborative Problem Solving<'
assert_count    "themes: patient-provider appears twice" "$BASE/" 'href="/projects/patient-provider-llm/"' 2
assert_count    "themes: no unresolved slugs"     "$BASE/" 'theme-row: unresolved project slug' 0
assert_count    "themes: 13 chips total"          "$BASE/" 'class="dc-chip"' 13

# ---- Task 5: dark mode (Ink) ------------------------------------------------

# ---- Task 7: regression on other pages --------------------------------------
for pg in /projects/ /people/ /publications/ /teaching/ /get-involved/; do assert_status "$BASE$pg" 200; done
for sl in action-dynamics-deception cps-coordination discourse-analysis dynamic-psycholinguistics language-deception linguistic-concordance multimodal-coordination patient-provider-llm perspective-taking robot-coadaptation semantic-models suspicion-911; do assert_status "$BASE/projects/$sl/" 200; done
assert_count    "publications: 63 entries"      "$BASE/publications/" 'class="row"' 63
assert_contains "projects: /projects/ redirects home to #research" "$BASE/projects/" 'http-equiv="refresh"[^>]*url=/#research'
assert_count    "nav: research link absent"      "$BASE/" 'nav-link[^>]*href="/projects/"' 0

# ---- Review fixes (2026-11-08 whole-branch review) ---------------------------
assert_contains "css: gold-deep meets AA on cream (#7f6611)" "$BASE/assets/css/main.css" '--dc-gold-deep:\s*#7f6611'
assert_count    "hero: four nowrap method spans"  "$BASE/" '<span class="dc-hero__method">' 4
assert_contains "css: method spans nowrap"        "$BASE/assets/css/main.css" '\.dc-hero__method\s*\{[^}]*white-space:\s*nowrap'
assert_contains "css: headline accent nowrap"     "$BASE/assets/css/main.css" '\.dc-hero__accent\s*\{[^}]*white-space:\s*nowrap'

# ---- Retire research tab, chip arrows, first real tile (2026-11-08) ---------
assert_contains "themes: section anchored as #research" "$BASE/" '<section class="dc-themes" id="research"'
assert_contains "css: chips carry an arrow"       "$BASE/assets/css/main.css" '\.dc-chip::after\s*\{[^}]*content:\s*"[^"]*↗'
assert_contains "themes: coordination tile is the real drawing" "$BASE/" 'id="theme-coordination".*themes/coordination'
assert_count    "themes: a 1800x1200 source exists" "$BASE/assets/img/themes/coordination.png" 'PNG' 1
assert_count    "themes: coordination has no placeholder" "$BASE/" 'id="theme-coordination"[^☃]{0,200}[^☃]{0,200}dc-tile--placeholder' 0

assert_contains "themes: in-the-wild tile is the real drawing" "$BASE/" 'id="theme-in-the-wild".*themes/in-the-wild'
assert_count    "themes: in-the-wild source exists" "$BASE/assets/img/themes/in-the-wild.png" 'PNG' 1

assert_contains "themes: computation tile is the real drawing" "$BASE/" 'id="theme-computation".*themes/computation'
assert_count    "themes: computation source exists" "$BASE/assets/img/themes/computation.png" 'PNG' 1
assert_contains "themes: people-and-machines tile is the real drawing" "$BASE/" 'id="theme-people-and-machines".*themes/people-and-machines'
assert_count    "themes: people-and-machines source exists" "$BASE/assets/img/themes/people-and-machines.png" 'PNG' 1

# ---- Launch blocker: al-folio demo content gone (2026-11-08) ----------------
for u in cv books repositories blog; do assert_status "$BASE/$u/" 404; done
assert_status   "$BASE/assets/rendercv/rendercv_output/Albert_Einstein_CV.pdf" 404
assert_count    "sitemap: no demo pages" "$BASE/sitemap.xml" '/(cv|books|repositories|blog)/' 0
assert_count    "feed: no al-folio branding" "$BASE/feed.xml" 'whitespace theme for academics' 0

# ---- People, teaching, get involved (2026-11-08) ----------------------------
assert_contains "people: lab manager listed" "$BASE/people/" 'Farhana Anisha'
assert_count    "people: Natalie Liu removed" "$BASE/people/" 'Natalie Liu' 0
assert_contains "teaching: FDS I" "$BASE/teaching/" 'PSY 371E'
assert_contains "teaching: FDS II" "$BASE/teaching/" 'PSY 371F'
assert_count    "teaching: no placeholder" "$BASE/teaching/" 'To be added' 0
assert_contains "teaching: ASU block is the small archive" "$BASE/teaching/" 'class="teaching-archive"'
assert_contains "get-involved: names the NBC area" "$BASE/get-involved/" 'Natural Behavior and Computation'

# ---- Launch prep (2026-11-12) ------------------------------------------------
assert_contains "redirect: /papers/ -> /publications/"        "$BASE/papers/"         'http-equiv="refresh" content="0; url=/publications/"'
assert_contains "redirect: /get-involved-2/ -> /get-involved/" "$BASE/get-involved-2/" 'http-equiv="refresh" content="0; url=/get-involved/"'
assert_contains "og: preview image meta"  "$BASE/" 'property="og:image" content="https://dynamicog.org/assets/img/og-image.jpg"'
assert_status   "$BASE/assets/img/og-image.jpg" 200
assert_count    "no brain banner anywhere in css (removed 2026-11-13)" "$BASE/assets/css/main.css" 'banner_brain' 0
assert_status   "$BASE/assets/img/banner_brain.png" 404
assert_contains "dark: band carries the flowing-lines banner" "$BASE/assets/css/main.css" 'html\[data-theme="?dark"?\] \.dc-hero__band::before\s*\{[^}]*banner_lines\.jpg'
assert_status   "$BASE/assets/img/banner_lines.jpg" 200
assert_count    "light: no banner on the light hero" "$BASE/assets/css/main.css" '(^|\})\.dc-hero__band::before' 0
assert_contains "favicon: monogram png"   "$BASE/" 'rel="shortcut icon" href="/assets/img/favicon\.png'
assert_count    "footer: no al-folio credit" "$BASE/" 'Built with' 0

# ---- People / publications / teaching polish (2026-11-13) ---------------------
assert_count    "people: three gold section breaks" "$BASE/people/" 'class="section-break"' 3
assert_count    "people: RA grid has no placeholders" "$BASE/people/" 'people-grid--ra">[^<]*<div class="person-card">[^<]*<div class="person-photo--placeholder' 0
assert_count    "teaching: gold break before ASU courses" "$BASE/teaching/" 'class="section-break"' 1
assert_count    "publications: no empty thumbnail column" "$BASE/publications/" 'col col-sm-2 abbr' 0
assert_contains "publications: entries full width" "$BASE/publications/" 'class="col-12"'

assert_contains "navbar: shortcut hint hidden, icon kept" "$BASE/assets/css/main.css" '#search-toggle \.nav-link\s*\{\s*font-size:\s*0'

echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]

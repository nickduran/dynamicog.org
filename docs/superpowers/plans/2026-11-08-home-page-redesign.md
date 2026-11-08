# Home Page Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn dynamicog.org's home page into a themed research statement (hero + four theme rows) in the "Paper" look, with "Ink" in dark mode, without touching the rest of the site's content.

**Architecture:** al-folio gem theme customized by same-path overrides. One rewritten layout (`_layouts/about.liquid`), one new include (`_includes/theme-row.liquid`) driven by one new data file (`_data/themes.yml`), one footer override, and additions to the existing `assets/css/main.scss`. All copy lives in front matter or data, never in templates. Verification is a bash script that curls the Docker preview and asserts on the served HTML and CSS, plus headless-Chrome screenshots for layout.

**Tech Stack:** Jekyll 4 via al_folio_core 1.0.11 gem, Liquid, SCSS, Docker preview at `http://localhost:4000` (LiveReload; `_config.yml` edits need `docker compose restart jekyll`), headless Google Chrome for screenshots, ImageMagick 7 inside the container.

**Spec:** `docs/superpowers/specs/2026-11-08-home-page-redesign-design.md`

## Global Constraints

- Repo is `~/dev/dynamicog.org`, branch `main`, no remote. Work directly on `main`; a worktree cannot be served by the Docker bind mount of the repo root.
- Never fork the gem. Only same-path override files under `_layouts/`, `_includes/`, `assets/css/main.scss`, plus `_data/` and `_pages/`.
- Do not modify: `_projects/`, `_pages/projects.md`, `_includes/projects.liquid`, `_bibliography/`, `_pages/people.md`, `_data/people.yml`, `publications/`.
- Tokens, light: ground `#f6f1e7`, ink `#1c1c1c`, muted `#444`, rule `#d9d0bd`, gold `#c9a227`, gold-deep `#8a6f12`, tile paper `#efe8d8`, chip bg `#fff`, chip border `#d9d0bd`.
- Tokens, dark: ground `#121212`, ink `#f3ede0`, muted `#cfc8b8`, rule `#2c2c2c`, gold `#e2b73a`, gold-deep `#e2b73a`, tile paper `#efe8d8`, chip bg `#1e1e1e`, chip border `#3a3a3a`.
- Link text color (al-folio `--global-theme-color`) is gold-deep in light, `#e2b73a` in dark. Bright gold `#c9a227` is for rules, numerals, headshot ring, headline accent only.
- Fonts: `Fraunces` (600, 800, opsz axis) for display, `Inter` (400, 500, 700) for text, site-wide, from Google Fonts. Fallbacks `Georgia, serif` and `system-ui, -apple-system, "Segoe UI", sans-serif`.
- Dark-mode hook is `html[data-theme="dark"]` (the gem's toggle sets it).
- No horizontal scroll at 375, 768, 1280 px widths, both modes.
- Theme blurbs: two or three sentences each, hard cap. Four themes.
- Every CSS class added by this work is prefixed `dc-`.
- Commit after each task with a short conventional message; include the plan and spec in the first commit.

## Review Focus

1. A `_data/themes.yml` entry whose `projects:` list names a slug with no matching `_projects/` file must not render an empty or broken chip; it must emit `<!-- theme-row: unresolved project slug "x" -->` so the check script catches it. (Task 4)
2. Google Fonts blocked or offline: the page must fall back to `Georgia, serif` / system sans with no layout collapse; the hero headline must still fit two lines at 1280 px. (Task 1 fallback stacks; Task 6 screenshot with `--host-rules="MAP fonts.googleapis.com 127.0.0.1"`)
3. `recruiting.enabled: false` in `_pages/about.md` must remove the recruiting line entirely, leaving no empty paragraph. (Task 3)
4. A theme with `image:` set to a real file must render through `figure.liquid` at 3:2 with `object-fit: cover`, while the other three keep the placeholder; a non-3:2 test image must not distort. (Task 4)
5. Pages other than home must still render on the cream ground with the new fonts: the 63-entry publications list, its PDF/GitHub/OSF buttons, the people cards, and all twelve project pages return 200 and have legible links in both modes. (Task 7)

---

### Task 1: Check script, fonts, tokens, site-wide ground

**Files:**
- Create: `test/dynamicog/check-site.sh`
- Modify: `_config.yml:536-538` (google_fonts url), `_config.yml:88` (`footer_fixed`)
- Modify: `assets/css/main.scss` (append tokens block after the `@use` imports, before "DynamiCog Lab custom overrides")
- Modify: `.gitignore` (already has `.superpowers/`; confirm, no change expected)

**Interfaces:**
- Produces: `bash test/dynamicog/check-site.sh` exits 0 and prints `N passed, 0 failed`; later tasks append `check_*` calls to it. Functions: `assert_status <url> <code>`, `assert_contains <name> <url> <grep -E pattern>`, `assert_count <name> <url> <pattern> <expected-count>`.
- Produces CSS custom properties `--dc-ground`, `--dc-ink`, `--dc-muted`, `--dc-rule`, `--dc-gold`, `--dc-gold-deep`, `--dc-tile-paper`, `--dc-chip-bg`, `--dc-chip-border` on `:root` and `html[data-theme="dark"]`; `--global-bg-color`, `--global-text-color`, `--global-theme-color`, `--global-hover-color`, `--global-divider-color` remapped to them.

- [ ] **Step 1: Write the check script with the first assertions (they will fail)**

`test/dynamicog/check-site.sh`, bash, `set -u`, `BASE="${BASE:-http://localhost:4000}"`, a `PASS`/`FAIL` counter, the three assert functions (each curls with `-s`, greps with `-E`, prints `ok <name>` or `FAIL <name>`), and these calls:

```bash
assert_status   "$BASE/" 200
assert_contains "fonts: Fraunces+Inter in head" "$BASE/" 'fonts\.googleapis\.com/css2\?family=Fraunces.*Inter'
assert_count    "no pinned footer"              "$BASE/" 'footer class="fixed-bottom"' 0
assert_contains "css: dc tokens defined"        "$BASE/assets/css/main.css" '--dc-ground:#f6f1e7'
assert_contains "css: dark ground"              "$BASE/assets/css/main.css" 'html\[data-theme=dark\].*--dc-ground:#121212'
assert_contains "css: theme color is gold-deep" "$BASE/assets/css/main.css" '--global-theme-color:var\(--dc-gold-deep\)'
assert_contains "css: body font Inter"          "$BASE/assets/css/main.css" 'html body\{font-family:Inter'
assert_contains "css: brand font Fraunces"      "$BASE/assets/css/main.css" '\.navbar-brand\.title\{font-family:Fraunces'
echo "$PASS passed, $FAIL failed"; [ "$FAIL" -eq 0 ]
```

Note: Jekyll serves compiled SCSS at `/assets/css/main.css`, minified in this setup (no spaces around `:`; selectors like `html[data-theme=dark]` lose their quotes). If the first run shows the CSS is not minified, adjust the patterns to allow optional whitespace (`\s*`) rather than changing the build.

- [ ] **Step 2: Run it to verify it fails**

Run: `cd ~/dev/dynamicog.org && docker compose up -d && bash test/dynamicog/check-site.sh`
Expected: `1 passed, 7 failed` (only the 200 passes).

- [ ] **Step 3: Edit `_config.yml`**

Line 538, replace the fonts URL with:
`"https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,800&family=Inter:wght@400;500;700&family=Material+Icons&display=swap"`
Line 88: `footer_fixed: false`.

- [ ] **Step 4: Append the token block to `assets/css/main.scss`**

Insert directly after the last `@use` line and before the "DynamiCog Lab custom overrides" banner:

```scss
/* DynamiCog tokens (spec §9). Light = Paper, dark = Ink. */
:root {
  --dc-ground: #f6f1e7; --dc-ink: #1c1c1c; --dc-muted: #444; --dc-rule: #d9d0bd;
  --dc-gold: #c9a227; --dc-gold-deep: #8a6f12; --dc-tile-paper: #efe8d8;
  --dc-chip-bg: #fff; --dc-chip-border: #d9d0bd;
  --global-bg-color: var(--dc-ground); --global-text-color: var(--dc-ink);
  --global-theme-color: var(--dc-gold-deep); --global-hover-color: var(--dc-gold-deep);
  --global-divider-color: var(--dc-rule); --global-card-bg-color: #fff;
}
html[data-theme="dark"] {
  --dc-ground: #121212; --dc-ink: #f3ede0; --dc-muted: #cfc8b8; --dc-rule: #2c2c2c;
  --dc-gold: #e2b73a; --dc-gold-deep: #e2b73a; --dc-tile-paper: #efe8d8;
  --dc-chip-bg: #1e1e1e; --dc-chip-border: #3a3a3a;
  --global-bg-color: var(--dc-ground); --global-text-color: var(--dc-ink);
  --global-theme-color: var(--dc-gold-deep); --global-hover-color: var(--dc-gold-deep);
  --global-divider-color: var(--dc-rule); --global-card-bg-color: #1e1e1e;
}
html body { font-family: Inter, system-ui, -apple-system, "Segoe UI", sans-serif; font-weight: 400; }
.navbar-brand.title { font-family: Fraunces, Georgia, serif; font-weight: 800; }
```

`html body` outranks the gem's compiled `body{font-family:Roboto}` in `tailwind.css` regardless of load order.

- [ ] **Step 5: Restart and verify**

Run: `docker compose restart jekyll && until curl -s -o /dev/null -w '%{http_code}' $BASE/ | grep -q 200; do sleep 3; done; bash test/dynamicog/check-site.sh`
Expected: `8 passed, 0 failed`. Also `docker compose logs --tail=40 jekyll` shows no Sass or Liquid errors.

- [ ] **Step 6: Commit**

```bash
git add test/dynamicog/check-site.sh _config.yml assets/css/main.scss .gitignore docs/superpowers/
git commit -m "feat(home): site-wide Paper/Ink tokens, Fraunces+Inter, in-flow footer flag; add check script"
```

---

### Task 2: Footer override with the UT lockup

**Files:**
- Create: `_includes/footer.liquid` (override of the gem's 30-line include)
- Modify: `_config.yml:14-17` (`footer_text`)
- Modify: `assets/css/main.scss` (append `.dc-footer*` rules; remove the `.ut-logo` rule if one exists in the file)
- Modify: `test/dynamicog/check-site.sh`

**Interfaces:**
- Produces: `<footer class="dc-footer" role="contentinfo">` containing `<img class="dc-footer__lockup" src=".../assets/img/ut_psychology_logo.png">` and `<span class="dc-footer__text">© 2026 Nick D. Duran · DynamiCog Lab · Built with <a href="https://github.com/alshedivat/al-folio">al-folio</a></span>`.

- [ ] **Step 1: Add assertions**

```bash
assert_contains "footer: dc-footer present"   "$BASE/" '<footer class="dc-footer"'
assert_contains "footer: UT lockup"           "$BASE/" 'dc-footer__lockup[^>]*ut_psychology_logo\.png'
assert_contains "footer: credit line"         "$BASE/" 'Nick D\. Duran · DynamiCog Lab · Built with'
assert_count    "footer: no Jekyll/GitHub Pages credit" "$BASE/" 'Powered by' 0
assert_contains "footer: also on publications" "$BASE/publications/" '<footer class="dc-footer"'
assert_contains "dark: lockup inverted"       "$BASE/assets/css/main.css" 'html\[data-theme=dark\] \.dc-footer__lockup\{[^}]*invert'
```

- [ ] **Step 2: Run, expect 5 new failures**

Run: `bash test/dynamicog/check-site.sh` Expected: `8 passed, 6 failed`.

- [ ] **Step 3: Write `_includes/footer.liquid`**

Render the structure in Interfaces. Year from `{{ site.time | date: '%Y' }}`. Lockup path via `relative_url`. The text comes from `site.footer_text` so `_config.yml` stays the single source of the credit wording. Keep the gem's `{% if site.newsletter.enabled %}` branch out; the site does not use it.

- [ ] **Step 4: Rewrite `footer_text` in `_config.yml`**

```yaml
footer_text: >
  Nick D. Duran · DynamiCog Lab · Built with <a href="https://github.com/alshedivat/al-folio">al-folio</a>
```

The include prepends `© {{ year }} `.

- [ ] **Step 5: Append footer CSS to `main.scss`**

`.dc-footer`: `border-top: 2px solid var(--dc-gold); margin-top: 3rem; padding: 1.4rem 0 1.6rem; font-size: 12px; color: var(--dc-muted);` inner `.container` as flex, `justify-content: space-between; align-items: center;`. `.dc-footer__lockup { height: 34px; width: auto; }`. Dark: `html[data-theme="dark"] .dc-footer__lockup { filter: brightness(0) invert(1); opacity: .85; }`. Below 576px stack vertically with `gap: .6rem`. Remove any `.ut-logo` body-placement rule from `main.scss` (the lockup leaves the body in Task 3).

- [ ] **Step 6: Restart (config changed), verify**

Run: `docker compose restart jekyll` then wait for 200, then `bash test/dynamicog/check-site.sh`
Expected: `14 passed, 0 failed`.

- [ ] **Step 7: Commit**

```bash
git add _includes/footer.liquid _config.yml assets/css/main.scss test/dynamicog/check-site.sh
git commit -m "feat(footer): in-flow footer with UT lockup and short credit"
```

---

### Task 3: Hero block (eyebrow, headline, lede, methods, links, recruiting, photo)

**Files:**
- Modify: `_pages/about.md` (front matter rewritten; body prose removed)
- Modify: `_layouts/about.liquid` (rewrite; replaces the banner and the gem's profile/float structure)
- Modify: `assets/css/main.scss` (remove the `.dynamicog-hero*` block and its `@media`; keep `html, body { overflow-x: hidden }`; append `.dc-hero*` rules)
- Modify: `test/dynamicog/check-site.sh`

**Interfaces:**
- Consumes: `_data/socials.yml` keys `email`, `scholar_userid`, `github_username`, `orcid_id`.
- Produces: front-matter keys on `_pages/about.md`: `eyebrow`, `eyebrow_sub`, `headline` (may contain `<br>`), `headline_accent`, `lede`, `methods` (list of strings), `recruiting: {enabled, text, link, link_text}`, `director: [lines]`, `profile.image`. Markup: `<section class="dc-hero">` with children `.dc-hero__band` (eyebrow + h1), `.dc-hero__body` (lede, methods, links, recruiting), `.dc-hero__photo`. Task 4 inserts `<section class="dc-themes">` after it; Task 5 styles `.dc-hero__band` for dark mode.

- [ ] **Step 1: Add assertions**

```bash
assert_contains "hero: eyebrow name"        "$BASE/" 'dc-hero__eyebrow[^<]*DynamiCog Lab'
assert_contains "hero: eyebrow aCDC"        "$BASE/" 'dc-hero__eyebrow-sub[^<]*\(applied\) Cognitive Dynamics and Communication'
assert_contains "hero: headline accent"     "$BASE/" '<em class="dc-hero__accent">as it happens\.</em>'
assert_contains "hero: methods line"        "$BASE/" 'dc-hero__methods[^<]*Movement tracking · Conversation analysis · Language models · Dynamical systems'
assert_contains "hero: scholar link"        "$BASE/" 'href="https://scholar\.google\.com/citations\?user=dU26pfIAAAAJ"'
assert_contains "hero: github link"         "$BASE/" 'href="https://github\.com/nickduran"'
assert_contains "hero: orcid link"          "$BASE/" 'href="https://orcid\.org/0000-0002-8872-5617"'
assert_contains "hero: email link"          "$BASE/" 'href="mailto:nicholas\.duran@utexas\.edu"'
assert_count    "hero: no RSS in link row"  "$BASE/" 'dc-hero__links.*feed\.xml' 0
assert_contains "hero: recruiting line"     "$BASE/" 'dc-hero__recruiting.*href="/get-involved/"'
assert_contains "hero: photo"               "$BASE/" 'dc-hero__photo.*prof_pic'
assert_count    "home: old banner gone"     "$BASE/" 'dynamicog-hero' 0
assert_count    "home: old prose gone"      "$BASE/" 'biggish data' 0
assert_count    "home: lockup not in body"  "$BASE/" 'class="ut-logo"' 0
```

- [ ] **Step 2: Run, expect 14 new failures**

Run: `bash test/dynamicog/check-site.sh` Expected: `14 passed, 14 failed`.

- [ ] **Step 3: Rewrite `_pages/about.md` front matter; delete the body**

```yaml
---
layout: about
title: home
permalink: /
eyebrow: DynamiCog Lab
eyebrow_sub: (applied) Cognitive Dynamics and Communication
headline: "Natural behavior,<br>measured"
headline_accent: "as it happens."
lede: >
  We study how people communicate and coordinate, in the body, in language, and
  between each other, using the recordings, text, and movement data that real
  interaction leaves behind, and the computational tools to make sense of it.
methods: [Movement tracking, Conversation analysis, Language models, Dynamical systems]
recruiting:
  enabled: true
  text: Recruiting undergraduate research assistants and PhD students.
  link: /get-involved/
  link_text: See Get Involved.
profile:
  image: prof_pic.jpg
director:
  - Nick Duran, Director
  - Department of Psychology
  - The University of Texas at Austin
news: false
selected_papers: false
social: false
---
```

No body content. The removed paragraphs stay in git history only.

- [ ] **Step 4: Rewrite `_layouts/about.liquid`**

`layout: default`. Render `<section class="dc-hero">` per Interfaces. Details the markup must satisfy:
- Eyebrow: `<p class="dc-hero__eyebrow">{{ page.eyebrow }}<span class="dc-hero__eyebrow-sep">·</span><span class="dc-hero__eyebrow-sub">{{ page.eyebrow_sub }}</span></p>`, the sep and sub only when `page.eyebrow_sub` is set.
- Headline: `<h1 class="dc-hero__headline">{{ page.headline }} <em class="dc-hero__accent">{{ page.headline_accent }}</em></h1>`.
- Methods: `<p class="dc-hero__methods">{{ page.methods | join: " · " }}</p>`.
- Links: `<ul class="dc-hero__links">` with four `<li><a href=...><svg …/>Label</a></li>`, hand-written from `site.data.socials` (the gem's `{% social_links %}` tag emits icon-only anchors plus RSS, so it is not used). URLs: `mailto:{{ site.data.socials.email }}`, `https://scholar.google.com/citations?user={{ site.data.socials.scholar_userid }}`, `https://github.com/{{ site.data.socials.github_username }}`, `https://orcid.org/{{ site.data.socials.orcid_id }}`. Icons: reuse the gem's Font Awesome/Academicons classes already loaded (`fa-solid fa-envelope`, `ai ai-google-scholar`, `fa-brands fa-github`, `ai ai-orcid`) rather than inline SVG.
- Recruiting: wrapped in `{% if page.recruiting and page.recruiting.enabled %}` so disabling removes the element entirely.
- Photo: `{% include figure.liquid path="assets/img/prof_pic.jpg" class="dc-hero__img" alt="Nick Duran" loading="eager" %}` inside `.dc-hero__photo`, followed by `<p class="dc-hero__director">` with `page.director` joined by `<br>`.
- After the hero, `{{ content }}` (empty now; harmless), then a placeholder comment `<!-- dc-themes -->` where Task 4 inserts the themes section.
- Drop the gem's news/latest-posts/selected-papers/social/newsletter blocks; the page's flags are all false and the spec removes them.

- [ ] **Step 5: Replace the hero CSS in `main.scss`**

Delete the `.dynamicog-hero`, `::before`, `-inner`, `-title`, `-subtitle` rules and their `@media` block. Append `.dc-hero*`:
- `.dc-hero`: CSS grid, `grid-template-columns: 1fr 200px; grid-template-areas: "band photo" "body photo"; column-gap: 40px; align-items: center; padding: 44px 0 10px;`
- `.dc-hero__band { grid-area: band }`, `.dc-hero__body { grid-area: body }`, `.dc-hero__photo { grid-area: photo; text-align: center }`.
- Eyebrow: `font-size: 12px; letter-spacing: .14em; text-transform: uppercase; font-weight: 600; color: var(--dc-gold-deep); margin: 0 0 14px;` sep `margin: 0 8px; color: var(--dc-gold)`; sub `font-weight: 400; letter-spacing: .06em; text-transform: none; font-size: 13px;`.
- Headline: `font-family: Fraunces, Georgia, serif; font-weight: 800; font-size: clamp(2.2rem, 5vw, 3.4rem); line-height: 1.02; letter-spacing: -.01em; margin: 0;` accent `font-style: normal; color: var(--dc-gold)` (light) and `#e2b73a` via token in dark.
- Lede `font-size: 17px; line-height: 1.5; max-width: 620px; margin: 18px 0 10px;`. Methods `font-size: 12.5px; letter-spacing: .08em; text-transform: uppercase; color: var(--dc-gold-deep); margin: 0 0 16px;`.
- Links: `list-style: none; padding: 0; display: flex; flex-wrap: wrap; gap: 18px; font-size: 12.5px; font-weight: 500;` anchors `color: var(--dc-ink)`, icons `color: var(--dc-gold); margin-right: 6px`.
- Recruiting `font-size: 13.5px; color: var(--dc-muted); margin: 14px 0 0;` link `color: var(--dc-gold-deep); text-decoration: underline; text-underline-offset: 3px;`.
- Photo img: `width: 200px; height: 200px; border-radius: 50%; object-fit: cover; border: 4px solid #fff; box-shadow: 0 0 0 2px var(--dc-gold);`. Director `font-size: 12px; color: var(--dc-muted); line-height: 1.4; margin-top: 10px;`.
- `@media (max-width: 767px)`: `.dc-hero { grid-template-columns: 1fr; grid-template-areas: "photo" "band" "body"; }` photo img 140px.

- [ ] **Step 6: Verify (no restart needed)**

Run: `bash test/dynamicog/check-site.sh` Expected: `28 passed, 0 failed`.
Then: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu --hide-scrollbars --window-size=1280,900 --virtual-time-budget=6000 --screenshot=/tmp/dc-hero-1280.png http://localhost:4000/` and view it. Expected: eyebrow, two-line headline with gold accent, lede, methods, four links, recruiting line, circular photo with gold ring on the right; no banner.

- [ ] **Step 7: Commit**

```bash
git add _pages/about.md _layouts/about.liquid assets/css/main.scss test/dynamicog/check-site.sh
git commit -m "feat(home): hero block with eyebrow, headline, methods, links, recruiting, photo"
```

---

### Task 4: Theme rows from data, with placeholder tiles and project chips

**Files:**
- Create: `_data/themes.yml`
- Create: `_includes/theme-row.liquid`
- Modify: `_layouts/about.liquid` (replace `<!-- dc-themes -->` with the section loop)
- Modify: `assets/css/main.scss` (append `.dc-themes`, `.dc-theme*`, `.dc-tile*`, `.dc-chip`)
- Modify: `test/dynamicog/check-site.sh`

**Interfaces:**
- Consumes: `site.projects` documents; each project's `url` is `/projects/<slug>/` and has `card_title` (fallback `title`).
- Produces: `_data/themes.yml` schema per entry: `slug`, `number` (string "01"), `title`, `blurb`, `image` (filename in `assets/img/themes/` or empty), `projects` (list of `_projects` slugs). Markup per row: `<article class="dc-theme" id="theme-<slug>">` containing `.dc-tile` (placeholder div or `img.dc-tile__img`), `.dc-theme__num`, `h2.dc-theme__title`, `p.dc-theme__blurb`, `ul.dc-theme__projects > li > a.dc-chip`.

- [ ] **Step 1: Add assertions**

```bash
assert_count    "themes: four rows"               "$BASE/" '<article class="dc-theme"' 4
assert_contains "themes: titles in order"         "$BASE/" 'Communication and coordination.*Natural behavior in the wild.*Computation for behavior.*People and machines, adapting'
assert_count    "themes: four placeholders"       "$BASE/" 'dc-tile--placeholder' 4
assert_contains "themes: chip links to project"   "$BASE/" 'class="dc-chip" href="/projects/cps-coordination/"[^>]*>Coordination in Collaborative Problem Solving<'
assert_count    "themes: patient-provider appears twice" "$BASE/" 'href="/projects/patient-provider-llm/"' 2
assert_count    "themes: no unresolved slugs"     "$BASE/" 'theme-row: unresolved project slug' 0
assert_count    "themes: 13 chips total"          "$BASE/" 'class="dc-chip"' 13
```

(13 = 4 + 4 + 3 + 2 chips per the spec table.)

- [ ] **Step 2: Run, expect 7 new failures**

Run: `bash test/dynamicog/check-site.sh` Expected: `28 passed, 7 failed`.

- [ ] **Step 3: Write `_data/themes.yml`**

Four entries in this order with these exact `slug`/`number`/`title`/`projects` values; blurbs copied verbatim from the mockup `.superpowers/brainstorm/14927-1794158400/content/06-look-and-feel.html` (treatment 1, the four `.theme p` paragraphs); `image: ""` on all four.

| slug | number | title | projects |
|---|---|---|---|
| coordination | "01" | Communication and coordination | cps-coordination, multimodal-coordination, linguistic-concordance, perspective-taking |
| in-the-wild | "02" | Natural behavior in the wild | suspicion-911, patient-provider-llm, action-dynamics-deception, language-deception |
| computation | "03" | Computation for behavior | semantic-models, dynamic-psycholinguistics, discourse-analysis |
| people-and-machines | "04" | People and machines, adapting | robot-coadaptation, patient-provider-llm |

- [ ] **Step 4: Write `_includes/theme-row.liquid`**

Takes `include.theme`. Tile branch:
```liquid
{% if include.theme.image and include.theme.image != "" %}
  {% assign tile_path = include.theme.image | prepend: "assets/img/themes/" %}
  {% include figure.liquid path=tile_path class="dc-tile__img" sizes="300px" alt=include.theme.title loading="lazy" %}
{% else %}
  <div class="dc-tile dc-tile--placeholder" aria-hidden="true"></div>
{% endif %}
```
Chip resolution, per slug: `{% assign proj_url = "/projects/" | append: slug | append: "/" %}` then `{% assign proj = site.projects | where: "url", proj_url | first %}`. If `proj` is nil, emit `<!-- theme-row: unresolved project slug "{{ slug }}" -->`; else `<li><a class="dc-chip" href="{{ proj.url | relative_url }}">{{ proj.card_title | default: proj.title }}</a></li>`.

- [ ] **Step 5: Wire into `_layouts/about.liquid`**

Replace `<!-- dc-themes -->` with `<section class="dc-themes">{% for theme in site.data.themes %}{% include theme-row.liquid theme=theme %}{% endfor %}</section>`.

- [ ] **Step 6: Append theme CSS to `main.scss`**

- `.dc-themes { margin-top: 34px; }`
- `.dc-theme`: grid `grid-template-columns: 300px 1fr; column-gap: 34px; padding: 30px 0; border-top: 1px solid var(--dc-rule); align-items: start;`
- `.dc-tile, .dc-tile__img { width: 100%; aspect-ratio: 3 / 2; display: block; }` `.dc-tile__img { object-fit: cover; }`
- Placeholder: `.dc-tile--placeholder { position: relative; overflow: hidden; background: var(--dc-tile-paper); border: 1px solid var(--dc-rule); }` with `::before` (`width: 18%; height: 62%; left: 36%; top: 18%; transform: rotate(-8deg)`) and `::after` (`width: 40%; height: 14%; left: 28%; top: 60%; transform: rotate(14deg)`), both `position: absolute; background: #1c1c1c; box-shadow: 0 0 12px 4px rgba(0,0,0,.28);`.
- `.dc-theme__num { font-family: Fraunces, Georgia, serif; font-weight: 600; font-size: 13px; letter-spacing: .1em; color: var(--dc-gold); margin-bottom: 8px; }`
- `.dc-theme__title { font-family: Fraunces, Georgia, serif; font-weight: 800; font-size: 28px; line-height: 1.1; margin: 0 0 10px; }`
- `.dc-theme__blurb { font-size: 15.5px; line-height: 1.55; max-width: 600px; margin: 0 0 12px; }`
- `.dc-theme__projects { list-style: none; padding: 0; margin: 0; display: flex; flex-wrap: wrap; gap: 8px; }` `.dc-chip { font-size: 12px; padding: 5px 10px; border-radius: 3px; background: var(--dc-chip-bg); border: 1px solid var(--dc-chip-border); color: var(--dc-gold-deep); text-decoration: none; }` hover: border color `var(--dc-gold)`.
- `@media (max-width: 767px) { .dc-theme { grid-template-columns: 1fr; row-gap: 14px; } }`

- [ ] **Step 7: Verify, including the two Review Focus cases**

Run: `bash test/dynamicog/check-site.sh` Expected: `35 passed, 0 failed`.
Then temporarily add a bogus slug `not-a-project` to theme 03 in `themes.yml`, wait for rebuild, run `curl -s $BASE/ | grep -c 'unresolved project slug "not-a-project"'` Expected: `1`. Revert.
Then create `assets/img/themes/` and copy a non-3:2 test image: `docker exec dynamicogorg-jekyll-1 magick /srv/jekyll/assets/img/projects/cps-coordination.jpg -resize 900x900! /srv/jekyll/assets/img/themes/test-square.jpg`; set theme 01 `image: test-square.jpg`; screenshot at 1280 and confirm tile 01 is a 3:2 crop with no distortion and tiles 02–04 remain placeholders; `curl -s $BASE/ | grep -c dc-tile--placeholder` Expected: `3`. Revert `image: ""` and delete the test image (keep the empty `assets/img/themes/.gitkeep`).

- [ ] **Step 8: Commit**

```bash
git add _data/themes.yml _includes/theme-row.liquid _layouts/about.liquid assets/css/main.scss assets/img/themes/.gitkeep test/dynamicog/check-site.sh
git commit -m "feat(home): four theme rows from _data/themes.yml with placeholder tiles and project chips"
```

---

### Task 5: Dark mode (Ink): banner band and inverted lockup

**Files:**
- Modify: `assets/css/main.scss` (append `html[data-theme="dark"] .dc-hero*` rules)
- Modify: `test/dynamicog/check-site.sh`

**Interfaces:**
- Consumes: `.dc-hero` grid areas from Task 3.
- Produces: in dark mode `.dc-hero__band` becomes a full-bleed band with `banner_brain.png` behind the eyebrow and headline; `.dc-hero__body` and `.dc-hero__photo` sit beneath it.

- [ ] **Step 1: Add assertions**

```bash
assert_contains "dark: band has banner image" "$BASE/assets/css/main.css" 'html\[data-theme=dark\] \.dc-hero__band\{[^}]*banner_brain\.png'
assert_contains "dark: hero areas reflow"     "$BASE/assets/css/main.css" 'html\[data-theme=dark\] \.dc-hero\{[^}]*grid-template-areas:"band band"'
```

- [ ] **Step 2: Run, expect 2 new failures**

Run: `bash test/dynamicog/check-site.sh` Expected: `35 passed, 2 failed`.

- [ ] **Step 3: Append dark-mode hero CSS**

```scss
html[data-theme="dark"] .dc-hero {
  grid-template-areas: "band band" "body photo"; column-gap: 40px; padding-top: 0;
}
html[data-theme="dark"] .dc-hero__band {
  margin-left: calc(50% - 50vw); margin-right: calc(50% - 50vw); padding: 150px 20px 30px;
  background: linear-gradient(90deg, rgba(18,18,18,.92) 0%, rgba(18,18,18,.55) 55%, rgba(18,18,18,.2) 100%),
              url("{{ '/assets/img/banner_brain.png' | relative_url }}") center 40% / cover no-repeat;
}
html[data-theme="dark"] .dc-hero__band > * { max-width: var(--global-max-width, 930px); margin-left: auto; margin-right: auto; }
html[data-theme="dark"] .dc-hero__body { padding-top: 28px; }
html[data-theme="dark"] .dc-hero__photo { padding-top: 28px; }
html[data-theme="dark"] .dc-hero__img { border-color: #121212; }
```

`main.scss` has front matter, so the Liquid `relative_url` filter resolves at build time. The existing `html, body { overflow-x: hidden }` rule covers the full-bleed band's scrollbar gap.

- [ ] **Step 4: Verify**

Run: `bash test/dynamicog/check-site.sh` Expected: `37 passed, 0 failed`.
Then visually: open `http://localhost:4000/` in Chrome (the Claude-in-Chrome tools are acceptable), click the gem's theme toggle in the navbar to dark, screenshot at 1280 wide. Expected: near-black ground, banner band behind the headline with legible cream type, body and photo beneath, cream tiles brightest on the page, inverted UT lockup in the footer. Toggle back to light and confirm the band is gone.

- [ ] **Step 5: Commit**

```bash
git add assets/css/main.scss test/dynamicog/check-site.sh
git commit -m "feat(home): Ink dark mode with banner band"
```

---

### Task 6: Responsive and font-fallback checks

**Files:**
- Create: `test/dynamicog/screenshots.sh`
- Modify: `assets/css/main.scss` only if a check fails

**Interfaces:**
- Produces: `bash test/dynamicog/screenshots.sh <outdir>` writes `home-375.png`, `home-768.png`, `home-1280.png`, `home-1280-nofonts.png` via headless Chrome.

- [ ] **Step 1: Write `test/dynamicog/screenshots.sh`**

Loop over widths 375, 768, 1280 with `--window-size=<w>,2200 --virtual-time-budget=6000 --screenshot=<outdir>/home-<w>.png http://localhost:4000/`. Fourth run at 1280 adds `--host-rules="MAP fonts.googleapis.com 127.0.0.1,MAP fonts.gstatic.com 127.0.0.1"` and writes `home-1280-nofonts.png`. Chrome binary: `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`, flags `--headless=new --disable-gpu --hide-scrollbars`.

- [ ] **Step 2: Run it and inspect all four images**

Run: `bash test/dynamicog/screenshots.sh /tmp/dc-shots && ls /tmp/dc-shots`
Expected, by inspection: at 375 the photo is above the hero text, theme rows stack tile-over-text, nothing is clipped at the right edge; at 768 the hero is still two-column or has cleanly collapsed; at 1280 matches the mockup's proportions; `nofonts` renders in Georgia and system sans with the headline still on two lines and the layout intact.

- [ ] **Step 3: Horizontal-scroll check**

Run in the browser console (Claude-in-Chrome `javascript_tool`) at a 375 px viewport, light and dark: `document.documentElement.scrollWidth - document.documentElement.clientWidth` Expected: `0` both times.

- [ ] **Step 4: Fix anything the inspection found, re-run Steps 2–3, then commit**

```bash
git add test/dynamicog/screenshots.sh assets/css/main.scss
git commit -m "test(home): responsive and font-fallback screenshot script"
```

---

### Task 7: Regression pass on other pages, overrides audit, handoff update

**Files:**
- Modify: `test/dynamicog/check-site.sh`
- Create/Modify: `.al-folio-overrides.yml` (generated)
- Modify: `SESSION-HANDOFF.md` (repo) and copy to `Box/LAB-LOGISTICS/Website-Redesign/SESSION-HANDOFF.md`
- Modify: `assets/css/main.scss` only if a page fights the ground

**Interfaces:**
- Consumes: everything above.

- [ ] **Step 1: Add assertions**

```bash
for p in /projects/ /people/ /publications/ /teaching/ /get-involved/; do assert_status "$BASE$p" 200; done
for s in action-dynamics-deception cps-coordination discourse-analysis dynamic-psycholinguistics language-deception linguistic-concordance multimodal-coordination patient-provider-llm perspective-taking robot-coadaptation semantic-models suspicion-911; do assert_status "$BASE/projects/$s/" 200; done
assert_count    "publications: 63 entries"      "$BASE/publications/" 'class="row"' 63
assert_contains "projects: grant grid intact"   "$BASE/projects/" 'Grant-Funded Projects.*Other Ongoing Projects.*Previous Projects'
assert_contains "nav: research link present"    "$BASE/" 'href="/projects/"[^>]*>\s*research'
```

If the publications-count selector is wrong for the bib layout, pick the per-entry element from `_layouts/bib.liquid` and keep the expected count 63.

- [ ] **Step 2: Run** Expected: all pass. Fix any 404 or count mismatch before continuing.

- [ ] **Step 3: Visual pass on the other pages, both modes**

Screenshot `/publications/`, `/people/`, `/projects/` at 1280 in light (headless) and dark (browser toggle). Expected: cream/near-black ground, Inter body, legible gold-deep links, PDF/GitHub/OSF buttons readable, project cards white on cream. If a component fights the ground (e.g., a hard-coded white card edge), fix it in `main.scss` with a `dc-` scoped rule rather than reverting the ground.

- [ ] **Step 4: Overrides audit**

Run: `docker exec -w /srv/jekyll dynamicogorg-jekyll-1 bundle exec al-folio upgrade overrides audit`
Expected: a generated `.al-folio-overrides.yml` listing exactly: `_layouts/bib.liquid`, `_layouts/about.liquid`, `_includes/projects.liquid`, `_includes/footer.liquid`, `_includes/theme-row.liquid`, `assets/css/main.scss`, `_pages/projects.md` (plus any the tool classifies that already existed). No unexpected entries.

- [ ] **Step 5: Update `SESSION-HANDOFF.md`**

In the repo copy: bump "Last updated" to today; in §2 replace the stale "session-3 work is uncommitted" paragraph with the current `git log --oneline | head -8`; in §3 add a "Home page (2026-11-08)" block pointing at the spec and this plan and listing the new files; in §5 add the decisions from spec §13; in §4A add "Theme drawings: four tiles are CSS placeholders; art direction in Box `Website-Redesign/Art-Direction/`". Then `cp SESSION-HANDOFF.md "/Users/ndd697/Library/CloudStorage/Box-Box/LAB-LOGISTICS/Website-Redesign/SESSION-HANDOFF.md"`.

- [ ] **Step 6: Final run and commit**

Run: `bash test/dynamicog/check-site.sh && docker compose logs --tail=60 jekyll | grep -iE "error|warn" ; git status --short`
Expected: all checks pass, no new errors or Liquid warnings in the log, and `git status` shows only the files below.

```bash
git add test/dynamicog/check-site.sh .al-folio-overrides.yml SESSION-HANDOFF.md assets/css/main.scss
git commit -m "chore(home): regression checks, overrides audit, handoff update"
```

# DynamiCog site — session handoff & task list

**Last updated 2026-11-08 (end of session 4: home-page redesign).** Goal: finish the al-folio site and
launch `dynamicog.org` on GitHub Pages. Nothing is live yet — the old WordPress site is
still up. This file is the single "fire right up" doc: current state, what's left, and how
to deploy. Background (optional): `MIGRATION-PLAN.md`, `dynamicog-site/README.md`.

**To resume:** start Docker, `cd ~/dev/dynamicog.org && docker compose up -d`, open
http://localhost:4000/, then work the **Task list (§4)** below.

---

## 0. Where everything lives

- **Working repo (all edits happen here):** `~/dev/dynamicog.org` — full git clone of
  al-folio with the scaffold merged in. On branch `main`. **Outside Box.**
- **This handoff exists in two synced places:** `~/dev/dynamicog.org/SESSION-HANDOFF.md`
  (canonical, in-repo but excluded from the build) and a copy at
  `Box/LAB-LOGISTICS/Website-Redesign/SESSION-HANDOFF.md` (backup for when the repo isn't handy).
- **Branding assets (headshots, logos, banner):** `Box/LAB-LOGISTICS/Branding/COLA_Psychology_logos/`
  (`headshots/`, `otherbanners/brain-scan.png`, `COLA_Psychology_logos_formal|primary/4_RGB/`).
- **Publication PDFs (source of truth):** `Box/research-hub/publications/` (index in its `CLAUDE.md`).
- **WordPress export (legacy text/images):** `Box/LAB-LOGISTICS/dynamicoglab.WordPress.2026-07-17.xml`.
- **Live old site (reachable, good for pulling legacy images):** https://dynamicog.org

## 1. How to preview locally

Toolchain: **Docker** (system Ruby 2.6 is too old to run al-folio directly).
```bash
cd ~/dev/dynamicog.org
open -a Docker                    # wait until `docker info` works
docker compose up -d              # serves http://localhost:4000  (container serves 8080; remapped)
docker compose logs --tail=40 jekyll   # check for build errors
docker compose restart jekyll     # REQUIRED after any _config.yml change
docker compose down               # stop when done
```
- Port 4000 via `docker-compose.override.yml` (git-ignored). LiveReload auto-refreshes.
- `_pages`, `_layouts`, `assets`, `_data`, `_bibliography` edits: picked up by the watcher.
- `_config.yml` edits: **restart required**.
- Chrome disk-caches `main.css`/pages aggressively during preview — if a CSS change doesn't
  show, hard-reload or append a throwaway query (`/?v=2`).

## 2. Current git state

Branch `main`, tracking **`origin` = `https://github.com/nickduran/dynamicog.org` (private, created
2026-11-08)**. The al-folio template remote is now `upstream`. First off-machine backup exists.

**History was rewritten once, 2026-11-08, before the first push.** The repo had been a shallow
clone (al-folio at depth 1 plus Nick's commits), which GitHub refuses to accept. Rather than pull
~370 MB of upstream history, the imported al-folio snapshot ("Update Google Scholar citations") was
grafted into a true root, so the repo is self-contained (13 commits, ~49 MB). Every hash changed;
older notes citing `349e5be`, `c759159`, `26aa0a9`, etc. refer to this same history under its old
hashes. A pre-rewrite bundle is at `~/dev/dynamicog.org-pre-graft-2026-11-08.bundle`.

```
21ebac8 fix(home): review fixes — AA-contrast gold-deep, nowrap methods/accent, trimmed banner, aligned dark band
324dc6b chore(home): regression checks, overrides audit, handoff update
3b627f6 test(home): responsive and font-fallback screenshot script
eeee075 feat(home): Ink dark mode with banner band
5ae698a feat(home): four theme rows from _data/themes.yml with placeholder tiles and project chips
dfb6541 feat(home): hero block with eyebrow, headline, methods, links, recruiting, photo
f612d90 feat(footer): in-flow footer with UT lockup and short credit
b98b2ea feat(home): site-wide Paper/Ink tokens, Fraunces+Inter, in-flow footer flag; add check script
ad583df Rebuild research page: three sections, twelve projects, selected papers
9ac3e29 Home banner/branding, publications flat list, people cards, project images
cdba17b Add repo-local SESSION-HANDOFF.md (excluded from build)
3314af0 DynamiCog site: merge scaffold, rebuild publications, apply review edits
e9ef82b Update Google Scholar citations
```

## 3. DONE and verified (in the browser)

**Structure & content**
- al-folio + scaffold merged; builds clean. Nav IA: home · research · people · publications ·
  teaching · get involved. **Demo cruft is NOT fully removed** — this line previously claimed it was.
  Four demo pages are still reachable and in the sitemap; see §4B.
- **Publications**: renders all **63 papers** as a **flat running list, newest first** (no year
  headings — `_config.yml` scholar `group_by: none`, `sort_by: year, month`, `order: descending`).
  Name-highlighted; each entry has a PDF link (7 also GitHub, 3 also OSF); button labels
  renamed (Code→GitHub, Website→OSF) via local `_layouts/bib.liquid`. `_bibliography/papers.bib`
  rebuilt from the research-hub index. DOI buttons intentionally omitted.
- **PDFs hosted in-repo** under `/publications/{journal,chapters,proceedings,other}/`; bib uses
  absolute `https://dynamicog.org/publications/...` URLs (preserves old inbound links + serves
  post-cutover).
- **Dropped for now** (files kept, `published:false`): Resources & News (flip flags to re-enable).

**Home page** (`_pages/about.md` + local `_layouts/about.liquid`)
- Full-bleed **gold "neural" hero banner** (`assets/img/banner_brain.png`) with "DynamiCog Lab"
  + "(applied) Cognitive Dynamics and Communication (aCDC)" overlay. Verified light + dark, no
  horizontal scrollbar. CSS in `main.scss` (`.dynamicog-hero*`, `html,body{overflow-x:hidden}`).
- **UT/Dept-of-Psychology lockup** (`assets/img/ut_psychology_logo.png`) top-left of the body;
  gets a white card backing in dark mode.
- **Headshot** `assets/img/prof_pic.jpg` — grey-tee tea-field photo, auto-oriented + cropped
  (wider crop, chin included). Circular.
- **Social icons** (bottom of profile column): email · Google Scholar · GitHub · ORCID · RSS.
  `_data/socials.yml`: `scholar_userid: dU26pfIAAAAJ`, `orcid_id: 0000-0002-8872-5617`. OSF omitted.
- Profile spacing fixed so wrapping body text no longer crowds the info block.

**People page** (`_pages/people.md` + `_data/people.yml`)
- Grad students + research assistants render as **photo-box cards** (`.people-grid`/`.person-card`).
  Dashed-circle user-icon placeholder when no photo. Grad cards larger (`--grad`); RA cards small,
  name-only (`--ra`). Add a photo: drop a square image in `assets/img/people/` and set that
  person's `image:` field. Grad student **Jiahan (Nicole) Li** added.

**Home page — redesigned in session 4 (2026-11-08)** — spec
`docs/superpowers/specs/2026-11-08-home-page-redesign-design.md`, plan
`docs/superpowers/plans/2026-11-08-home-page-redesign.md`.
- Home is now the research statement: eyebrow ("DynamiCog Lab · (applied) Cognitive Dynamics and
  Communication"), two-line headline with a gold phrase, lede, methods line, link row (email,
  Scholar, GitHub, ORCID), one-line recruiting call, circular headshot; then **four theme rows**
  (drawing tile 3:2 left, numeral + title + two/three sentences + project chips right).
- **All copy is data:** hero words in `_pages/about.md` front matter (`eyebrow`, `headline`,
  `lede`, `methods`, `recruiting`, `director`); themes in `_data/themes.yml` (title, blurb,
  `image`, `projects` slugs). Chips resolve slugs to `_projects/` by URL; an unresolved slug emits
  `<!-- theme-row: unresolved project slug "x" -->`.
- **Look = "Paper"** (cream `#f6f1e7`, charcoal, gold `#c9a227` accents, links in gold-deep
  `#8a6f12`) in light mode; **"Ink"** in dark mode (near-black, cream type, the old gold neural
  banner returns as a full-bleed band behind the headline). Fonts **Fraunces + Inter site-wide**
  via the Google Fonts URL in `_config.yml`. Footer is now **in-flow** (`footer_fixed: false`),
  UT lockup left, short credit right, via `_includes/footer.liquid`.
- The old gold banner, the two prose paragraphs, and the in-body UT lockup are gone from home.
- **Tiles are CSS placeholders** (two charcoal bars on cream) until real drawings exist; set
  `image: <file>` in `themes.yml` with the file in `assets/img/themes/`. Art direction lives in
  Box `LAB-LOGISTICS/Website-Redesign/Art-Direction/`.
- New local overrides: `_includes/footer.liquid`, `_includes/theme-row.liquid`; `_layouts/about.liquid`
  rewritten. `.al-folio-overrides.yml` generated and committed.
- **Checks:** `bash test/dynamicog/check-site.sh` (65 assertions against localhost:4000) and
  `bash test/dynamicog/screenshots.sh <outdir>`.

**Research page — retired 2026-11-08 (Nick's call).** The home page's theme rows and project
chips now carry the research overview; a second index of the same twelve projects was judged
redundant. `_pages/projects.md` is a `layout: none` meta-refresh stub to `/#research` (no redirect
plugin is configured), `nav: false`, out of the sitemap. **The twelve detail pages under
`/projects/<slug>/` are untouched and still linked from the chips.** Chips now carry a gold ↗
(`.dc-chip::after`). A grants page was considered and rejected (CV covers it); a "spotlight" page
may come later when there is something to spotlight. The 2026-09-21 notes below describe the page as
it was before retirement.

**First real theme tiles (2026-11-08):** `assets/img/themes/coordination.png` and `in-the-wild.png` (each 1800×1200, padded to
3:2 from square Nano Banana generations) set on themes 01 and 02 in `_data/themes.yml`. Sources and briefs in
Box `Website-Redesign/Art-Direction/`.

**Research page — rebuilt in session 3** (`_pages/projects.md` + `_projects/*.md`)
- Now **three sections in this order**: Grant-Funded Projects (6) · Other Ongoing Projects (2) ·
  Previous Projects (4). Driven by `display_categories`; each project's `category` places it and
  `importance` orders it within the section. Category anchors are slugified (they previously emitted
  `id="Grant-Funded Projects"` with a literal space).
- **Twelve projects**, restored from the live WordPress site's own three sections, plus
  Human-Robot Co-Adaptation which post-dates that site. Files renamed to clean slugs
  (`/projects/suspicion-911/`), dropping the `1_`…`6_` prefixes.
- Each detail page carries the **full formal title**, the **award line** (all six grant-funded), the
  **original description verbatim** from the WordPress export, and a **Selected papers** list.
- Cards show a **short title** via a `card_title` front-matter field, read by a new local
  `_includes/projects.liquid` override. Without it the formal titles run eight lines and swamp the
  card. `card_title` falls back to `title` when absent.
- Card thumbnails are normalized to a uniform **3:2 crop** by `.projects .card-img-top` in
  `main.scss` (`object-fit: cover`), so source images do not need pre-cropping.
- Verified: builds clean, all 12 detail pages 200, all 12 cards have images, 47 citations, every
  cited PDF resolves on disk.
- **Three images are generated filler** in a matched gold-on-dark style: `discourse-analysis.jpg`,
  `semantic-models.jpg`, `robot-coadaptation.jpg`. The last replaced al-folio's stock
  sunset-over-rocks photo. The other nine are real images pulled from the old site.

## 4. TASK LIST — what's left

### A. Needs Nick's input / assets
- [ ] **Theme drawings** — all four home tiles are CSS placeholders. Brief + style guide in Box
      `Website-Redesign/Art-Direction/`; drop finished 3:2 files in `assets/img/themes/` and set
      `image:` in `_data/themes.yml`.
- [ ] **Theme wording** — titles, blurbs, headline, lede are Claude's drafts; edit `_data/themes.yml`
      and `_pages/about.md` front matter.
- [ ] **Human-Robot Co-Adaptation image** — currently generated filler, not a real image.
- [ ] **UT Austin course listings** — `_pages/teaching.md` still ships the visible placeholder
      "Courses at UT Austin / _To be added._" Fill it or drop the heading.
- [ ] **Get Involved / NBC framing** — the page sends prospective PhD students to "the UT Austin
      Department of Psychology graduate program" without naming the **NBC area**. Application
      season is now.
- [ ] **Grad/RA photos** — optional; square images in `assets/img/people/` (the folder does not
      exist yet) plus `image:` fields in `_data/people.yml`.
- [ ] **Skim publication details** — a few proceedings may lack volume/pages.

### B. Can be done autonomously
- [ ] **Remove the al-folio demo pages — blocker, do before the first push.** `/cv/` (Albert
      Einstein), `/books/`, `/repositories/`, `/blog/` all return 200 and are in `sitemap.xml`.
      Strip `external_sources` from `_config.yml` and fix `blog_name`/`blog_description`, which
      still read "al-folio — a simple whitespace theme for academics". Delete the demo assets
      (`the_godfather`, `rhino`, `template_error`, the demo publication previews).
- [ ] **Fix `_data/people.yml`** — drop Natalie Liu (withdrew 2026-09-15); add Farhana Anisha, the
      lab manager, who is missing entirely; fill the director's empty `scholar:` field.
- [ ] **Prune the inherited upstream workflows** — ~18 of them (axe, lighthouse, codeql,
      visual-regression, unit-tests, prettier…) will fire on the new repo and mostly fail. Keep
      `deploy.yml`.
- [ ] **Run the overrides audit** — `bundle exec al-folio upgrade overrides audit`; commit
      `.al-folio-overrides.yml`, which has never been generated. Local overrides are now
      **five**: `_layouts/bib.liquid`, `_layouts/about.liquid`, `_includes/projects.liquid`,
      `assets/css/main.scss`, and `_pages/projects.md`.
- [ ] **Re-enable Resources/News** if wanted (`published:` flags).
- [ ] **Commit the session-3 work** (see §2).

### C. Deploy (only on Nick's go — see §6)
- [ ] Create GitHub repo, push, enable Pages, point DNS, verify.

## 5. Decisions locked (do NOT re-litigate)
- Framework al-folio; build via Docker; repo at `~/dev/dynamicog.org`.
- PDFs in-repo under `/publications/` with absolute URLs.
- Publications = **flat running list, newest first** (changed from year-grouped in session 2b).
- DOI buttons omitted (PDF/OSF/GitHub only). Data in research-hub/CLAUDE.md if ever wanted.
- OSF social icon omitted. Headshot may be casual ("somewhat unprofessional" is fine).

- Research page = **three sections** sourced from the live WordPress site's own grouping, not from
  the new site's earlier Active/Past-work tagging (which had mis-bucketed two grant-funded projects).
- Project URLs are **clean slugs**, no numeric prefixes.
- **Selected papers are hand-written text, generated from `papers.bib` at write time but not wired
  to it.** The alternative — tagging bib entries with a `project` field and rendering each page with
  `{% raw %}{% bibliography --query @*[project=...] %}{% endraw %}` — was offered and declined. The
  mechanism does work (`bibliography[query]` delegates to bibtex-ruby, which supports arbitrary
  field queries) if this is ever revisited. **Consequence: adding a paper to `papers.bib` does not
  update the twelve project pages.**
- Card titles are short (`card_title`); detail pages keep the full formal title.
- **Home page (2026-11-08):** structure "C" (one page, full-width theme rows, no click-to-expand);
  Paper light / Ink dark; research page (grant grid) **stays** in the nav; four themes, deception
  is a project under theme 02 not a theme; headshot stays on home; eyebrow carries the aCDC
  expansion; Fraunces + Inter site-wide; footer in-flow; links use gold-deep in light mode.

## 6. DEPLOY checklist (nothing live yet)
0. **Clear the §4B demo-page blocker first.** Pushing with `/cv/` serving Albert Einstein and
   `/blog/` branded al-folio puts them in the sitemap.
1. **GitHub repo**: ~~create~~ **done 2026-11-08** — `nickduran/dynamicog.org`, private, `main` pushed.
   **GitHub Pages on a private repo needs GitHub Pro or the repo made public**; decide at deploy time.
   Verify the GitHub-hosted URL completely **before** touching DNS.
2. **Action**: keep al-folio's stock `.github/workflows/deploy.yml` (builds w/ jekyll-scholar +
   imagemagick → `gh-pages`). `CNAME` (= `dynamicog.org`) is at repo root already.
3. **Settings → Pages**: source `gh-pages`; custom domain `dynamicog.org`; Enforce HTTPS after cert.
4. **DNS at registrar** (`whois dynamicog.org` first — likely Bluehost):
   | Type | Host | Value |
   |------|------|-------|
   | A | @ | 185.199.108.153 |
   | A | @ | 185.199.109.153 |
   | A | @ | 185.199.110.153 |
   | A | @ | 185.199.111.153 |
   | CNAME | www | `<github-username>.github.io` |
5. Lower TTL a day ahead; cut over; verify apex + www + HTTPS + a sample of
   `/publications/journal/*.pdf`. Keep Bluehost 2–4 wks as safety net. **Keep the domain reg.**

## 7. Gotchas
- al-folio is a **gem theme** (`theme: al_folio_core`); layouts/includes/SCSS live in the gem
  (`/usr/local/bundle/gems/al_folio_core-*/` inside the container). Override by placing a
  same-path file locally (done: `_layouts/bib.liquid`, `_layouts/about.liquid`, `assets/css/main.scss`).
- `test/style_contract.js` fails just because `_layouts/` exists — that gate is for the upstream
  *starter* repo; a customized site legitimately uses overrides. Stock `deploy.yml` (plain
  `jekyll build`) is unaffected.
- The Docker container occasionally stops; `docker compose up -d` restarts it. New `_layouts`/
  `assets` files sometimes need `docker compose restart jekyll` to register.
- zsh aborts commands on unmatched globs (`*.PDF`) — use `find` for file ops.
- Image processing (crop/convert) is easiest via the container's ImageMagick 7
  (`docker exec <container> magick ...`); the repo is bind-mounted at `/srv/jekyll`.

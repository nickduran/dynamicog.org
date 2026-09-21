# DynamiCog site — session handoff & task list

**Last updated 2026-09-21 (end of session 3).** Goal: finish the al-folio site and
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

Branch `main`, last commit `c759159` ("Home banner/branding, publications flat list, people cards,
project images"). Session 2's working tree **was committed** — the old warning here was stale.

**Session 3's research-page rebuild is uncommitted:** 6 project files and 6 images deleted, 12
project files and 12 images added, plus `_pages/projects.md` and a new `_includes/projects.liquid`
override. `git status` in the repo is the live list.

**`origin` still points at `alshedivat/al-folio`.** There is no `nickduran/dynamicog.org` remote
yet, so the repo has no off-machine copy — see §6.

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

## 6. DEPLOY checklist (nothing live yet)
0. **Clear the §4B demo-page blocker first.** Pushing with `/cv/` serving Albert Einstein and
   `/blog/` branded al-folio puts them in the sitemap.
1. **GitHub repo**: create (e.g. `nickduran/dynamicog.org`). `gh` is installed/authed. Push `main`.
   This is also the first off-machine backup — the repo currently has no remote (ADR-0020).
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

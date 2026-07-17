# DynamiCog site — session handoff & task list

**Last updated 2026-07-17 (end of session 2).** Goal: finish the al-folio site and
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

## 2. Current git state — IMPORTANT

**Everything below is uncommitted** in the working tree (branch `main`, last commit
`7e4ee0f`). Decide whether to commit before/after further edits.

```
 M _config.yml            _data/people.yml       _data/socials.yml
 M _pages/about.md        _pages/get-involved.md _pages/people.md
 M assets/css/main.scss   SESSION-HANDOFF.md
 M assets/img/prof_pic.jpg
 M assets/img/projects/{911,coordination,eclippse,pcori,perspective}.jpg
 ?? _layouts/about.liquid
 ?? assets/img/banner_brain.png   assets/img/ut_psychology_logo.png
```

## 3. DONE and verified (in the browser)

**Structure & content**
- al-folio + scaffold merged; builds clean. Nav IA: home · research · people · publications ·
  teaching · get involved. al-folio demo cruft removed.
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

**Research page** (`_pages/projects.md` + `_projects/*.md`)
- 6 cards (4 Active, 2 Past work). Category labels darkened/bolded.
- Card thumbnails normalized to a uniform **3:2 crop** (`.projects .card-img-top` in `main.scss`)
  — fixed the elongated-card / whitespace problem.
- Real images wired from the old site: **911** (phone screen), **ECLIPPSE** (physician typing),
  **PCORI** (doctor/patient split). **Past work**: coordination + perspective (legacy).

**People page** (`_pages/people.md` + `_data/people.yml`)
- Grad students + research assistants render as **photo-box cards** (`.people-grid`/`.person-card`).
  Dashed-circle user-icon placeholder when no photo. Grad cards larger (`--grad`); RA cards small,
  name-only (`--ra`). Add a photo: drop a square image in `assets/img/people/` and set that
  person's `image:` field. Grad student **Jiahan (Nicole) Li** added.

## 4. TASK LIST — what's left

### A. Needs Nick's input / assets
- [ ] **Human–Robot Co-Adaptation project image** — still a stock placeholder
      (`assets/img/projects/robot.jpg`); no match on the old site. Provide one → wire in.
- [ ] **UT Austin course listings** — `_pages/teaching.md` "Courses at UT Austin" left blank
      by choice (ASU archive already present). Fill when ready.
- [ ] **Grad/RA photos** — optional; add square images to `assets/img/people/` + set `image:`
      fields in `_data/people.yml`. Add more grad students there as they join.
- [ ] **Skim publication details** — 63 bib entries generated from the research-hub index;
      a few proceedings may lack volume/pages. Worth a once-over.
- [ ] **Higher-res assets (optional)** — banner `brain-scan.png` (845×631) and
      `projects/perspective.jpg` (222×223) upscale; swap if better versions exist.

### B. Can be done autonomously
- [ ] **Re-enable Resources/News** if wanted (flip `published:`/collection `output:` flags).
- [ ] **Run overrides audit before deploy** — `bundle exec al-folio upgrade overrides audit`,
      review + commit `.al-folio-overrides.yml` (local overrides: `_layouts/bib.liquid`,
      `_layouts/about.liquid`, `assets/css/main.scss`).
- [ ] **Commit the working tree** (see §2) once edits settle.

### C. Deploy (only on Nick's go — see §6)
- [ ] Create GitHub repo, push, enable Pages, point DNS, verify.

## 5. Decisions locked (do NOT re-litigate)
- Framework al-folio; build via Docker; repo at `~/dev/dynamicog.org`.
- PDFs in-repo under `/publications/` with absolute URLs.
- Publications = **flat running list, newest first** (changed from year-grouped in session 2b).
- DOI buttons omitted (PDF/OSF/GitHub only). Data in research-hub/CLAUDE.md if ever wanted.
- OSF social icon omitted. Headshot may be casual ("somewhat unprofessional" is fine).

## 6. DEPLOY checklist (nothing live yet)
1. **GitHub repo**: create (e.g. `nickduran/dynamicog.org`). `gh` is installed/authed. Push `main`.
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

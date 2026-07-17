# DynamiCog site migration — session handoff

**Written 2026-07-17.** Pick this up in a fresh Claude Code session (YOLO/safehouse fine).
Goal: finish the al-folio site and deploy `dynamicog.org` to GitHub Pages.

Read `MIGRATION-PLAN.md` and `dynamicog-site/README.md` first for background. This file
is the current state + exactly what's left.

---

## 0. Where everything lives (IMPORTANT)

- **The working al-folio repo is OUTSIDE Box:** `~/dev/dynamicog.org`
  (i.e. `/Users/ndd697/dev/dynamicog.org`). It is a full git clone of al-folio with the
  scaffold merged in. **All site edits happen here**, not in the Box scaffold.
  → If running in safehouse, make sure `~/dev/dynamicog.org` is writable/mounted.
- **Scaffold source** (already merged, reference only): `Website-Redesign/dynamicog-site/` (Box).
- **Publication PDFs source of truth:** `~/Library/CloudStorage/Box-Box/research-hub/publications/`
  with a full index in that folder's `CLAUDE.md` (journal/chapters/proceedings/other + citations).
- **WordPress export** (for legacy images/text): `LAB-LOGISTICS/dynamicoglab.WordPress.2026-07-17.xml`.
- **Live old site** (still WordPress, reachable): https://dynamicog.org

## 1. How to preview locally

Toolchain decision: **Docker** (system Ruby 2.6 is too old). Repo location: **outside Box**.
```bash
cd ~/dev/dynamicog.org
open -a Docker                 # start Docker Desktop, wait until `docker info` works
docker compose up              # serves at http://localhost:4000  (see note below)
```
- Port is remapped to **4000** via `docker-compose.override.yml` (git-ignored; container
  serves 8080 internally). LiveReload is on — file edits auto-refresh.
- `_config.yml` changes require a restart: `docker compose restart jekyll`.
- `_pages`, `_layouts`, `assets`, `_bibliography` changes are picked up by the watcher.

## 2. Current state — DONE and verified

- al-folio cloned + scaffold merged (`_config.yml` merged surgically; pages/projects/
  bibliography/CNAME copied). Site builds clean, serves at localhost:4000.
- **Nav** (final IA): home · research · people · publications · teaching · get involved.
- Removed al-folio demo cruft (Einstein posts, sample projects/teachings, profiles/
  dropdown/plugins/about_einstein pages).
- **Home** (`_pages/about.md`): "selected publications" section removed
  (`selected_papers: false`); News removed from home (`news: false`); right-side info
  has "Department of Psychology" and "The University of Texas at Austin" on separate lines.
- **Research** (`_pages/projects.md` + `_projects/*.md`): 6 cards (4 Active, 2 Past work).
  Category labels ("Active"/"Past work") darkened + bolded via local override
  `assets/css/main.scss` (they were near-invisible).
- **Publications**: FIXED (scaffold shipped a broken `layout: bib` empty page). Now renders
  all **63 papers** grouped by year, name-highlighted. Rebuilt `_bibliography/papers.bib`
  from the research-hub index (was 27, now 63). Button labels renamed via local override
  `_layouts/bib.liquid`: **Code→GitHub**, **Website→OSF**. Each entry has a PDF link
  (7 also GitHub, 3 also OSF). 5 flagship papers marked `selected={true}`.
- **PDFs hosted in-repo**: all 63 PDFs copied to `~/dev/dynamicog.org/publications/{journal,
  chapters,proceedings,other}/`. Bib uses absolute `https://dynamicog.org/publications/...`
  URLs → preserves old inbound links AND serves from the new site after cutover.
- **Dropped for now** (files kept, `published: false` + collection `output: false`):
  Resources (`_pages/resources.md`) and News (`_pages/news.md`, `_news/`, home news).
  Both 404 currently; re-enable by flipping those flags.

## 3. Decisions already made (do NOT re-litigate)

- Framework: al-folio. Build: Docker. Repo path: `~/dev/dynamicog.org`.
- PDF strategy: in-repo under `/publications/` + absolute URLs (preserves links).
- Publications grouped by year only (all types together), newest first. Year-label light
  font is intentional — KEEP it (user likes it). Category labels on Research were the
  ones that needed darkening (done).
- DOI buttons were intentionally OMITTED to match the user's PDF/OSF/GitHub expectation.
  (Data exists in research-hub/CLAUDE.md if the user later wants DOI buttons added.)

## 4. What's LEFT — needs Nick's input (ASK, don't guess)

1. **RA interest-survey link** — `_pages/get-involved.md` has a dead `#` placeholder.
2. **UT Austin course listings** — `_pages/teaching.md` says "_To be added_" (ASU archive
   is already there). Need current UT course names/descriptions.
3. **Google Scholar / ORCID / OSF ids** — `_data/socials.yml` has TODO placeholders.
4. **Headshot** — currently al-folio's stock photo. Candidate from old site:
   `https://dynamicog.org/wp-content/uploads/2018/12/nduran_crop.jpg` (or 2019/04 version).
   Confirm which photo to use, or Nick supplies a new one → save as `assets/img/prof_pic.jpg`.
5. **Project card images** — all 6 are placeholders. Legacy images that map:
   - Past work → `.../2013/09/perspectiveTaking.jpg`, `.../2013/09/coordination.jpg`
   - The 4 Active projects (911, ECLIPPSE, PCORI, Robot) have NO legacy image — need new
     images or Nick's call to leave abstract/placeholder.
6. **Grad students** — `_data/people.yml` `grad_students: []` (shows "recruiting"). Add if any.
7. **Confirm publication details** — the 63 bib entries were generated from the research-hub
   index; volumes/pages are mostly complete but a few proceedings lack them. Worth a skim.

## 5. What's LEFT — can be done autonomously (safe in YOLO)

- **Wire legacy images** once Nick confirms #4/#5: download from the live site with `curl`,
  save to `assets/img/prof_pic.jpg` and `assets/img/projects/{coordination,perspective}.jpg`
  (overwrite placeholders; keep the exact filenames the `_projects/*.md` `img:` fields use).
- **Lab logos** — check `LAB-LOGISTICS/Branding/` for a lab logo; can be added to the navbar/
  footer if desired.

## 6. DEPLOY — only after Nick says go (nothing live yet)

Per `MIGRATION-PLAN.md §5`. Steps:
1. **GitHub repo**: create (e.g. `nickduran/dynamicog.org` or a `dynamicog-lab` org).
   `gh` is installed and authenticated. Push `~/dev/dynamicog.org` `main`.
2. **Deploy Action**: al-folio ships `.github/workflows/deploy.yml` (keep the stock one; it
   builds with jekyll-scholar + imagemagick and publishes to `gh-pages`). The scaffold's
   simpler deploy.yml was NOT copied over — stock is better. Verify `CNAME` (= `dynamicog.org`)
   is at repo root (it is).
3. **Repo Settings → Pages**: source = `gh-pages` branch; custom domain = `dynamicog.org`;
   enable Enforce HTTPS after cert provisions.
4. **DNS at registrar** (check `whois dynamicog.org` first — may be Bluehost):
   | Type | Host | Value |
   |------|------|-------|
   | A | @ | 185.199.108.153 |
   | A | @ | 185.199.109.153 |
   | A | @ | 185.199.110.153 |
   | A | @ | 185.199.111.153 |
   | CNAME | www | `<github-username>.github.io` |
5. Lower Bluehost TTL a day ahead; cut over; verify apex + www resolve, HTTPS green, and a
   sample of `/publications/journal/*.pdf` links open. Keep Bluehost ~2–4 wks as safety net.
   **Keep the domain registration.**

## 7. Gotchas learned this session

- al-folio here is a **gem theme** (`theme: al_folio_core`), so layouts/includes/SCSS live in
  the gem (`/usr/local/bundle/gems/al_folio_core-*/`). Override by placing a same-path file
  locally (already done for `_layouts/bib.liquid` and `assets/css/main.scss`).
- zsh aborts commands on unmatched globs (`*.PDF`) — use `find` for file ops.
- New `_layouts`/`assets` files sometimes need `docker compose restart jekyll` to register.

# DynamiCog site — session handoff & task list

**Last updated 2026-11-08 (end of session 5: launch-blocker cleanup, theme 03 tile, teaching and
Get Involved copy).** Goal: finish the al-folio site and launch `dynamicog.org` on GitHub Pages.
Nothing is live yet; the old WordPress site is still up. This file is the single "fire right up"
doc: current state, what's left, and how to deploy. Background (optional): `MIGRATION-PLAN.md`,
`dynamicog-site/README.md`.

**To resume (do this at session start, unprompted):** start Docker, then
`cd ~/dev/dynamicog.org && docker compose up -d && open http://localhost:4000/`, so the working
site is in front of Nick. Then work the **Task list (§4)** below.

**At session close:** walk §4 and §5 against the session's commits, check off or delete what's
done, remove anything a later decision contradicts, refresh the §2 log, then copy this file over
the Box copy. Session 4 skipped this and left the handoff stale.

---

## 0. Where everything lives

- **Working repo (all edits happen here):** `~/dev/dynamicog.org`, a full git clone of al-folio
  with the scaffold merged in. On branch `main`. **Outside Box.**
- **This handoff exists in two synced places:** `~/dev/dynamicog.org/SESSION-HANDOFF.md`
  (canonical, in-repo but excluded from the build) and a copy at
  `Box/LAB-LOGISTICS/Website-Redesign/SESSION-HANDOFF.md` (backup for when the repo isn't handy).
- **Art direction (style guide, briefs, generated tiles + provenance notes):**
  `Box/LAB-LOGISTICS/Website-Redesign/Art-Direction/`. Each tile has a `<slug>-2026-11-08.txt`
  note in `generated/` recording its source file and how it was padded to 3:2.
- **Branding assets (headshots, logos, banner):** `Box/LAB-LOGISTICS/Branding/COLA_Psychology_logos/`.
- **Publication PDFs (source of truth):** `Box/research-hub/publications/` (index in its `CLAUDE.md`).
- **WordPress export (legacy text/images):** `Box/LAB-LOGISTICS/Website-Redesign/dynamicoglab-wordpress-export-2026-07-17.xml`.
- **Teaching source material** (for the teaching page): `~/Desktop/teaching/` (FDS I weekly
  breakdown `FDS I/PSY371E-weekly-content-for-SDS.md`; FDS II syllabus `FDS II/FDS2-F26-Syllabus-v2.docx`).
- **Live old site (reachable, good for pulling legacy images):** https://dynamicog.org

## 1. How to preview locally

Toolchain: **Docker** (system Ruby 2.6 is too old to run al-folio directly).
```bash
cd ~/dev/dynamicog.org
open -a Docker                    # wait until `docker info` works
docker compose up -d              # serves http://localhost:4000  (container serves 8080; remapped)
open http://localhost:4000/
docker compose logs --tail=40 jekyll   # check for build errors
docker compose restart jekyll     # REQUIRED after any _config.yml change
docker compose down               # stop when done
```
- Port 4000 via `docker-compose.override.yml` (git-ignored). LiveReload auto-refreshes.
- `_pages`, `_layouts`, `assets`, `_data`, `_bibliography` edits: picked up by the watcher.
- `_config.yml` edits: **restart required**.
- Chrome disk-caches `main.css`/pages aggressively during preview. If a CSS change doesn't
  show, hard-reload or append a throwaway query (`/?v=2`).
- **Checks:** `bash test/dynamicog/check-site.sh` (88 assertions against localhost:4000, all
  passing at end of session 5) and `bash test/dynamicog/screenshots.sh <outdir>`.

## 2. Current git state

Branch `main`, tracking **`origin` = `https://github.com/nickduran/dynamicog.org` (private, created
2026-11-08)**. The al-folio template remote is `upstream`.

**History was rewritten once, 2026-11-08, before the first push** (shallow clone grafted to a true
root; ~49 MB). Older notes citing `349e5be`, `c759159`, `26aa0a9`, etc. refer to the same history
under pre-rewrite hashes. Pre-rewrite bundle: `~/dev/dynamicog.org-pre-graft-2026-11-08.bundle`.

```
d5ff165 feat(site): theme 03 tile, remove al-folio demo content, people/teaching/get-involved updates
eee9d18 feat(home): replace theme 02 tile with revised drawing
d6c11ba fix(home): rebuild theme tiles with continuous paper texture instead of flat padding
35760b5 feat(home): second real theme tile (natural behavior in the wild)
dc25c4d feat(site): retire research page (redirect to /#research), chip arrows, first real theme tile
1f60a52 docs: handoff — private origin created, history grafted to a true root before first push
21ebac8 fix(home): review fixes — AA-contrast gold-deep, nowrap methods/accent, trimmed banner, aligned dark band
324dc6b chore(home): regression checks, overrides audit, handoff update
... (11 earlier commits back to e9ef82b, the imported al-folio snapshot)
```
Whether `d5ff165` and the handoff commit after it are pushed: check `git status -sb`.

## 3. DONE and verified (in the browser)

**Structure & content**
- al-folio + scaffold merged; builds clean. **Nav:** home · people · publications · teaching ·
  get involved. (The research page was retired 2026-11-08; see below.)
- **al-folio demo content removed (session 5).** `/cv/`, `/books/`, `/repositories/`, `/blog/`
  return 404 and are out of `sitemap.xml`. Deleted: the demo pages, the Albert Einstein CV
  (`assets/rendercv/`, `_data/cv.yml`, `assets/json/resume.json`), demo audio/video/jupyter/plotly/
  html, numbered stock images, `rhino`/`template_error`/`the_godfather`, publication-preview gifs,
  `_data/repositories.yml`. `_config.yml`: `external_sources` removed, `blog_name`/`blog_description`
  rebranded, `disqus_shortname` cleared, `books` collection + archive removed, `jekyll_get_json`
  removed, `features.cv.enabled: false`. RSS icon hidden in `_data/socials.yml` (no posts).
- **Workflows pruned:** only `.github/workflows/deploy.yml` remains (18 upstream workflows deleted).
- **Overrides audit:** done in session 4; `.al-folio-overrides.yml` is committed.
- **Publications**: all **63 papers**, flat running list, newest first (`group_by: none`,
  `sort_by: year, month`, `order: descending`). Name-highlighted; each has a PDF link (7 also
  GitHub, 3 also OSF); button labels renamed via local `_layouts/bib.liquid`. DOI buttons omitted.
- **PDFs hosted in-repo** under `/publications/{journal,chapters,proceedings,other}/`; bib uses
  absolute `https://dynamicog.org/publications/...` URLs.
- **Dropped for now** (files kept, `published:false`): Resources & News (flip flags to re-enable).

**Home page** (`_pages/about.md` + local `_layouts/about.liquid`). Spec
`docs/superpowers/specs/2026-11-08-home-page-redesign-design.md`, plan
`docs/superpowers/plans/2026-11-08-home-page-redesign.md`.
- Home is the research statement: eyebrow, two-line headline with a gold phrase, lede, methods
  line, link row (email, Scholar, GitHub, ORCID), one-line recruiting call, circular headshot;
  then **four theme rows** (3:2 tile left; numeral + title + blurb + project chips right). The
  section is anchored `#research`.
- **All copy is data:** hero words in `_pages/about.md` front matter; themes in
  `_data/themes.yml` (title, blurb, `image`, `projects` slugs). Unresolved slugs emit
  `<!-- theme-row: unresolved project slug "x" -->`. Chips carry a gold ↗ (`.dc-chip::after`).
- **Look:** "Paper" light (cream `#f6f1e7`, charcoal, gold `#c9a227`, links gold-deep `#8a6f12`);
  "Ink" dark (near-black, cream type, the gold neural banner as a full-bleed band behind the
  headline). Fraunces + Inter site-wide. Footer in-flow, UT lockup left, short credit right
  (`_includes/footer.liquid`).
- **Theme tiles: all four are real drawings** (each 1800×1200, square Nano Banana source
  padded to 3:2 by stretching only clean paper margins, or center-cropped when wider than 3:2):
  01 `coordination.png` (replaced session 5 with a landscape source, two figures joined by
  tangled charcoal and gold lines; full width kept for side space, top extended with mirror-tiled
  paper to reach 3:2; v1 kept in
  `Art-Direction/generated/superseded/`), 02 `in-the-wild.png`, 03 `computation.png` (abstract
  charcoal lattice, one gold stroke; added session 5), 04 `people-and-machines.png` (overhead person
  and robot passing through a gap in a wall; source was a photographed sheet, so it is cropped inside
  the paper; added session 5). Sources and provenance notes in `Art-Direction/generated/`.

**People page** (`_pages/people.md` + `_data/people.yml`)
- Sections: Lab Director · **Lab Manager (Farhana Anisha, added session 5)** · Graduate Students
  (Jiahan (Nicole) Li) · Research Assistants · Alumni · Faculty Collaborators. Photo-box cards with
  dashed-circle placeholders. Natalie Liu removed (withdrew 2026-09-15). Director's Scholar link
  filled. Director role and bio now render as separate paragraphs.

**Teaching page** (`_pages/teaching.md`, rewritten session 5)
- Leads with the UT **Foundations of Psychological Data Science** sequence: PSY 371E (FDS I) and
  PSY 371F (FDS II), one paragraph each, drawn from the Sp26 FDS I weekly breakdown and the F26
  FDS II syllabus. The three ASU courses are a small, muted `.teaching-archive` block at the bottom
  (style in `main.scss`).

**Get Involved page** (`_pages/get-involved.md`, rewritten session 5)
- PhD section now leads and recruits through the **Natural Behavior and Computation (NBC)** area:
  list NBC as your area, name Nick, email him before applying. Links to the department's
  prospective-graduate-students page. No NBC-specific link: as of 2026-11-08 the department's
  areas-of-study page does not list NBC.

**Research page: retired 2026-11-08 (Nick's call).** The home page's theme rows and chips carry the
research overview. `_pages/projects.md` is a `layout: none` meta-refresh stub to `/#research`,
`nav: false`, out of the sitemap. **The twelve detail pages under `/projects/<slug>/` stay** and are
linked from the chips. Each carries the full formal title, award line (grant-funded ones), the
original WordPress description verbatim, and a hand-written **Selected papers** list. Three project
images are generated filler (`discourse-analysis.jpg`, `semantic-models.jpg`,
`robot-coadaptation.jpg`); the other nine came from the old site.

## 4. TASK LIST — what's left

### A. Needs Nick's input / assets
- [ ] **Theme wording**: titles, blurbs, headline, lede are Claude's drafts; edit `_data/themes.yml`
      and `_pages/about.md` front matter.
- [ ] **Review session-5 copy**: teaching descriptions and the Get Involved NBC paragraph are
      Claude's drafts. Confirm the course titles match the catalog (the FDS I materials use both
      "Foundations of Psychological Data Science I" and "Psychology Data Science Foundations I").
- [ ] **RA roster**: Nadia Talanker and Madison Jaques have been unreachable since June per
      `CLAUDE.md`; still listed. Mona Xue's role is unrecorded, so she is not listed.
- [ ] **Human-Robot Co-Adaptation image**: generated filler, not a real image.
- [ ] **Grad/RA/lab-manager photos**: optional; square images in `assets/img/people/` (folder does
      not exist yet) plus `image:` fields in `_data/people.yml`.
- [ ] **Skim publication details**: a few proceedings may lack volume/pages.

### B. Can be done autonomously
- [ ] **Footer credit** still says "Built with al-folio". Fine to keep; drop if unwanted.
- [ ] **Re-enable Resources/News** if wanted (`published:` flags).

### C. Deploy (only on Nick's go — see §6)
- [ ] Decide Pages hosting for a private repo (GitHub Pro, or make the repo public), enable Pages,
      verify the github.io URL, then point DNS.

## 5. Decisions locked (do NOT re-litigate)
- Framework al-folio; build via Docker; repo at `~/dev/dynamicog.org`.
- PDFs in-repo under `/publications/` with absolute URLs.
- Publications = **flat running list, newest first**.
- DOI buttons omitted (PDF/OSF/GitHub only). OSF social icon omitted. Headshot may be casual.
- Project URLs are **clean slugs**, no numeric prefixes. Detail pages keep the full formal title.
- **Selected papers are hand-written, not wired to `papers.bib`.** The bib-query alternative was
  declined. Consequence: adding a paper to `papers.bib` does not update the project pages.
- **Home page (2026-11-08):** one page, full-width theme rows, no click-to-expand; Paper light /
  Ink dark; four themes, deception is a project under theme 02 not a theme; headshot stays on
  home; eyebrow carries the aCDC expansion; Fraunces + Inter site-wide; footer in-flow; links use
  gold-deep in light mode.
- **Research page retired (2026-11-08)**; the home theme rows replace it. A grants page was
  rejected (CV covers it); a "spotlight" page may come later.
- **No blog, CV page, books, or repositories pages** (removed session 5).
- **Teaching page:** UT FDS sequence first; ASU courses kept but small, at the bottom.
- **Get Involved:** PhD recruitment framed through the NBC area.

## 6. DEPLOY checklist (nothing live yet)
0. ~~Clear the demo-page blocker~~ **done session 5.**
1. **GitHub repo**: `nickduran/dynamicog.org`, private, `main` pushed. **GitHub Pages on a private
   repo needs GitHub Pro or the repo made public**; decide at deploy time. Verify the
   GitHub-hosted URL completely **before** touching DNS.
2. **Action**: al-folio's stock `.github/workflows/deploy.yml` (jekyll-scholar + imagemagick →
   `gh-pages`) is the only workflow. `CNAME` (= `dynamicog.org`) is at repo root.
3. **Settings → Pages**: source `gh-pages`; custom domain `dynamicog.org`; Enforce HTTPS after cert.
4. **DNS at registrar** (`whois dynamicog.org` first; likely Bluehost):
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
  same-path file locally. Current local overrides: `_layouts/bib.liquid`, `_layouts/about.liquid`,
  `_includes/projects.liquid`, `_includes/footer.liquid`, `_includes/theme-row.liquid`,
  `assets/css/main.scss`.
- `test/style_contract.js` fails just because `_layouts/` exists; that gate is for the upstream
  *starter* repo. Stock `deploy.yml` is unaffected.
- The dev sitemap shows `http://0.0.0.0:8080/...` URLs; that is the dev server's `site.url`, not a
  production problem.
- The Docker container occasionally stops; `docker compose up -d` restarts it. New `_layouts`/
  `assets` files sometimes need `docker compose restart jekyll` to register.
- zsh aborts commands on unmatched globs (`*.PDF`, `--include=*.html`); quote them or use `find`.
- macOS `grep -E` rejects repetition counts over 255 (`{0,400}`); split into two `{0,200}`.
- Image processing is easiest via the container's ImageMagick 7
  (`docker exec dynamicogorg-jekyll-1 magick ...`); the repo is bind-mounted at `/srv/jekyll`.
  For tiles, check which margin columns are truly clean before stretching (`-format
  "%[fx:minima]"` on narrow crops); stray charcoal near the art streaks when stretched.
  Stretching a thin strip more than ~4x shows streaks; mirror-tiling the strip (alternate
  `-flip`/`-flop`, original copy adjacent to the art) looks continuous.

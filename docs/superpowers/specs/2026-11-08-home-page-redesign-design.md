# Design: dynamicog.org home page as a themed research statement

**Date:** 2026-11-08
**Status:** builder check complete 2026-11-08; all questions resolved; awaiting Nick's approval of this document
**Repo:** `~/dev/dynamicog.org` (al-folio, Jekyll, Docker preview at localhost:4000)
**Owner:** Nick Duran
**Paper trail:** a copy of this file lives in Box at `LAB-LOGISTICS/Website-Redesign/`, with the art direction in `Website-Redesign/Art-Direction/`.

---

## 1. Intent

The site exists so that a visitor, in thirty seconds, knows what the lab studies and how. Today the home page is a decorative banner plus two paragraphs of prose, and the research page is a grid of twelve grant projects with mismatched stock images. Nothing on the first screen states the research.

This design turns the home page into the research statement: a bold headline, a three-sentence lede, a methods line, the director's photo and links, and four **theme rows**, each with a drawing tile, a title, two or three sentences, and chips linking to the existing project pages. The themes are the lenses; the grants are the evidence underneath.

The look is "Paper": cream ground, charcoal type, gold as rules, numerals, and one highlighted phrase. Dark mode shows the same page as "Ink": near-black ground, cream type, the existing gold neural banner as a hero band.

## 2. Goals

- A visitor can state the lab's research question and methods after the first screen, without scrolling.
- The lab's range (movement, language, computation, applied settings) reads as one program with four lenses, not twelve unrelated projects.
- Four drawing tiles in one consistent hand carry the visual identity. Until the drawings exist, a single uniform placeholder stands in.
- Nick's photo, email, Google Scholar, GitHub, and ORCID are on the first screen.
- Everything already built and verified stays: publications, people, teaching, get involved, the twelve project detail pages, the grant-organized research grid.

## 3. Non-goals

- No new framework, theme, or hosting change. al-folio, Docker, GitHub Pages, and every decision in `SESSION-HANDOFF.md` section 5 stand.
- No change to publications, people, teaching, or get-involved pages.
- No rewrite of the twelve project detail pages. Their copy is a separate content task.
- No generation of the theme drawings. Art is produced outside the repo per `Art-Direction/image-style-guide-2026-11-08.md` and dropped in later.
- No deploy. The deploy checklist in the handoff is untouched by this work.
- No reorganization of the Box `Website-Redesign/` folder. Separate project, queued after this one.

## 4. Anti-goals (what would make this a failure even if it builds)

- A home page that still needs a paragraph read before the research is clear.
- Theme tiles that look like four different styles, or like stock.
- Anything that reads as a copy of Rick Dale's Co-Mind site. Shared energy is fine; shared palette, wordmark treatment, or layout is not.
- A "wall of text" theme section. Each theme is two or three sentences, hard cap.
- Breaking the project detail pages' URLs or the publications list.

## 5. Constraints

- al-folio is a gem theme. Customization is by same-path override files (`_layouts/`, `_includes/`, `assets/css/main.scss`), already in use. Five local overrides exist; this adds a small number more and must not fork the gem.
- `_config.yml` changes require a container restart. Layout, include, data, and SCSS changes are picked up live.
- Dark mode is al-folio's toggle (`enable_darkmode: true`). Both modes must be checked; CSS uses the theme's `--global-*` variables where they exist and defines its own tokens where they do not.
- No horizontal scroll at any width. Mobile (375px) must stack the theme rows: tile above text.
- Images in `assets/img/` go through al-folio's ImageMagick responsive pipeline on build; the placeholder is CSS, not an image, so it needs no pipeline.
- Google Fonts are an external stylesheet. If the fonts fail to load, the page must still look intentional: fall back to Georgia/serif and system sans.

## 6. The page, top to bottom (desktop)

Reference mockup: `.superpowers/brainstorm/14927-1794158400/content/06-look-and-feel.html`, treatment 1 (Paper). It is a mockup, not a spec for pixel values; the builder should match its proportions and hierarchy, not its exact numbers.

1. **Nav.** al-folio's navbar, unchanged in behavior and **not overridden**. On the home page al-folio hides the navbar brand, so the lab's name is carried by the hero (next item). On every other page the brand "DynamiCog Lab" renders in the display face via CSS only. Links: research, people, publications, teaching, get involved. The existing gold neural banner hero is **removed** from the home page in light mode (see dark mode below).
2. **Hero block.** Two-column: text left (about 70%), photo right.
   - Eyebrow, above the headline: **DynamiCog Lab** in small caps, letter-spaced, gold-deep, then a gold dot, then *(applied) Cognitive Dynamics and Communication* in lighter, mixed-case type at the same size, so it reads as a subtitle to the name and not a second headline. This is where the lab's name appears on the home page, since the gem hides the navbar brand on `/`. Both strings are front matter on `about.md` (`eyebrow`, `eyebrow_sub`).
   - Headline, display serif, heavy, two lines, one phrase in gold. Draft text: *Natural behavior, measured* **as it happens.** (gold on the last three words).
   - Lede, three sentences, body face, max width about 620px.
   - Methods line, small caps, letter-spaced, gold-brown: *Movement tracking · Conversation analysis · Language models · Dynamical systems*.
   - Link row: email, Google Scholar, GitHub, ORCID, each a small gold icon plus label, sourced from `_data/socials.yml`. RSS is dropped from this row (keep it in the footer if al-folio insists).
   - Recruiting line, one sentence under the link row, body face, muted, with the link in gold-deep: *Recruiting undergraduate research assistants and PhD students. See [Get Involved].* Text and on/off are front matter on `about.md` (`recruiting:`), so it can be switched off out of season. (Builder-check call: the old page's only recruiting call would otherwise vanish during application season.)
   - Photo: `prof_pic.jpg`, circular, about 200px, white inner ring and thin gold outer ring. Under it, centered small text: *Nick Duran, Director / Department of Psychology / The University of Texas at Austin*.
3. **Theme rows.** Four rows separated by thin rules. Each row is a two-column grid: tile left (fixed about 300px, 3:2), text right.
   - Gold numeral (01–04), display serif, small, letter-spaced.
   - Title, display serif, heavy, about 28px.
   - Two or three sentences, body face, max width about 600px.
   - Project chips: small bordered labels, each linking to a project detail page (`/projects/<slug>/`). Chips wrap.
   - Tile: the placeholder (section 8) until a real drawing exists for that theme.
4. **Footer.** al-folio's **in-flow** footer (`footer_fixed: false`; today it is `true`, a pinned near-black bar, which fights a cream page). UT Psychology lockup (`ut_psychology_logo.png`) at left, about 34px tall, carried by `footer_text`, which the gem renders unescaped; copyright at right: *© 2026 Nick D. Duran · DynamiCog Lab · Built with al-folio*. The lockup moves here from the body. Thin gold rule above. This is a `_config.yml` change and alters every page's footer markup; that is intended.

### Dark mode (Ink)

Same structure. Ground near-black, type cream, gold brightened. The hero gains a band: the existing `banner_brain.png` as a full-width background behind the headline, with a left-to-right dark gradient so the type stays legible, headline sitting at the band's bottom edge. Lede, methods, links, and photo sit below the band. Tiles keep their cream paper and become the brightest elements on the page. The UT lockup in the footer is inverted to cream.

## 7. Content and data

Theme content lives in one data file so wording can be edited without touching templates.

`_data/themes.yml`, one entry per theme, in display order:

```yaml
- slug: coordination
  number: "01"
  title: Communication and coordination
  blurb: >
    When two people talk, move, and solve problems together they start to act
    as one system. We measure that coupling in speech, gesture, and posture,
    and ask when it helps and when it gets in the way.
  image: ""            # empty = placeholder; else a file in assets/img/themes/
  projects:            # project slugs, in order; each must exist in _projects/
    - cps-coordination
    - multimodal-coordination
    - linguistic-concordance
    - perspective-taking
```

Draft content for all four, to be shipped as written and edited by Nick later:

| # | Title | Projects |
|---|---|---|
| 01 | Communication and coordination | cps-coordination, multimodal-coordination, linguistic-concordance, perspective-taking |
| 02 | Natural behavior in the wild | suspicion-911, patient-provider-llm, action-dynamics-deception, language-deception |
| 03 | Computation for behavior | semantic-models, dynamic-psycholinguistics, discourse-analysis |
| 04 | People and machines, adapting | robot-coadaptation, patient-provider-llm |

Blurb drafts are in the mockup file and should be copied from it. A project may appear under more than one theme (patient-provider-llm appears twice). Chip labels come from each project's `card_title`, falling back to `title`.

Headline, lede, and methods line are front matter on `_pages/about.md` (new keys: `headline`, `headline_accent`, `lede`, `methods`), so the same file that holds the page holds its words. The two existing prose paragraphs in `about.md` are removed from the home page; keep their text in the git history, nothing else.

Director block text and the link row come from existing config (`_data/socials.yml`, `profile.more_info`), trimmed to the three lines above. The email line moves into the link row.

## 8. The placeholder tile

A CSS-only tile: cream (`#efe8d8`) with a thin border, two near-black bars in the Shapiro posture (one tall, rotated about -8°, one short crossing it at about 14°), soft shadow suggesting smudge. Identical on all four rows. Implemented as a `<div class="theme-tile theme-tile--placeholder">` with `::before`/`::after` bars. When `image` is set in `themes.yml`, the include renders `<img>` instead, via al-folio's `figure.liquid` so the responsive pipeline applies, with `object-fit: cover` to enforce 3:2.

## 9. Visual tokens

Define once in `main.scss` as CSS custom properties, light and dark:

| Token | Light (Paper) | Dark (Ink) |
|---|---|---|
| ground | `#f6f1e7` | `#121212` |
| ink (text) | `#1c1c1c` | `#f3ede0` |
| muted text | `#444` | `#cfc8b8` |
| rule | `#d9d0bd` | `#2c2c2c` |
| gold | `#c9a227` | `#e2b73a` |
| gold-deep (small caps, links) | `#7f6611` | `#e2b73a` |
| tile paper | `#efe8d8` | `#efe8d8` |
| chip bg / border | `#fff` / `#d9d0bd` | `#1e1e1e` / `#3a3a3a` |

Type: display `Fraunces` (weights 600, 800, optical size axis), text `Inter` (400, 500, 700), **site-wide**, replacing Roboto everywhere so the nav, publications, people, and project pages share one body face with the home page. Load by replacing the Google Fonts URL at `third_party_libraries.google_fonts.url.fonts` in `_config.yml` (keep Material Icons in it). Fallbacks: Georgia/serif and system sans. Override the gem's `body { font-family: Roboto }` from the compiled Tailwind CSS in `main.scss`.

al-folio's theme color (`$purple-color` / `$cyan-color` in the gem's variables, overridden in `main.scss`) becomes **gold-deep `#7f6611` in light mode** and `#e2b73a` in dark mode. That variable colors every body link and the publication buttons; bright gold on cream is about 2.2:1 contrast and fails for text, gold-deep is 4.89:1 on the cream ground (the earlier `#8a6f12` measured 4.28:1 on cream, below AA; review fix 2026-11-08). Bright gold `#c9a227` is reserved for rules, numerals, the headshot ring, and the headline phrase.

The ground color applies to the whole site in both modes, not just the home page, so that navigating to publications does not snap from cream to white. Verify the publications and people pages still read well on cream; if a component fights it, fix the component rather than reverting the ground.

## 10. Files the builder will touch

- `_pages/about.md` – new front matter keys; prose removed.
- `_layouts/about.liquid` – rewritten: hero block, theme rows via include, dark-mode band. Keep the gem's structure for anything not described here.
- `_includes/theme-row.liquid` – new; renders one theme from `_data/themes.yml`, resolving project slugs to `site.projects` entries for chip labels and URLs. Must fail loudly in the build log if a slug does not resolve (a Liquid `{% unless %}` that emits an HTML comment is acceptable; a silent empty chip is not).
- `_data/themes.yml` – new.
- `assets/css/main.scss` – tokens, hero, theme rows, placeholder tile, footer tweaks, dark-mode band; remove the old `.dynamicog-hero*` rules and `.ut-logo` body placement.
- `_includes/footer.liquid` – override only if needed to place the lockup; prefer `footer_text` in `_config.yml` if it can carry the image.
- `_config.yml` – three edits, then restart: `footer_fixed: false`; `footer_text` rewritten to carry the lockup `<img>` and the new copyright line; `third_party_libraries.google_fonts.url.fonts` replaced with Fraunces + Inter + Material Icons. There is no theme-color config key; the color is overridden in `main.scss`.
- `.al-folio-overrides.yml` – regenerate via `bundle exec al-folio upgrade overrides audit` after the change so the override list is current.

Not touched: `_projects/`, `_pages/projects.md`, `_includes/projects.liquid`, `_bibliography/`, `_pages/people.md`, `_data/people.yml`, `publications/`.

## 11. Acceptance

- Light and dark mode both render as described; no horizontal scroll at 375, 768, 1280 widths.
- All four theme rows render with the placeholder; every chip links to a 200 page.
- The old banner, the two prose paragraphs, and the in-body UT lockup are gone from the home page.
- Email, Scholar, GitHub, ORCID links resolve to the right targets from `socials.yml`.
- Setting `image:` for one theme in `themes.yml` to a test 3:2 file swaps that one tile and leaves the other three on the placeholder.
- Publications, people, teaching, get involved, and all twelve project pages have unchanged content and URLs. Their HTML differs only in the shared changes (footer markup, font link, body class) and they are checked visually in both modes on the new ground and type, with the 63-entry publications list and its PDF/GitHub/OSF buttons read in full.
- Every body link on the publications and people pages is legible in both modes (gold-deep on cream, bright gold on near-black).
- `docker compose logs` shows a clean build with no Liquid warnings introduced by this work.
- `git status` clean after a single commit (or a short series) on `main`, with this document committed alongside.

## 12. Left to the builder

- Exact pixel values, spacing rhythm, and breakpoints, matching the mockup's proportions.
- How al-folio's navbar accepts the display face for the brand without affecting the link items.
- The Liquid for resolving project slugs and for the empty-image placeholder branch.
- Whether a dark-mode-only banner band is best done with a `[data-theme="dark"]` CSS rule on a single element that is always in the DOM (preferred) or with two elements.

## 13. Decisions recorded here (do not re-litigate)

- Structure C: one page, full-width theme rows, no click-to-expand.
- Treatment Paper in light mode, Ink in dark mode.
- Research page (grant grid) stays in the nav. Nick may retire it later.
- Themes are four, as drafted; deception is a project under theme 02, not a theme.
- Headshot stays on the home page, right of the hero text.
- All four tiles ship as the same CSS placeholder.
- Fonts: Fraunces + Inter from Google Fonts, site-wide.
- Navbar is not overridden; the lab name on the home page is the hero eyebrow.
- Footer is in-flow, carries the UT lockup and a short al-folio credit.
- Links use gold-deep in light mode; bright gold is for accents only.
- A one-line recruiting call sits under the link row, switchable from front matter.

- Eyebrow carries the name and the aCDC expansion (Nick, 2026-11-08).

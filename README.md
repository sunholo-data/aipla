# AIPLA — AI in Physics Learning and Assessment

Technical documentation for the AIPLA project at the Center for Digital Education, University of Copenhagen. AIPLA investigates how generative AI can be meaningfully integrated into upper-secondary (stx) physics education in Denmark.

Site: <https://www.sunholo.com/aipla/>

## What's in this repo

This repo holds the **internal-team site** for the AIPLA project. The URL is shared with the project team only, not advertised publicly. All published pages use initials (M, JB, AR, DS, ZL, P2, K) for light anonymisation in case the URL gets discovered.

Internal working materials that contain real names, contract details, raw correspondence, or observation notes are kept out of the repo entirely.

## Public vs. private content

Two stacked safety layers:

1. **`_quarto.yml` render whitelist** — only files explicitly listed become pages. Adding a file to the repo does not auto-publish it.
2. **`.gitignore`** — excludes private content so it never reaches GitHub at all, even as repo source.

Locally-only directories (present on the working machine, never committed):

- `briefs/` — correspondence, work descriptions with real names
- `notes/` — meeting notes, observations
- `admin/` — contract details
- `sources/aipla-proposal/` — grant proposal material

## Site pages

- **Home** (`index.qmd`) — landing + page index
- **About** (`about.qmd`) — project context, ADDIE method, research questions
- **Timeline** (`timeline.qmd`) — 17-week plan, handover fan-out, ownership map
- **Architecture** (`architecture.qmd`) — Strand A ADRs
- **Evaluation** (`evaluation.qmd`) — capability-floor framework
- **Self-hosting** (`self-hosting.qmd`) — UCPH migration table

## Local preview

```bash
quarto preview            # live-reloading preview at localhost
quarto render             # one-shot build to _site/
```

## Deploy

Pushes to `main` trigger the `.github/workflows/publish.yml` action, which renders the site and deploys to GitHub Pages.

Pages must be enabled for the repo: **Settings → Pages → Source: GitHub Actions**.

## Licence

Documentation: CC BY 4.0 (default; subject to revision).
Code (when added): Apache 2.0 unless otherwise specified.

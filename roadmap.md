# AIPLA roadmap — code-verified status

> **Working draft — NOT published.** This is a `.md` file (not in the Quarto
> render whitelist), so it does not appear on the site. It's the staging copy of
> the roadmap; once reviewed it becomes `roadmap.qmd` + a nav entry.
>
> **Verified against code on 2026-06-28**, not against design docs. Each "shipped"
> line was checked against real files/functions/routes in the execution repo
> (`sunholo-data/cphu-aipla-app`), and each "not built" line was confirmed absent
> in code. Three items the docs implied were pending turned out already shipped
> (image upload, curriculum RAG, summary-first report) — corrected below.

Initials per the site convention (M, JB, AR, DS, ZL, P2, K).

## Shipped to dev — verified in code

### This week (2026-06-22 → 28, the pre-freeze push)
- **Teacher co-working co-pilot** — a floating AI partner on the teacher's own pages that **proposes** changes the teacher **Applies** (nothing happens without the teacher's click), with the change appearing alongside their own edits. Live on the class list (create classes / mint join-codes) and read-only on the class detail page (ask about engagement). Conversations resume across visits. *(verified: shared shell + both mounts + propose-only tools + resume.)*
- **Activity-authoring co-pilot** — the AI composes an activity from a teacher's description (lesson prompt, checklists, tables, charts, calculators, notes, solution/upload fields, and proposing a vetted sim). Live on dev; held off test/prod until the AR/JB teaching framework lands. *(verified live via the dev build flag.)*
- **Cross-teacher activity sharing** — duplicate/branch an activity, publish to a shared catalogue, adopt a colleague's, with provenance/history; plus a researcher all-teachers view. *(verified end-to-end.)*
- **Sims as portable MCP Apps** — the physics sims are now served over the open MCP protocol so they can render in external AI hosts, not just our app. *(verified: public endpoint + sim resources.)*
- **Researcher cross-class analytics** — drill-downs, overview, trends, transcripts across all classes for the researcher role. *(verified.)*
- **Rich-document workbench** (RICH-DOC) — rich parsed-document rendering (not a raw dump), a Documents tab + activity-driven workbench shell, an in-place PDF viewer (page-nav / zoom / fullscreen, ACL-gated raw fetch), and student upload feeding the active file to the tutor. *(verified in code: react-pdf `DocumentViewer`, `GET /api/documents/{id}/raw`, upload→`document_ids`. The planned rich-text solution editor was superseded — see next.)*
- **Image-based solution submission** (SUBMIT-1) — students answer with a photo + freehand whiteboard instead of a rich-text editor; the old TipTap editor was removed as dead weight. *(verified in code: `ff7c889` removed TipTap + `WorkbenchSolution`.)*
- Onboarding (auto-seeded demo for a new teacher), workbench trust cards ("shared with the AI"), one unified sim render path, env-level "thinking budget" control. *(verified.)*

### Earlier in v1.1 (shipped before this week — spot-checked, some pre-dating this verification pass)
- **Student image upload** — paperclip/camera in the student chat; the tutor sees handwritten work / setup photos. **(Verified shipped — earlier roadmap wrongly listed this as pending.)**
- **Curriculum RAG grounding** — teachers cite curriculum documents on an activity; the tutor is grounded in them (retrieval + citation + grounding preamble). **(Verified shipped — fuller browsable-corpus UI may still be partial.)**
- **Session report, summary-first** — AI summary primary, transcript collapsed by default. **(Verified shipped.)**
- Teacher UI consolidation; activity element palette (table/chart/calculator/note); activity preview; teacher-attached sim + image materials; voice provider + personas; cost dashboard. *(per implemented/ docs; not re-verified this pass.)*

## In progress
- **Teacher activity authoring** (TAA-1) — the non-sim authoring umbrella. M0+M1 shipped (concept activity, end-to-end); M2 quiz / M4 workbench-type / M6 equipment co-design gated on JB/AR. The one genuinely-open sprint at the freeze.

## Partial — backend done, surface or layers missing
- **Per-code TTL choice** — backend accepts `ttl_days`; **no teacher UI** to pick it yet.
- **Thinking budget** — environment-level only; per-skill / per-turn / per-persona layers not built.
- **Student consent** — only the *recording*-consent attestation (teacher holds signed forms); no per-session student opt-in prompt.

## Not built yet — the backlog (verified absent in code)
**Finish the co-pilot:** chat **history tier** (browse/reopen past chats by class); migrate the activity co-pilot onto the shared shell (de-dup).
**Authoring depth:** the full from-scratch activity authoring (M1+); the AR/JB **teaching framework** that gates the authoring co-pilot for test/prod.
**Student-facing:** end-of-class notes summary; student audio turns.
**Assessment/feedback:** exit ticket; session-report dual-source narrative; student engagement signals.
**Labs:** offline-lab workbench (ground-truth checking) — only stub comments today.
**Teacher tools:** call-teacher (raised hand); lesson-author surface (resolved-prompt preview + trial session); per-code TTL UI; mobile-performance pass.

## Deferred / parked
- **Duplex voice (`gemini_live`)** — TODO stub only; deferred until there's a clear non-Google reason (turn-based speech is the shipped path).
- **Sim-catalogue admin UI** — post-pilot (the pilot runs on the static catalogue + curated additions).
- Cross-teacher attribution polish; the builder "Parameters" tab; the 2010 exam archive (out of scope, Strand C).

## Blocked on people
- **JB/AR:** exit-ticket question set · offline-lab ground-truth model + 2 real experiments · engagement-signal metric set · the authoring teaching framework (un-gates the co-pilot for test/prod).
- **JB:** student-consent wording.
- **R1 decision:** the teacher-analytics framework (don't instrument summary content before it lands).

## Dates
- Mid-point review: 2026-06-26 (done). · M+JB freeze: week 27, 2026-06-29 → 07-05.
- Teacher pilot: 2026-08-14. · Final handover: 2026-09-15.

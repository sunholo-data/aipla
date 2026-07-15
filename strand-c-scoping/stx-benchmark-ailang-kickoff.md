# STX benchmark harness — AILANG implementation kickoff

**For:** an AILANG-aware implementation agent. Design only — nothing has been built.
**Owner:** M. Pedagogical review of results: JB/AR.
**Date:** 2026-07-14
**Context:** [evaluation.qmd](../evaluation.qmd) (model panel / capability floor / versioning),
[notes/2026-07-14-stx-exam-corpus-catalogue.md](../notes/2026-07-14-stx-exam-corpus-catalogue.md)
(the corpus + validation), app-repo design doc 1.1.57 (competency rubrics — the judge discipline).

## Goal

A benchmark harness, written in AILANG, that measures which model tiers can solve Danish stx
Fysik A written-exam problems — calibrated against official answer keys first, then used for
tier descent. Two questions, in order:

1. **Calibration:** does the top-tier model ceiling the ~50 gold items that have official
   answers? (If yes, its answers become trustworthy provisional keys elsewhere, with a
   *measured* error rate.)
2. **Tier descent:** working down the model list, where do tiers start to diverge — overall and
   *per physics topic*?

## Inputs (all exist, all private/gitignored — never publish problem or answer text)

Root: `~/Documents/clients/cph-uni/sources/aswin-july/`

| Input | Path | Notes |
|---|---|---|
| Catalogue | `stx-exam-catalogue.yaml` | 65 units, 258 problems tagged (topic taxonomy, subquestions, modality). Validated 2026-07-14. |
| Answer keys (gold) | `answer-keys/key-{1stx,2stx}-{2023,2024}.json` | 60 subquestions: `{subq, answer}` with linear math (fractions `(a)/(b)`, exponents `^()`). Extractor alongside. |
| Problem texts | `extracted-text/<unit-id>.txt` | Danish; HTML-derived files carry navigation noise; superscripts sometimes split across lines. |
| Marking context | catalogue `general_marking_principles` + per-RoV `per_problem_marking_emphases` | Ministry marking rules incl. the 2025 five-level rubric reference. |

Gold sets: `1stx231-fysa-17052023`, `1stx241-fys-a-27052024`, `2stx231-fys-a-26052023`,
`2stx241-fys-a-03062024` (flagged `has_official_answer_key: true`, `structured_key: ...`).

## Stage 0 — item builder (deterministic, no AI)

Parse catalogue + keys + problem texts into `items.jsonl`, one record per subquestion:

```json
{"item_id": "1stx241-4b", "set": "1stx241-fys-a-27052024", "problem_no": 4,
 "subq": "4b", "title": "Landing", "topics": ["mechanics-kinematics", "data-analysis-modelling"],
 "question_text": "<the subquestion + its problem stem, cleaned>",
 "expected": {"kind": "numeric", "value": 59, "unit": "m/s",
              "raw_key": "<full key text for the judge>", "tolerance_rel": 0.05},
 "flags": ["bilag-dependent"?, "graph-reading"?], "source": "official-key"}
```

Rules:
- **Exclude** the 5 bilag-dependent items (mp4/xlsx required) from the runnable set but keep
  them in the file with a `skipped` flag — the count must be visible, not silent.
- **Graph-reading items (~7):** `kind: "graph-reading"`, wider tolerance (±10% default) and the
  key's value marked as "one accepted reading".
- **Reaction schemes (2–3):** `kind: "symbolic"` — judged by LLM, not numeric compare. Their
  nuclide notation in the keys is flattened (mass/charge digits merged); repair by hand in a
  small overrides file, don't parse.
- Numeric parsing of `expected.value`/`unit` from the key text: deterministic regex over the
  final `= <value> <unit>` pattern; anything unparseable goes to a manual-review list, not a
  guess. Default `tolerance_rel` 0.05 (marking convention: 1–2 significant-figure differences
  must not change the grade); per-item override supported.
- Question text extraction: from `extracted-text/<set>.txt`, slice the problem by its numbered
  heading; normalize the split-superscript artifact (`137,0·10` newline `3` → `137,0·10^3`).

Expect **~50 runnable gold items**. Stage 0 output is reviewed by M before any AI runs.

## Stage 1 — gold calibration run

For each runnable item × the **top-tier model only**:

- **Solver prompt (Danish):** the student role — solve the subquestion, show the method,
  formula first, end with `FACIT: <value> <unit>` on its own line. Allow standard Databog
  constant values. No tools, no web. System prompt states the stx context + the answer-format
  contract; item text is the user message.
- **Grading, two layers:**
  1. Deterministic: parse the `FACIT:` line, normalize units (a small unit table: J/kJ/GJ, s/h,
     m/s ↔ km/h, N/kN, V, A, Ω, T, Bq, mm/m…), compare within tolerance.
  2. LLM judge (schema-enforced JSON via `callJson`) only when deterministic parsing fails or
     `kind != numeric`: given the model's full answer + the official `raw_key`, return
     `{verdict: correct|incorrect|ambiguous, reason}`. Judge prompt must state: judge the final
     result against the key, method differences are fine, unit errors are wrong.
- **Output:** `runs/<run-id>/results.jsonl` (per item: model, verdict, parsed answer, expected,
  latency, tokens incl. cache telemetry) + `report.md` (score overall + per topic + per set;
  every incorrect/ambiguous item listed with the model's answer vs key).

Decision gate (M + JB/AR read the report): top-tier score ≥ ~95% → proceed; below → inspect
before trusting any model-generated keys.

## Stage 2 — tier descent

Same items, same prompts, same grading — over a **configurable model panel**, one run per model.
Panel lives in `bench-config.json`, not code. Initial suggestion (implementer: verify current
model ids against providers at build time, do not trust this list):

- Gemini tier ladder (the app's stack): `gemini-3-pro` → `gemini-3-flash` → `gemini-2.5-flash`
  → `gemini-2.5-flash-lite`
- Cross-vendor spot checks (optional flag): one Claude tier, one open-weights model via the
  configured provider.

Report adds: per-model × per-topic matrix; **divergence list** (items the top tier gets right
and a lower tier gets wrong — grouped by topic); cost per model per item (token telemetry);
and the **student-difficulty correlation**: catalogue forcensur notes flag which subquestions
students found hardest — report whether model failures rank the same way (research observation
for JB/AR, one table, no claims).

## Stage 3 — provisional keys for 2016–2022 (gated, do not build until Stage 1 passes)

Top-tier model generates keys for the ~200 uncatalogued-answer problems; cross-check each
against the RoV `per_problem_marking_emphases` for its set/year where present; disagreements go
to a JB/AR sampling list. Output shape identical to `answer-keys/key-*.json` plus
`{source: "model-generated", model, run_id}`. Never mixed into the gold files.

## AILANG specifics (verified against ailang-docs, v-latest)

- **Per-call model selection is native:** `std/ai.step(model, messages, tools) -> Result[StepResult, AIError]`
  — pass the panel model string per call; `model=""` uses the handler default. This is the
  tier-descent primitive.
- **Judge:** `std/ai.callJson(input, schema)` — provider-enforced JSON schema.
- **Caching:** `stepWithCache` with a `{position: "system", ttl: "ephemeral"}` breakpoint — the
  solver system prompt is identical across ~50 items; cache telemetry lands in `StepResult`.
- **Errors:** use the `Result`-returning variants throughout; retry only when
  `AIError.retryable`; `BudgetExhausted` must halt the run cleanly with partial results saved.
- **Effects/caps:** `AI`, `FS`, `IO` (+ `Env` for keys). No `Net` beyond the AI providers, no
  `Process`.
- **Determinism:** stamp a run manifest (`runs/<run-id>/manifest.json`: model ids, prompt
  hashes, item-file hash, date, ailang version) — this is the versioning contract from
  evaluation.qmd. Item order fixed; temperature 0 or provider minimum.
- The stdlib has `std/json`, `std/math`, `std/string` for all Stage-0 parsing. YAML: the
  catalogue is also parseable as JSON via a pre-step if AILANG lacks a YAML reader — check
  `docs_search("yaml")`; if absent, add a one-line Python pre-conversion to the repo, don't
  write a YAML parser.
- **Keep the grading core pure + contracted (forward requirement, costs nothing now).**
  Structure the deterministic grader — FACIT-line parsing, unit normalization, tolerance
  compare — as `pure func`s with `requires`/`ensures` contracts (e.g. `requires
  { tolerance_rel > 0.0 }`, `ensures` the verdict is one of the three legal values), separate
  from all effectful code (FS/AI/IO stays in the harness shell). Two reasons: (a) contracts are
  Z3-verifiable (`ailang verify`) — a provably-correct grader is a strong claim for a research
  instrument; (b) the AILANG interpreter compiles to WASM (docparse already runs fully
  in-browser), so a pure grader module can later run **client-side in the AIPLA app** — instant,
  zero-token answer checking for the TAA quiz work, same code as the benchmark. Don't build the
  WASM packaging now; just don't preclude it (no effects in the grading path).

## Constraints

- **Copyright/privacy:** exam problem text and key text never leave the local machine except
  inside model API calls; results/reports may quote item ids, topics, scores — never full
  problem text. Everything under `sources/` stays gitignored.
- **Cost guardrail:** ~50 items × ~6 models × (1 solver + ≤1 judge call) ≈ ≤700 calls. Set the
  AILANG capability budget accordingly; a full run should be single-digit dollars. Stage 3 is
  ~200 items on one model — separate budget, separate invocation.
- **Language:** solver prompts and expected answers are Danish; the judge prompt may be English
  with Danish quotes inline.

## Acceptance

- [ ] Stage 0 emits ~50 runnable items + explicit skipped/manual-review lists; M signs off on a
  sample of 10 before Stage 1.
- [ ] Stage 1 report: per-item verdicts against official keys, deterministic-vs-judge decision
  visible per item; rerunning with the same manifest reproduces identical verdicts.
- [ ] Stage 2: one command, panel from config, produces the matrix + divergence + cost tables.
- [ ] A dry-run mode (`--models none` or similar) exercises Stage 0 + grading on the official
  keys themselves (keys fed back as "answers" must score 100% — the self-test for the grader).
- [ ] No AILANG run required for this doc — implementation agent starts from here.

## Non-goals (for now)

- No app-repo integration (the app's eval runner consumes results later; formats are JSONL
  precisely so that's trivial).
- No multimodal items (bilag mp4/xlsx problems) — v2 candidate once the text benchmark is stable.
- No public leaderboard/publication — results feed evaluation.qmd summaries as aggregates only.
- No WASM packaging yet — but the pure-grader requirement above keeps the door open: the
  benchmark's grading module is the future **in-browser answer checker** for the app (M,
  2026-07-14). When that lands it routes through the app repo as its own design doc, not this
  harness.

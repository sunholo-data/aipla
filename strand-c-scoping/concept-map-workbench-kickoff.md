# Strand C kickoff: concept-map workbench component

*2026-07-10. Strand C's C3 (student models) starts as a thin build, not a literature
review: a new workbench type that makes the teachable-robot mechanic real on one
topic. The scoping note's C3 section is then written from what the prototype teaches.*

## What to build (thin slice)

A **concept-map editor** as a workbench type, paired with a tutor skill that answers
**from the map, not from the model's own physics knowledge**.

- **Workbench side:** nodes (concepts) and labelled edges (relations) the student can
  create, connect, and edit. One topic to start — pick a mechanics topic with an
  existing reference network (FCI-adjacent, Koponen & Nousiainen lineage; AR chooses).
- **Tutor side (the teachable robot):** the map is the closed world. The robot's
  answers verbalize a traversal of the student's network — wrong map, wrong answers,
  visibly. Students correct the robot by showing evidence (an experiment result, a
  worked problem); accepted evidence updates the map, which changes the answers.
- **Reference comparison:** a curated reference network for the topic; a diff
  (missing nodes, wrong/absent edges) surfaced as formative feedback and visible to
  the teacher.

## The make-or-break constraint

An LLM "knows" the right physics regardless of the map. If it answers from that
knowledge, the map is decorative and the mechanic collapses. Enforce closed-world:
the answering prompt sees only the serialized student map (plus the question), never
the topic knowledge — and the eval below checks for leakage.

## What the scoping note needs from the prototype

1. **Extraction consistency** — can the LLM reliably turn free-form student input /
   evidence into map updates? Trial against curated examples.
2. **Reference alignment** — do LLM-built maps compare sanely against the
   expert reference (calibrate on a concept inventory where one exists)?
3. **Leakage rate** — how often does the robot answer from its own knowledge despite
   the closed-world prompt? This number decides feasibility.
4. **Privacy posture** — a student-understanding model is sensitive data; GDPR
   analysis in scope from day one (where stored, retention, group vs individual).

## Relation to the app repo's existing specs (verified 2026-07-10)

The app repo already holds two adjacent design docs (both design-only, no code —
verified against `activity_config.py`, which has no `concept_map` field and no
`conceptMap` element kind):

- `docs/design/aipla/v1.1.0-feedback/living-concept-map.md` — M0–M3 execution spec:
  a **teacher-authored prerequisite DAG** the tutor *checks off* as students
  demonstrate concepts (LLM-as-judge + reconciling pass), with per-node
  precision/recall calibration **gated on the capability-floor eval (SEQUENCE 1.5)**.
  Awaiting M's UX-coherence-gate call.
- `docs/design/aipla/post-pilot/knowledge-graph-and-student-matching.md` — Year-2
  vision: longitudinal per-group mastery over the graph + cross-group matching.

**The delta this brief adds is the mechanic, not the substrate.** The living concept
map is *AI observes the student* (check-off against a teacher's map); the teachable
robot is *student teaches the AI* (the robot answers **only from the student's map**,
closed-world — a constraint neither existing doc has). Reuse the M0 map-editor
element and graph persistence from the living-concept-map spec; the new pieces are
the closed-world answering skill, the student-editable (not teacher-authored) map,
and the reference-network diff. Both mechanics' evals want the same SEQUENCE-1.5
harness — a second reason the capability-floor eval comes first.

## Fit

Lands on the existing Chatbot | Workbench form factor and extends the workbench-type
set from the breadth-demo sprint. Same review/deploy machinery; the new pieces are
the map editor component, the closed-world answering skill, and map persistence.

## Sequence

1. AR picks the topic + drafts the reference network (this week).
2. App-agent brief for the editor component + closed-world skill.
3. Run the four assessments above on the thin slice.
4. Write the C3 section of the scoping note from the results; C1/C2 sections proceed
   in parallel as desk research (C2's Plaud-like recording angle now also overlaps
   the autumn data-collection scoping).

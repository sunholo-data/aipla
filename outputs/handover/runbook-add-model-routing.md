# Runbook: add a new model to the routing layer

**Reader:** AD
**Status:** stub — fill from the execution repo

## To cover

- The routing layer's shape (ADR-003 four tiers) and where per-task-class model
  choice is configured
- Adding a cloud model vs a local/Ollama model; EU-region and GDPR constraints on
  the choice
- Cost controls: budget enforcement (ADR-014), thinking-budget env control
- Canarying a model change and rolling it back

## Verification

- [ ] One model swap performed on dev from these steps alone

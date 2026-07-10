# Runbook: onboard a new teacher / class

**Reader:** AR + AD (the August pilot makes this the first runbook actually needed)
**Status:** stub — fill from the execution repo

## To cover

- Teacher account creation (Google-linked login) and role assignment
- Creating a class, minting join-codes (incl. TTL), the group-ID identity model
  (ADR-001 — group, not student, is the unit)
- Seeding or adopting activities (own, shared catalogue, demo seed)
- Consent prerequisites before any student use — what must be signed and recorded
  first (JB owns the forms; the system records attestation)
- Where the class's data lands (Firestore app state, BigQuery chat logs) and how to
  verify a session was captured

## Verification

- [ ] A test teacher + class run end-to-end from these steps alone, on test (not dev)

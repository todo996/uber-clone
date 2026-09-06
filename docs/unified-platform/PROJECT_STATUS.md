# Unified Platform — Project Status

Last updated: 2026-09-07 (Asia/Ho_Chi_Minh)

## Branch

```text
feature/unified-platform-docs
```

## Overall state

- Documentation: **INITIAL MASTER SPEC COMPLETE / READY FOR OWNER REVIEW**
- Product code: **NOT STARTED ON THIS BRANCH**
- `master`: intentionally untouched by this documentation work

## Approved product direction

- [x] Keep Firebase as the backend platform.
- [x] Build one unified Web App for Customer + Driver.
- [x] Web is mobile-first and deployable to Vercel.
- [x] Build one unified Flutter Mobile App codebase for Android + iOS.
- [x] Reuse behavior/data contracts from current User + Driver apps.
- [x] Add immediate and scheduled standard rides.
- [x] Add immediate and scheduled shared rides.
- [x] Add local delivery.
- [x] Add intercity cargo matching for cars and trucks.
- [x] Add Driver dashboard and service-specific workflows.
- [x] Keep legacy apps as references until migration passes.
- [x] Do not use demo images as a source of truth; UI is specified in text and component/screen requirements.

## Documentation status

- [x] Master specification and read order.
- [x] Current source-code audit.
- [x] Product/feature catalog.
- [x] Target project architecture.
- [x] Firebase compatibility + new data model.
- [x] Detailed UI/UX screen specification.
- [x] Service state flows/business rules.
- [x] Web + Android/iOS build specification.
- [x] Security/reliability/release requirements.
- [x] P0–P10 implementation roadmap.
- [x] Localization/i18n specification.
- [x] AI/engineer handoff instructions.
- [ ] Final source-field inventory from every legacy Firebase read/write — P0 execution task.
- [ ] Final admin compatibility inventory — P0 execution task.
- [ ] Exact Firebase Rules implementation — implementation task.
- [ ] Exact Firestore indexes generated from real implementation queries.
- [ ] Final pricing policy values — owner/product configuration before production.
- [ ] Final cancellation/fee policy values — owner/product configuration before production.
- [ ] Final service-region configuration — owner/product configuration before production.

## UI reference policy

- Demo images have been removed from this branch.
- `05_UI_UX_SPEC.md` is the UI/UX source of truth.
- Actual legacy User/Driver source remains the behavioral reference for existing flows.
- Production UI must be verified from the running Web/Android/iOS builds rather than static demo artwork.

## Implementation phases

| Phase | Name | State |
|---|---|---|
| P0 | Audit / contract freeze / security cleanup | NOT STARTED |
| P1 | Foundations / design system | NOT STARTED |
| P2 | Auth / roles / driver onboarding | NOT STARTED |
| P3 | Standard ride parity | NOT STARTED |
| P4 | Active ride / history / earnings | NOT STARTED |
| P5 | Scheduling / shared ride | NOT STARTED |
| P6 | Delivery | NOT STARTED |
| P7 | Intercity cargo | NOT STARTED |
| P8 | Notifications / payments / ratings | NOT STARTED |
| P9 | Hardening / commercial polish | NOT STARTED |
| P10 | Release / migration | NOT STARTED |

## Critical security blockers discovered before implementation

- [ ] Revoke exposed Firebase/Google service-account key externally.
- [ ] Remove privileged service-account usage from client notification implementation.
- [ ] Move Stripe secret/payment-intent creation to trusted server-side Firebase Function.
- [ ] Review Firebase RTDB/Firestore/Storage rules before production.

These are deliberately left unchecked because writing documentation does not revoke external Google Cloud credentials or change production security configuration.

## Recommended implementation branch

After owner review/approval, create a separate implementation branch from the approved documentation state:

```text
feature/unified-platform
```

Implementation should begin at P0, not directly at UI coding, because the legacy Firebase contracts and exposed-secret cleanup are release-critical dependencies.

## Agent update rules

Every AI/engineer working on this project must update this file when a phase changes state.

Allowed phase states:

```text
NOT STARTED
IN PROGRESS
BLOCKED
READY FOR MANUAL VERIFY
PASS
```

A phase cannot be marked `PASS` unless its gate in `09_IMPLEMENTATION_ROADMAP.md` has been met.

## CI policy

Do not enable expensive automatic emulator/screenshot builds on every branch push unless the project owner explicitly requests it. Manual verification should be preferred for costly workflows.

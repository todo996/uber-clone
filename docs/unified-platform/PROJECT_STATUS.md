# Unified Platform — Project Status

Last updated: 2026-09-07 (Asia/Ho_Chi_Minh)

## Branch

```text
feature/unified-platform-docs
```

## Overall state

- Documentation: IN PROGRESS / INITIAL SPEC CREATED
- Product code: NOT STARTED ON THIS BRANCH
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

## Documentation status

- [x] Master specification
- [x] Current code audit
- [x] Product/feature catalog
- [x] Target architecture
- [x] Firebase data model
- [x] UI/UX specification
- [x] Service flows/business rules
- [x] Web + Android/iOS build specification
- [x] Security/reliability/release requirements
- [x] P0–P10 roadmap
- [ ] Final source-field inventory from every legacy Firebase write/read
- [ ] Final admin compatibility inventory
- [ ] Exact Firebase Rules implementation
- [ ] Exact Firestore indexes generated from implementation queries
- [ ] Final pricing policy values
- [ ] Final cancellation/fee policy values
- [ ] Final service-region configuration

## UI concept asset status

Target asset references:

- [ ] `assets/web-desktop-overview.jpg`
- [ ] `assets/web-mobile-overview.jpg`
- [ ] `assets/user-driver-original-concept.jpg`
- [ ] `assets/driver-dashboard.jpg`
- [ ] `assets/driver-new-trip.jpg`
- [ ] `assets/driver-active-trip.jpg`
- [ ] `assets/driver-delivery.jpg`
- [ ] `assets/driver-intercity-cargo.jpg`

Mark each item complete after the actual binary asset is committed to this branch.

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

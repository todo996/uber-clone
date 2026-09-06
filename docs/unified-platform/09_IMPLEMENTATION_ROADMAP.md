# 09 — Implementation Roadmap (P0–P10)

## Working branch policy

Current documentation branch:

```text
feature/unified-platform-docs
```

Recommended implementation branch after documentation approval:

```text
feature/unified-platform
```

Do not code directly on `master` during the migration. Merge only after phase gates pass.

---

# P0 — Audit, contract freeze and security cleanup

## Goal

Freeze the current legacy behavior so the new clients can remain compatible while security problems are removed.

## Tasks

- [ ] Audit all User app Firebase paths.
- [ ] Audit all Driver app Firebase paths.
- [ ] Audit Admin panel reads/writes that touch users/drivers/trips.
- [ ] Record standard ride `tripRequest` shape as compatibility contract.
- [ ] Record all observed ride status values.
- [ ] Record driver registration fields and storage paths.
- [ ] Record earnings/history data sources.
- [ ] Record current Google Maps/Directions usage.
- [ ] Record push notification flow.
- [ ] Remove privileged service-account key from client source.
- [ ] Revoke leaked service-account key operationally.
- [ ] Remove Stripe secret usage from client architecture.
- [ ] Draft Firebase security rules tests.
- [ ] Change costly build-preview workflow to manual trigger if approved.

## Gate

P0 passes when contracts are documented, secrets are not required client-side, and current behavior has a testable compatibility map.

---

# P1 — Repository foundation and design system

## Goal

Create production foundations without implementing full booking flows yet.

## Web tasks

- [ ] Create `apps/web` Next.js App Router project.
- [ ] TypeScript strict mode.
- [ ] lint/typecheck/test/build scripts.
- [ ] Firebase Web configuration module.
- [ ] environment validation.
- [ ] responsive shell.
- [ ] customer bottom navigation.
- [ ] driver bottom navigation.
- [ ] design tokens.
- [ ] reusable buttons/forms/cards/bottom sheets/dialogs.
- [ ] map shell/component abstraction.
- [ ] PWA manifest baseline.

## Mobile tasks

- [ ] Create `apps/mobile` unified Flutter project.
- [ ] Android target configured.
- [ ] iOS target configured.
- [ ] Firebase app initialization.
- [ ] routing shell.
- [ ] design system.
- [ ] customer navigation.
- [ ] driver navigation.
- [ ] shared map abstraction.

## Shared tasks

- [ ] Add `packages/contracts` schemas.
- [ ] Add architecture lint/import rules where practical.
- [ ] Add base error model.
- [ ] Add logger/analytics interface.

## Gate

- Web builds production successfully.
- Flutter analyze/test pass.
- Android debug build succeeds.
- iOS no-codesign compile validation succeeds where build environment permits.
- UI shell matches approved direction on mobile widths.

---

# P2 — Authentication, account modes, driver onboarding

## Customer identity

- [ ] Sign-in/register.
- [ ] Firebase session restoration.
- [ ] user profile.
- [ ] block status.
- [ ] permission error handling.

## Driver identity

Port current functional steps:

- [ ] basic information.
- [ ] identity document.
- [ ] selfie.
- [ ] driving license.
- [ ] vehicle information.
- [ ] vehicle registration documents.
- [ ] verification status screen.
- [ ] approved/rejected handling.

## Mode switching

- [ ] customer → driver conversion CTA.
- [ ] approved driver role switch.
- [ ] persist active mode preference.
- [ ] route guard by role/verification.

## Vehicles

- [ ] multi-vehicle model.
- [ ] active vehicle selection.
- [ ] service eligibility display.

## Gate

A single real Firebase account can use Customer mode, complete driver onboarding, and after approved test state switch into Driver mode on Web and Mobile.

---

# P3 — Standard ride parity

## Customer

- [ ] current location.
- [ ] address search.
- [ ] pickup/drop-off map selection.
- [ ] directions/polyline.
- [ ] vehicle class selection.
- [ ] fare quote adapter.
- [ ] optional bid.
- [ ] payment method selector.
- [ ] create real `tripRequest` compatible with legacy.
- [ ] cancel request.
- [ ] no-driver state.

## Dispatch

- [ ] read existing `onlineDrivers` compatibility source.
- [ ] driver eligibility filter.
- [ ] request timeout.
- [ ] driver assignment.
- [ ] legacy `newTripStatus` compatibility.

## Driver

- [ ] online/offline.
- [ ] live location.
- [ ] receive standard ride.
- [ ] accept/decline.

## Gate

Cross-client matrix must work:

- New Web Customer → legacy Driver app.
- Legacy User app → New Mobile Driver where compatible.
- New Web Customer → New Web Driver active session.
- New Mobile Customer → New Mobile Driver.

At least one full end-to-end standard ride completes for each supported matrix chosen for release.

---

# P4 — Active ride execution, history, earnings

## Trip execution

- [ ] accepted state.
- [ ] driver to pickup.
- [ ] arrived.
- [ ] passenger onboard/start.
- [ ] on-trip live location.
- [ ] destination navigation.
- [ ] end trip.
- [ ] recovery after refresh/restart.

## Customer active UI

- [ ] driver card.
- [ ] ETA.
- [ ] realtime marker.
- [ ] call/message action.
- [ ] timeline.

## Driver active UI

- [ ] navigation map.
- [ ] next valid state CTA.
- [ ] customer detail.
- [ ] fare summary.

## History and earnings

- [ ] customer ride history.
- [ ] driver trip history.
- [ ] driver earnings dashboard.

## Gate

Trip survives app/page restart at every major state and reconstructs correctly from Firebase.

---

# P5 — Scheduling and shared rides

## Scheduling foundation

- [ ] immediate/scheduled selector reusable across services.
- [ ] scheduled job schema.
- [ ] server timestamps/timezone handling.
- [ ] activation/matching schedule function.
- [ ] reminders.
- [ ] upcoming jobs UI.

## Shared ride

- [ ] shared ride offer/request model.
- [ ] seat capacity.
- [ ] atomic seat reservation.
- [ ] matching by route/time.
- [ ] shared ride result cards.
- [ ] scheduled shared ride.
- [ ] immediate shared ride.
- [ ] ordered stops.
- [ ] driver multi-passenger UI.
- [ ] board/no-show/drop-off states.
- [ ] capacity release on cancellation.

## Gate

Race test proves the last available seat cannot be overbooked, and a multi-stop shared ride can complete with at least two passenger bookings.

---

# P6 — Local delivery

## Customer

- [ ] sender.
- [ ] receiver.
- [ ] item details.
- [ ] photos.
- [ ] weight/dimensions.
- [ ] vehicle class.
- [ ] immediate/scheduled.
- [ ] quote.
- [ ] create order.

## Driver

- [ ] request preview.
- [ ] accept.
- [ ] pickup navigation.
- [ ] pickup confirmation.
- [ ] pickup photo/OTP.
- [ ] delivery navigation.
- [ ] delivery OTP/photo.
- [ ] complete.

## Gate

Real Firebase delivery order completes with required proof and reconnect recovery.

---

# P7 — Intercity cargo and driver routes

## Cargo customer

- [ ] post cargo.
- [ ] origin/destination provinces.
- [ ] precise addresses.
- [ ] weight/volume/dimensions.
- [ ] photos.
- [ ] pickup/delivery windows.
- [ ] proposed price.
- [ ] matches/offers UI.

## Driver route

- [ ] create route.
- [ ] choose vehicle.
- [ ] available payload/volume.
- [ ] accepted categories.
- [ ] departure time.
- [ ] max detour.

## Matching

- [ ] hard capacity filters.
- [ ] route overlap.
- [ ] schedule compatibility.
- [ ] match score.
- [ ] atomic payload + volume reservation.
- [ ] capacity release.

## Execution

- [ ] pickup sequence.
- [ ] loaded/in-transit/delivered states.
- [ ] proof.
- [ ] route completion.

## Gate

Concurrency test proves cargo cannot exceed weight or volume capacity and a route can safely carry multiple matched cargo orders.

---

# P8 — Notifications, payments, ratings and support

## Notifications

- [ ] FCM trusted sender function.
- [ ] Android/iOS push.
- [ ] Web push where supported.
- [ ] notification preference model.
- [ ] scheduled reminders.

## Payments

- [ ] server-side payment function.
- [ ] Stripe or selected provider integration.
- [ ] cash state.
- [ ] webhooks.
- [ ] refund state.

## Ratings

- [ ] customer rates driver.
- [ ] aggregate rating server-side.

## Support

- [ ] cancellation reasons.
- [ ] issue/report entry.
- [ ] audit event visibility for support/admin future use.

## Gate

No payment or notification privileged secret is present in client source; webhook/state tests pass.

---

# P9 — Hardening, performance and commercial polish

- [ ] Firebase Rules comprehensive tests.
- [ ] App Check evaluation/enablement.
- [ ] upload compression.
- [ ] map/listener performance audit.
- [ ] battery/location write audit.
- [ ] accessibility audit.
- [ ] mobile responsive audit 320–480 px.
- [ ] tablet audit.
- [ ] desktop audit.
- [ ] error/empty/offline states complete.
- [ ] localization cleanup.
- [ ] analytics funnel events.
- [ ] crash/error monitoring.
- [ ] secret scan.

## Gate

No P0 security blocker or P9 critical defect remains.

---

# P10 — Release and migration

## Web

- [ ] Vercel project.
- [ ] preview env.
- [ ] production env.
- [ ] domain.
- [ ] Firebase authorized domain.
- [ ] Maps restrictions.
- [ ] production smoke test.

## Android

- [ ] package id.
- [ ] production Firebase Android app.
- [ ] signed AAB.
- [ ] Play release checklist.

## iOS

- [ ] bundle id.
- [ ] production Firebase iOS app.
- [ ] APNs.
- [ ] App Store archive.
- [ ] privacy disclosures.

## Legacy migration

- [ ] compare active legacy usage.
- [ ] confirm data compatibility.
- [ ] decide deprecation plan for old User/Driver apps.
- [ ] do not delete legacy code until owner approves.

## Final gate

Production web + Android + iOS pass the critical E2E matrix with real Firebase staging/production configuration and no mock data.

# AI / Engineer Handoff Instructions

## 1. Read order before coding

Every implementation agent must read, in this order:

1. `README.md`
2. `01_CURRENT_CODE_AUDIT.md`
3. `02_PRODUCT_AND_FEATURE_SPEC.md`
4. `03_ARCHITECTURE.md`
5. `04_FIREBASE_DATA_MODEL.md`
6. `05_UI_UX_SPEC.md`
7. `06_SERVICE_FLOWS.md`
8. `07_WEB_AND_MOBILE_BUILD_SPEC.md`
9. `08_SECURITY_RELIABILITY_RELEASE.md`
10. `09_IMPLEMENTATION_ROADMAP.md`
11. `10_LOCALIZATION_I18N.md`
12. `PROJECT_STATUS.md`

Then inspect the actual legacy source for the phase being implemented.

## 2. Source-of-truth precedence

If sources conflict, use this precedence:

1. Explicit newest project-owner instruction.
2. Approved unified-platform documents on the working branch.
3. Existing production/legacy Firebase behavior required for compatibility.
4. Existing legacy UI implementation.

Do not preserve an insecure legacy implementation merely because it exists in code.

## 3. Coding policy

- Never code directly on `master` unless explicitly instructed.
- Use small, phase-scoped commits.
- Do not redesign data contracts casually during UI work.
- Do not hardcode mock drivers, users, maps, trips, orders, earnings or prices in production code.
- Test fixtures must live in explicit test-only locations.
- Keep Firebase access behind repositories/adapters.
- Keep business state transitions outside UI widgets/components.
- Keep privileged secrets server-side.
- **Vietnamese (`vi`) is the primary/default language; English (`en`) is mandatory secondary language.**
- All user-facing strings must use the localization layer. Do not hardcode UI copy directly in components/widgets.
- Missing localization keys must fall back to Vietnamese.

## 4. Legacy compatibility requirement

Before changing standard-ride behavior, inspect:

- `uber_users_app/lib/pages/home_page.dart`
- `uber_drivers_app/lib/pages/home/home_page.dart`
- `uber_drivers_app/lib/pages/newTrip/new_trip_page.dart`

Current compatibility behaviors include:

- `tripRequest/{tripId}`
- `onlineDrivers`
- `drivers/{uid}/newTripStatus`
- live `driverLocation`
- states `new`, `accepted`, `arrived`, `ontrip`, `ended`

New normalized domain states must map through an adapter while legacy clients remain supported.

Machine states remain language-neutral. Never write Vietnamese or English display strings as Firebase state values.

## 5. Driver onboarding reference

Inspect the existing source under:

```text
uber_drivers_app/lib/pages/driverRegistration/
```

The unified app should retain functionality for:

- basic info
- identity document
- driving license
- selfie
- vehicle info
- vehicle registration documents

Modernize UX but do not accidentally drop verification fields.

## 6. UI policy

Use approved images in `docs/unified-platform/assets/` only as visual and information-hierarchy references.

The actual implementation must:

- use real Firebase state
- be responsive
- have loading/error/empty states
- use Vietnamese as default product copy
- provide complete English equivalents
- render Vietnamese diacritics cleanly
- survive English text expansion without clipping
- have accessible touch targets
- preserve role/service clarity

Language switching must not reset authentication, active trip/order state, map state, or Driver online state.

## 7. Phase workflow

For each phase:

1. Mark phase `IN PROGRESS` in `PROJECT_STATUS.md`.
2. Audit relevant legacy files.
3. Implement smallest complete vertical slice.
4. Implement Vietnamese copy and English translation for that slice.
5. Run required tests/builds in both locales where UI is involved.
6. Fix until green.
7. Update docs if implementation reveals a contract change.
8. Mark `READY FOR MANUAL VERIFY` when owner verification is required.
9. Only mark `PASS` after phase gate is satisfied.

## 8. Build discipline

Web checks:

- install
- lint
- typecheck
- test
- production build
- localization-key parity check (`vi` and `en`)

Mobile checks:

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- localization generation/check
- Android build
- iOS compile check where environment supports it

Do not trigger expensive CI/emulator jobs automatically unless explicitly approved.

## 9. Definition of a complete screen

A screen is not complete if it only matches the concept visually.

A complete screen includes:

- navigation
- real data
- validation
- authorization
- loading
- empty state
- error state
- realtime behavior where applicable
- responsive/adaptive behavior
- Vietnamese primary copy
- English translation
- no missing localization keys
- test coverage appropriate to risk

## 10. Stop conditions

Do not merge/release when any of these remain:

- client-side privileged secret
- permissive/unverified Firebase rules
- production mock data
- build failure
- critical state-transition bug
- duplicated booking on refresh/retry
- overbookable seat/cargo capacity
- role verification bypass
- unrecoverable active trip after restart
- missing Vietnamese production copy
- missing English translation for a released screen
- hardcoded user-facing strings that bypass i18n

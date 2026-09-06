# UberClone Unified Platform — Master Specification

> Branch: `feature/unified-platform-docs`
>
> Purpose: convert the current repository into one commercial-grade ride, shared-ride, delivery and intercity-cargo platform while preserving the existing Firebase project and reusing the working behavior from the current User and Driver Flutter apps.

## 1. Product target

The target product has two first-class clients built from the same product specification:

1. **Web App** — Next.js App Router, mobile-first responsive UI, installable PWA, deployable to Vercel.
2. **Unified Mobile App** — one Flutter codebase producing both Android and iOS builds.

Both clients support the same account switching between:

- Passenger / Customer mode
- Driver / Carrier mode

The legacy apps remain in the repository during migration and are treated as the source of truth for existing ride behavior:

- `uber_users_app/`
- `uber_drivers_app/`
- `uber_admin_panel/`

## 2. Core services

### Passenger / Customer

- Standard ride booking
- Immediate ride booking
- Scheduled ride booking
- Shared ride / seat booking
- Immediate shared ride
- Scheduled shared ride
- Local delivery
- Immediate or scheduled delivery
- Intercity cargo posting
- Live vehicle/driver tracking
- Trip/order status timeline
- Trip history
- Saved profile and payment preferences
- Driver conversion flow from the same account

### Driver / Carrier

- Driver onboarding and verification
- Identity, selfie, driving-license and vehicle information
- Multiple vehicle profiles
- Online/offline availability
- Receive normal ride requests
- Receive shared-ride requests
- Manage multiple passenger pickups/drop-offs for shared rides
- Receive delivery jobs
- Publish intercity routes
- Receive matched intercity cargo
- Track available payload and volume
- Active-trip navigation and status updates
- Earnings, history and ratings

## 3. Existing behavior that must be preserved

The current User app already creates standard rides under `tripRequest`, with pickup/drop-off coordinates and addresses, rider identity, fare, bid, vehicle type and status. It then listens to the same request in realtime for driver assignment and state changes.

The current Driver app already:

- publishes driver location to `onlineDrivers`,
- sets `drivers/{uid}/newTripStatus = waiting`,
- receives trip IDs,
- updates `tripRequest/{tripId}/driverLocation`,
- progresses a trip through accepted/arrived/ontrip/ended states.

These behaviors form the compatibility contract for the new web and unified mobile clients.

## 4. Target repository structure

```text
uber-clone/
├── apps/
│   ├── web/                    # Next.js unified User + Driver web/PWA
│   └── mobile/                 # Flutter unified Android + iOS app
│
├── packages/
│   ├── contracts/              # JSON Schema / OpenAPI-style shared contracts
│   ├── firebase-rules/         # RTDB / Firestore / Storage rules source
│   ├── design-tokens/          # UI tokens shared conceptually across clients
│   └── fixtures/               # test-only fixtures; never production mock data
│
├── firebase/
│   ├── functions/              # trusted server-side Firebase functions
│   ├── firestore.indexes.json
│   ├── firestore.rules
│   ├── database.rules.json
│   └── storage.rules
│
├── docs/unified-platform/      # this specification set
│
├── uber_users_app/             # legacy reference during migration
├── uber_drivers_app/           # legacy reference during migration
└── uber_admin_panel/           # existing admin reference
```

Do not delete or restructure the legacy apps until the new clients pass compatibility tests.

## 5. Documentation map

- `01_CURRENT_CODE_AUDIT.md` — what exists and what is reusable.
- `02_PRODUCT_AND_FEATURE_SPEC.md` — complete feature catalog and business rules.
- `03_ARCHITECTURE.md` — professional target architecture.
- `04_FIREBASE_DATA_MODEL.md` — legacy compatibility + new data model.
- `05_UI_UX_SPEC.md` — UI system and every main User/Driver screen.
- `06_RIDE_AND_SHARED_RIDE.md` — standard ride, scheduling and shared ride.
- `07_DELIVERY_AND_INTERCITY_CARGO.md` — delivery and cargo matching.
- `08_WEB_AND_MOBILE_BUILD_SPEC.md` — Next.js web + Flutter Android/iOS requirements.
- `09_SECURITY_RELIABILITY_RELEASE.md` — security, Firebase rules, payments, notifications, testing.
- `10_IMPLEMENTATION_ROADMAP.md` — P0–P10 implementation tasks and acceptance gates.
- `PROJECT_STATUS.md` — durable progress ledger for AI agents.
- `assets/` — approved UI concept images.

## 6. Non-negotiable engineering rules

1. No production mock data.
2. Never put Firebase Admin/service-account private keys, Stripe secret keys or other privileged credentials in Web/Flutter client code.
3. Preserve standard-ride compatibility with current Firebase data until migration is explicitly completed.
4. Mobile-first UI, but desktop/tablet layouts must be intentionally designed rather than stretched mobile screens.
5. User and Driver are roles/modes of the same identity, not separate account systems.
6. All service operations use explicit state machines and idempotent transitions.
7. All writes involving money, rewards, verification, sensitive state transitions or notifications must be trusted/server-side where appropriate.
8. Every phase must build and pass its defined verification before the next phase is marked complete.
9. Do not auto-trigger costly CI from every commit unless explicitly approved. Prefer manual workflow dispatch for verification workflows.

## 7. UI concept assets

The following images are specification references, not literal pixel-perfect requirements:

- `assets/web-desktop-overview.jpg`
- `assets/web-mobile-overview.jpg`
- `assets/user-driver-original-concept.jpg`
- `assets/driver-dashboard.jpg`
- `assets/driver-new-trip.jpg`
- `assets/driver-active-trip.jpg`
- `assets/driver-delivery.jpg`
- `assets/driver-intercity-cargo.jpg`

Implementation must preserve the information hierarchy, service coverage and interaction model shown by these concepts while using production components, real Firebase data and responsive behavior.

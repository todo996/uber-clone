# 03 — Target Architecture

## 1. Architectural goals

- Preserve one Firebase project as the backend platform.
- Keep existing ride behavior compatible during migration.
- Build one unified web app and one unified Flutter mobile app.
- Support passenger and driver modes in both clients.
- Separate UI, domain logic, Firebase adapters and trusted server operations.
- Make future service additions possible without rewriting core ride flows.

## 2. High-level architecture

```text
                    ┌──────────────────────────┐
                    │       Firebase Auth      │
                    └────────────┬─────────────┘
                                 │
                 ┌───────────────┴────────────────┐
                 │                                │
        ┌────────▼────────┐              ┌────────▼────────┐
        │  Next.js Web/PWA │              │ Flutter Mobile   │
        │ User + Driver    │              │ Android + iOS    │
        └────────┬────────┘              └────────┬────────┘
                 │                                │
                 └───────────────┬────────────────┘
                                 │
                ┌────────────────▼────────────────┐
                │            Firebase             │
                │                                 │
                │ Realtime Database               │
                │ Firestore                       │
                │ Storage                         │
                │ Cloud Messaging                 │
                │ Cloud Functions / Scheduler     │
                └─────────────────────────────────┘
```

## 3. Client responsibilities

### Web App

Tech target:

- Next.js App Router
- TypeScript
- React
- Firebase Web SDK
- Google Maps JavaScript API or supported React wrapper
- PWA/service worker
- Vercel deployment

Web responsibilities:

- responsive UI
- foreground geolocation
- web notifications when permission is granted
- user/driver mode switching
- realtime job updates while active
- standard/shared/delivery/cargo workflows

Web limitation to document clearly:

Browser background GPS tracking is not equivalent to native mobile. Driver mode on Web is supported as an active-session client, while the Flutter app is the preferred production driver client for reliable background location and push behavior.

### Unified Flutter Mobile App

Tech target:

- Flutter current stable
- Dart current compatible stable
- Firebase Auth/Database/Firestore/Storage/Messaging
- Google Maps
- native background location strategy
- Android/iOS build from one codebase

Mobile responsibilities:

- full passenger mode
- full driver mode
- background driver location when permitted and compliant
- native push notifications
- camera/document uploads
- deep links

## 4. Domain architecture

Both clients follow the same conceptual modules:

```text
core/
  auth/
  errors/
  config/
  analytics/
  localization/

domains/
  identity/
  users/
  drivers/
  vehicles/
  rides/
  shared_rides/
  delivery/
  intercity_cargo/
  scheduling/
  location/
  matching/
  payments/
  notifications/
  ratings/
  support/

infrastructure/
  firebase/
  maps/
  storage/
  notifications/
  payments/
```

UI screens must call domain services/repositories rather than writing arbitrary Firebase paths directly.

## 5. Firebase responsibility split

### Firebase Auth

Single identity source for both User and Driver modes.

### Realtime Database

Use for low-latency/presence/live state and legacy compatibility:

- `users/{uid}` legacy-compatible profile while migration is active
- `drivers/{uid}` legacy-compatible driver record
- `onlineDrivers/{driverId}`
- `tripRequest/{tripId}` legacy standard ride
- active live locations
- driver presence
- immediate dispatch state where sub-second/realtime subscriptions are useful

### Firestore

Use for structured durable data and richer indexed queries:

- vehicles
- unified booking metadata
- scheduled jobs
- shared ride offers/bookings
- delivery orders
- intercity cargo orders
- driver routes
- ratings/reviews
- audit events
- configuration snapshots

### Storage

Use for:

- avatars
- identity documents
- licenses
- vehicle documents
- delivery/cargo photos
- proof-of-pickup/delivery

Storage paths must be user-scoped and protected by rules.

### Cloud Functions

Trusted server-side operations:

- send FCM notifications
- create Stripe PaymentIntent or other payment-provider actions
- verify privileged state transitions
- scheduled matching jobs
- scheduled booking activation
- transactional capacity reservation for shared rides/cargo
- rating aggregation
- server timestamps/audit logs
- cleanup/expiry tasks

## 6. Compatibility layer

For standard rides, new clients should initially dual-model around the existing `tripRequest` structure rather than immediately replacing it.

Example:

```text
New domain Ride entity
        │
        ├── maps to legacy tripRequest/{tripId}
        │
        └── may additionally write normalized metadata if needed
```

The compatibility adapter owns translation between normalized enums and legacy strings such as:

- `new`
- `accepted`
- `arrived`
- `ontrip`
- `ended`

No UI component should depend directly on those string literals.

## 7. State machines

Every service uses explicit allowed transitions.

### Standard ride

```text
DRAFT
→ REQUESTED
→ MATCHING
→ ACCEPTED
→ DRIVER_ARRIVING
→ DRIVER_ARRIVED
→ IN_TRIP
→ COMPLETED
```

Terminal branches:

```text
CANCELLED
EXPIRED
FAILED
```

Legacy adapter maps these to current Firebase values.

### Delivery

```text
DRAFT → REQUESTED → ASSIGNED → DRIVER_TO_PICKUP
→ PICKED_UP → DELIVERING → DELIVERED
```

### Cargo

```text
POSTED → MATCHING → MATCHED → ACCEPTED
→ PICKUP_SCHEDULED → PICKED_UP → IN_TRANSIT → DELIVERED
```

## 8. Data contracts

Use versioned JSON Schema contracts under `packages/contracts/` for cross-language parity.

Suggested contracts:

- `user.schema.json`
- `driver.schema.json`
- `vehicle.schema.json`
- `location.schema.json`
- `ride.schema.json`
- `shared-ride.schema.json`
- `delivery.schema.json`
- `cargo.schema.json`
- `driver-route.schema.json`
- `money.schema.json`
- `status-event.schema.json`

Generate or manually mirror TypeScript/Dart models from these schemas.

## 9. App structure — Web

```text
apps/web/
├── app/
│   ├── (public)/
│   ├── (auth)/
│   ├── (customer)/
│   ├── driver/
│   ├── api/
│   └── layout.tsx
├── components/
│   ├── ui/
│   ├── maps/
│   ├── booking/
│   ├── driver/
│   └── navigation/
├── domains/
├── lib/
│   ├── firebase/
│   ├── maps/
│   ├── pwa/
│   └── validation/
├── hooks/
├── state/
├── styles/
└── tests/
```

## 10. App structure — Mobile

```text
apps/mobile/lib/
├── app/
├── core/
├── design_system/
├── domains/
│   ├── auth/
│   ├── user/
│   ├── driver/
│   ├── rides/
│   ├── shared_rides/
│   ├── delivery/
│   ├── cargo/
│   └── vehicles/
├── infrastructure/
├── routing/
└── shared/
```

## 11. Environment configuration

Client-side environment variables may contain only public Firebase/Maps configuration.

Never expose:

- Firebase Admin private key
- service account JSON
- Stripe secret key
- private webhook secrets

Use Firebase Functions secrets/runtime configuration for privileged keys.

## 12. Observability

Minimum production observability:

- structured client error reporting
- Firebase Crashlytics for mobile
- web error monitoring
- analytics events for booking funnel
- function logs
- state transition audit logs
- correlation ID per booking/order where practical

## 13. Scalability posture

This is not microservices-first. Keep the backend as a modular Firebase architecture until scale or organizational needs justify extraction.

The domain boundaries and contracts should make later extraction possible without forcing premature infrastructure complexity.

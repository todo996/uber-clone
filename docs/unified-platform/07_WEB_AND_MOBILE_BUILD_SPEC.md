# 07 — Web and Unified Mobile Build Specification

## 1. Delivery target

The finished product must ship as:

1. **One Web App**
   - mobile-first
   - responsive desktop/tablet
   - combines Customer + Driver
   - deploys to Vercel
   - PWA installable

2. **One Unified Mobile App codebase**
   - Flutter
   - builds Android APK/AAB
   - builds iOS IPA/App Store archive
   - combines Customer + Driver

The old separate User and Driver Flutter applications remain reference clients during migration.

## 2. Web application

### Technology

- Next.js App Router
- TypeScript strict mode
- React
- Firebase modular Web SDK
- form/schema validation
- Google Maps JS integration
- PWA manifest + service worker
- Vercel-compatible build

### Required web routes

Suggested route layout:

```text
/
/login
/register
/onboarding

/(customer)/home
/(customer)/ride
/(customer)/ride/[id]
/(customer)/shared-ride
/(customer)/shared-ride/[id]
/(customer)/delivery
/(customer)/delivery/[id]
/(customer)/cargo
/(customer)/cargo/[id]
/(customer)/schedule
/(customer)/history
/(customer)/payments
/(customer)/notifications
/(customer)/profile

/driver
/driver/requests
/driver/ride/[id]
/driver/shared-rides
/driver/delivery/[id]
/driver/cargo
/driver/routes
/driver/earnings
/driver/history
/driver/vehicles
/driver/documents
/driver/profile
```

Route groups may change during implementation, but user-facing capabilities must remain.

### Web app state

Separate:

- auth/session state
- active mode
- active booking/order state
- map/geolocation state
- ephemeral UI state

Avoid placing all state in one global store.

### Web realtime

Use Firebase listeners scoped by screen/domain.

Rules:

- unsubscribe on route/domain disposal
- avoid duplicate listeners after navigation
- use one live-location subscription per active entity
- throttle client location writes to appropriate interval/distance thresholds
- do not write GPS on every browser event without rate control

### Web PWA

Minimum:

- manifest
- icons
- installable shell
- offline fallback shell
- cache static assets
- do not cache private realtime data as public shared cache
- push notification support where browser/platform permits

### Vercel

Required:

- root directory configurable to `apps/web`
- build command documented
- no privileged Firebase secrets in `NEXT_PUBLIC_*`
- preview and production environments separated
- only public Firebase Web configuration in client environment

## 3. Unified Flutter mobile app

### Product model

One authenticated user can have:

```text
roles = [customer]
```

or

```text
roles = [customer, driver]
```

`activeMode` controls the navigation shell.

### Mobile app routing

Suggested logical routes:

```text
/auth
/customer/*
/driver/*
/verification/*
/active-service/*
```

### Android requirements

- current supported Android SDK levels
- notification permission handling
- location permission flow
- background location only when justified and disclosed
- foreground service for active driver tracking where platform rules require it
- Google Maps key configured securely per platform
- Firebase google-services config
- release signing through CI/local secure secrets, never committed

### iOS requirements

- current supported iOS deployment target
- Info.plist permission descriptions
- location permission states
- background location entitlement only if product policy and App Store requirements are satisfied
- push notification entitlement
- Firebase GoogleService-Info config management
- Maps key/config
- release signing/provisioning outside source control

## 4. Shared feature parity matrix

| Feature | Web Customer | Web Driver | Mobile Customer | Mobile Driver |
|---|---:|---:|---:|---:|
| Auth/Profile | Yes | Yes | Yes | Yes |
| Standard ride | Yes | Yes | Yes | Yes |
| Scheduled ride | Yes | Yes | Yes | Yes |
| Shared ride | Yes | Yes | Yes | Yes |
| Delivery | Yes | Yes | Yes | Yes |
| Intercity cargo | Yes | Yes | Yes | Yes |
| Live map | Yes | Yes | Yes | Yes |
| Foreground GPS | Yes | Yes | Yes | Yes |
| Reliable background GPS | No guarantee | Limited | N/A | Yes, native policy dependent |
| Push | Browser dependent | Browser dependent | Yes | Yes |
| Camera proof/documents | Browser camera/upload | Browser camera/upload | Native | Native |
| PWA install | Yes | Yes | N/A | N/A |

## 5. Web/mobile design parity

The apps share:

- service names
- status terminology
- icons meaning
- information hierarchy
- primary action semantics
- validation and business rules

They do not need identical layout code.

Mobile may use:

- bottom sheets
- native camera
- full-screen maps

Desktop web may use:

- split panes
- left navigation rail
- persistent details sidebar

## 6. Firebase adapters

Both clients implement equivalent repository interfaces.

Example conceptual interfaces:

```text
AuthRepository
UserRepository
DriverRepository
VehicleRepository
RideRepository
SharedRideRepository
DeliveryRepository
CargoRepository
DriverRouteRepository
LocationRepository
NotificationRepository
```

No screen writes raw Firebase paths unless inside an infrastructure adapter.

## 7. Map abstraction

Features:

- current position
- pickup/drop-off
- route polyline
- map fit bounds
- nearby drivers
- driver live marker
- shared ride stops
- cargo route

Map UI should call a domain/map service rather than repeat route decoding logic across screens.

## 8. Forms and validation

All forms require:

- schema validation
- inline error messages
- disabled submit while invalid/submitting
- idempotent submission behavior
- upload progress for photos/documents

Critical forms:

- auth/profile
- driver onboarding
- vehicle
- standard ride
- shared ride
- delivery
- cargo
- driver route

## 9. Localization

Primary language for first release: Vietnamese.

Architecture should keep strings outside business logic so English/other languages can be added later.

## 10. Testing pyramid

### Unit

- state transitions
- price/quote utilities
- matching constraints
- capacity math
- validation
- adapters/mappers

### Integration

- Firebase emulator where practical
- booking creation
- driver accept
- shared seat reservation
- cargo capacity reservation
- scheduled activation

### UI/component

- forms
- map state panels
- request cards
- status timelines
- role switching

### End-to-end

Critical journeys:

1. Customer standard ride → Driver accept → complete.
2. Scheduled ride → matching → complete.
3. Shared ride seat reservation → multi-stop driver flow.
4. Delivery → pickup proof → delivery proof.
5. Cargo post → route match → capacity reservation → delivery.
6. Driver onboarding → approval state.

## 11. Build commands — target

Exact package manager commands will be finalized during P1 foundation, but target conventions:

### Web

```text
install
lint
typecheck
test
build
```

### Mobile

```text
flutter pub get
flutter analyze
flutter test
flutter build apk
flutter build appbundle
flutter build ios --no-codesign   # CI verification where applicable
```

## 12. CI policy

Given build/emulator workflows can consume meaningful quota:

- verification workflow should support `workflow_dispatch`
- do not automatically run expensive emulator/screenshot jobs on every commit unless explicitly approved
- lightweight lint/typecheck may be separated from costly build jobs
- manual release workflows for production artifacts

## 13. Definition of done for clients

A feature is not complete when only the UI exists.

Done requires:

- real Firebase integration
- loading/error/empty states
- validation
- permission handling
- reconnect recovery
- tests
- responsive behavior
- no mock production data
- build passes
- documentation/status updated

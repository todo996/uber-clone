# 01 — Current Code Audit

## 1. Scope audited

This document treats the current Flutter User and Driver applications as the behavioral baseline for the unified platform.

### User app

Primary source paths:

- `uber_users_app/lib/main.dart`
- `uber_users_app/lib/pages/home_page.dart`
- `uber_users_app/lib/pages/search_destination_place.dart`
- `uber_users_app/lib/pages/trips_history_page.dart`
- `uber_users_app/lib/pages/profile_page.dart`
- `uber_users_app/lib/authentication/`
- `uber_users_app/lib/methods/`
- `uber_users_app/lib/services/`

### Driver app

Primary source paths:

- `uber_drivers_app/lib/main.dart`
- `uber_drivers_app/lib/pages/home/home_page.dart`
- `uber_drivers_app/lib/pages/newTrip/new_trip_page.dart`
- `uber_drivers_app/lib/pages/driverRegistration/`
- `uber_drivers_app/lib/pages/earnings/`
- `uber_drivers_app/lib/pages/profile/`
- `uber_drivers_app/lib/pages/trips/`
- `uber_drivers_app/lib/pushNotifications/`

## 2. Reusable User behavior

The current User app already implements the core standard-ride state flow:

1. Authenticate user.
2. Check Firebase user record and block status.
3. Acquire current GPS position.
4. Search/select pickup and drop-off.
5. Request directions.
6. Draw route, markers and circles on Google Maps.
7. Calculate/show fare and vehicle option.
8. Allow bid amount.
9. Create `tripRequest/{tripId}`.
10. Search nearby online drivers using `onlineDrivers`/GeoFire.
11. Assign request to `drivers/{driverId}/newTripStatus`.
12. Listen to trip changes in realtime.
13. Show accepted/arrived/ontrip states.
14. Track driver live location.
15. End trip and invoke payment flow.
16. Persist/read trip history.

### Legacy standard ride payload

The current User app writes a structure equivalent to:

```text
tripRequest/{tripId}
  tripID
  publishDateTime
  userName
  userPhone
  userID
  pickUpLatLng
    latitude
    longitude
  dropOffLatLng
    latitude
    longitude
  pickUpAddress
  dropOffAddress
  driverId = waiting
  carDetails
  driverLocation
    latitude
    longitude
  driverName
  driverPhone
  driverPhoto
  fareAmount
  status = new
  bidAmount
  vehicleType
```

This shape must be treated as a compatibility contract for standard rides until legacy migration is explicitly closed.

### Existing User trip states

Observed states used in code:

- `new`
- `accepted`
- `arrived`
- `ontrip`
- `ended`

The new architecture will normalize naming internally but must translate to/from these values while legacy clients remain supported.

## 3. Reusable Driver behavior

The Driver app already implements:

- current GPS acquisition,
- online/offline state,
- live location publishing,
- push-notification registration,
- new-trip reception,
- trip route drawing,
- realtime driver-location writes,
- trip-state progression,
- end-trip fare handling,
- driver registration workflow,
- driver profile and vehicle data,
- earnings/history areas.

### Driver online contract

Current behavior:

```text
onlineDrivers/{driverId}      # GeoFire location

drivers/{driverId}/newTripStatus = waiting
```

When offline, the GeoFire location and trip-status listener state are removed.

### Driver registration screens already present

The existing code provides dedicated screens for:

- basic information,
- national identity/CNIC-like document,
- driver registration flow,
- driving license,
- selfie,
- vehicle information,
- vehicle registration documents.

The new unified app should preserve these functional steps, modernize the UX, adapt labels to the target market, and make verification status visible.

## 4. Existing features to retain

### Authentication

- Firebase Auth
- OTP/phone-related flow
- Google Sign-In in dependencies/current project
- Profile persistence
- Blocked-user handling

### Maps and location

- Google Maps
- Current location
- Pickup/drop-off markers
- Polylines/directions
- Nearby online driver discovery
- Driver realtime updates

### Ride operations

- vehicle choice
- fare estimate
- bidding
- request timeout
- driver selection
- accepted/arrived/ontrip/ended states
- cancellation
- driver contact information

### Driver operations

- online/offline
- location streaming
- new trip request
- route to pickup
- route to destination
- status actions
- earnings/history/profile

## 5. Current weaknesses that must not be copied

### Security

A Firebase/Google service-account credential is embedded in client-side source used for FCM sending. This is a critical credential-leak pattern and must be removed from all new clients. The compromised key must be revoked separately in Google Cloud/Firebase administration.

Stripe secret-key logic is also implemented client-side in the existing User app. The unified platform must move payment-intent creation and privileged payment actions to trusted server-side Firebase Functions.

### Architecture

- Large Flutter screens contain UI, Firebase writes, geolocation and business logic together.
- State transitions are string-based and scattered.
- Error handling is inconsistent.
- Realtime subscriptions are manually managed in screen widgets.
- Shared contracts between User and Driver do not exist.
- There is no formal schema migration strategy.
- Driver availability is partly stored locally using SharedPreferences rather than one durable domain model.

### Web incompatibilities

The current Flutter apps contain mobile-specific packages and behavior such as GeoFire mobile bindings, Android notification channels and native background behavior. The new web app should reimplement the same domain behavior with browser-appropriate libraries instead of trying to compile the old Flutter app unchanged to Web.

## 6. Migration principle

**Reuse behavior and data contracts, not the old screen architecture.**

The new code should be organized by domains/services and state machines, with separate adapters for Firebase, Maps, Notifications and Payments.

The legacy apps stay untouched as a reference until all compatibility tests pass.

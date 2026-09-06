# 08 — Security, Reliability and Release Requirements

## 1. Critical security finding from current source

The current repository contains privileged credential patterns that must not be copied into the new clients.

### Firebase/Google service account

A service-account private key is embedded in client-side notification code. Treat that credential as compromised because it exists in repository history.

Required operational action outside code:

1. Revoke/delete the exposed key in Google Cloud/Firebase administration.
2. Create a replacement credential only if server-side infrastructure requires one.
3. Store server credentials only in Firebase Functions/Vercel secure environment configuration as appropriate.
4. Never commit the replacement credential.

### Stripe secret

Current client code creates Stripe PaymentIntents using a secret key from the app. That architecture is not permitted in the new clients.

Use trusted server-side functions to:

- create PaymentIntent
- validate amount/currency
- handle webhook events
- mark payment status
- perform refunds

Client receives only client-safe identifiers/secrets required by the payment SDK.

## 2. Authentication

- Firebase Auth is the identity provider.
- UI session state is not authorization.
- Every sensitive Firebase read/write is protected by rules and/or trusted function checks.
- Account block/suspension is checked at sign-in/session recovery and before sensitive service creation.

## 3. Role authorization

A client cannot self-grant Driver role or service eligibility.

Trusted driver fields:

```text
verificationStatus
serviceEligibility
approvedVehicleIds
accountStatus
```

These must be admin/server controlled.

## 4. Firebase Realtime Database rules

Rules must enforce at minimum:

- authenticated access
- owner-scoped profile writes
- no arbitrary write to another user's profile
- driver can update own live location only
- user can create own trip request
- only assigned driver can update allowed driver-side fields/status
- blocked accounts denied service operations
- validation on expected types/fields where practical

Legacy compatibility rules should be tightened without breaking required flows.

## 5. Firestore rules

Rules must protect:

- bookings
- vehicles
- delivery orders
- cargo orders
- driver routes
- ratings
- status events

Prefer trusted Functions for operations requiring multi-document invariants.

## 6. Storage rules

Requirements:

- authenticated user-scoped paths
- driver documents accessible only to owner and authorized admin/server contexts
- file size limits
- MIME/content type restrictions where possible
- proof photos scoped to related order participants/admin
- no globally public identity/license documents

## 7. Location privacy

Driver live location is sensitive operational data.

Rules:

- expose precise driver position only to eligible active matching/booking participants
- do not keep public permanent live-location history by default
- expire ephemeral live-location records
- passenger location is visible to assigned driver only when operationally needed
- shared ride passengers must not see each other's private contact information

## 8. PII minimization

Do not expose unnecessary:

- phone numbers
- full identity documents
- driver document URLs
- payment data
- passenger addresses outside active service context

Logs must not dump full tokens, credentials or sensitive payloads.

## 9. State transition protection

Sensitive state transitions require guarded logic.

Examples:

- only matching/eligible driver can accept a job
- customer cannot mark own trip completed
- driver cannot mark delivery delivered without required verification when policy enables it
- capacity reservation must be atomic
- payment success cannot be client-declared

## 10. Rate limiting and abuse protection

At trusted function/API layer where applicable:

- notification send rate limits
- booking creation throttles
- OTP/auth provider protections
- cargo posting limits
- upload limits
- repeated cancellation/dispatch abuse monitoring

Firebase App Check should be evaluated for supported clients/services.

## 11. Reliability

### Realtime reconnect

Clients must:

- show network state
- reconnect listeners
- reload authoritative active booking after reconnect
- avoid duplicate subscriptions
- avoid duplicate booking creation

### Offline behavior

Do not pretend a ride request was created if Firebase write has not succeeded.

The UI may retain draft form data locally, but operational state must come from authoritative backend data.

### Crash/restart recovery

On app startup:

1. restore auth
2. load account state
3. detect active/scheduled jobs
4. route to correct active screen
5. resume subscriptions
6. resume driver tracking only when eligible and permissions allow

## 12. Time handling

- Store canonical timestamps server-side when authoritative ordering matters.
- Store timezone/region for scheduled services.
- Display localized time to user.
- Never compare schedule validity using client-local string formats only.

## 13. Money

Use integer minor units or a consistent decimal strategy.

Do not perform authoritative money math using floating point UI values.

Store:

```text
amountMinor
currency
```

Display formatting is client-only.

## 14. Audit logs

For sensitive operations, record:

- entity ID
- prior state
- new state
- actor
- timestamp
- reason/context
- correlation ID

Especially important for:

- driver verification
- service eligibility
- ride cancellation
- delivery proof
- cargo capacity reservation
- payment/refund
- disputes

## 15. Testing gates

Before production release:

### Security

- rules emulator tests
- unauthorized access tests
- role escalation tests
- cross-user document access tests
- secret scan

### Functional

- standard ride E2E
- scheduled booking E2E
- shared ride capacity race test
- delivery proof flow
- cargo capacity race test
- reconnect/recovery

### Performance

- map rendering
- live marker update rate
- listener count
- Firebase read/write volume
- image upload compression
- mobile battery impact under driver tracking

## 16. Release environments

Minimum:

- local/emulator
- staging/preview
- production

Recommended separate Firebase projects for production vs non-production when practical. If the project intentionally keeps one Firebase project during early migration, use strict test namespaces/collections and never mix production users with destructive test data.

## 17. Vercel release

- environment variables configured per environment
- no secret values committed
- production domain HTTPS
- error monitoring enabled
- build output verified
- Firebase authorized domains updated
- Google Maps restrictions set for production domains

## 18. Android release

- signed AAB
- Play Console package name fixed
- production Firebase app registered
- Maps key restrictions
- notification/location disclosure
- privacy policy URL
- release notes
- crash monitoring

## 19. iOS release

- stable bundle ID
- App Store signing/provisioning
- production Firebase app registered
- APNs configuration
- Maps config/restrictions
- privacy permission strings accurate
- background location justified if enabled
- App Privacy answers aligned with real data usage

## 20. Release blocker list

Production release is blocked if any are true:

- privileged secret exists in client/repo
- Firebase rules are permissive/unreviewed
- critical E2E journey fails
- capacity overbooking race exists
- active trip cannot recover after refresh/restart
- payment status is client-authoritative
- driver verification can be bypassed
- production uses hardcoded demo data
- blocking crash/build error remains

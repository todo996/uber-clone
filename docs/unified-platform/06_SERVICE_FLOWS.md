# 06 — Service Flows and Business Rules

## 1. Standard ride — customer flow

```text
HOME
→ choose Đặt xe
→ choose pickup
→ choose destination
→ load route/ETA/distance
→ select vehicle
→ choose immediate or scheduled
→ choose payment
→ optional bid
→ confirm
→ MATCHING
→ DRIVER ACCEPTED
→ DRIVER ARRIVING
→ DRIVER ARRIVED
→ IN TRIP
→ COMPLETED
→ payment/rating/history
```

### Required validation

- authenticated account
- not blocked
- location service available or manual pickup selected
- pickup and destination are valid and different
- vehicle class enabled in service region
- scheduled time valid when scheduled
- payment selection valid

### Matching

Initial compatibility implementation may keep the existing nearby-driver strategy for standard rides:

- discover online drivers
- attempt driver assignment
- timeout
- try next eligible driver

Future implementation may add regional dispatch queues without changing UI contracts.

### Cancellation

Cancellation must record:

- actor
- timestamp
- reason
- prior status
- fee policy result if applicable

Do not simply delete normalized durable booking history. Legacy `tripRequest` cleanup can happen through the compatibility adapter while normalized audit data remains.

## 2. Standard ride — driver flow

```text
OFFLINE
→ ONLINE
→ receive request
→ preview
→ accept/decline
→ navigate pickup
→ arrived
→ passenger onboard
→ start trip
→ navigate destination
→ end trip
→ earnings/history
→ available again
```

### Driver state rules

A driver cannot accept incompatible concurrent standard rides unless the active service is a shared ride designed for multi-passenger operation.

A driver must be:

- approved
- unblocked
- online
- using verified active vehicle
- eligible for service type

## 3. Scheduled standard ride

### Customer

- chooses date/time
- confirms booking
- sees booking under “Sắp tới”
- can cancel according to policy
- gets reminder before matching
- gets driver assignment notification

### System

```text
SCHEDULED
→ READY_FOR_MATCHING at matchAt
→ MATCHING
→ ASSIGNED
→ normal ride execution
```

If no driver is matched by configured threshold:

- notify user
- optionally expand matching radius
- optionally request user confirmation to keep waiting
- cancel/refund automatically when policy requires

## 4. Shared ride — two operating models

The architecture supports both models so product policy can evolve.

### Model A — system/driver route offer

A route has:

- driver
- vehicle
- departure window
- seat capacity
- route corridor

Users book seats into compatible route offers.

### Model B — user demand aggregation

Users submit compatible requests; system groups them and assigns an eligible driver.

Phase implementation should start with the simpler deterministic model defined in roadmap, but schemas must not block the other model.

## 5. Shared ride — booking flow

```text
choose Xe ghép
→ pickup + destination
→ immediate/scheduled
→ seat count
→ find compatible offers
→ select offer
→ reserve seats atomically
→ confirm
→ wait for departure/driver
→ track ordered stops
→ board
→ ride
→ drop off
→ complete
```

### Seat reservation

Reservation must be transactional.

Failure cases:

- last seat taken before confirmation
- vehicle/driver cancelled
- departure window expired
- user changed seat count

UI must show recoverable messages and refreshed alternatives.

### Shared ride stop ordering

Every confirmed passenger contributes:

- pickup stop
- drop-off stop

Stop ordering algorithm must obey:

- pickup before corresponding drop-off
- vehicle seat capacity at every segment
- configured maximum detour
- departure/arrival constraints

Phase 1 can use heuristic ordering; route-optimization can be upgraded later behind the same service interface.

## 6. Shared ride — driver operation

Driver sees:

- total seats
- booked seats
- remaining seats
- ordered stops
- next pickup/drop-off
- passenger count at each segment

Driver actions:

```text
start route
→ arrive pickup
→ passenger boarded / no-show
→ continue next stop
→ passenger dropped off
→ finish route after all obligations complete
```

No-show must not silently remove a passenger; record an event and apply policy.

## 7. Local delivery — customer flow

```text
choose Giao hàng
→ pickup/sender
→ destination/receiver
→ item details
→ photo(s)
→ vehicle
→ immediate/scheduled
→ quote
→ confirm
→ assigned driver
→ driver to pickup
→ pickup verified
→ delivering
→ delivery verified
→ completed
```

### Item restrictions

The data model must support policy fields for:

- prohibited items
- fragile
- high value
- temperature sensitivity future-ready
- dangerous goods future-ready but disabled unless regulatory requirements are handled

## 8. Delivery — driver flow

Driver request preview:

- pickup distance
- delivery route
- item category
- weight/dimensions
- payout
- special-handling tags

Execution:

```text
accept
→ navigate pickup
→ arrived pickup
→ inspect/confirm item
→ pickup photo/OTP if required
→ picked up
→ navigate delivery
→ arrived delivery
→ recipient OTP/photo proof
→ delivered
```

### Failed delivery

If receiver unavailable:

- attempt contact
- record reason
- record evidence where policy allows
- support chooses retry/return flow

Do not mark completed without valid proof when proof policy requires it.

## 9. Intercity cargo — customer flow

```text
choose Hàng liên tỉnh
→ Đăng hàng
→ origin/destination
→ cargo size/weight/volume
→ photos
→ pickup window + delivery deadline
→ proposed price
→ post
→ matching
→ receive matching routes/offers
→ accept driver/route
→ capacity reserved
→ pickup scheduled
→ picked up
→ in transit
→ delivered
→ complete/rate
```

## 10. Intercity cargo — driver route flow

```text
Driver mode
→ Hàng liên tỉnh
→ Tạo tuyến
→ choose vehicle
→ origin/destination/waypoints
→ departure time
→ max detour
→ publish route
→ receive matched cargo list
→ inspect fit
→ accept cargo
→ capacity reserved
→ pickup sequence
→ intercity transport
→ delivery sequence
→ route complete
```

## 11. Cargo match scoring

Suggested score components, configurable rather than hardcoded in UI:

```text
matchScore =
  routeOverlapWeight * routeOverlapScore
+ scheduleWeight * scheduleScore
+ capacityWeight * capacityScore
+ detourWeight * detourScore
+ trustWeight * driverTrustScore
```

Hard constraints must be checked before scoring:

- cargo weight fits available payload
- cargo volume fits available volume
- cargo category permitted
- schedule windows do not conflict
- driver/vehicle verified

## 12. Capacity reservation lifecycle

When cargo is accepted:

```text
AVAILABLE
→ RESERVED
→ LOADED
→ DELIVERED
```

If cancelled before pickup:

```text
RESERVED → RELEASED
```

If cancellation occurs after pickup, capacity remains occupied until cargo is returned/delivered/resolved.

## 13. Pricing abstraction

Each service uses a quote model, not scattered formulas in UI.

```text
Quote
  baseAmount
  distanceAmount
  durationAmount
  scheduleAmount
  serviceFee
  demandAdjustment
  bidAmount?
  discount?
  total
  currency
```

For shared ride:

- price may be per seat.

For cargo:

- proposed price / driver offer / agreed price are separate fields.

## 14. Payment states

```text
NOT_REQUIRED
PENDING
AUTHORIZED
PAID
FAILED
REFUNDED
PARTIALLY_REFUNDED
CASH_DUE
CASH_SETTLED
```

Payment state cannot be set authoritative by the client.

## 15. Notifications matrix

### Customer

- booking accepted
- driver approaching
- driver arrived
- scheduled reminder
- shared ride confirmed/changed
- delivery pickup
- delivery completed
- cargo match offer
- cargo pickup/delivery
- cancellation/refund

### Driver

- new immediate request
- scheduled-job reminder
- shared-ride seat added/cancelled
- delivery request
- cargo match
- customer cancellation
- verification update

## 16. Reconnect/recovery rules

Every active job must recover after app refresh/restart:

1. authenticate
2. load active jobs
3. subscribe to latest state
4. reconstruct screen from durable state
5. resume realtime location if Driver and policy/permissions allow

A page refresh must never create a duplicate booking.

## 17. Idempotency

Actions requiring idempotency keys or guarded transitions:

- create booking
- accept job
- reserve shared seats
- reserve cargo capacity
- payment creation
- completion
- refund
- proof submission

## 18. Auditability

Every sensitive transition should have an append-only status event with actor and timestamp so support/admin can reconstruct what happened without relying on client logs.

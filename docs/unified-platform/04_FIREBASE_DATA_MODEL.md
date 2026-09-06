# 04 — Firebase Data Model

## 1. Migration strategy

The new platform keeps the existing Firebase project. Standard rides remain compatible with current Flutter clients while new service domains use normalized structures.

The migration has two layers:

1. **Legacy compatibility layer** — do not break current User/Driver apps.
2. **Normalized domain layer** — new Web + Unified Mobile features.

## 2. Existing Realtime Database contracts to preserve

### `users/{uid}`

Existing clients expect a user record and a `blockStatus` field. The unified clients must continue honoring block state until an explicit migration changes the contract.

Recommended normalized fields while maintaining compatibility:

```json
{
  "name": "string",
  "phone": "string",
  "email": "string",
  "photoUrl": "string|null",
  "blockStatus": "no|yes",
  "createdAt": "timestamp/string",
  "updatedAt": "timestamp/string"
}
```

### `drivers/{uid}`

Must preserve current driver data required by Driver app, including:

- identity/profile fields
- block/verification-related fields already used by project
- `newTripStatus`
- `deviceToken`

New clients should access this through a driver repository/adapter.

### `onlineDrivers/{driverId}`

GeoFire-compatible live location used by legacy User and Driver apps.

Do not rename/remove while legacy apps are active.

### `tripRequest/{tripId}`

Current standard-ride request shape:

```json
{
  "tripID": "...",
  "publishDateTime": "...",
  "userName": "...",
  "userPhone": "...",
  "userID": "...",
  "pickUpLatLng": {
    "latitude": "...",
    "longitude": "..."
  },
  "dropOffLatLng": {
    "latitude": "...",
    "longitude": "..."
  },
  "pickUpAddress": "...",
  "dropOffAddress": "...",
  "driverId": "waiting",
  "carDetails": "",
  "driverLocation": {
    "latitude": "",
    "longitude": ""
  },
  "driverName": "",
  "driverPhone": "",
  "driverPhoto": "",
  "fareAmount": "...",
  "status": "new",
  "bidAmount": "...",
  "vehicleType": "..."
}
```

### Legacy status mapping

| Legacy value | Normalized state |
|---|---|
| `new` | `REQUESTED` / `MATCHING` |
| `accepted` | `ACCEPTED` / `DRIVER_ARRIVING` |
| `arrived` | `DRIVER_ARRIVED` |
| `ontrip` | `IN_TRIP` |
| `ended` | `COMPLETED` |

## 3. New Firestore collections

### `profiles/{uid}`

Optional normalized profile projection for new clients. During migration, RTDB `users` remains authoritative for fields required by legacy apps.

Fields:

```text
uid
name
phone
email
photoUrl
roles: [customer, driver]
activeMode
accountStatus
createdAt
updatedAt
```

### `driver_profiles/{uid}`

```text
uid
verificationStatus
verificationReason
rating
ratingCount
serviceEligibility
activeVehicleId
onlinePreference
createdAt
updatedAt
```

### `vehicles/{vehicleId}`

```text
ownerDriverId
type
make
model
year
color
plateNumber
seatCapacity
payloadCapacityKg
cargoVolumeM3
serviceTypes[]
verificationStatus
documents{}
isActive
createdAt
updatedAt
```

Vehicle types initially:

```text
motorbike
car_4
car_7
van
truck_500kg
truck_1_5t
truck_2_5t
truck_5t
other
```

### `bookings/{bookingId}`

Normalized umbrella record for customer-facing service requests.

```text
id
serviceType: ride | shared_ride | delivery | intercity_cargo
customerId
driverId?
vehicleId?
scheduleMode: immediate | scheduled
scheduledAt?
status
origin{}
destination{}
pricing{}
payment{}
legacyTripRequestId?
createdAt
updatedAt
```

### `scheduled_jobs/{jobId}`

```text
bookingId
serviceType
scheduledAt
matchAt
status
notificationState
createdAt
```

### `shared_ride_offers/{offerId}`

Driver/system-created shared ride capacity:

```text
driverId
vehicleId
origin
destination
routePolylineEncoded?
departureWindowStart
departureWindowEnd
seatCapacity
reservedSeats
availableSeats
maxDetourKm
status
```

### `shared_ride_bookings/{id}`

```text
offerId
customerId
pickup
dropoff
seatCount
price
status
pickupOrder?
dropoffOrder?
createdAt
```

### `delivery_orders/{id}`

```text
customerId
driverId?
vehicleId?
origin
destination
sender{}
receiver{}
item{}
photos[]
scheduleMode
scheduledAt?
status
pricing{}
pickupProof{}
deliveryProof{}
createdAt
updatedAt
```

### `cargo_orders/{id}`

```text
customerId
assignedDriverId?
assignedVehicleId?
origin
destination
cargoCategory
weightKg
volumeM3
dimensions{}
quantity
photos[]
specialHandling[]
earliestPickupAt
latestDeliveryAt
proposedPrice
agreedPrice?
status
createdAt
updatedAt
```

### `driver_routes/{id}`

```text
driverId
vehicleId
origin
destination
waypoints[]
departureAt
estimatedArrivalAt
maxPayloadKg
reservedPayloadKg
availablePayloadKg
maxVolumeM3
reservedVolumeM3
availableVolumeM3
acceptedCargoCategories[]
maxDetourKm
status
createdAt
updatedAt
```

### `cargo_matches/{id}`

```text
cargoOrderId
driverRouteId
driverId
vehicleId
matchScore
routeOverlapScore
detourKm
scheduleScore
capacityScore
priceOffer?
status
createdAt
updatedAt
```

### `ratings/{id}`

```text
bookingId
serviceType
fromUserId
toUserId
score
comment?
createdAt
```

### `status_events/{id}`

Append-only event projection for support/debugging:

```text
entityType
entityId
fromStatus
status
actorType
actorId
reason?
createdAt
correlationId
```

## 4. Realtime live-session paths

For new clients, separate ephemeral live state from durable Firestore order documents.

Suggested RTDB paths:

```text
presence/drivers/{driverId}
liveLocations/drivers/{driverId}
liveBookings/{bookingId}
dispatchQueues/{region}/{serviceType}/...
```

Do not migrate away from `onlineDrivers` until legacy standard rides are validated on the new live-location adapter.

## 5. Shared ride capacity transactions

Seat reservation must be atomic.

Invariant:

```text
0 <= reservedSeats <= seatCapacity
availableSeats = seatCapacity - reservedSeats
```

Reservation requires trusted transaction logic to prevent two users booking the last seat simultaneously.

## 6. Cargo capacity transactions

Payload invariant:

```text
reservedPayloadKg + newCargoWeightKg <= maxPayloadKg
```

Volume invariant:

```text
reservedVolumeM3 + newCargoVolumeM3 <= maxVolumeM3
```

Both must succeed together before a cargo match becomes accepted.

## 7. Storage layout

Suggested paths:

```text
users/{uid}/avatar/...
drivers/{uid}/identity/...
drivers/{uid}/license/...
drivers/{uid}/selfie/...
drivers/{uid}/vehicles/{vehicleId}/...
deliveries/{deliveryId}/item/...
deliveries/{deliveryId}/proof/...
cargo/{cargoId}/item/...
cargo/{cargoId}/proof/...
```

## 8. Security rules principles

- Users can read/update only permitted own profile fields.
- Drivers cannot self-approve verification or service eligibility.
- Customers cannot directly set a booking to completed.
- Drivers can only mutate allowed state transitions on assigned jobs.
- Rating aggregates are server maintained.
- Payment status is server maintained.
- Cargo/seat capacity cannot be client-authoritative.
- Document files must be scoped to owner/admin access and validated for size/type.

## 9. Indexes

Firestore indexes will be required for common queries including:

- bookings by customer + status + createdAt
- bookings by driver + status + scheduledAt
- shared ride offers by status + departure window
- delivery orders by driver + status
- cargo orders by origin region + destination region + status
- driver routes by origin region + destination region + departureAt + status

Exact indexes should be generated during implementation from real query plans rather than guessed globally up front.

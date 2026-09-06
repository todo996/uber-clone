# 02 — Product and Feature Specification

## 1. Product identity

One account, one identity, two operating modes:

- **Customer mode** — book transport or delivery services.
- **Driver mode** — receive jobs, transport passengers/cargo, manage vehicles and earnings.

A verified driver can switch modes without creating a second account.

## 2. Customer mode — global features

### Account and identity

- Register/sign in
- Phone OTP
- Google/Apple sign-in where supported
- Profile photo
- Name, phone, email
- Emergency contact (future-ready)
- Block/suspension state
- Saved places
- Preferred payment method
- Notification preferences
- Convert account to driver

### Home

Primary service cards:

1. Đặt xe
2. Xe ghép
3. Giao hàng
4. Hàng liên tỉnh

Secondary shortcuts:

- Đặt lịch trước
- Lịch sử
- Ví/Thanh toán
- Ưu đãi
- Hỗ trợ

## 3. Standard ride

### Booking inputs

- pickup
- destination
- current GPS as pickup shortcut
- map pin selection
- address search/autocomplete
- vehicle type
- immediate/scheduled departure
- payment method
- optional bid/offer
- rider note

### Vehicle classes

Initial supported classes:

- Motorbike
- Car 4 seats
- Car 7 seats

Architecture must allow adding premium, EV, taxi, van or accessible classes later without schema rewrites.

### Booking outputs

- route preview
- distance
- ETA
- estimated fare
- nearby-driver indication
- booking confirmation

### Active ride

- driver identity and rating
- vehicle and plate
- realtime map position
- driver ETA
- call/message actions
- status timeline
- cancel/support
- trip sharing link capability

## 4. Scheduled ride

Available for standard rides, shared rides and local delivery.

Required fields:

- service type
- date
- local time
- timezone
- pickup window
- optional reminder preferences

Rules:

- booking cannot be scheduled in the past;
- configurable minimum lead time;
- scheduled job enters matching queue before departure based on service policy;
- user is notified on matching, driver assignment, driver approach and cancellation;
- driver must see scheduled jobs separately from immediate requests.

## 5. Shared ride / seat booking

### Customer flow

- select pickup and destination
- choose “Đi ngay” or “Đặt lịch trước”
- choose seat count
- browse matching shared rides or request matching
- show route, departure window, remaining seats, driver, rating and price/seat
- confirm seat booking
- track multi-stop trip

### Driver flow

- enable shared-ride service
- define seat capacity
- accept shared ride requests
- see existing occupants/seats reserved
- see ordered pickup/drop-off stops
- navigation progresses through stop queue
- capacity automatically decrements/increments with bookings/cancellations

### Matching dimensions

- pickup proximity
- destination corridor similarity
- departure time window
- seat availability
- maximum acceptable detour
- driver service eligibility

### Shared ride states

- draft
- searching
- matched
- confirmed
- driver_en_route
- boarding
- in_progress
- completed
- cancelled
- expired

## 6. Local delivery

### Customer inputs

- pickup location
- sender name/phone
- destination
- receiver name/phone
- item category
- weight
- dimensions
- quantity
- item photos
- fragile/high-value flags
- delivery note
- immediate/scheduled time
- vehicle type
- payment preference

### Suggested vehicle mapping

- motorbike: small/light parcels
- car: larger or weather-sensitive parcels
- van/truck classes can be enabled later

### Delivery verification

At pickup:

- pickup confirmation
- photo evidence optional/required by policy
- OTP or sender confirmation optional

At delivery:

- recipient OTP
- photo proof
- signature/recipient name future-ready

### Delivery states

- draft
- requested
- assigned
- driver_to_pickup
- picked_up
- delivering
- delivered
- failed_delivery
- returned
- cancelled

## 7. Intercity cargo matching

Supports both passenger cars with spare cargo capacity and trucks.

### Cargo owner flow

Post cargo with:

- origin province/city
- pickup address
- destination province/city
- delivery address
- cargo category
- weight
- volume
- dimensions
- quantity
- photos
- special handling
- earliest pickup time
- latest delivery time
- proposed price
- notes

### Driver/carrier flow

Publish route with:

- origin
- destination
- optional waypoints
- departure date/time
- estimated arrival
- vehicle
- maximum payload
- available payload
- cargo volume capacity
- available volume
- accepted cargo categories
- maximum detour

### Matching engine dimensions

- route overlap
- pickup/drop-off detour
- schedule compatibility
- payload capacity
- volume capacity
- cargo restrictions
- price expectations
- driver rating/verification

### Load management

The system must maintain:

- vehicle payload capacity
- reserved payload
- available payload
- volume capacity
- reserved volume
- available volume

Capacity updates must be transactional/idempotent to prevent overbooking.

### Cargo states

- posted
- matching
- offer_received
- matched
- accepted
- pickup_scheduled
- picked_up
- in_transit
- delivered
- cancelled
- disputed

## 8. Driver mode — dashboard

Driver home must show:

- identity/avatar
- verification state
- online/offline toggle
- current service modes
- today trip count
- today earnings
- rating
- map and current position
- counts for ride/shared/delivery/cargo requests
- upcoming scheduled jobs
- incentive/reward placeholder

## 9. Driver service eligibility

Each driver account may be eligible for a subset of services based on verified vehicle(s):

- ride
- shared ride
- delivery
- intercity cargo

Service eligibility is server-controlled and cannot be self-granted by modifying client state.

## 10. Driver onboarding

Port the existing registration functionality into a modern stepper:

1. Personal information
2. Identity document
3. Selfie
4. Driving license
5. Vehicle information
6. Vehicle registration/document
7. Service selection
8. Review & submit
9. Verification pending
10. Approved/rejected with reason

## 11. Vehicle management

A driver can own/manage multiple vehicles.

Minimum fields:

- type
- make/model
- plate
- year
- color
- passenger seats
- payload capacity kg
- cargo volume m3
- document images
- verification state
- enabled service types

Only one active vehicle should be used for job matching at a time unless multi-fleet support is introduced later.

## 12. Earnings

Driver earnings view:

- today/week/month/custom period
- gross earnings
- completed jobs
- rating
- online time
- breakdown by service
- recent jobs
- adjustments/bonuses/fees future-ready

## 13. History

Customer history filters:

- rides
- shared rides
- deliveries
- intercity cargo
- scheduled/upcoming
- cancelled

Driver history filters:

- accepted
- completed
- cancelled
- service type
- date range

## 14. Ratings and trust

- customer rates driver after completed service
- driver may rate customer later
- delivery/cargo proof attached to order
- verification badge
- report/support action

## 15. Admin compatibility

The current admin panel remains outside the first unified-client build, but the data model must support admin operations for:

- user block/unblock
- driver approve/reject
- vehicle verification
- ride/order lookup
- dispute/support status
- pricing configuration
- service eligibility

A future admin rebuild must not require changing customer/driver data contracts.

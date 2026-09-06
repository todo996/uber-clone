# 05 — UI / UX Specification

## 1. Design direction

The production UI must use a clean, modern ride-hailing/logistics visual language suitable for a commercial product:

- light primary surface
- strong black/dark typography
- green primary action color
- blue reserved for map/location/supporting states where useful
- orange for delivery/cargo accents
- purple only as a secondary service identifier when required
- large map surfaces
- card-based information hierarchy
- persistent bottom navigation on mobile
- clear mode switching between Customer and Driver
- compact, high-information desktop shell

This file is the UI source of truth. No demo image or static mockup is required for implementation.

All user-facing copy must follow `10_LOCALIZATION_I18N.md`: Vietnamese (`vi`) is primary/default, English (`en`) is mandatory secondary language.

## 2. Core design tokens

### Color roles

Use semantic tokens rather than hardcoded screen colors:

```text
color.bg.canvas
color.bg.surface
color.bg.elevated
color.text.primary
color.text.secondary
color.text.muted
color.border.subtle
color.action.primary
color.action.primaryHover
color.action.destructive
color.status.success
color.status.warning
color.status.error
color.service.ride
color.service.shared
color.service.delivery
color.service.cargo
color.map.route
```

Primary action family: green.

### Typography

Requirements:

- Vietnamese diacritics must render cleanly.
- English text expansion must not clip buttons/cards.
- Strong numeric hierarchy for price, ETA, distance and earnings.
- Avoid tiny 10–11 px text on mobile.
- Body text should remain readable under sunlight/mobile conditions.

Suggested hierarchy:

```text
Display      32–40
Title L      24–28
Title M      20–22
Title S      17–18
Body L       16
Body M       14–15
Caption      12–13
Numeric KPI  22–32 bold
```

### Spacing

Use a 4/8-based spacing system:

```text
4, 8, 12, 16, 20, 24, 32, 40
```

### Radius

- small controls: 8–10
- cards: 12–16
- bottom sheets: 20–24
- pills/status: full radius

### Touch targets

Minimum practical interactive area: ~44×44 px.

## 3. Responsive strategy

### Mobile

Primary target width range:

```text
320–480 px
```

Characteristics:

- single-column flow
- bottom navigation
- sticky primary CTA when useful
- map may occupy 40–65% of viewport depending state
- bottom sheets for trip/order details
- safe-area aware
- no horizontal overflow at 320 px

### Tablet

```text
481–1024 px
```

Use adaptive split panels when map + form benefit from side-by-side placement.

### Desktop

```text
> 1024 px
```

Preferred shell:

- left navigation/service rail
- central task/form area
- map/details on right
- no oversized stretched mobile cards

## 4. Global mobile shell

### Customer bottom navigation

Recommended five items:

1. Trang chủ / Home
2. Chuyến đi / Trips
3. Thanh toán / Ví / Payments
4. Thông báo / Notifications
5. Tài khoản / Account

### Driver bottom navigation

Recommended five items:

1. Trang chủ / Home
2. Chuyến mới / Requests
3. Thu nhập / Earnings
4. Lịch sử / History
5. Hồ sơ / Profile

### Role switch

Role switching must be reachable from:

- profile/account screen
- driver dashboard header where appropriate

Behavior:

- Customer-only account sees `Trở thành tài xế / Become a driver`.
- Approved driver sees current mode and a switch action.
- Pending/rejected driver sees verification state instead of direct switch.
- Switching language or role must not destroy an active trip/order.

## 5. Screen: Customer Home

### Purpose

Start any service quickly.

### Layout

Header:

- current city/location
- profile/avatar
- notifications

Hero:

- primary destination prompt
- destination search field

Service grid:

- Đặt xe / Ride
- Xe ghép / Shared ride
- Giao hàng / Delivery
- Hàng liên tỉnh / Intercity cargo

Secondary actions:

- Đặt lịch trước / Schedule
- Ưu đãi / Offers
- Lịch sử / History
- Hỗ trợ / Support

States:

- location permission granted
- permission denied
- unsupported area
- loading services
- offline/no network

## 6. Screen: Standard Ride Booking

Top:

- back
- title
- schedule shortcut

Map:

- user location
- pickup marker
- destination marker
- nearby available vehicles
- route polyline after both locations selected

Bottom content:

- pickup
- destination
- vehicle cards
- estimated price
- estimated arrival
- payment method
- immediate/scheduled selector
- optional bid entry
- primary CTA for book now / schedule

Vehicle card must show:

- vehicle icon/image
- label
- seats
- ETA
- estimated price

Selected state must be visually obvious without relying only on color.

## 7. Screen: Ride Matching

Display:

- map
- animated/searching state
- booking summary
- search timeout
- cancel action

If user leaves the screen, booking state must persist and be recoverable.

## 8. Screen: Active Customer Ride

Map first.

Status timeline:

```text
Đang đến / Arriving
→ Đã đến / Arrived
→ Đang đi / In trip
→ Hoàn thành / Completed
```

Bottom sheet:

- driver photo/name/rating
- vehicle model/plate
- call
- message
- share trip
- pickup/destination
- ETA/distance
- fare/payment method
- notes
- cancel/support depending state

Realtime location updates without full page reload.

## 9. Screen: Shared Ride Booking

Tabs:

- Đi ngay / Now
- Đặt lịch trước / Schedule

Inputs:

- pickup
- destination
- date/time if scheduled
- seat count stepper

Result cards:

- departure window
- route
- driver
- rating
- vehicle
- available seats
- price per seat
- estimated detour
- book CTA

No-match state can offer wider time window or create a matching request.

## 10. Screen: Active Shared Ride

Map with ordered stops.

Bottom panel:

- driver
- passenger seat count
- departure/arrival window
- ordered pickup/drop-off timeline
- current stop
- next stop ETA
- privacy-safe representation of other riders

Never expose another passenger’s phone or precise private profile information.

## 11. Screen: Delivery Creation

Tabs:

- Giao ngay / Deliver now
- Đặt lịch / Schedule

Pickup section:

- pickup address
- sender name
- sender phone

Destination section:

- delivery address
- receiver name
- receiver phone

Item section:

- category
- weight
- dimensions
- quantity
- fragile flag
- photos
- note

Vehicle section:

- motorbike
- car
- later van/truck if configured

Footer:

- estimate
- create delivery CTA

## 12. Screen: Active Delivery

Map with pickup and delivery markers.

Timeline:

```text
Đã nhận đơn / Accepted
→ Đang lấy hàng / Picking up
→ Đang giao hàng / Delivering
→ Hoàn thành / Completed
```

Details:

- order code
- service type
- addresses
- item summary
- sender/receiver
- driver contact
- pickup proof
- delivery proof
- note

## 13. Screen: Intercity Cargo — Customer

Tabs:

- Đăng hàng / Post cargo
- Đơn của tôi / My orders

Form:

- province/city origin
- precise pickup
- destination province/city
- precise delivery
- cargo category
- weight
- volume
- dimensions
- photos
- pickup window
- delivery deadline
- proposed price
- notes

After posting show:

- matching state
- carrier offers/matches
- vehicle type
- available capacity
- route
- proposed/agreed price
- driver verification/rating

## 14. Screen: Driver Dashboard

Header:

- driver identity
- verification/rating
- online/offline toggle
- notifications

KPI cards:

- trips today
- earnings today
- rating
- online time when available

Map:

- driver live location
- demand/active-area indication only when backed by real data

Service counters:

- standard rides
- shared rides
- deliveries
- intercity cargo

Upcoming jobs:

- service icon
- pickup/destination
- distance/time
- payout
- primary action

## 15. Screen: Driver New Ride Request

Map:

- current driver position
- pickup
- destination/route preview when policy permits

Bottom sheet:

- request countdown
- customer summary
- rating if enabled
- pickup
- destination
- distance
- ETA
- fare/payout
- service type
- payment type
- decline
- accept

Accept must lock the request to the driver through safe state-transition logic.

## 16. Screen: Driver Active Ride

Navigation-first map:

- route
- next maneuver summary
- target marker
- current driver position

Trip-state CTA sequence:

```text
Đang đến / Arriving
→ Đã đến / Arrived
→ Đã đón khách / Passenger onboard
→ Hoàn thành / Complete
```

Customer card:

- name
- pickup
- note
- call/message

Only the next valid state action should be the primary CTA.

## 17. Screen: Driver Shared Ride

Driver sees:

- total seats
- available/reserved seats
- passenger count
- ordered stop list
- current stop
- next stop
- detour impact
- passenger board/no-show actions

Map should distinguish pickup, drop-off and current target without relying only on color.

## 18. Screen: Driver Delivery

Sections:

- map
- pickup/delivery timeline
- order code
- service
- item summary
- sender/receiver
- photos
- notes

State-constrained actions:

- accept
- arrived pickup
- confirm pickup
- upload pickup proof
- start delivery
- arrived delivery
- verify OTP
- upload delivery proof
- complete

## 19. Screen: Driver Intercity Cargo Matching

Header:

- active route
- selected vehicle
- total/remaining payload
- total/remaining volume
- departure time

Matching cards:

- cargo category/photo
- weight
- volume
- origin/destination
- pickup/delivery time
- payout
- detour
- match score/fit label
- accept cargo action

Capacity must refresh immediately and atomically after accepting cargo.

## 20. Screen: Driver Routes

Tabs:

- Tuyến của tôi / My routes
- Tạo tuyến / Create route
- Đã hoàn thành / Completed

Create route:

- origin
- destination
- waypoints
- departure time
- selected vehicle
- max detour
- accepted cargo categories
- available capacity initialized from vehicle

## 21. Screen: Earnings

Period tabs:

- Hôm nay / Today
- Tuần này / This week
- Tháng này / This month
- Tùy chỉnh / Custom

KPI:

- total earnings
- completed jobs
- rating
- online time

Breakdown:

- ride
- shared ride
- delivery
- cargo

Chart is optional and must not replace numeric breakdown.

## 22. Screen: Profile / Account

Customer profile:

- identity
- saved places
- payment
- trip history
- notifications
- language
- settings
- help
- become driver / switch to driver

Driver profile:

- verification
- personal information
- documents
- vehicles
- service eligibility
- ratings
- payout/payment settings
- language
- switch to customer

## 23. Empty/loading/error states

Every major screen must explicitly support:

- loading
- no data
- no available drivers
- no shared ride match
- no cargo match
- permission denied
- offline/network error
- Firebase permission error
- expired request
- cancelled service
- blocked/suspended account

All states require both Vietnamese and English copy.

## 24. Motion and feedback

Use motion for comprehension, not decoration:

- map marker movement
- bottom-sheet transitions
- request countdown
- skeleton loading
- success state after booking
- state timeline progression

Avoid excessive bounce/glow effects.

## 25. Accessibility

- contrast-safe text/buttons
- localized labels for icons
- keyboard navigation on web
- focus-visible states
- reduced-motion support on web
- scalable text on mobile where possible
- status not communicated by color alone

## 26. Production rule

Production implementation must use real authenticated Firebase data and current service/order state only. No hardcoded demo names, drivers, maps, prices or earnings in production screens.

No demo image is part of the implementation contract. When a UI question arises, use this specification, the product/feature specification, service-flow specification and the actual legacy code behavior as the sources of truth.

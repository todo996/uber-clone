# 05 — UI / UX Specification

## 1. Design direction

The approved concepts define a clean, modern ride-hailing/logistics visual language:

- light primary surface
- strong black typography
- green primary action color
- blue reserved for map/location/supporting states where useful
- orange for delivery/cargo accents
- purple only as a secondary service identifier when required
- large map surfaces
- card-based information hierarchy
- persistent bottom navigation on mobile
- clear mode switching between Customer and Driver
- compact, high-information desktop shell

The production UI should feel closer to a mature transport platform than a generic admin dashboard.

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

Use an 4/8-based spacing system:

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
- bottom sheets for trip details
- safe-area aware

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

1. Trang chủ
2. Chuyến đi
3. Thanh toán / Ví
4. Thông báo
5. Tài khoản

### Driver bottom navigation

Recommended five items:

1. Trang chủ
2. Chuyến mới
3. Thu nhập
4. Lịch sử
5. Hồ sơ

### Role switch

Role switching must be reachable from:

- profile/account screen
- driver dashboard header where appropriate

Behavior:

- Customer-only account sees “Trở thành tài xế”.
- Approved driver sees “Chế độ hiện tại” and a switch action.
- Pending/rejected driver sees verification state instead of direct switch.

## 5. Screen: Customer Home

### Purpose

Start any service quickly.

### Layout

Header:

- current city/location
- profile/avatar
- optional notifications

Hero:

- strong “Bạn muốn đi đâu hôm nay?” prompt
- destination search field

Service grid:

- Đặt xe
- Xe ghép
- Giao hàng
- Hàng liên tỉnh

Secondary actions:

- Đặt lịch trước
- Ưu đãi

Promotional/informational card:

- shared ride savings or safety information

### States

- location permission granted
- permission denied
- unsupported area
- loading services
- offline/no network

Reference: `assets/web-mobile-overview.jpg`.

## 6. Screen: Standard Ride Booking

### Main structure

Top:

- back
- title “Đặt xe”
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
- immediate/scheduled toggle
- optional bid entry
- primary CTA “Đặt xe ngay” / “Đặt lịch”

### Vehicle card requirements

Show:

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

Do not block navigation unexpectedly. If user leaves the screen, booking state must persist and be recoverable.

## 8. Screen: Active Customer Ride

Map first.

Top status timeline:

```text
Đang đến → Đã đến → Đang đi → Hoàn thành
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

Realtime location should update without full page reload.

## 9. Screen: Shared Ride Booking

Header tabs:

- Đi ngay
- Đặt lịch trước

Inputs:

- pickup
- destination
- date/time if scheduled
- seat count stepper

Results cards:

- departure window
- route
- driver
- rating
- vehicle
- available seats
- price per seat
- estimated detour
- CTA “Đặt ngay”

If no direct match:

- offer to expand departure window
- create match request
- show nearby pickup adjustment option later

## 10. Screen: Active Shared Ride

Map with ordered stops.

Bottom panel:

- driver
- your seat count
- departure/arrival window
- ordered pickup/drop-off timeline
- current stop
- next stop ETA
- other riders represented only with privacy-safe minimal avatars/initials

Never expose another passenger’s phone or precise private profile information.

## 11. Screen: Delivery Creation

Header tabs:

- Giao ngay
- Đặt lịch

Sections:

### Pickup

- pickup address
- sender name
- sender phone

### Destination

- delivery address
- receiver name
- receiver phone

### Item

- category
- weight
- dimensions
- quantity
- fragile flag
- photos
- note

### Vehicle

- motorbike
- car
- later van/truck if configured

Footer:

- estimate
- CTA “Đặt giao hàng”

## 12. Screen: Active Delivery

Map with pickup and delivery markers.

Timeline:

```text
Đã nhận đơn → Đang lấy hàng → Đang giao hàng → Hoàn thành
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

Driver actions are described in Driver screens below.

## 13. Screen: Intercity Cargo — Customer

Tabs:

- Đăng hàng
- Đơn của tôi

Form sections:

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

After posting:

- show matching state
- show carrier offers/matches
- vehicle type
- available capacity
- route
- proposed/agreed price
- driver verification/rating

## 14. Screen: Driver Dashboard

Reference: `assets/driver-dashboard.jpg`.

Header:

- driver identity
- rating
- online/offline toggle
- notifications

KPI cards:

- trips today
- earnings today
- rating

Map:

- driver live location
- demand/active area indication where data is available

Service request counters:

- Đặt xe
- Xe ghép
- Giao hàng
- Hàng liên tỉnh

Upcoming jobs list:

- service icon
- pickup/destination
- distance/time
- payout
- CTA

## 15. Screen: Driver New Ride Request

Reference: `assets/driver-new-trip.jpg`.

Map:

- current driver position
- pickup
- destination/route preview when policy permits

Bottom sheet:

- request countdown
- customer
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

On accept, request must become locked to that driver through trusted/state-safe logic.

## 16. Screen: Driver Active Ride

Reference: `assets/driver-active-trip.jpg`.

Map/navigation area:

- route
- next maneuver summary
- destination/pickup marker
- current speed optionally

Trip-state control:

```text
Đang đến
→ Đã đến
→ Đã đón khách
→ Hoàn thành
```

Customer card:

- name
- pickup
- note
- call/message

Primary action is always the next valid state transition only.

## 17. Screen: Driver Shared Ride

Driver sees:

- available seats
- reserved seats
- total passengers
- ordered stop list
- current stop
- next stop
- detour impact
- passenger board/no-show actions

The map should mark:

- pickup stops green
- drop-off stops red
- current target highlighted

## 18. Screen: Driver Delivery

Reference: `assets/driver-delivery.jpg`.

Sections:

- map
- pickup/delivery timeline
- order code
- service
- item summary
- sender and receiver
- photos
- notes

Actions by state:

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

Reference: `assets/driver-intercity-cargo.jpg`.

Header:

- active route
- vehicle
- total/remaining payload
- total/remaining volume
- departure time

Matching cards:

- cargo photo/category
- weight
- volume
- origin/destination
- pickup/delivery time
- payout
- detour
- match score/fit label
- “Nhận hàng” action

Capacity must refresh immediately after accepting cargo.

## 20. Screen: Driver Routes

Tabs:

- Tuyến của tôi
- Tạo tuyến
- Đã hoàn thành

Create route:

- origin
- destination
- waypoints
- departure time
- selected vehicle
- max detour
- cargo categories
- available capacity defaults from vehicle

## 21. Screen: Earnings

Period tabs:

- Hôm nay
- Tuần này
- Tháng này
- Tùy chỉnh

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

Chart is optional but must not replace the numeric breakdown.

## 22. Screen: Profile / Account

Customer profile:

- identity
- saved places
- payment
- trip history
- notifications
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
- switch to customer

## 23. Empty/loading/error states

Every major screen must have deliberate states for:

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
- labels for icons
- keyboard navigation on web
- focus-visible states
- reduced-motion support on web
- scalable text on mobile where possible
- status not communicated by color alone

## 26. Production rule

The concept images contain placeholder names, addresses and amounts. Production implementation must use real authenticated Firebase data and current service/order state only. No hardcoded demo names, drivers, maps, prices or earnings in production screens.

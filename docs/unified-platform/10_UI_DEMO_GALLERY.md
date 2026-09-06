# 10 — Approved UI Demo Gallery

> These images are approved visual references for the unified-platform implementation. They are **not screenshots of finished production code**. The production UI must use real Firebase data, real state machines, responsive components and the behaviors specified in `05_UI_UX_SPEC.md` and `06_SERVICE_FLOWS.md`.

## 1. Mobile-first Web App — Customer + Driver services

![Mobile-first unified Web App overview](assets/web-mobile-overview.jpg)

This concept establishes the primary mobile Web App information architecture. The finished Next.js/PWA implementation must cover the same service families and interaction hierarchy:

### Customer mode

- **Trang chủ / service launcher** — current location, destination search, primary services and quick shortcuts.
- **Đặt xe thường** — pickup/destination, map route, vehicle class, estimated fare, payment and immediate booking.
- **Xe ghép** — immediate or scheduled mode, seat count, matching shared routes, remaining seats and price per seat.
- **Giao hàng** — pickup/delivery addresses, parcel category, weight/dimensions, photos, vehicle selection and booking.
- **Hàng liên tỉnh** — cargo origin/destination, weight, volume, schedule and proposed price.
- **Theo dõi chuyến** — realtime driver position, state timeline, driver/vehicle details, contact and support actions.
- **Theo dõi xe ghép** — multi-stop route, seat information and ordered pickup/drop-off timeline.
- **Theo dõi giao hàng** — pickup/delivery timeline, shipper position and order information.

### Driver access in the same product

The same authenticated identity can become/switch to Driver mode when approved. Driver mode is not a separate account system.

## 2. Driver Mobile Experience

![Unified Driver mobile workflow overview](assets/driver-mobile-overview.jpg)

The driver concept establishes five critical Driver-mode experiences that both the unified Flutter app and active-session Web Driver mode must support.

### A. Driver dashboard

- Online/Offline toggle.
- Driver identity, verification/rating.
- Trips today, earnings today and rating KPIs.
- Current-location map.
- Request counters by service: standard ride, shared ride, delivery and intercity cargo.
- Upcoming jobs.
- Direct path to earnings/history/profile.

### B. New ride request

- Map preview of current driver location, pickup and destination/route where policy allows.
- Countdown before request expiry.
- Customer summary.
- Pickup/destination.
- Distance and ETA.
- Driver payout/fare information.
- Service/payment type.
- **Từ chối** / **Nhận chuyến** actions.

### C. Active passenger trip

- Navigation-first map.
- Current target and next maneuver.
- Driver trip-state progression:
  - Đang đến.
  - Đã đến.
  - Đã đón khách.
  - Hoàn thành.
- Customer card, pickup/destination, note and contact actions.
- One clear primary CTA for the next valid state transition.

### D. Active delivery

- Pickup and drop-off route.
- Delivery state timeline.
- Order code and parcel details.
- Sender/receiver information.
- Pickup/delivery photos.
- Required OTP/photo proof where configured.
- Pickup and completion actions constrained by the delivery state machine.

### E. Intercity cargo matching

- Active driver route.
- Selected car/truck.
- Payload and volume remaining.
- Departure schedule.
- Matching cargo list with category, weight, volume, origin/destination, pickup/delivery windows, payout and detour/fit information.
- Atomic capacity reservation after **Nhận hàng**.

## 3. Adaptive Desktop Web App

![Desktop responsive Web App overview](assets/web-desktop-overview.jpg)

The desktop reference shows how the same domains adapt to larger screens rather than simply stretching the mobile UI.

Expected desktop layout patterns:

- Persistent left service/navigation rail where useful.
- Form or task panel beside a larger map.
- Multi-column matching results.
- Driver dashboard with request panel + map + KPI summary.
- Shared ride, delivery and cargo forms with more visible information and fewer modal transitions.

## 4. Visual language to preserve

The production design system should preserve these principles:

- Mobile-first hierarchy.
- Light primary surfaces.
- Strong black/dark typography.
- Green primary actions and online/success states.
- Service-specific accents used sparingly.
- Map-centric ride and delivery experiences.
- Rounded cards/bottom sheets with compact information density.
- Persistent mobile bottom navigation.
- Large, obvious status and price/ETA information.
- Vietnamese labels with clear typography and correct diacritics.

## 5. What must improve beyond the concept images

The implementation must add production behavior that a static concept cannot demonstrate:

- Firebase Auth/session recovery.
- Role and verification authorization.
- Real Google Maps/geolocation.
- Real realtime Firebase listeners.
- Offline/network/permission errors.
- Empty/loading/skeleton states.
- Booking idempotency.
- Scheduled booking recovery.
- Shared-seat concurrency safety.
- Cargo payload/volume concurrency safety.
- Push notifications.
- Accessibility and keyboard/focus behavior on Web.
- Native background-driver tracking on Android/iOS where permitted.
- Responsive tablet and desktop breakpoints.

## 6. Source-to-screen mapping

The existing Flutter code is the behavioral source for standard rides and Driver execution; the images are the visual source for the new presentation.

| New experience | Legacy behavior source | New spec source |
|---|---|---|
| Standard booking | `uber_users_app/lib/pages/home_page.dart` | `05_UI_UX_SPEC.md`, `06_SERVICE_FLOWS.md` |
| Driver online/location | `uber_drivers_app/lib/pages/home/home_page.dart` | `03_ARCHITECTURE.md`, `06_SERVICE_FLOWS.md` |
| Driver active ride | `uber_drivers_app/lib/pages/newTrip/new_trip_page.dart` | `05_UI_UX_SPEC.md`, `06_SERVICE_FLOWS.md` |
| Driver onboarding | `uber_drivers_app/lib/pages/driverRegistration/` | `02_PRODUCT_AND_FEATURE_SPEC.md`, `05_UI_UX_SPEC.md` |
| Shared ride | New domain | `02_PRODUCT_AND_FEATURE_SPEC.md`, `04_FIREBASE_DATA_MODEL.md`, `06_SERVICE_FLOWS.md` |
| Delivery | New domain | `02_PRODUCT_AND_FEATURE_SPEC.md`, `04_FIREBASE_DATA_MODEL.md`, `06_SERVICE_FLOWS.md` |
| Intercity cargo | New domain | `02_PRODUCT_AND_FEATURE_SPEC.md`, `04_FIREBASE_DATA_MODEL.md`, `06_SERVICE_FLOWS.md` |

## 7. Acceptance rule

A screen is not considered implemented merely because it resembles these images. It is complete only when it passes the corresponding phase gate in `09_IMPLEMENTATION_ROADMAP.md` with real Firebase behavior, validation, permission handling, recovery and tests.
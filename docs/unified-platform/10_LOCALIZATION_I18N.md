# 10 — Localization / i18n Specification

## 1. Language policy

The finished product is bilingual from the first production release:

- **Vietnamese (`vi`) is the primary and default language.**
- **English (`en`) is the secondary language.**
- Every production screen, dialog, validation message, status label, notification, permission explanation, empty state, error state and transactional message must exist in both languages.
- If a translation key is missing, the runtime fallback is Vietnamese, not English.
- No new user-facing string may be hardcoded directly inside business logic or screen components.

Default behavior:

```text
first launch -> Vietnamese
saved preference exists -> use saved preference
user changes language -> persist account/device preference
missing translation -> fallback to Vietnamese
```

## 2. Scope

This rule applies equally to:

- Next.js Web App / PWA
- Flutter unified Android app
- Flutter unified iOS app
- Customer mode
- Driver mode
- Standard rides
- Scheduled rides
- Shared rides / seat booking
- Local delivery
- Intercity cargo
- Driver onboarding and verification
- Payments
- Notifications
- Ratings
- Support/help
- System and permission explanations owned by the app

## 3. Language selector

Language switching must be available from:

- initial/authentication screen where practical
- Customer profile/settings
- Driver profile/settings

Display names:

```text
Tiếng Việt
English
```

Do not represent the language only by flags.

Changing language should update the visible UI without forcing the user to log out. Active trip/order state must not reset when language changes.

## 4. Web implementation

Target structure:

```text
apps/web/
└── src/
    ├── i18n/
    │   ├── config.ts
    │   ├── locale.ts
    │   ├── vi/
    │   │   ├── common.json
    │   │   ├── auth.json
    │   │   ├── ride.json
    │   │   ├── sharedRide.json
    │   │   ├── delivery.json
    │   │   ├── cargo.json
    │   │   ├── driver.json
    │   │   ├── payments.json
    │   │   ├── notifications.json
    │   │   └── errors.json
    │   └── en/
    │       └── same namespaces as vi/
```

Requirements:

- locale-aware formatting through `Intl`/standards-based APIs
- no duplicated business constants inside locale files
- translation keys are semantic, e.g. `ride.status.driverArriving`, not full sentence text as key
- server/client rendering must agree on locale to avoid hydration mismatch
- locale preference stored in authenticated profile when available and mirrored locally for pre-auth startup
- accessibility labels must also be localized

## 5. Flutter implementation

Use Flutter's standard localization workflow or an equivalent typed solution.

Target structure:

```text
apps/mobile/lib/
├── l10n/
│   ├── app_vi.arb
│   ├── app_en.arb
│   └── generated/
└── core/localization/
    ├── locale_controller.dart
    └── locale_repository.dart
```

Requirements:

- `vi` is `supportedLocales` default/fallback
- Android and iOS both expose Vietnamese and English metadata where platform configuration requires it
- background notification content must use the intended user locale where possible
- driver active-trip UI must never lose state during a locale switch

## 6. Content hierarchy

Vietnamese wording is the canonical product copy for the first release. English is translated from the approved Vietnamese meaning, not the other way around.

Style rules for Vietnamese:

- natural Vietnamese, concise, not machine-literal
- preserve full diacritics
- use familiar transport vocabulary
- avoid unnecessary English terminology when a clear Vietnamese term exists
- monetary values shown with Vietnamese formatting by default

Examples:

| Key | Vietnamese (primary) | English |
|---|---|---|
| `nav.home` | Trang chủ | Home |
| `nav.trips` | Chuyến đi | Trips |
| `nav.earnings` | Thu nhập | Earnings |
| `nav.profile` | Hồ sơ | Profile |
| `service.ride` | Đặt xe | Ride |
| `service.sharedRide` | Xe ghép | Shared ride |
| `service.delivery` | Giao hàng | Delivery |
| `service.intercityCargo` | Hàng liên tỉnh | Intercity cargo |
| `booking.now` | Đi ngay | Ride now |
| `booking.schedule` | Đặt lịch trước | Schedule |
| `driver.online` | Đang online | Online |
| `driver.offline` | Đang offline | Offline |
| `trip.accept` | Nhận chuyến | Accept trip |
| `trip.decline` | Từ chối | Decline |
| `trip.arriving` | Đang đến điểm đón | Arriving at pickup |
| `trip.arrived` | Đã đến điểm đón | Arrived at pickup |
| `trip.onTrip` | Đang di chuyển | In trip |
| `trip.completed` | Hoàn thành | Completed |
| `delivery.pickup` | Lấy hàng | Pick up |
| `delivery.delivered` | Đã giao hàng | Delivered |
| `cargo.findLoad` | Tìm hàng | Find cargo |
| `cargo.accept` | Nhận hàng | Accept cargo |

## 7. Status mapping

Firebase/domain state values remain language-neutral machine values. UI converts them through localization keys.

Example:

```text
accepted -> ride.status.accepted
arrived  -> ride.status.arrived
ontrip   -> ride.status.onTrip
ended    -> ride.status.completed
```

Never write translated strings such as `Đã đến` or `Arrived` as business-state values in Firebase.

## 8. Dates, time, currency and numbers

Vietnamese defaults:

- locale: `vi-VN`
- currency: `VND`
- 24-hour time for product UI unless a platform convention clearly requires otherwise
- date examples: `12/09/2026`, `12 tháng 9, 2026` depending context
- currency examples: `120.000 đ`, `2.450.000 đ`

English defaults:

- locale: `en`
- keep transaction currency as VND when the service is priced in VND
- translate labels, not monetary meaning

Distances/weights/volume are shared domain values and formatted per locale without changing the underlying unit contract unless a future market explicitly requires unit conversion.

## 9. Notifications and transactional copy

Every notification template must have at least `vi` and `en` variants.

Examples:

```text
ride.new_request.title.vi
ride.new_request.title.en
ride.driver_arriving.body.vi
ride.driver_arriving.body.en
delivery.picked_up.body.vi
delivery.picked_up.body.en
cargo.match_found.body.vi
cargo.match_found.body.en
```

Server-side/Firebase Functions must select template language from the recipient profile preference, falling back to Vietnamese.

## 10. Validation and error messages

Validation libraries must return machine error codes, then map those codes to localized copy.

Do not pass raw Firebase/Stripe/Google error messages directly to users.

Example:

```text
AUTH_INVALID_PHONE -> errors.auth.invalidPhone
RIDE_NO_DRIVER -> errors.ride.noDriver
DELIVERY_INVALID_WEIGHT -> errors.delivery.invalidWeight
CARGO_CAPACITY_EXCEEDED -> errors.cargo.capacityExceeded
```

## 11. UI design requirements for bilingual text

All approved UI layouts must survive English text expansion and Vietnamese diacritics.

Requirements:

- buttons cannot rely on fixed text widths
- cards allow reasonable wrapping
- bottom navigation uses concise localized labels
- map sheets must not clip translated status text
- no image should contain mandatory runtime copy that cannot be localized
- screenshots/concept images are visual references only; implementation text comes from i18n resources

## 12. SEO / metadata for Web

Web metadata must support both languages:

- page titles
- descriptions
- Open Graph copy
- install/PWA naming where locale-aware support is used

Vietnamese remains the default public metadata language for the initial Vietnam release.

## 13. Testing requirements

Every major feature must be tested at least once in both locales.

Minimum checks:

- no missing translation keys
- Vietnamese default on clean install/session
- switch `vi -> en -> vi`
- locale survives refresh/restart
- active trip survives language switch
- long English labels do not overflow
- Vietnamese diacritics render correctly
- localized push templates resolve
- validation/error mappings exist in both languages

CI should include a translation-key parity check so `vi` and `en` namespaces cannot drift silently.

## 14. Definition of done

A feature is not complete unless:

1. Vietnamese copy is complete and approved as primary copy.
2. English translation exists for all user-visible strings.
3. No hardcoded UI string bypasses the localization layer except intentionally non-localized proper nouns/data.
4. Both locales pass layout and functional checks.
5. Locale preference persists correctly on Web, Android and iOS.

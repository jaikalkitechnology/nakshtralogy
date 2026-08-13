# Hindustani Jyotish — Astrologer App (Flutter)

The astrologer-facing app: onboard with KYC, toggle online, attend incoming
requests, go live, and withdraw earnings.

## Architecture

Same stack as the user app — `flutter_bloc` · `get_it` · `go_router` · `dio` —
sharing theme/models/network via the `hj_core` package (`../hj_core`).

```
lib/
├── core/di.dart            GetIt service locator
├── router/app_router.dart  go_router guard (auth → KYC/review → dashboard)
├── app.dart, main.dart     bootstrap (restores session before first frame)
└── features/
    ├── auth/               splash · welcome · OTP + astrologer session
    ├── kyc/                KYC form + "Under Review" gate
    ├── dashboard/          online toggle, stats, quick actions, bottom-nav shell
    ├── requests/           incoming requests (accept / decline)
    ├── live/               go-live (start / broadcast / end)
    ├── earnings/           balance + withdraw to the registered payout method
    └── profile/            public profile & sign out
```

## Run

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/v1
```

Login uses Mobile + OTP against `/auth/astrologer/*`. New applicants land on the
KYC form; once an admin approves the KYC (via the React admin panel), the
dashboard unlocks and the astrologer can go online.

Device-only integrations (Agora broadcast, push) are abstracted at
their plug-in points; the API wiring for KYC, online status, requests, earnings,
payouts, and live sessions is complete.

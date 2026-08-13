# Hindustani Jyotish — User App (Flutter)

The seeker-facing app: find astrologers, consult (chat/call/video), generate
Kundli & cosmic insights, and manage the wallet.

## Architecture (per the blueprint)

- **State**: `flutter_bloc` (Cubits) · **DI**: `get_it` · **Routing**:
  `go_router` (with an auth guard) · **Network**: `dio` via `hj_core`.
- Shared theme/models/network/auth live in the `hj_core` package (`../hj_core`).

```
lib/
├── core/di.dart            GetIt service locator
├── router/app_router.dart  go_router + auth guard + bottom-nav shell
├── app.dart, main.dart     bootstrap (restores session before first frame)
└── features/
    ├── auth/               splash · welcome · OTP · profile completion
    ├── home/               home + bottom-nav shell
    ├── discovery/          astrologer list & profile
    ├── consultation/       chat / call / video with live wallet ticker
    ├── insights/           Cosmic Insights grid (kundli, horoscope, …)
    ├── wallet/             balance, recharge, transactions
    └── profile/            account & settings
```

## Run

```bash
flutter pub get
# Point the app at your backend (Android emulator default: 10.0.2.2:8000):
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/v1
```

Login uses Mobile + OTP; in backend dev mode the OTP is shown on screen.

## Notes on device-only integrations

Google Sign-In, biometric unlock, Agora A/V, and the Razorpay checkout sheet are
device/SDK features. Their API wiring is in place (endpoints + flows); the native
SDK surfaces are marked where they plug in. OTP auth, discovery, consultation
billing, insights, and wallet are fully wired to the API.

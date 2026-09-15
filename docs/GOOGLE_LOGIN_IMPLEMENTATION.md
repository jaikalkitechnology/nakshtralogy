# Google Sign-In — How It Works (and Why `flutter_astro` Isn't Working Right)

This documents the **working Google Sign-In implementation in `flutter_user`** (the Nakshatralogy end-user app) end-to-end, and the exact gap in `flutter_astro` (the astrologer app) that makes its Google login worse. Use this as the reference to bring `flutter_astro` to parity.

> Superseded/updated: `authWebPlatform/STATUS.md` describes an *intended* design where both apps use native `google_sign_in` on mobile. That intent was only actually built in `flutter_user`. In the current codebase, `flutter_astro` never calls the native `google_sign_in` package at all — it always falls back to a browser redirect. This doc reflects the **current, real code**, not the original plan.

## TL;DR

- **Backend is shared and correct for both apps** — not the problem.
- **`flutter_user`** has two working sign-in paths: a native in-app Google account picker (mobile) and a server-redirect flow (web, and as a fallback). It gets a Google `idToken` on-device and POSTs it to the backend.
- **`flutter_astro`** declares the same `google_sign_in` package in `pubspec.yaml` but **never imports or calls it anywhere in the app**. Every sign-in — web or mobile — leaves the app and goes through an external browser + deep-link round trip. That's the "not working perfect" experience: no in-app account picker, always a browser hand-off.
- The fix is mechanical: port `flutter_user`'s native sign-in method into `flutter_astro/lib/services/google_auth_service.dart`, wire it into the bloc/screens the same way, and point it at astro's own `web_client_id` (not user's).

---

## 1. Architecture overview

Two independent flows exist, both ending at the same backend and both producing the same app JWT + refresh token:

```
┌─────────────────────────────┐        ┌──────────────────────────────┐
│   A) Native flow (mobile)   │        │  B) Redirect flow (web/       │
│                              │        │     mobile fallback)          │
│  google_sign_in package     │        │  GET /google/login-url        │
│  → device account picker    │        │  → browser → Google consent   │
│  → Google idToken           │        │  → GET /google/callback       │
│  → POST /google/verify      │        │  → deep link / web redirect   │
│      { id_token, role }     │        │      back into the app        │
└─────────────────────────────┘        └──────────────────────────────┘
              │                                        │
              └──────────────┬─────────────────────────┘
                              ▼
              app/routers/google_auth_router.py
              find-or-create User, issue JWT + refresh
```

Neither app uses Firebase Auth / `firebase_auth` / `GoogleAuthProvider`. This is a **custom backend OAuth flow** — `google_sign_in` is used purely to obtain a native Google `idToken` on-device; verification and session issuance are entirely backend-owned.

---

## 2. Backend — `app/routers/google_auth_router.py` (shared by both apps)

### Credentials are role-scoped, admin-managed, and stored in the DB — not in `.env`

`app/core/config.py:56-57` has `GOOGLE_CLIENT_ID`/`GOOGLE_CLIENT_SECRET` env vars, but **they're unused** — nothing in `app/` reads them. The real source of truth is `PlatformSetting` rows:

- category `google_auth_user` → keys `client_id`, `client_secret`, `redirect_uri`, `web_client_id`, `android_client_id`, `ios_client_id`, `frontend_return_url`
- category `google_auth_astro` → the same keys, for the astrologer app

Both roles share the **same backend redirect URI** (`https://api.nakshatralogy.com/api/v1/google/callback`), registered once in Google Cloud Console. These are managed from the admin panel: `react_admin/src/pages/admin/GoogleAuthSettings.tsx`, which has a User App / Astrologer App toggle that switches which `PlatformSetting` category it edits.

> ⚠️ The admin page's "Configured ✓" badge only checks that `client_id` is non-empty — it does **not** verify `web_client_id`/`android_client_id`/`ios_client_id` are set. Those are exactly what the native flow needs (see §2.3). Check the astro row in the admin panel before assuming it's ready.

### 2.1 `GET /google/login-url` — redirect flow, step 1

- Query params: `role` (`user` | `astrologer`, default `user`), optional `return_to`.
- Loads the role's credentials, builds `state = "{role}:{random16}[:{base64(return_to)}]"` (role + return URL are smuggled through `state` since Google won't otherwise pass custom params through).
- Returns `{url, state}` — `url` is a full `accounts.google.com/o/oauth2/v2/auth?...` URL, `scope=openid email profile`, `access_type=offline`, `prompt=consent`.

### 2.2 `GET /google/callback` — redirect flow, step 2

- Parses `role`/`return_to` back out of `state`.
- Exchanges `code` for tokens at `https://oauth2.googleapis.com/token` (server-to-server, with `client_secret`).
- Fetches the profile from `https://www.googleapis.com/oauth2/v3/userinfo` (`sub`, `email`, `name`, `picture`). No JWT verification needed here — trusting `userinfo` is safe because the code exchange itself is server-to-server over TLS with the client secret.
- Find-or-create `User` by `google_id`, then by `email`. New users get `is_verified=True`, `role`, a `Wallet`.
- **Role-mismatch guard**: if an existing user's stored role differs from the requested role and the requested role isn't `"user"`, redirects with `google_error=role_mismatch` (an existing user can't "become" an astrologer via Google login on the astro app).
- `_ensure_astrologer_profile()` backfills `AstrologerProfile` + `Wallet` for astrologer-role users.
- Issues the JWT (`create_access_token`) + refresh token, redirects to the frontend with `token`, `refresh`, `role`, `is_new_user`, `user_id`, `name`, `email` in the query string.

### 2.3 `POST /google/verify` — native flow (the one `flutter_astro` doesn't use yet)

- Body: `{id_token: str, role: str = "user"}`.
- Loads the role's credentials, builds an **acceptable-audiences set** from whichever of `{web_client_id, android_client_id, ios_client_id, client_id}` are configured for that role.
- Verifies the token via Google's tokeninfo endpoint: `GET https://oauth2.googleapis.com/tokeninfo?id_token=...`. A non-200 response → 401 `invalid_google_token` (this is Google checking the signature/expiry). The router then checks `info['aud']` is in the acceptable-audiences set — **this is the client-ID check that must match the `serverClientId` the Flutter app used to request the token**.
- Same find-or-create-`User` / role-mismatch / `_ensure_astrologer_profile` / token-issuance logic as `/callback`.
- Returns `{token, refresh, is_new_user}` — **no `user` object** in the response (worth knowing if you're populating a profile screen immediately after sign-in — hydrate from `GET /me` instead).

---

## 3. `flutter_user` — the working reference implementation

### 3.1 Dependency

`pubspec.yaml:20` → `google_sign_in: ^6.2.1` (also: `app_links: ^6.3.0` for deep-link capture, no `firebase_auth`).

### 3.2 The native call — `lib/services/google_auth_service.dart`

```dart
Future<...> nativeVerify() async {
  final googleUser = await GoogleSignIn(
    scopes: const ['email', 'profile'],
    serverClientId: const String.fromEnvironment(
      'GOOGLE_WEB_CLIENT_ID',
      defaultValue: '410358361509-5h98nfjhdc9bu92rq7o39idkq3r9nieh.apps.googleusercontent.com',
    ),
  ).signIn();

  final auth = await googleUser!.authentication;
  final idToken = auth.idToken;
  ...
  return _api.googleVerify(idToken, fcmToken: fcmToken);
}
```

Key detail: **`serverClientId` must be the app's *web* OAuth client ID** (not an Android/iOS client ID) — this is what makes the returned `idToken`'s `aud` claim match what the backend checks against `web_client_id`. It also has a redirect-flow method, `startRedirectFlow()`, used for web and as a fallback.

### 3.3 Wiring — bloc, screens, deep links

- `lib/bloc/auth/auth_bloc.dart`:
  - `_onGoogleNative` → calls `nativeVerify()`. If `is_new_user == true`, emits `AuthNewGoogleUser` (routes to profile completion); otherwise `AuthAuthenticated`.
  - `_onGoogleSession` → adopts tokens delivered by the redirect flow's deep link / web callback (`_api.adoptSessionTokens(token, refresh)`).
- `lib/screens/auth/signup_screen.dart` (the screen to model, since it correctly branches):
  ```dart
  if (kIsWeb) {
    GoogleAuthService.instance.startRedirectFlow();
  } else {
    context.read<AuthBloc>().add(const AuthGoogleNativeRequested());
  }
  ```
  (Note: `login_screen.dart` is *inconsistent* — it always calls `startRedirectFlow()` regardless of platform, despite a comment implying mobile should use the native sheet. Use `signup_screen.dart`'s branching as the pattern to copy, not `login_screen.dart`'s.)
- `lib/main.dart` — `AppLinks()` (`app_links` package): `getInitialLink()` for cold start + `uriLinkStream.listen(...)` for warm, parses `token`/`refresh` out of the deep link, dispatches `AuthGoogleSessionReceived`. This part only matters for the redirect-flow path.
- `lib/services/api_service.dart`:
  - `googleLoginUrl({returnTo})` → `GET {googleBase}/login-url?role=user&return_to=...`
  - `googleVerify(idToken, {fcmToken})` → `POST {googleBase}/verify`, body `{id_token, role: 'user', fcm_token?}`, saves tokens from the response.
  - `adoptSessionTokens({token, refresh})` → saves tokens, then hydrates the profile via `GET /me`.
- `lib/utils/constants.dart`:
  ```dart
  static const String googleBase = '$baseUrl/google';
  static const String googleLoginUrl = '$googleBase/login-url';
  static const String googleVerify = '$googleBase/verify';
  static const String webAuthCallbackUrl = 'https://app.nakshatralogy.com/auth/callback';
  static const String mobileAuthCallback = 'nakshatralogy://auth/callback';
  ```

### 3.3 Native config (Android/iOS)

- `android/app/build.gradle` — `applicationId = "com.nakshtralogy.app"`.
- `android/app/src/main/AndroidManifest.xml` — intent-filter scheme `nakshatralogy`, host `auth`.
- `ios/Runner/Info.plist` — `CFBundleURLTypes` scheme `nakshatralogy`.
- `android/app/google-services.json` — shared Firebase project (`nakshatralogy-bc5a5`); its `oauth_client` array is **empty** for this app (and astro's). That's fine — native `idToken` retrieval here relies on the `serverClientId` passed to `GoogleSignIn(...)`, not on Firebase's own registered OAuth client.

---

## 4. `flutter_astro` — the gap, precisely

| Aspect | `flutter_user` | `flutter_astro` |
|---|---|---|
| `google_sign_in` imported/used anywhere | **yes** | **no — zero occurrences in `flutter_astro/lib`** |
| Native in-app account picker | yes (signup screen) | **unreachable** — no UI path triggers it |
| Mobile sign-in UX | in-app sheet (signup) / browser (login) | **always** external browser + deep-link round trip |
| `POST /google/verify` client method | implemented and called | implemented in `api_service.dart`, but **dead code** — nothing calls it |
| `AuthGoogleLoginRequested` bloc handler | n/a (different event name) | **exists but is never dispatched** — dead code |
| Redirect flow (`login-url`/`callback`) | implemented, used for web + fallback | implemented, used for **everything** |
| Deep-link capture (`app_links` in `main.dart`) | wired | wired — this part is fine |
| Backend credentials | `google_auth_user` category | `google_auth_astro` category — both correctly separate, same router |

`flutter_astro/lib/services/google_auth_service.dart` only has `startWebRedirect()` and `startMobileServerRedirect()` — both screens (`login_screen.dart`, `signup_screen.dart`) call one of those two regardless of platform. The bloc's `_onGoogleLogin` handler (which calls `_api.googleVerify(event.idToken, ...)`, with a legacy `/google-login` 404/405 fallback) is fully implemented but **orphaned** — no `.add(AuthGoogleLoginRequested(...))` call exists anywhere in the app.

So astro *has* all the backend-facing plumbing (`googleVerify()` in `api_service.dart`, the bloc handler) — it's just missing the one piece that produces an `idToken` in the first place: the native `GoogleSignIn(...).signIn()` call.

---

## 5. How to bring `flutter_astro` to parity

1. **Add a native sign-in method** to `flutter_astro/lib/services/google_auth_service.dart`, mirroring `flutter_user`'s `nativeVerify()`:
   ```dart
   import 'package:google_sign_in/google_sign_in.dart';

   Future<...> nativeVerify() async {
     final googleUser = await GoogleSignIn(
       scopes: const ['email', 'profile'],
       serverClientId: const String.fromEnvironment(
         'GOOGLE_WEB_CLIENT_ID_ASTRO', // astro's OWN web_client_id — see below
         defaultValue: '<astro web_client_id from google_auth_astro platform_settings>',
       ),
     ).signIn();
     final auth = await googleUser!.authentication;
     return _api.googleVerify(auth.idToken, fcmToken: fcmToken);
   }
   ```
   **Do not reuse `flutter_user`'s hardcoded client ID.** The backend checks the token's `aud` claim against `google_auth_astro`'s configured `web_client_id`/`android_client_id`/`ios_client_id` — copying user's ID verbatim will fail `/google/verify` for the astro role unless an admin has (perhaps accidentally) configured the same ID under both categories. Pull the correct value from the admin panel (`GoogleAuthSettings.tsx`, Astrologer App tab) first.

2. **Branch on platform** in `login_screen.dart` and `signup_screen.dart`, same pattern as `flutter_user/lib/screens/auth/signup_screen.dart`:
   ```dart
   if (kIsWeb) {
     GoogleAuthService().startWebRedirect();
   } else {
     context.read<AuthBloc>().add(AuthGoogleLoginRequested(idToken: /* from nativeVerify */));
     // or introduce a native-flow event (mirroring user's AuthGoogleNativeRequested)
     // that calls nativeVerify() itself, so the screen doesn't need the token directly.
   }
   ```
   The cleanest port mirrors `flutter_user`'s split: a `AuthGoogleNativeRequested` event with no payload, whose handler calls `GoogleAuthService().nativeVerify()` itself (rather than the screen fetching the token and passing it in, which is how astro's existing-but-unused `AuthGoogleLoginRequested(idToken)` is shaped).

3. **Confirm `google_auth_astro`'s `web_client_id` is actually set** in the admin panel before testing — the "Configured ✓" badge doesn't check for it, so it's easy to have `client_id`/`client_secret` set (redirect flow works) while `web_client_id` is empty (native flow will fail `/google/verify`'s audience check with a 401).

4. Leave the redirect flow (`startWebRedirect`/`startMobileServerRedirect`) in place for web — only mobile needs the native path.

No backend changes are needed — `/google/verify` already handles `role: "astrologer"` identically to `role: "user"`.

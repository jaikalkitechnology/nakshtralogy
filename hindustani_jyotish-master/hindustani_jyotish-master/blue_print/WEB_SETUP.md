# Web build setup — Google login, push notifications, and video calls

Everything below is about the **Flutter web builds** of the two apps
(`hindustani_user` and `hindustani_astro`). Android builds are unaffected by
any of it — they read the baked-in `google-services.json` and link the native
Agora SDK.

Three things must be right for the web apps to work fully:

| Capability | Where the values are entered | Needs a rebuild? |
|---|---|---|
| Google login | Google Cloud Console (origins) + admin console (client IDs) | No |
| Push notifications | Firebase console (Web app + VAPID) + admin console | No |
| Audio/video calls & live | Admin console (Agora) — the SDK script is already in `web/index.html` | No |

---

## 1. Google login on web — where the "redirect URL" comes from

**Short answer: this flow does not use a redirect URL. It uses an
*Authorized JavaScript origin*, and that origin is simply the URL where you
host the web app** — scheme + domain, with no path.

### Why there is no redirect URI

There are two different Google OAuth flows:

* **Server-side ("authorization code") flow** — the browser is *redirected* to
  Google and then back to a URL you registered. That flow is the one that
  needs **Authorized redirect URIs**.
* **Google Identity Services (GIS) flow** — Google renders a button/popup
  inside your page and hands the credential straight back to JavaScript. No
  navigation away, so **no redirect URI is involved at all**. Instead Google
  checks that the *page's origin* is one you authorized.

The Flutter apps use the **GIS flow** (`google_sign_in_web`), so:

* **Authorized JavaScript origins → you MUST fill this in.**
* **Authorized redirect URIs → leave empty.** Adding one changes nothing.

### The exact value to enter

It is the address users type to reach the web app, with **no path and no
trailing slash**:

```
https://user.hindustanijyotish.com        ✅ correct
https://user.hindustanijyotish.com/       ❌ trailing slash
https://user.hindustanijyotish.com/login  ❌ has a path
user.hindustanijyotish.com                ❌ missing scheme
```

Add one entry per address the app is served from, e.g.:

* production: `https://user.hindustanijyotish.com`
* staging (if any): `https://staging-user.hindustanijyotish.com`
* local development: `http://localhost:5000`

> Google only allows `http://` for `localhost`. Every other origin must be
> **HTTPS** — Google login, push notifications, and camera/microphone access
> all refuse to work on a plain-HTTP domain.

For local development the Flutter dev server picks a **random port** each run,
which can never match a registered origin. Pin it:

```bash
flutter run -d chrome --web-port=5000
```

…and register `http://localhost:5000`.

### Step by step in Google Cloud Console

1. Open <https://console.cloud.google.com/apis/credentials> and select the
   project that owns these OAuth clients.
2. Under **OAuth 2.0 Client IDs**, click the client of type **Web
   application**. There are **two** — one for the user app and one for the
   astrologer app. Their IDs are the same values pasted into the admin console
   (**Settings → Google Login**); match them by ID so you edit the right one.
3. In **Authorized JavaScript origins**, click **ADD URI** and enter the
   origin(s) from above.
4. Leave **Authorized redirect URIs** empty.
5. Click **SAVE**. Changes can take a few minutes to propagate (occasionally
   longer); until then you may still see `origin_mismatch`.
6. Repeat for the **second** web client (the other app) with that app's own
   domain.

Also confirm the **OAuth consent screen** is configured and (if the app is in
"Testing" mode) that the accounts you sign in with are listed as test users —
otherwise sign-in is refused regardless of origins.

### The other half: the admin console

Client IDs are saved in the admin console under **Settings → Google Login**,
with a field per app **and per platform**:

| | Android field | Web field |
|---|---|---|
| **User app** | used as `serverClientId` | used as `clientId` |
| **Astrologer app** | used as `serverClientId` | used as `clientId` |

Both are OAuth **Web application** client IDs — Android's *own* client is
matched automatically from `google-services.json` (package name + SHA-1) and
is never entered here. They are separate fields because the **web** client is
the one that must carry Authorized JavaScript origins, so it is usually a
different client from the one Android uses.

* Leave the **Android** field blank to reuse that app's **Web** ID — which is
  what existing single-client setups already do, so nothing breaks.
* Every configured ID is accepted as a token audience, so Android and web
  users can sign in at the same time, and you can rotate one platform without
  disturbing the other.

Both apps fetch these at startup, so changing them needs no app rebuild. Copy
the **Client ID** from the same Credentials page (never the client secret — it
isn't used here).

### Common errors and what they actually mean

| Symptom | Cause |
|---|---|
| `origin_mismatch` / popup closes instantly | The page's origin is not in **Authorized JavaScript origins** for that client ID (or the change hasn't propagated) |
| `idpiframe_initialization_failed` | Same as above, or the page is served over plain HTTP on a non-localhost domain |
| Sign-in succeeds but the backend returns 401 | The client ID saved in the admin console doesn't match the one the browser used, so the token audience is rejected |
| "Google login is not configured yet…" | No client ID in the admin console *and* no compiled fallback |

---

## 2. Push notifications on web

Web push needs two values that only exist once a **Web app** is registered in
Firebase (mobile doesn't need either, which is why they start blank).

1. **Firebase console → Project settings → Your apps → Add app → Web.**
   Register one Web app per Flutter app. Copy the generated **App ID**
   (`1:892936615659:web:…`) — and the API key / auth domain / storage bucket
   if they differ from the seeded values.
2. **Firebase console → Project settings → Cloud Messaging → Web Push
   certificates → Generate key pair.** Copy the **public key** (the VAPID
   key).
3. Paste both into the admin console: **Firebase → Web app config**, on the
   matching *User app* / *Astrologer app* tab, then **Save**.

That's all — the web builds read this config at startup, so it takes effect on
the next page load with **no rebuild**. The status pill on that page turns
green ("ready for web") once the API key and App ID are both present.

Notes:

* The service worker (`web/firebase-messaging-sw.js`) is already in place in
  both apps and is deliberately **credential-free**, so it never needs editing
  when credentials change. It is served from the site root and registered
  automatically by the Firebase SDK.
* Browsers only allow push over **HTTPS** (except `localhost`), and the user
  must accept the browser's notification permission prompt.
* Server-side sending uses the **service-account JSON** uploaded on the same
  admin page. One shared account covers Android *and* Web when both apps are
  in the same Firebase project.
* If Android and Web live in **different Firebase projects**, upload a
  dedicated service account per platform under **Firebase → Per-platform
  service accounts**. A device token can only be delivered through the
  project that minted it, so the server groups tokens by platform and sends
  each group through its own credential. A platform with no dedicated
  credential falls back to the shared one.

---

## 3. Audio/video calls and live streaming on web

`agora_rtc_engine`'s web support is a wrapper around Agora's **iris-web-rtc**
JavaScript bundle, which must be loaded by the page. That script tag is
already present in both apps' `web/index.html`; without it every call and live
screen fails at engine initialisation instead of connecting.

* The version is pinned to the one `agora_rtc_engine 6.5.4` is built against
  (`iris-web-rtc_n450_w4220_0.8.6.js`). **Do not bump it independently of the
  plugin** — the wrapper and the bundle are version-matched.
* It currently loads from Agora's official CDN. To drop the runtime CDN
  dependency, download that exact file into `web/` and change the `src` to the
  relative filename; nothing else changes.
* Agora App ID/Certificate come from the admin console (**Agora**) exactly as
  on mobile — the "Test now" button on the Credentials page verifies them.
* Browsers require **HTTPS** (except `localhost`) before granting camera and
  microphone access, and the user must accept the permission prompt.

> Agora's own documentation classes its Flutter **web** support as alpha and
> tested primarily on desktop browsers. Desktop Chrome/Edge is the safe target;
> test mobile browsers before promising them to users.

---

## 4. Deployment checklist

* Serve both web builds over **HTTPS** on the domains registered above.
* Build with `flutter build web` in each app directory; deploy `build/web/`.
* After changing any credential in the admin console, a **page reload** is
  enough — no rebuild, no redeploy.
* After changing anything in `web/` (the SDK script, the service worker, or
  `index.html`), you **do** need to rebuild and redeploy.

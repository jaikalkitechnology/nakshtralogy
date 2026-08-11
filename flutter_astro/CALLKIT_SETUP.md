# CallKit / VoIP incoming-call ringing — setup

Full-screen native incoming-call ringing for the astrologer app. The Dart code
(`lib/services/callkit_service.dart`, wired from `fcm_service.dart`) and the
backend APNs-VoIP sender (`app/services/voip_push.py`) are done. The remaining
work is native platform configuration + Apple credentials, which **cannot be
built or verified in the CI/sandbox** — do it locally in Xcode / Android Studio.

## 0. Install the package
```
cd flutter_astro && flutter pub get
```
`flutter_callkit_incoming: ^2.5.0` was added to `pubspec.yaml`.

## iOS (this is what unlocks killed-app full-screen ringing)

FCM/APNs *notification* pushes cannot present CallKit while the app is killed —
only a **VoIP (PushKit)** push can. Steps:

1. **Capabilities** (Xcode → Signing & Capabilities):
   - Push Notifications
   - Background Modes → check **Voice over IP** and **Remote notifications**
2. **Apple credentials** (developer.apple.com):
   - Create an **Apple VoIP Services Certificate** *or* reuse the **APNs Auth
     Key (.p8)** (recommended — one key does normal + VoIP APNs).
   - Note the **Key ID**, **Team ID**, and the app **bundle id**.
3. **Backend config** — set these (env or admin `platform_settings`
   category `apns_voip`): `APNS_VOIP_KEY_ID`, `APNS_VOIP_TEAM_ID`,
   `APNS_VOIP_BUNDLE_ID`, and the `.p8` at `APNS_VOIP_AUTH_KEY_PATH`
   (or the PEM text in `platform_settings` key `auth_key`).
   Use `APNS_USE_SANDBOX=true` only for development/TestFlight builds.
4. **AppDelegate (PushKit → CallKit bridge)** — register PushKit and forward the
   VoIP push to the plugin so it shows CallKit even from a cold start. In
   `ios/Runner/AppDelegate.swift`:
   ```swift
   import PushKit
   import flutter_callkit_incoming

   // in didFinishLaunchingWithOptions:
   let registry = PKPushRegistry(queue: nil)
   registry.delegate = self
   registry.desiredPushTypes = [.voIP]

   extension AppDelegate: PKPushRegistryDelegate {
     func pushRegistry(_ r: PKPushRegistry, didUpdate c: PKPushCredentials, for t: PKPushType) {
       let token = c.token.map { String(format: "%02x", $0) }.joined()
       SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(token)
     }
     func pushRegistry(_ r: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload,
                       for t: PKPushType, completion: @escaping () -> Void) {
       let d = payload.dictionaryPayload
       let info = [
         "id": d["call_id"] as? String ?? UUID().uuidString,
         "nameCaller": d["caller_name"] as? String ?? "Nakshtralogy",
         "handle": "Incoming call",
         "type": (d["call_type"] as? String == "video") ? 1 : 0,
         "extra": d,
       ] as [String: Any]
       SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(
         flutter_callkit_incoming.Data(args: info), fromPushKit: true)
       completion()
     }
   }
   ```
   > Apple requires that **every** received VoIP push reports a CallKit call, or
   > iOS kills the app. The backend only sends a VoIP push for a real incoming
   > call, which satisfies this.

## Android (optional — FCM full-screen intent already works)

The existing FCM path already shows a full-screen call notification
(`fullScreenIntent: true`, category `call`). `flutter_callkit_incoming` is
additive. If you use its UI, add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>
```
No VoIP token is used on Android (`CallkitService` skips it).

## Data flow

```
user calls → POST /comm/call/initiate
   ├─ FCM push  (Android full-screen intent; iOS foreground)
   └─ VoIP push (voip_push.send_voip_call → APNs /3/device/{token}, type=voip)
          └─ iOS PushKit (AppDelegate) → CallKit full-screen ring (killed OK)
                 ├─ Accept  → CallkitService → POST /comm/call/{id} accept → ActiveCallScreen
                 └─ Decline → CallkitService → POST /comm/call/{id} reject
```

The VoIP token is registered by `CallkitService` on app start
(`POST /astrologer/push/voip/register`) and cleared on logout. If Apple reports
the token dead, the backend clears it automatically.

# Phase D — Payment Aggregator (PAPG): status, design & operator guide

## D.1 — Real IAP receipt validation — DONE (impl) / BLOCKED (go-live)
Shipped in `app/services/iap_verify.py` (real Apple + Google validators, refund
handling), wired via `POST /service/iap/verify` and `POST /service/iap/refund`.

**Go-live checklist (operator — needs real store credentials this env lacks):**
1. Create App Store Connect API key (Issuer ID, Key ID, `.p8` private key) and a
   Google Play service-account JSON with Play Developer API access.
2. Store them in `PlatformSetting` category **`iap`**:
   - `apple_issuer_id`, `apple_key_id`, `apple_private_key` (PEM of the .p8),
     `apple_bundle_id`, `apple_environment` (`production`|`sandbox`)
   - `google_package_name`, `google_service_account_json` (the full JSON)
3. Ensure `PyJWT` + `cryptography` are installed in the server image (already
   needed elsewhere; guarded so a missing backend degrades, never crashes).
4. Leave `IAP_SCAFFOLD_MODE_FORCE = False`. Real validation auto-activates per
   platform once its credentials are present.
5. Configure store server-to-server notifications (Apple ASSN V2 / Google RTDN)
   to `POST /service/iap/refund`. **Signature verification of those webhooks is
   still BLOCKED pending the credentials** — network-restrict the endpoint until
   the JWS/Pub-Sub signature check is added.

**Why BLOCKED for go-live:** real Apple/Google keys + on-device receipts are
required to exercise validation E2E and to verify refund-webhook signatures;
none are available in this build environment.

## D.2 — Web / non-store checkout (Stripe / PayPal) — BLOCKED (needs merchant creds)
Conditional ("if web/non-store needed"). **Blocked** on real Stripe/PayPal
merchant credentials, which this environment does not have.

Design when activated (kept small because the grant path is already unified):
- The **grant** is the same `ServiceOrder` write used by IAP — a Stripe/PayPal
  success handler records a completed `ServiceOrder` with `payment_method =
  "stripe"|"paypal"`, `currency_paid = "USD"`, `iap_transaction_id =` the
  provider charge/order id (idempotency key reused). No new grant logic needed.
- Add `POST /service/checkout/session` (create a Checkout Session / PayPal order,
  amount = `price_usd` from the rule, never the client) and a
  `POST /service/checkout/webhook` (verify the provider signature, then grant).
- USD amounts already come from `app/core/pricing.py`; catalog is shared, so web
  buyers hit the exact same priced services.
- Admin revenue INR+USD is already available (see D.3 revenue-summary); a Stripe
  row appears as `USD / stripe`.

## D.3 — Reconciliation, receipts, tax/VAT — DONE (guidance + reporting)
- **Reporting:** `GET /service/revenue-summary` (admin) returns gross + order
  counts grouped by `currency_paid` × `payment_method`, plus refunds — i.e.
  revenue in **INR (wallet)** and **USD (IAP / future Stripe)** side by side.
- **Reconciliation:** each paid international order stores `iap_transaction_id`
  (Apple `transactionId`/`originalTransactionId` or Google `orderId`). Match
  these against Apple's Sales/Financial reports and Google Play's order reports;
  refunds land via `/service/iap/refund` → order `status = refunded`, so the
  ledger and store reports stay aligned.
- **Receipts:** the `ServiceOrder` row IS the receipt of record (service, amount,
  currency, store txn id, timestamp). Order history (`GET /service/orders`)
  surfaces it to the user.
- **Tax / VAT:** for **store IAP**, Apple/Google act as Merchant of Record and
  collect/remit VAT/GST/sales tax per storefront — the app charges the tier
  price tax-inclusive and must NOT add tax. For a future **Stripe/PayPal** path
  the platform is the merchant of record and must handle tax itself (e.g. Stripe
  Tax) — flagged for when D.2 is unblocked.

## Final verification (this build)
py_compile all touched `.py` OK; 22 ARB locales at 3777-key parity; all Flutter
gen + touched Dart BALANCED; refcheck OK; react_admin USD imports resolve. No
astrology calculation/score/dasha/transit/remedy/confidence logic was changed.

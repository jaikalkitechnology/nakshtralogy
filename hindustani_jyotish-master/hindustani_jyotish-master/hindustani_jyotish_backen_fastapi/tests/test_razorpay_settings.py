"""Admin-managed Razorpay credentials — masked reads, upsert, and resolution."""
from app.services import razorpay_service
from tests.helpers import register_user, seed_admin, user_headers


async def test_razorpay_settings_unconfigured(client):
    admin_h = await seed_admin(email="rzp1@hj.example.com")
    r = await client.get("/v1/admin/razorpay-settings", headers=admin_h)
    assert r.status_code == 200, r.text
    assert r.json() == {"configured": False}


async def test_razorpay_settings_requires_admin(client):
    r = await client.get("/v1/admin/razorpay-settings")
    assert r.status_code in (401, 403)


async def test_razorpay_settings_upsert_masks_secrets(client):
    admin_h = await seed_admin(email="rzp2@hj.example.com")
    r = await client.put(
        "/v1/admin/razorpay-settings",
        json={
            "key_id": "rzp_live_abcd1234",
            "key_secret": "supersecretvalue9876",
            "webhook_secret": "whsecret5555",
            "is_active": True,
        },
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["configured"] is True
    assert body["key_id"] == "rzp_live_abcd1234"
    # secrets are NEVER echoed in full
    assert "key_secret" not in body
    assert body["key_secret_masked"] == "****9876"
    assert body["key_secret_configured"] is True
    assert body["webhook_secret_masked"] == "****5555"

    # GET reflects the stored (masked) row
    r = await client.get("/v1/admin/razorpay-settings", headers=admin_h)
    assert r.json()["key_id"] == "rzp_live_abcd1234"
    assert r.json()["key_secret_masked"] == "****9876"


async def test_razorpay_settings_second_put_updates_single_row(client):
    admin_h = await seed_admin(email="rzp3@hj.example.com")
    await client.put(
        "/v1/admin/razorpay-settings",
        json={"key_id": "rzp_a", "key_secret": "sa1111", "is_active": True},
        headers=admin_h,
    )
    await client.put(
        "/v1/admin/razorpay-settings",
        json={"key_id": "rzp_b", "key_secret": "sb2222", "is_active": True},
        headers=admin_h,
    )
    r = await client.get("/v1/admin/razorpay-settings", headers=admin_h)
    assert r.json()["key_id"] == "rzp_b"


async def test_recharge_intent_uses_admin_key_id(client, monkeypatch):
    """An active admin credential row drives the resolved key_id AND takes
    the REAL Razorpay order path even though PAYMENTS_DEV_MODE defaults to
    True — activating credentials in the admin console is the explicit "go
    live" signal; dev mode only applies while nothing is configured. The
    Razorpay HTTP call is stubbed so the test proves the endpoint → DB creds
    → real-order wiring without network."""
    admin_h = await seed_admin(email="rzp4@hj.example.com")
    await client.put(
        "/v1/admin/razorpay-settings",
        json={"key_id": "rzp_test_fromdb", "key_secret": "secret0001", "is_active": True},
        headers=admin_h,
    )

    import httpx

    calls: list[dict] = []
    orig_post = httpx.AsyncClient.post

    async def fake_post(self, url, *args, **kwargs):
        # Only intercept the Razorpay API — the ASGI test client itself is an
        # httpx.AsyncClient, so a blanket patch would swallow app requests.
        if str(url).startswith("https://api.razorpay.com"):
            calls.append({"url": str(url), "auth": kwargs.get("auth"), "json": kwargs.get("json")})
            return httpx.Response(
                200, json={"id": "order_real_stub123"},
                request=httpx.Request("POST", str(url)),
            )
        return await orig_post(self, url, *args, **kwargs)

    monkeypatch.setattr(httpx.AsyncClient, "post", fake_post)

    uid = await register_user(client, mobile="+919711000001")
    r = await client.post(
        "/v1/wallet/recharge/intent", json={"amount": "100"}, headers=user_headers(uid)
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["key_id"] == "rzp_test_fromdb"
    # The REAL order path ran, authenticated with the admin-configured pair.
    assert body["order_id"] == "order_real_stub123"
    assert calls and calls[0]["auth"] == ("rzp_test_fromdb", "secret0001")


async def test_payment_signature_real_when_secret_configured(monkeypatch):
    """With a configured secret, only the REAL signature verifies — the
    dev-mode signature must be rejected even while PAYMENTS_DEV_MODE is on
    (mirrors create_order's configured-creds-win precedence)."""
    creds = razorpay_service.RazorpayCreds(
        key_id="rzp_x", key_secret="s3cret", webhook_secret=None
    )
    real = razorpay_service.expected_signature("o1", "p1", "s3cret")
    dev = razorpay_service.dev_signature("o1", "p1")
    assert razorpay_service.verify_payment_signature("o1", "p1", real, creds) is True
    assert razorpay_service.verify_payment_signature("o1", "p1", dev, creds) is False


async def test_resolve_credentials_falls_back_to_env(client):
    """With no active row, resolution returns the env creds."""
    from app.core.database import AsyncSessionLocal

    async with AsyncSessionLocal() as db:
        creds = await razorpay_service.resolve_credentials(db)
    assert isinstance(creds, razorpay_service.RazorpayCreds)

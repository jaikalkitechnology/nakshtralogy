"""Coupon redemption at wallet recharge — preview, bonus credit, idempotency."""
from decimal import Decimal

from app.services import razorpay_service
from tests.helpers import register_user, seed_admin, set_wallet, user_headers


async def _create_coupon(client, admin_h, **overrides):
    payload = {
        "code": "welcome10",
        "discount_type": "percent",
        "value": "10",
        "min_amount": "100",
        "usage_limit": 0,
    }
    payload.update(overrides)
    r = await client.post("/v1/admin/coupons", json=payload, headers=admin_h)
    assert r.status_code == 201, r.text
    return r.json()


async def _recharge(client, h, amount, payment_id, coupon_code=None):
    order_id = (
        await client.post("/v1/wallet/recharge/intent", json={"amount": amount}, headers=h)
    ).json()["order_id"]
    body = {
        "razorpay_order_id": order_id,
        "razorpay_payment_id": payment_id,
        "razorpay_signature": razorpay_service.dev_signature(order_id, payment_id),
        "amount": amount,
    }
    if coupon_code is not None:
        body["coupon_code"] = coupon_code
    return await client.post("/v1/wallet/recharge/verify", json=body, headers=h)


async def test_percent_coupon_adds_bonus(client):
    admin_h = await seed_admin(email="cp1@hj.example.com")
    await _create_coupon(client, admin_h)  # 10% off, min 100
    uid = await register_user(client, mobile="+919811000001")
    await set_wallet(uid, Decimal("0"))
    h = user_headers(uid)

    r = await _recharge(client, h, "500", "pay_cp_001", coupon_code="WELCOME10")
    assert r.status_code == 200, r.text
    # 500 + 10% bonus (50) = 550
    assert r.json()["balance_after"] == "550.00"

    # usage counter incremented
    coupons = (await client.get("/v1/admin/coupons", headers=admin_h)).json()
    assert coupons[0]["used_count"] == 1


async def test_coupon_preview_does_not_consume(client):
    admin_h = await seed_admin(email="cp2@hj.example.com")
    await _create_coupon(client, admin_h)
    uid = await register_user(client, mobile="+919811000002")
    h = user_headers(uid)

    r = await client.post(
        "/v1/wallet/coupon/preview",
        json={"amount": "300", "coupon_code": "welcome10"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["bonus"] == "30.00"
    assert r.json()["credited_total"] == "330.00"

    coupons = (await client.get("/v1/admin/coupons", headers=admin_h)).json()
    assert coupons[0]["used_count"] == 0  # preview must not consume


async def test_flat_coupon_capped_by_max_discount(client):
    admin_h = await seed_admin(email="cp3@hj.example.com")
    await _create_coupon(
        client, admin_h, code="flat200", discount_type="flat", value="200", max_discount="150",
        min_amount="0",
    )
    uid = await register_user(client, mobile="+919811000003")
    await set_wallet(uid, Decimal("0"))
    h = user_headers(uid)

    r = await _recharge(client, h, "100", "pay_cp_003", coupon_code="FLAT200")
    assert r.status_code == 200, r.text
    # flat 200 bonus capped at max_discount 150 → 100 + 150 = 250
    assert r.json()["balance_after"] == "250.00"


async def test_coupon_below_min_amount_rejected(client):
    admin_h = await seed_admin(email="cp4@hj.example.com")
    await _create_coupon(client, admin_h, min_amount="1000")
    uid = await register_user(client, mobile="+919811000004")
    h = user_headers(uid)

    r = await client.post(
        "/v1/wallet/coupon/preview",
        json={"amount": "100", "coupon_code": "welcome10"},
        headers=h,
    )
    assert r.status_code == 400


async def test_coupon_usage_limit_enforced(client):
    admin_h = await seed_admin(email="cp5@hj.example.com")
    await _create_coupon(client, admin_h, usage_limit=1)
    uid = await register_user(client, mobile="+919811000005")
    await set_wallet(uid, Decimal("0"))
    h = user_headers(uid)

    r1 = await _recharge(client, h, "500", "pay_cp_005a", coupon_code="welcome10")
    assert r1.status_code == 200, r1.text
    # second redemption exceeds usage cap
    r2 = await _recharge(client, h, "500", "pay_cp_005b", coupon_code="welcome10")
    assert r2.status_code == 400


async def test_coupon_not_reapplied_on_replay(client):
    admin_h = await seed_admin(email="cp6@hj.example.com")
    await _create_coupon(client, admin_h)
    uid = await register_user(client, mobile="+919811000006")
    await set_wallet(uid, Decimal("0"))
    h = user_headers(uid)

    await _recharge(client, h, "500", "pay_cp_006", coupon_code="welcome10")
    # replay the same payment_id → idempotent, coupon not consumed twice
    await _recharge(client, h, "500", "pay_cp_006", coupon_code="welcome10")

    me = await client.get("/v1/me", headers=h)
    assert me.json()["wallet_balance"] == "550.00"  # credited once (500 + 50)
    coupons = (await client.get("/v1/admin/coupons", headers=admin_h)).json()
    assert coupons[0]["used_count"] == 1


async def test_recharge_without_coupon_unchanged(client):
    uid = await register_user(client, mobile="+919811000007")
    await set_wallet(uid, Decimal("0"))
    h = user_headers(uid)
    r = await _recharge(client, h, "500", "pay_cp_007")
    assert r.status_code == 200, r.text
    assert r.json()["balance_after"] == "500.00"

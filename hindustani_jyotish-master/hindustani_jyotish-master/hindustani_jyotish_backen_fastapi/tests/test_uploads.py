"""Uploads — user avatar and astrologer KYC documents (multipart)."""
from tests.helpers import register_astrologer, register_user, user_headers

PNG = b"\x89PNG\r\n\x1a\n" + b"0" * 64


async def test_avatar_upload(client):
    uid = await register_user(client, mobile="+919511000001")
    h = user_headers(uid)
    r = await client.post(
        "/v1/me/avatar",
        files={"file": ("me.png", PNG, "image/png")},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["avatar_url"].endswith(".png")

    # the file is served back over the /media mount
    url = r.json()["avatar_url"]
    got = await client.get(url)
    assert got.status_code == 200


async def test_avatar_rejects_bad_type(client):
    uid = await register_user(client, mobile="+919511000002")
    r = await client.post(
        "/v1/me/avatar",
        files={"file": ("bad.exe", b"MZ...", "application/octet-stream")},
        headers=user_headers(uid),
    )
    assert r.status_code == 400


async def test_kyc_document_upload(client):
    _aid, h = await register_astrologer(client, mobile="+919500000051")
    r = await client.post(
        "/v1/astrologer/kyc/upload",
        data={"doc_type": "pan"},
        files={"file": ("pan.png", PNG, "image/png")},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["doc_type"] == "pan"
    assert r.json()["key"].startswith("kyc/")


async def test_kyc_document_bad_type(client):
    _aid, h = await register_astrologer(client, mobile="+919500000052")
    r = await client.post(
        "/v1/astrologer/kyc/upload",
        data={"doc_type": "passport"},
        files={"file": ("x.png", PNG, "image/png")},
        headers=h,
    )
    assert r.status_code == 400

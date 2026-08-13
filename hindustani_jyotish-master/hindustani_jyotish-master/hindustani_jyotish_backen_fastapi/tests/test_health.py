async def test_root(client):
    r = await client.get("/")
    assert r.status_code == 200
    assert r.json()["name"]


async def test_health(client):
    r = await client.get("/health")
    assert r.status_code == 200
    assert r.json() == {"status": "ok"}


async def test_openapi_lists_phase1_and_stubs(client):
    r = await client.get("/openapi.json")
    assert r.status_code == 200
    paths = r.json()["paths"]
    assert "/v1/auth/google" in paths
    assert "/v1/me" in paths
    assert "/v1/astrologers" in paths
    # later-phase contract is published too
    assert "/v1/consultations/request" in paths
    assert "/v1/wallet/recharge/intent" in paths

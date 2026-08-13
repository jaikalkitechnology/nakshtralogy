"""Hardened POST /admin/create-admin — bootstrap-only + setup-token gate."""
from app.core.config import settings

URL = "/v1/admin/create-admin"


async def test_bootstrap_first_admin_allowed(client):
    r = await client.post(
        URL, json={"email": "first@hj.example.com", "name": "First", "password": "pw123456"}
    )
    assert r.status_code == 200, r.text
    assert r.json()["message"] == "Admin created"


async def test_second_admin_without_token_forbidden(client):
    await client.post(
        URL, json={"email": "boot@hj.example.com", "name": "Boot", "password": "pw123456"}
    )
    r = await client.post(
        URL, json={"email": "two@hj.example.com", "name": "Two", "password": "pw123456"}
    )
    assert r.status_code == 403, r.text


async def test_second_admin_with_valid_token_allowed(client, monkeypatch):
    monkeypatch.setattr(settings, "ADMIN_SETUP_TOKEN", "setup-token-xyz")
    await client.post(
        URL, json={"email": "boot2@hj.example.com", "name": "Boot", "password": "pw123456"}
    )
    r = await client.post(
        URL,
        json={"email": "three@hj.example.com", "name": "Three", "password": "pw123456"},
        headers={"X-Admin-Setup-Token": "setup-token-xyz"},
    )
    assert r.status_code == 200, r.text


async def test_second_admin_with_wrong_token_forbidden(client, monkeypatch):
    monkeypatch.setattr(settings, "ADMIN_SETUP_TOKEN", "setup-token-xyz")
    await client.post(
        URL, json={"email": "boot3@hj.example.com", "name": "Boot", "password": "pw123456"}
    )
    r = await client.post(
        URL,
        json={"email": "four@hj.example.com", "name": "Four", "password": "pw123456"},
        headers={"X-Admin-Setup-Token": "wrong"},
    )
    assert r.status_code == 403, r.text


async def test_duplicate_email_with_token_conflicts(client, monkeypatch):
    monkeypatch.setattr(settings, "ADMIN_SETUP_TOKEN", "tok")
    await client.post(
        URL, json={"email": "dup@hj.example.com", "name": "Dup", "password": "pw123456"}
    )
    r = await client.post(
        URL,
        json={"email": "dup@hj.example.com", "name": "Dup", "password": "pw123456"},
        headers={"X-Admin-Setup-Token": "tok"},
    )
    assert r.status_code == 400, r.text

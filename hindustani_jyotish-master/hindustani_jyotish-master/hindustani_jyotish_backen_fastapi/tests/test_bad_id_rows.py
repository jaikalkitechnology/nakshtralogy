"""A row with a non-UUID id (usually hand-inserted) must not 500 list endpoints.

SQLAlchemy loads a row with a NULL/unparseable primary key as `None` (a NULL
identity key means "no entity"), so any endpoint iterating query results must
tolerate a None entry instead of crashing on `.id`.
"""
from __future__ import annotations

import pytest
from sqlalchemy import text

from app.core.database import AsyncSessionLocal
from tests.helpers import seed_admin

pytestmark = pytest.mark.anyio


async def _insert_bad_agora_row():
    async with AsyncSessionLocal() as db:
        await db.execute(
            text(
                "INSERT INTO agora_settings "
                "(id, app_id, app_certificate, token_expire_seconds, is_active, created_at, updated_at) "
                "VALUES ('not-a-uuid', 'x', 'y', 3600, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)"
            )
        )
        await db.commit()


async def test_list_agora_settings_tolerates_bad_id_row(client):
    headers = await seed_admin()
    await _insert_bad_agora_row()
    r = await client.get("/v1/admin/agora-settings", headers=headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


async def test_diagnostics_bad_ids_finds_the_row(client):
    headers = await seed_admin()
    await _insert_bad_agora_row()
    r = await client.get("/v1/admin/diagnostics/bad-ids", headers=headers)
    assert r.status_code == 200
    body = r.json()
    assert body["ok"] is False
    assert "not-a-uuid" in body["bad_id_rows"].get("agora_settings", [])


async def test_diagnostics_bad_ids_clean_db_is_ok(client):
    headers = await seed_admin()
    r = await client.get("/v1/admin/diagnostics/bad-ids", headers=headers)
    assert r.status_code == 200
    assert r.json()["ok"] is True

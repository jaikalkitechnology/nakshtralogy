"""Test fixtures — run the full app against an async SQLite database.

The custom column types in app.core.database are portable, so the exact MySQL
models exercise here without needing a running MySQL server.
"""
from __future__ import annotations

import os
import pathlib

# Must be set before any app module imports the settings/engine singletons.
_DB_PATH = pathlib.Path(__file__).parent / "_test.db"
os.environ["DATABASE_URL"] = f"sqlite+aiosqlite:///{_DB_PATH}"
os.environ["JWT_SECRET"] = "test-secret"
os.environ["OTP_DEV_MODE"] = "true"
# Off by default suite-wide: many tests legitimately request an OTP for the
# same identifier twice within one test (relogin, role-conflict checks,
# idempotency checks) — that's not what they're testing, so don't make them
# all fight the resend cooldown. tests/test_otp_rate_limit_and_email_case.py
# explicitly re-enables this (monkeypatch) for the tests that actually
# exercise it.
os.environ["OTP_RATE_LIMIT_ENABLED"] = "false"
os.environ["ENVIRONMENT"] = "local"
os.environ["DEBUG"] = "false"  # silence SQL echo during tests
# Tests must never auto-discover and use a REAL Firebase credential — the repo
# keeps one in ../credentials/ for the deployed backend, and push_service's
# auto-discovery would otherwise pick it up here too (matching by relative
# path), making "no creds -> skipped" tests flaky/network-dependent and
# sending real FCM calls with fake test tokens. Force push off entirely.
os.environ["PUSH_ENABLED"] = "false"

import pytest  # noqa: E402
import pytest_asyncio  # noqa: E402
from httpx import ASGITransport, AsyncClient  # noqa: E402

from app.core.database import Base, engine  # noqa: E402
from app.main import app  # noqa: E402
from app.models import *  # noqa: E402,F401,F403


@pytest.fixture(scope="session")
def anyio_backend():
    return "asyncio"


@pytest_asyncio.fixture(autouse=True)
async def _setup_db():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
    yield
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)


@pytest_asyncio.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac

"""Schemas for admin-managed Firebase config (server SDK creds + client build config)."""
from __future__ import annotations

from datetime import datetime

from pydantic import BaseModel


class ServiceAccountOut(BaseModel):
    """Never includes the private key."""

    project_id: str | None = None
    client_email: str | None = None


class ServiceAccountStatusOut(BaseModel):
    exists: bool
    project_id: str | None = None
    client_email: str | None = None
    push_enabled: bool


class ClientConfigOut(BaseModel):
    app: str
    project_id: str | None = None
    updated_at: datetime | None = None

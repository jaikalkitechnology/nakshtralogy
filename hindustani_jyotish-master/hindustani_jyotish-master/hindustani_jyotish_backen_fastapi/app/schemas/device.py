"""Schemas for FCM device-token registration."""
from __future__ import annotations

from pydantic import BaseModel, Field


class DeviceRegister(BaseModel):
    token: str = Field(min_length=8, max_length=255)
    platform: str = Field(default="android", max_length=16)


class DeviceRegistered(BaseModel):
    detail: str = "Device registered for push notifications."

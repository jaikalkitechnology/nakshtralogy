"""Pydantic schemas for the metered gateway (developerApiPlatform/ Phase 4).

These are the PUBLIC request/response contracts for `/api/v2/*` — they are
rendered directly into the developer-facing OpenAPI docs (see
app/routers/gateway_router.py + app/gateway_docs.py), so every field has a
description + example.
"""

from typing import Optional
from pydantic import BaseModel, Field, field_validator


class GatewayBirthData(BaseModel):
    """Raw birth details for a single person — no chart needs to be saved
    first, the gateway computes everything on the fly."""

    name: str = Field(..., min_length=1, max_length=80, description="Person's full name.", examples=["Rahul Kumar"])
    gender: str = Field("M", pattern="^[MFO]$", description="M, F or O.", examples=["M"])
    dob: str = Field(..., pattern=r"^\d{2}/\d{2}/\d{4}$", description="Date of birth, DD/MM/YYYY.", examples=["15/08/1992"])
    tob: str = Field(..., pattern=r"^\d{2}:\d{2}$", description="Time of birth, 24h HH:MM.", examples=["06:30"])
    place: str = Field(..., min_length=2, max_length=100, description="Birth place (city, country).", examples=["Delhi, India"])

    @field_validator("dob")
    @classmethod
    def _validate_dob(cls, v: str) -> str:
        d, m, y = map(int, v.split("/"))
        if not (1 <= d <= 31 and 1 <= m <= 12 and 1800 <= y <= 2100):
            raise ValueError("Invalid date of birth")
        return v

    @field_validator("tob")
    @classmethod
    def _validate_tob(cls, v: str) -> str:
        h, mn = map(int, v.split(":"))
        if not (0 <= h <= 23 and 0 <= mn <= 59):
            raise ValueError("Invalid time of birth")
        return v

    model_config = {
        "json_schema_extra": {
            "example": {"name": "Rahul Kumar", "gender": "M", "dob": "15/08/1992", "tob": "06:30", "place": "Delhi, India"}
        }
    }


class KundliGatewayRequest(GatewayBirthData):
    """POST /api/v2/kundli body — a complete natal chart + every analysis
    module (dashas, doshas, yogas, shadbala, ashtakavarga, aspects, life
    areas, bhava strength, dasha activation, chakra health, today's gochar)."""
    dasha_levels: int = Field(2, ge=1, le=6, description="Vimshottari/Moola dasha drill-down depth (MD→AD→PD…).")


class ReportGatewayRequest(GatewayBirthData):
    """POST /api/v2/reports/{key} body — one of the 15 specialist engines
    (career, wealth, marriage, health, legal, ...). See GET /api/v2/products
    for the full list of valid `key` values."""
    pass


class MilanGatewayRequest(BaseModel):
    """POST /api/v2/milan body — full 3-phase Kundli Milan (Ashtakoot +
    advanced + timing) with a unified compatibility score."""
    person1: GatewayBirthData = Field(..., description="Bride/partner 1 birth details.")
    person2: GatewayBirthData = Field(..., description="Groom/partner 2 birth details.")

    model_config = {
        "json_schema_extra": {
            "example": {
                "person1": {"name": "Priya Singh", "gender": "F", "dob": "22/03/1995", "tob": "14:15", "place": "Mumbai, India"},
                "person2": {"name": "Rahul Kumar", "gender": "M", "dob": "15/08/1992", "tob": "06:30", "place": "Delhi, India"},
            }
        }
    }


class ForecastGatewayRequest(GatewayBirthData):
    """POST /api/v2/forecast body — today's probability forecast for this
    birth chart (career/love/health/finance windows for the current day)."""
    pass


class GatewayMeta(BaseModel):
    product: str
    endpoint: Optional[str] = None
    tps_limit: int
    subscription_expires_at: Optional[str] = None
    latency_ms: Optional[int] = None
    cache_hit: bool = False


class GatewayErrorResponse(BaseModel):
    status: str = "error"
    error: str
    detail: Optional[str] = None

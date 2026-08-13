"""Specialist reports via the Nakshatralogy developer API (Phase J).

Mirrors ``kundli_service``'s generate → charge → store(``KundliReport``) →
reopen-free plumbing, but for the developer API's single-chart "Special
Reports" (``POST /api/v2/reports/<type>``): career, marriage, wealth, health,
legal, …. Every report type is priced/enabled by the admin via the same
``cosmic_services`` table the other cosmic insights use (see
``services/astro/pricing.py``); reports default to PAID while the detailed
kundli stays free.

The shared billing/PDF/record helpers live in ``kundli_service`` — this module
reuses them rather than duplicating the wallet/refund/store logic, so a paid
report is billed and refunded on upstream failure exactly like a paid insight.
When the API key is empty (dev/CI), ``enabled()`` is False and a graceful local
preview is stored instead of calling the provider (the charge still applies,
matching the other paid insights' stub behaviour).
"""
from __future__ import annotations

from datetime import date
from datetime import time as dtime
from typing import Any

from sqlalchemy.ext.asyncio import AsyncSession

from app.models.kundli import KundliReport
from app.models.user import User
from app.services import kundli_service as ks
from app.services import nakshatralogy as nk

# Report type → human PDF/report title. The user-facing display NAME + price
# come from the admin-configured cosmic_services row (seeded from
# pricing.DEFAULTS); this is only the PDF heading. Keys mirror
# nakshatralogy.REPORT_KEYS.
REPORT_TITLES: dict[str, str] = {
    "career": "Career & Profession Report",
    "business": "Business & Entrepreneurship Report",
    "education": "Education & Learning Report",
    "wealth": "Wealth & Finance Report",
    "debt_recovery": "Debt Recovery Report",
    "love": "Love & Romance Report",
    "marriage": "Marriage & Relationship Report",
    "health": "Health & Wellbeing Report",
    "mental_stress": "Mental Stress & Wellbeing Report",
    "property": "Property & Assets Report",
    "legal": "Legal & Disputes Report",
    "life_path": "Life Path Report",
    "character": "Character & Personality Report",
    "past_life": "Past Life Report",
}

# Technical/debug keys the specialist engines emit that carry no user value —
# dropped from the stored/returned payload (mirrors the curation the other
# insight paths do). genericSections on the client also skips `_`-prefixed
# keys, but stripping here keeps the stored payload + PDF clean.
_DROP_KEYS = frozenset({
    "version", "domain", "engine", "birth_jd", "chart_id",
    "confidence_breakdown", "schema_valid",
})


def is_report_type(report_type: str) -> bool:
    return report_type in nk.REPORT_KEYS


def report_title(report_type: str) -> str:
    return REPORT_TITLES.get(report_type, report_type.replace("_", " ").title() + " Report")


def _curate_report(raw: Any) -> dict:
    """Keep the user-facing fields; drop internal/debug machinery."""
    if not isinstance(raw, dict):
        return {}
    return {
        k: v for k, v in raw.items()
        if not k.startswith("_") and k not in _DROP_KEYS
    }


def _stub_report(report_type: str, payload: dict) -> dict:
    """Graceful local preview when the provider is unconfigured (empty key).

    There is no internal specialist engine (unlike the kundli fallback), so a
    minimal, renderable preview is stored — enough for the result sheet + PDF
    not to be blank after a paid call in dev/CI. Rendered generically by the
    client's genericSections + the PDF _walk."""
    title = report_title(report_type)
    return {
        "report_type": report_type,
        "title": title,
        "summary": (
            f"{title} for {payload.get('name') or 'the native'}. "
            "The full specialist analysis is delivered once the astrology "
            "service is connected."
        ),
        "note": "Local preview — connect the Nakshatralogy developer API for "
                "the complete specialist report.",
    }


async def generate_report(
    db: AsyncSession,
    user: User,
    report_type: str,
    *,
    dob: date,
    birth_time: dtime | None = None,
    place: str | None = None,
    name: str | None = None,
    gender: str | None = None,
) -> tuple[KundliReport, dict]:
    """Charge the admin price, call the dev-API report (or store a local
    preview when the provider is off), and persist a ``KundliReport`` row with
    ``type=<report_type>`` so it lists in history and reopens free."""
    if not is_report_type(report_type):
        raise ValueError(f"Unknown report type '{report_type}'")

    payload = ks._birth_payload(
        user, dob=dob, birth_time=birth_time, place=place, name=name, gender=gender,
    )
    title = report_title(report_type)

    if nk.enabled():
        amount, raw = await ks._external(
            db, user, report_type, nk.report_path(report_type), payload
        )
        data = _curate_report(raw)
        data["source"] = "nakshatralogy"
        provider = "nakshatralogy"
    else:
        amount = await ks._charge(db, user, report_type)
        data = _stub_report(report_type, payload)
        data["source"] = "stub"
        provider = "stub"

    inputs = {
        "name": name or payload["name"],
        "dob": dob.isoformat(),
        "time": payload["tob"],
        "place": payload["place"],
        "report_type": report_type,
        "provider": provider,
    }
    return await ks._finish(
        db, user, report_type, inputs, amount, data,
        title=title, details=ks._details_rows(payload),
    )

"""TDS (Tax Deducted at Source) on astrologer payouts — Phase I.

Indian compliance: when the platform pays an astrologer, income tax is deducted
at source against the astrologer's PAN (Permanent Account Number) and remitted
to the government; the astrologer receives the net. The default rate is 10%
(section 194 professional/technical services). Without a valid PAN on the
astrologer's KYC the payout is BLOCKED with a clear "add PAN" reason — this is
the admin-overridable default (turn ``pan_required`` off to instead apply a
higher no-PAN rate, mirroring §206AA).

Money flow (see app/models/payout.py):
    gross      = payout.amount        # already net of platform commission,
                                      # which was taken at consultation settle
    tds_amount = round(gross * rate, 2)
    net_paid   = gross - tds_amount   # what actually reaches the bank

The challan report aggregates TDS collected per financial year / quarter, per
astrologer (with PAN), for remittance + Form 26Q filing.
"""
from __future__ import annotations

import re
from dataclasses import dataclass
from datetime import date, datetime, timezone
from decimal import ROUND_HALF_UP, Decimal

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.admin_content import AppSetting
from app.models.astrologer import Astrologer
from app.models.kyc import AstrologerKYC
from app.models.payout import AstrologerPayout, PayoutStatus

# Standard Indian PAN: 5 letters, 4 digits, 1 letter.
PAN_RE = re.compile(r"^[A-Z]{5}[0-9]{4}[A-Z]$")

SETTING_KEY = "tds"
DEFAULT_TDS = {
    "rate": 0.10,          # 10% when a valid PAN is on file
    "pan_required": True,  # block the payout when PAN missing/invalid
    "no_pan_rate": 0.20,   # applied only when pan_required is False (admin override)
}

_CENT = Decimal("0.01")


class TDSBlocked(Exception):
    """Raised when a payout cannot proceed (e.g. no valid PAN and PAN required)."""


@dataclass
class TDSResult:
    rate: Decimal          # fraction, e.g. Decimal("0.10")
    tds_amount: Decimal    # rounded to paise
    net_paid: Decimal      # gross - tds_amount
    pan: str | None        # PAN snapshot the TDS is charged against


def _money(v: Decimal | float | str) -> Decimal:
    return Decimal(str(v)).quantize(_CENT, rounding=ROUND_HALF_UP)


def normalise_pan(pan: str | None) -> str | None:
    """Uppercase/strip a PAN; return it only if well-formed, else None."""
    p = (pan or "").strip().upper()
    return p if PAN_RE.match(p) else None


async def resolve_tds_config(db: AsyncSession) -> dict:
    """Effective TDS config: admin ``app_settings['tds']`` merged over defaults."""
    row = await db.get(AppSetting, SETTING_KEY)
    cfg = dict(DEFAULT_TDS)
    if row and isinstance(row.value, dict):
        cfg.update(row.value)
    # Coerce to sane types (settings arrive as JSON, possibly strings).
    cfg["rate"] = float(cfg.get("rate", DEFAULT_TDS["rate"]))
    cfg["no_pan_rate"] = float(cfg.get("no_pan_rate", DEFAULT_TDS["no_pan_rate"]))
    cfg["pan_required"] = bool(cfg.get("pan_required", True))
    return cfg


async def set_tds_config(db: AsyncSession, value: dict) -> dict:
    row = await db.get(AppSetting, SETTING_KEY)
    merged = dict(DEFAULT_TDS)
    if row and isinstance(row.value, dict):
        merged.update(row.value)
    merged.update(value or {})
    now = datetime.now(timezone.utc)
    if row is None:
        row = AppSetting(key=SETTING_KEY, value=merged, updated_at=now)
        db.add(row)
    else:
        row.value = merged
        row.updated_at = now
    await db.flush()
    return await resolve_tds_config(db)


def compute_tds(gross: Decimal, pan: str | None, cfg: dict) -> TDSResult:
    """Compute TDS for a gross payout.

    Raises :class:`TDSBlocked` when no valid PAN is on file and ``pan_required``
    is set (the default). With ``pan_required`` off, a missing PAN falls back to
    the higher ``no_pan_rate`` instead of blocking.
    """
    gross = _money(gross)
    valid_pan = normalise_pan(pan)
    if valid_pan:
        rate = Decimal(str(cfg["rate"]))
    else:
        if cfg.get("pan_required", True):
            raise TDSBlocked(
                "Please add a valid PAN in your KYC before withdrawing — it is "
                "required for TDS deduction on payouts."
            )
        rate = Decimal(str(cfg["no_pan_rate"]))
    tds_amount = _money(gross * rate)
    net_paid = _money(gross - tds_amount)
    return TDSResult(rate=rate, tds_amount=tds_amount, net_paid=net_paid, pan=valid_pan)


# ── Challan / report ──────────────────────────────────────────────────

def _fy_bounds(fy_start_year: int) -> tuple[date, date]:
    """Indian financial year: 1 Apr <y> .. 31 Mar <y+1> (end exclusive)."""
    return date(fy_start_year, 4, 1), date(fy_start_year + 1, 4, 1)


def _quarter_bounds(fy_start_year: int, quarter: int) -> tuple[date, date]:
    """Q1 Apr-Jun, Q2 Jul-Sep, Q3 Oct-Dec, Q4 Jan-Mar (end exclusive)."""
    starts = {
        1: date(fy_start_year, 4, 1),
        2: date(fy_start_year, 7, 1),
        3: date(fy_start_year, 10, 1),
        4: date(fy_start_year + 1, 1, 1),
    }
    ends = {
        1: date(fy_start_year, 7, 1),
        2: date(fy_start_year, 10, 1),
        3: date(fy_start_year + 1, 1, 1),
        4: date(fy_start_year + 1, 4, 1),
    }
    return starts[quarter], ends[quarter]


def parse_period(period: str | None) -> tuple[int, int | None, str]:
    """Parse a period string into (fy_start_year, quarter|None, label).

    Accepts: ``"2025-26"`` (whole FY), ``"2025-26-Q3"`` / ``"2025-26/Q3"``
    (one quarter), or None → current Indian FY. Raises ValueError on garbage.
    """
    if not period:
        today = date.today()
        y = today.year if today.month >= 4 else today.year - 1
        return y, None, f"{y}-{str(y + 1)[-2:]}"
    s = period.strip().upper().replace("/", "-").replace(" ", "")
    m = re.match(r"^(\d{4})-(\d{2})(?:-Q([1-4]))?$", s)
    if not m:
        raise ValueError("period must look like '2025-26' or '2025-26-Q3'")
    y = int(m.group(1))
    quarter = int(m.group(3)) if m.group(3) else None
    label = f"{y}-{m.group(2)}" + (f"-Q{quarter}" if quarter else "")
    return y, quarter, label


async def tds_report(
    db: AsyncSession, period: str | None = None, *, statuses: tuple[PayoutStatus, ...] | None = None,
) -> dict:
    """TDS challan summary for a financial year (or one quarter): per-astrologer
    rows (name + PAN + gross/tds/net + count) and grand totals.

    Only payouts on which TDS was actually withheld are counted — by default the
    settled ones (``paid``), since that is what gets remitted. ``created_at`` is
    the deduction date (TDS is computed + recorded at request time)."""
    fy_year, quarter, label = parse_period(period)
    start, end = _quarter_bounds(fy_year, quarter) if quarter else _fy_bounds(fy_year)
    statuses = statuses or (PayoutStatus.paid,)

    rows = list(
        await db.scalars(
            select(AstrologerPayout)
            .where(
                AstrologerPayout.status.in_(statuses),
                AstrologerPayout.created_at >= start,
                AstrologerPayout.created_at < end,
            )
            .order_by(AstrologerPayout.created_at.asc())
        )
    )

    names: dict = {}
    if rows:
        for a in await db.scalars(
            select(Astrologer).where(Astrologer.id.in_({p.astrologer_id for p in rows}))
        ):
            names[a.id] = a.display_name

    # Aggregate per astrologer.
    per: dict = {}
    for p in rows:
        key = p.astrologer_id
        agg = per.setdefault(
            key,
            {
                "astrologer_id": str(key),
                "astrologer_name": names.get(key),
                "pan": p.tds_pan,
                "gross": Decimal("0.00"),
                "tds": Decimal("0.00"),
                "net": Decimal("0.00"),
                "payouts": 0,
            },
        )
        agg["gross"] += _money(p.amount)
        agg["tds"] += _money(p.tds_amount or 0)
        agg["net"] += _money(p.net_paid if p.net_paid is not None else p.amount)
        agg["payouts"] += 1
        if not agg["pan"] and p.tds_pan:
            agg["pan"] = p.tds_pan

    items = [
        {
            **v,
            "gross": str(v["gross"]),
            "tds": str(v["tds"]),
            "net": str(v["net"]),
        }
        for v in sorted(per.values(), key=lambda x: (x["astrologer_name"] or ""))
    ]
    total_tds = sum((v["tds"] for v in per.values()), Decimal("0.00"))
    total_gross = sum((v["gross"] for v in per.values()), Decimal("0.00"))
    total_net = sum((v["net"] for v in per.values()), Decimal("0.00"))

    return {
        "period": label,
        "financial_year": f"{fy_year}-{str(fy_year + 1)[-2:]}",
        "quarter": quarter,
        "from": start.isoformat(),
        "to": end.isoformat(),
        "items": items,
        "totals": {
            "gross": str(_money(total_gross)),
            "tds": str(_money(total_tds)),
            "net": str(_money(total_net)),
            "payouts": len(rows),
            "astrologers": len(per),
        },
    }

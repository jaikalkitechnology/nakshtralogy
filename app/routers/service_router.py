"""
Service Router — Pricing Catalog + Birth Charts + Kundli Compute
================================================================
GET    /pricing                — list all active service pricing (public)
GET    /pricing/{id}           — single pricing detail
POST   /pricing                — admin: create pricing
PUT    /pricing/{id}           — admin: update pricing
POST   /pricing/seed           — admin: seed default kundli services

POST   /charts                 — create birth chart (compute kundli)
GET    /charts                 — list my charts
GET    /charts/{id}            — get chart with full JSON
PUT    /charts/{id}            — update chart metadata
DELETE /charts/{id}            — delete chart

POST   /compute/dasha          — compute vimshottari dasha for a chart
POST   /compute/moola          — compute moola dasha for a chart
POST   /compute/divisional     — get divisional chart positions
GET    /compute/gochar          — daily gochar (free, no chart needed)

POST   /purchase               — purchase a paid service (wallet debit)
GET    /orders                 — my service order history
"""

import io
import sys
import contextlib
from typing import List, Optional
from decimal import Decimal

from fastapi import APIRouter, Depends, HTTPException, Query, Header, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role, get_lang_user
from app.core.i18n import get_lang, t
from app.models.model import (
    User, Chart, DashaCache, ServicePricing, ServiceOrder,
    Wallet, WalletTransaction,
)
from app.schemas.service_schema import (
    ServicePricingResponse, ServicePricingCreate, ServicePricingUpdate,
    BirthChartCreateRequest, BirthChartResponse, BirthChartListResponse,
    BirthChartUpdateRequest, ComputeServiceRequest, GocharRequest,
    PurchaseServiceRequest, ServiceOrderResponse, ServiceOrderListResponse,
    MessageResponse, PricingSettingsUpdate,
)
from app.core import pricing as pricing_util
from app.core import region as region_util

router = APIRouter()


# ─── Kundli Engine Helpers ───────────────────────────────────────────

def _get_engine():
    """Lazy import of nakshtralogy engine."""
    sys.path.insert(0, "scripts")
    import nakshralogyV2 as nk
    return nk


def _silent_chart(nk, name, gender, dob, tob, place):
    """Run calculate_chart without printing to stdout."""
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        pdata, divs = nk.calculate_chart(name, gender, dob, tob, place)
    return pdata, divs


def _build_chart_json(nk, pdata, divs):
    """Convert raw pdata+divs into structured JSON."""
    SIGNS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
    SIGNS_FULL = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
                  'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']

    planets_out = {}
    for p, d in pdata.items():
        planets_out[p] = {
            "sign":       SIGNS[d["rashi_idx"]],
            "sign_full":  SIGNS_FULL[d["rashi_idx"]],
            "sign_idx":   d["rashi_idx"],
            "degree":     round(d["deg_rashi"], 4),
            "longitude":  round(d["lon"], 4),
            "nakshatra":  d.get("nak_name", ""),
            "nak_lord":   d.get("nak_lord", ""),
            "pada":       d.get("pada", 1),
            "dignity":    d.get("dignity", "Normal"),
            "vakri":      d.get("vakri", False),
            "combust":    d.get("combust", False),
            "vargottam":  d.get("vargottam", False),
        }

    divisionals_out = {}
    for planet, chart_map in divs.items():
        divisionals_out[planet] = {
            f"D{dnum}": SIGNS[s] for dnum, s in chart_map.items()
        }

    return {
        "planets":     planets_out,
        "divisionals": divisionals_out,
        "lagna_sign":  SIGNS_FULL[pdata["Lagna"]["rashi_idx"]],
        "lagna_idx":   pdata["Lagna"]["rashi_idx"],
    }


def _get_birth_jd(nk, dob, tob, place):
    """Parse birth data and compute Julian Day."""
    day, month, year = map(int, dob.split("/"))
    hour, minute = map(int, tob.split(":"))
    local_h = hour + minute / 60.0
    coords = nk.get_city(place)
    if coords is None:
        lat, lon_deg, tz = 19.076, 72.8777, 5.5
    else:
        lat, lon_deg, tz = coords
    ut_hour = local_h - tz
    jd = nk.to_julian_day(year, month, day, ut_hour)
    return jd, lat, lon_deg, tz


# ══════════════════════════════════════════════════════════════════════
#  PRICING CATALOG
# ══════════════════════════════════════════════════════════════════════

def _apply_session_pricing(sp, region: str, fx: float, mult: float):
    """Attach transient session_currency / session_amount / pay_via to a
    ServicePricing ORM row for the caller's region. INTL → USD via store IAP;
    IN → INR via the wallet. Free services present amount 0 in both. Never
    touches the stored columns or any astrology logic."""
    intl = region_util.is_international_region(region)
    price = float(sp.price or 0)
    if sp.is_free or price == 0:
        sp.session_currency = "USD" if intl else "INR"
        sp.session_amount = 0.0
        sp.pay_via = "free"
        return sp
    if intl:
        usd = pricing_util.usd_for_pricing(sp, fx, mult)
        sp.session_currency = "USD"
        sp.session_amount = float(usd) if usd else 0.0
        sp.pay_via = "iap"
    else:
        sp.session_currency = "INR"
        sp.session_amount = price
        sp.pay_via = "wallet"
    return sp


@router.get("/pricing", response_model=List[ServicePricingResponse])
def list_pricing(
    category: Optional[str] = None,
    include_inactive: bool = False,
    search: Optional[str] = None,
    region: Optional[str] = Query(None, description="Session region override IN|INTL"),
    x_device_country: Optional[str] = Header(None),
    db: Session = Depends(get_db),
):
    """
    Public: list active service pricing.
    Admin can pass include_inactive=true and search to see all entries.

    Each row carries a session view (`session_currency`, `session_amount`,
    `pay_via`) for the caller's region — USD/IAP for international, ₹/wallet for
    India. Region comes from ?region= or the X-Device-Country hint (no user
    context on this public endpoint).
    """
    q = db.query(ServicePricing)
    if not include_inactive:
        q = q.filter(ServicePricing.is_active == True)
    if category:
        q = q.filter(ServicePricing.category == category)
    if search:
        like = f"%{search}%"
        q = q.filter(
            (ServicePricing.service_name.like(like)) |
            (ServicePricing.service_key.like(like))
        )
    rows = q.order_by(ServicePricing.sort_order, ServicePricing.price).all()
    sess = region_util.session_region(explicit_region=region, device_country=x_device_country)
    fx = pricing_util.get_fx_rate(db)
    mult = pricing_util.get_multiplier(db)
    for sp in rows:
        _apply_session_pricing(sp, sess, fx, mult)
    return rows


@router.get("/pricing/{pricing_id}", response_model=ServicePricingResponse)
def get_pricing(
    pricing_id: str,
    region: Optional[str] = Query(None, description="Session region override IN|INTL"),
    x_device_country: Optional[str] = Header(None),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    p = db.query(ServicePricing).filter(ServicePricing.id == pricing_id).first()
    if not p:
        raise HTTPException(status_code=404, detail=t("err.service_not_found", lang))
    sess = region_util.session_region(explicit_region=region, device_country=x_device_country)
    _apply_session_pricing(p, sess, pricing_util.get_fx_rate(db), pricing_util.get_multiplier(db))
    return p


@router.post("/pricing", response_model=ServicePricingResponse, status_code=201)
def create_pricing(
    req: ServicePricingCreate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Admin-only: create a new service pricing."""
    if db.query(ServicePricing).filter(ServicePricing.service_key == req.service_key).first():
        raise HTTPException(status_code=409, detail=t("err.service_key_exists", lang))
    sp = ServicePricing(**req.model_dump())
    # Seed the USD price from the global rule (free services stay null).
    fx = pricing_util.get_fx_rate(db)
    mult = pricing_util.get_multiplier(db)
    usd = pricing_util.usd_for_pricing(sp, fx, mult)
    sp.price_usd = usd
    sp.iap_product_id = (
        pricing_util.iap_product_id_for(sp.service_key, usd) if usd else None
    )
    db.add(sp)
    db.commit()
    db.refresh(sp)
    return sp


@router.put("/pricing/{pricing_id}", response_model=ServicePricingResponse)
def update_pricing(
    pricing_id: str,
    req: ServicePricingUpdate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    sp = db.query(ServicePricing).filter(ServicePricing.id == pricing_id).first()
    if not sp:
        raise HTTPException(status_code=404, detail=t("err.service_not_found", lang))
    data = req.model_dump(exclude_unset=True)
    # Editing the USD price or store product id is a manual override → protect it
    # from the bulk "regenerate USD" rule, unless the admin explicitly toggles
    # price_usd_manual in the same request.
    manual_touch = ("price_usd" in data or "iap_product_id" in data) and "price_usd_manual" not in data
    for field, value in data.items():
        setattr(sp, field, value)
    if manual_touch:
        sp.price_usd_manual = True
    # If the INR price changed and the row isn't a manual override, refresh USD.
    if "price" in data and not sp.price_usd_manual:
        fx = pricing_util.get_fx_rate(db)
        mult = pricing_util.get_multiplier(db)
        usd = pricing_util.usd_for_pricing(sp, fx, mult)
        sp.price_usd = usd
        sp.iap_product_id = (
            pricing_util.iap_product_id_for(sp.service_key, usd) if usd else None
        )
    db.commit()
    db.refresh(sp)
    return sp


# ── USD pricing settings + bulk regenerate (admin) ───────────────────

@router.get("/pricing-settings/usd")
def get_usd_pricing_settings(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin: current FX rate + multiplier + IAP tier ladder used by the global
    USD rule ``usd = round_to_tier(inr × MULT ÷ FX)``."""
    return pricing_util.get_pricing_settings(db)


@router.put("/pricing-settings/usd")
def update_usd_pricing_settings(
    req: PricingSettingsUpdate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin: set the FX rate (INR per USD) and/or multiplier. Does not itself
    re-price services — call POST /pricing/regenerate-usd for that."""
    return pricing_util.set_pricing_settings(
        db,
        fx_rate=req.fx_rate_usd,
        multiplier=req.usd_multiplier,
        updated_by=current_user.id,
    )


@router.post("/pricing/regenerate-usd")
def regenerate_usd(
    force: bool = Query(False, description="Also overwrite admin-overridden prices"),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin: recompute price_usd + iap_product_id for every priced service from
    the current rule. Skips manual overrides unless force=true."""
    return pricing_util.regenerate_usd_prices(db, force=force)


@router.delete("/pricing/{pricing_id}", response_model=MessageResponse)
def delete_pricing(
    pricing_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Admin-only: delete a service pricing entry."""
    sp = db.query(ServicePricing).filter(ServicePricing.id == pricing_id).first()
    if not sp:
        raise HTTPException(status_code=404, detail=t("err.service_not_found", lang))
    db.delete(sp)
    db.commit()
    return MessageResponse(message=t("msg.service_deleted", lang, name=sp.service_name))


@router.post("/pricing/seed", response_model=MessageResponse)
def seed_pricing(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Admin-only: seed default Nakshtralogy service catalog."""
    defaults = [
        {
            "service_key": "birth_chart",
            "service_name": "Birth Chart (Janam Kundli)",
            "description": "Complete birth chart with D1 kundli, planetary positions, nakshatra, dignity, and all 20 divisional chart positions (D1-D60)",
            "icon": "📜",
            "category": "kundli",
            "price": 0,
            "is_free": True,
            "sort_order": 1,
            "features_json": ["D1 Lagna Kundli", "10 Graha Positions", "Nakshatra & Pada", "Dignity & Vargottam", "D1-D60 Divisional Charts"],
            "engine_function": "calculate_chart",
            "requires_birth_data": True,
            # First (primary) chart is free forever; extra charts consume the
            # `extra_chart` price. Admin-editable.
            "max_free_per_user": 1,
        },
        {
            "service_key": "vimshottari_dasha",
            "service_name": "Vimshottari Dasha",
            "description": "Complete 6-level Vimshottari Dasha timeline: Mahadasha > Antardasha > Pratyantardasha > Sookshma > Prana > Deha",
            "icon": "🕐",
            "category": "kundli",
            "price": 0,
            "is_free": True,
            "sort_order": 2,
            "features_json": ["120-Year Dasha Cycle", "6 Sub-Levels (MD to Deha)", "Moon Nakshatra Based", "Date-wise Timeline"],
            "engine_function": "vimshottari_dasha",
            "requires_birth_data": True,
            "max_free_per_user": 3,
        },
        {
            "service_key": "moola_dasha",
            "service_name": "Moola Dasha",
            "description": "Lagna Kendradi Graha Dasha - advanced dasha system based on D-60 chart, confirmed against JHora software",
            "icon": "🌀",
            "category": "kundli",
            "price": 99,
            "original_price": 199,
            "is_free": False,
            "sort_order": 3,
            "features_json": ["D-60 Based Calculation", "Kendradi Graha Order", "PVR Narasimha Method", "6-Level Sub-Periods"],
            "engine_function": "moola_dasha_lagna",
            "requires_birth_data": True,
        },
        {
            "service_key": "gochar_daily",
            "service_name": "Daily Horoscope (Gochar)",
            "description": "Daily transit scoring for all 12 rashis with Sade Sati and Chandrashtama alerts",
            "icon": "🌅",
            "category": "kundli",
            "price": 0,
            "is_free": True,
            "sort_order": 4,
            "features_json": ["12 Rashi Scores", "Sade Sati Alert", "Chandrashtama Alert", "Transit Grade"],
            "engine_function": "gochar_chart",
            "requires_birth_data": False,
        },
        {
            "service_key": "kundli_matching",
            "service_name": "Kundli Matching (Gun Milan)",
            "description": "Comprehensive Gun Milan for marriage compatibility with 36-point Ashtakoot matching",
            "icon": "💑",
            "category": "kundli",
            "price": 499,
            "is_free": False,
            "sort_order": 5,
            "features_json": ["36-Point Ashtakoot", "Manglik Check", "Nadi Dosha", "Compatibility Score"],
            "engine_function": "kundli_matching",
            "requires_birth_data": True,
        },
        {
            "service_key": "manglik_check",
            "service_name": "Manglik Dosha Check",
            "description": "Check Manglik Dosha presence and severity in your kundli",
            "icon": "🔴",
            "category": "report",
            "price": 199,
            "is_free": False,
            "sort_order": 6,
            "features_json": ["Mars Position Analysis", "Dosha Severity Level", "Remedies Suggested"],
            "engine_function": "manglik_check",
            "requires_birth_data": True,
        },
        {
            "service_key": "sade_sati",
            "service_name": "Sade Sati Report",
            "description": "Saturn transit impact analysis - past, current and upcoming Sade Sati periods",
            "icon": "🪐",
            "category": "report",
            "price": 249,
            "is_free": False,
            "sort_order": 7,
            "features_json": ["Saturn Transit Timeline", "Phase Analysis (Rising/Peak/Setting)", "Impact Assessment"],
            "engine_function": "sade_sati_report",
            "requires_birth_data": True,
        },
        {
            "service_key": "career_report",
            "service_name": "Career & Finance Report",
            "description": "Detailed career and financial predictions based on 10th house, Dasamsha (D-10) and dasha timeline",
            "icon": "💼",
            "category": "report",
            "price": 599,
            "is_free": False,
            "sort_order": 8,
            "features_json": ["10th House Analysis", "D-10 Dasamsha Chart", "Dasha Career Windows", "Financial Periods"],
            "engine_function": "career_report",
            "requires_birth_data": True,
        },
        {
            "service_key": "love_report",
            "service_name": "Love & Relationship Report",
            "description": "Insights into your love life based on Venus, 7th house, and Navamsha (D-9)",
            "icon": "❤️",
            "category": "report",
            "price": 399,
            "is_free": False,
            "sort_order": 9,
            "features_json": ["7th House Analysis", "Venus & D-9 Navamsha", "Marriage Timing", "Relationship Patterns"],
            "engine_function": "love_report",
            "requires_birth_data": True,
        },
        {
            "service_key": "health_report",
            "service_name": "Health Report",
            "description": "Health predictions based on 6th/8th house, planetary afflictions and dasha periods",
            "icon": "🏥",
            "category": "report",
            "price": 349,
            "is_free": False,
            "sort_order": 10,
            "features_json": ["6th & 8th House", "Planetary Afflictions", "Health Sensitive Periods"],
            "engine_function": "health_report",
            "requires_birth_data": True,
        },
        {
            "service_key": "yearly_prediction",
            "service_name": "Yearly Prediction",
            "description": "Comprehensive yearly forecast combining Vimshottari dasha, Gochar transits and Varshaphala",
            "icon": "📅",
            "category": "report",
            "price": 699,
            "is_free": False,
            "sort_order": 11,
            "features_json": ["Dasha Forecast", "Transit Analysis", "Month-wise Breakdown", "Key Dates"],
            "engine_function": "yearly_prediction",
            "requires_birth_data": True,
        },
        {
            "service_key": "ai_reading",
            "service_name": "AI Astro Reading",
            "description": "AI-powered personalized birth chart interpretation using advanced language models",
            "icon": "🤖",
            "category": "ai",
            "price": 149,
            "is_free": False,
            "sort_order": 12,
            "features_json": ["AI Personality Analysis", "Life Path Insights", "Dasha Interpretation", "Personalized Advice"],
            "engine_function": "ai_reading",
            "requires_birth_data": True,
        },
    ]

    # ── End-user monetization v1: pay-per-report catalog ──────────────
    # These service_keys MATCH the specialist engine keys (career, business,
    # …) so /service/entitlements and the 402 access-gate can map a report
    # request 1:1 to its pricing row. Prices below are DEFAULTS only — every
    # value is admin-editable via /service/pricing (source of truth). Never
    # hardcode a price in the app or engines.
    #
    #   single-chart report  → ₹149 (category "report")
    #   two-chart / combined → ₹299 (category "report")
    #   moola_dasha          → ₹99  (seeded above, category "kundli")
    #   detailed daily forecast → ₹149 (category "forecast")
    #   extra kundli         → ₹49  (category "kundli")
    _SINGLE_REPORTS = [
        ("career",        "Career & Job Report",        "💼", "10th house, D-10 Dasamsha, Jaimini karakas & dasha career windows"),
        ("business",      "Business & Startup Report",  "🚀", "Entrepreneurial yogas, timing windows & venture-fit analysis"),
        ("education",     "Education & Learning Report", "🎓", "4th/5th house, Budha & Guru, ideal streams and study periods"),
        ("wealth",        "Wealth & Finance Report",     "💰", "Dhana yogas, 2nd/11th house, income & savings potential"),
        ("debt_recovery", "Debt & Recovery Report",      "📉", "6th/8th/12th house debt patterns & recovery timing"),
        ("love",          "Love & Relationships Report", "❤️", "Venus, 5th/7th house, D-9 Navamsha & relationship patterns"),
        ("marriage",      "Marriage & Family Report",    "💒", "7th house, marriage timing, spouse indications & family life"),
        ("health",        "Health & Wellness Report",    "🏥", "6th/8th house, planetary afflictions & sensitive health periods"),
        ("mental_stress", "Mental & Stress Report",      "🧠", "Moon, Mercury & 12th house — mental resilience and stress map"),
        ("property",      "Property & Assets Report",    "🏠", "4th house, land/vehicle yogas & acquisition timing"),
        ("legal",         "Legal & Disputes Report",     "⚖️", "6th house, litigation windows & outcome tendencies"),
        ("life_path",     "Life Path & Luck Report",     "🌟", "Atmakaraka, purpose, fortune (9th house) & luck cycles"),
        ("character",     "Character Analysis Report",   "🔍", "Personality, temperament & psychological profile"),
        ("past_life",     "Past Life & Karma Report",    "🔮", "D-60 Shashtiamsha karma, past-life debts & soul lessons"),
    ]
    _COMBO_REPORTS = [
        ("kundli_milan",      "Kundli Milan (Gun Milan)",   "💑", "36-point Ashtakoot, Manglik & Nadi dosha, unified compatibility"),
        ("relationship",      "Relationship Intelligence",  "🔗", "2-5 chart relationship dynamics & compatibility intelligence"),
        ("child_probability", "Child Probability Report",   "👶", "Santaan yoga, 5th house & fertility timing for a couple"),
        ("love_compatibility","Love Compatibility Report",  "💞", "Romantic compatibility, emotional & karmic bonding score"),
        ("karma_linkage",     "Past-Life Karma Linkage",    "🧬", "Karmic ties across 2-5 charts & shared soul contracts"),
    ]

    sort = 20
    for key, name, icon, desc in _SINGLE_REPORTS:
        sort += 1
        defaults.append({
            "service_key": key,
            "service_name": name,
            "description": desc,
            "icon": icon,
            "category": "report",
            "price": 149,
            "original_price": 249,
            "is_free": False,
            "sort_order": sort,
            "features_json": ["Full multi-chart analysis", "Score-ring + grade", "Timing windows", "Remedies & confidence"],
            "engine_function": key,
            "requires_birth_data": True,
        })
    for key, name, icon, desc in _COMBO_REPORTS:
        sort += 1
        defaults.append({
            "service_key": key,
            "service_name": name,
            "description": desc,
            "icon": icon,
            "category": "report",
            "price": 299,
            "original_price": 499,
            "is_free": False,
            "sort_order": sort,
            "features_json": ["Two-chart / multi-chart analysis", "Compatibility scoring", "Detailed breakdown", "Remedies & confidence"],
            "engine_function": key,
            "requires_birth_data": True,
        })

    defaults.append({
        "service_key": "daily_forecast",
        "service_name": "Detailed Daily Forecast",
        "description": "Personalized daily probability forecast — planetary weather across every life area for your chart",
        "icon": "🔆",
        "category": "forecast",
        "price": 149,
        "original_price": 199,
        "is_free": False,
        "sort_order": 60,
        "features_json": ["Daily probability scores", "Per-life-area weather", "Best/worst windows", "Actionable guidance"],
        "engine_function": "daily_forecast",
        "requires_birth_data": True,
    })
    defaults.append({
        "service_key": "extra_chart",
        "service_name": "Additional Kundli",
        "description": "Create an extra birth chart beyond your free Primary Kundli (family, friend or client)",
        "icon": "➕",
        "category": "kundli",
        "price": 49,
        "original_price": 99,
        "is_free": False,
        "sort_order": 61,
        "features_json": ["Extra saved chart", "Full kundli compute", "All divisional charts", "Reusable for reports"],
        "engine_function": "calculate_chart",
        "requires_birth_data": True,
    })

    created = 0
    for d in defaults:
        if not db.query(ServicePricing).filter(ServicePricing.service_key == d["service_key"]).first():
            db.add(ServicePricing(**d))
            created += 1
    db.commit()
    return MessageResponse(
        message=t("msg.services_seeded", lang, created=created, existing=len(defaults) - created)
    )


# ══════════════════════════════════════════════════════════════════════
#  BIRTH CHARTS (Multiple per user)
# ══════════════════════════════════════════════════════════════════════

@router.post("/charts", response_model=BirthChartResponse, status_code=201)
def create_chart(
    req: BirthChartCreateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """
    Create a new birth chart. Runs nakshralogyV2.calculate_chart
    and stores the full result as chart_json.
    Both users and astrologers can create charts.
    """
    nk = _get_engine()

    try:
        pdata, divs = _silent_chart(nk, req.name, req.gender or "M", req.dob, req.tob, req.place)
    except Exception as e:
        raise HTTPException(status_code=422, detail=t("err.chart_computation_failed", lang, error=str(e)))

    if pdata is None:
        raise HTTPException(status_code=422, detail=t("err.chart_compute_no_data", lang))

    chart_json = _build_chart_json(nk, pdata, divs)

    # resolve coordinates
    coords = nk.get_city(req.place)
    lat = coords[0] if coords else None
    lon = coords[1] if coords else None
    tz = str(coords[2]) if coords else None

    # ── Free Primary Kundli: the user's FIRST chart is always the primary
    # (free forever, non-deletable). Exactly one primary per user. ──
    existing_count = db.query(Chart).filter(Chart.user_id == current_user.id).count()
    is_first = existing_count == 0
    is_primary = bool(req.is_primary) or is_first

    # ── Extra-chart gate: every chart beyond the free Primary consumes a paid
    # `extra_chart` credit (a completed ServiceOrder with no chart linked yet).
    # Money only ever moves through /service/purchase — here we merely consume
    # an already-bought credit, or 402 if none exists. ──
    extra_credit = None
    if not is_first and getattr(current_user, "role", None) not in ("astrologer", "admin"):
        from app.core.entitlements import get_pricing, payment_required_detail
        sp_extra = get_pricing(db, "extra_chart")
        if sp_extra and not sp_extra.is_free and float(sp_extra.price or 0) > 0:
            extra_credit = db.query(ServiceOrder).filter(
                ServiceOrder.user_id == current_user.id,
                ServiceOrder.service_pricing_id == sp_extra.id,
                ServiceOrder.chart_id.is_(None),
                ServiceOrder.status == "completed",
            ).order_by(ServiceOrder.created_at.asc()).first()
            if extra_credit is None:
                raise HTTPException(status_code=402, detail=payment_required_detail(sp_extra, lang))

    # if is_primary, unset existing primary (keep exactly one)
    if is_primary:
        db.query(Chart).filter(
            Chart.user_id == current_user.id, Chart.is_primary == True
        ).update({"is_primary": False})

    chart = Chart(
        user_id=current_user.id,
        name=req.name,
        gender=req.gender,
        dob=req.dob,
        tob=req.tob,
        place=req.place,
        latitude=lat,
        longitude=lon,
        timezone=tz,
        chart_json=chart_json,
        is_primary=is_primary,
        category=req.category,
    )
    db.add(chart)
    db.flush()

    # consume the extra-chart credit by linking it to the new chart
    if extra_credit is not None:
        extra_credit.chart_id = chart.id

    # auto-compute & cache vimshottari dasha
    try:
        moon_lon = chart_json["planets"]["Moon"]["longitude"]
        jd, _, _, _ = _get_birth_jd(nk, req.dob, req.tob, req.place)
        v_dashas, v_balance, v_lord = nk.vimshottari_dasha(moon_lon, jd)
        vimsh_data = {"balance_yrs": round(v_balance, 4), "first_lord": v_lord}

        dasha_cache = DashaCache(chart_id=chart.id, vimshottari=vimsh_data)
        db.add(dasha_cache)
    except Exception:
        pass  # dasha cache is optional

    # update user moon_sign if this is their primary chart
    if is_primary:
        current_user.moon_sign = chart_json["planets"]["Moon"]["sign_idx"]

    # create free service order if service_key provided
    if req.service_key:
        sp = db.query(ServicePricing).filter(ServicePricing.service_key == req.service_key).first()
        if sp and sp.is_free:
            db.add(ServiceOrder(
                user_id=current_user.id,
                service_pricing_id=sp.id,
                chart_id=chart.id,
                amount_paid=0,
                status="completed",
                result_json=chart_json,
            ))

    db.commit()
    db.refresh(chart)
    return chart


@router.get("/charts", response_model=List[BirthChartListResponse])
def list_charts(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """List birth charts for the current user with pagination."""
    charts = db.query(Chart).filter(
        Chart.user_id == current_user.id
    ).order_by(Chart.created_at.desc()).offset(skip).limit(limit).all()
    return charts


@router.get("/charts/{chart_id}", response_model=BirthChartResponse)
def get_chart(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    chart = db.query(Chart).filter(
        Chart.id == chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail=t("err.chart_not_found", lang))
    return chart


@router.put("/charts/{chart_id}", response_model=BirthChartResponse)
def update_chart(
    chart_id: str,
    req: BirthChartUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Update chart metadata. If dob/tob/place changed, re-compute kundli."""
    chart = db.query(Chart).filter(
        Chart.id == chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail=t("err.chart_not_found", lang))

    # Guard: the free Primary Kundli is protected — it can't be edited. To
    # change primaries, promote another chart (which auto-demotes this one).
    if chart.is_primary:
        raise HTTPException(status_code=403, detail=t("err.primary_chart_no_edit", lang))

    update_data = req.model_dump(exclude_unset=True)
    needs_recompute = any(k in update_data for k in ("dob", "tob", "place"))

    for field, value in update_data.items():
        if field == "is_primary" and value:
            db.query(Chart).filter(
                Chart.user_id == current_user.id, Chart.is_primary == True
            ).update({"is_primary": False})
        setattr(chart, field, value)

    if needs_recompute:
        nk = _get_engine()
        try:
            pdata, divs = _silent_chart(
                nk, chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place
            )
            if pdata:
                chart.chart_json = _build_chart_json(nk, pdata, divs)
                coords = nk.get_city(chart.place)
                if coords:
                    chart.latitude = coords[0]
                    chart.longitude = coords[1]
                    chart.timezone = str(coords[2])
        except Exception:
            pass

    db.commit()
    db.refresh(chart)
    return chart


@router.delete("/charts/{chart_id}", response_model=MessageResponse)
def delete_chart(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    chart = db.query(Chart).filter(
        Chart.id == chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail=t("err.chart_not_found", lang))
    # Guard: the free Primary Kundli is non-deletable.
    if chart.is_primary:
        raise HTTPException(status_code=403, detail=t("err.primary_chart_no_delete", lang))
    db.delete(chart)
    db.commit()
    return MessageResponse(message=t("msg.chart_deleted", lang))


# ══════════════════════════════════════════════════════════════════════
#  KUNDLI COMPUTE ENDPOINTS
# ══════════════════════════════════════════════════════════════════════

@router.post("/compute/dasha")
def compute_vimshottari(
    req: ComputeServiceRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Compute Vimshottari Dasha for an existing chart."""
    chart = db.query(Chart).filter(
        Chart.id == req.chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail=t("err.chart_not_found", lang))

    # check cache
    if chart.dasha_cache and chart.dasha_cache.vimshottari:
        return chart.dasha_cache.vimshottari

    nk = _get_engine()
    moon_lon = chart.chart_json["planets"]["Moon"]["longitude"]
    jd, _, _, _ = _get_birth_jd(nk, chart.dob, chart.tob, chart.place)

    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        v_dashas, v_balance, v_lord = nk.vimshottari_dasha(moon_lon, jd)

    # build response with MD + AD levels
    result = []
    for md in v_dashas:
        ads = []
        for ad in md.get("sub", []):
            ads.append({
                "planet": ad["planet"],
                "start": nk.jd_to_date(ad["start_jd"]),
                "end": nk.jd_to_date(ad["end_jd"]),
                "months": round(ad.get("months", (ad["end_jd"] - ad["start_jd"]) / 30.4375), 2),
            })
        result.append({
            "planet": md["planet"],
            "years": md["years"],
            "start": nk.jd_to_date(md["start_jd"]),
            "end": nk.jd_to_date(md["end_jd"]),
            "sub": ads,
        })

    data = {"balance_yrs": round(v_balance, 4), "first_lord": v_lord, "dashas": result}

    # cache
    if chart.dasha_cache:
        chart.dasha_cache.vimshottari = data
    else:
        db.add(DashaCache(chart_id=chart.id, vimshottari=data))
    db.commit()

    return data


@router.post("/compute/moola")
def compute_moola(
    req: ComputeServiceRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Compute Moola Dasha (paid service) for an existing chart."""
    chart = db.query(Chart).filter(
        Chart.id == req.chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail=t("err.chart_not_found", lang))

    # pay-per-report gate (moola dasha). Astrologer/admin & free rows pass;
    # otherwise 402 with structured {service_key, price, pricing_id}.
    from app.core.entitlements import require_entitlement
    require_entitlement(db, current_user, "moola_dasha", chart.id, lang)

    # check cache
    if chart.dasha_cache and chart.dasha_cache.moola:
        return chart.dasha_cache.moola

    nk = _get_engine()
    jd, _, _, _ = _get_birth_jd(nk, chart.dob, chart.tob, chart.place)

    # rebuild pdata from chart_json
    pdata = {}
    for planet_name, pinfo in chart.chart_json["planets"].items():
        pdata[planet_name] = {
            "lon": pinfo["longitude"],
            "rashi_idx": pinfo["sign_idx"],
            "deg_rashi": pinfo["degree"],
            "speed": 0.0,
        }

    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        m_dashas, m_balance, m_info = nk.moola_dasha_lagna(pdata, jd)

    result = []
    for md in m_dashas:
        ads = []
        for ad in md.get("sub", []):
            ads.append({
                "planet": ad["planet"],
                "start": nk.jd_to_date(ad["start_jd"]),
                "end": nk.jd_to_date(ad["end_jd"]),
                "days": round(ad["end_jd"] - ad["start_jd"], 2),
            })
        result.append({
            "planet": md["planet"],
            "cycle": md.get("cycle"),
            "group": md.get("group"),
            "eff_yrs": md.get("eff_yrs"),
            "start": nk.jd_to_date(md["start_jd"]),
            "end": nk.jd_to_date(md["end_jd"]),
            "sub": ads,
        })

    data = {
        "balance_yrs": round(m_balance, 4),
        "lagna_sign": m_info.get("lagna_sign_name", ""),
        "group_order": m_info.get("group_order", []),
        "dashas": result,
    }

    # cache
    if chart.dasha_cache:
        chart.dasha_cache.moola = data
    else:
        db.add(DashaCache(chart_id=chart.id, moola=data))
    db.commit()

    return data


@router.post("/compute/divisional")
def compute_divisional(
    req: ComputeServiceRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Return divisional chart positions from stored chart_json."""
    chart = db.query(Chart).filter(
        Chart.id == req.chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail=t("err.chart_not_found", lang))

    cj = chart.chart_json
    return {
        "lagna_sign": cj.get("lagna_sign"),
        "lagna_idx": cj.get("lagna_idx"),
        "divisionals": cj.get("divisionals", {}),
    }


@router.get("/compute/gochar")
def compute_gochar(
    date_str: Optional[str] = Query(None, description="DD/MM/YYYY or today/yesterday/tomorrow"),
    moon_sign: Optional[int] = Query(None, ge=0, le=11),
    db: Session = Depends(get_db),
):
    """Public/free: daily gochar transit scores."""
    nk = _get_engine()

    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        results = nk.gochar_chart(
            date_str=date_str or "today",
            native_moon_sign=moon_sign,
            show_detail=False,
        )

    SIGNS_FULL = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
                  'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
    out = []
    for r in results:
        gr_label, gr_stars = r["grade"]
        out.append({
            "rashi": SIGNS_FULL[r["rashi"]],
            "rashi_idx": r["rashi"],
            "score": r["score"],
            "grade": gr_label.strip(),
            "flags": r["flags"],
        })
    return {"date": date_str or "today", "rashis": out}


# ══════════════════════════════════════════════════════════════════════
#  SERVICE PURCHASE (Wallet debit for paid services)
# ══════════════════════════════════════════════════════════════════════

@router.post("/purchase", response_model=ServiceOrderResponse)
def purchase_service(
    req: PurchaseServiceRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Purchase a paid service for a specific chart. Debits wallet."""
    sp = db.query(ServicePricing).filter(ServicePricing.id == req.service_pricing_id).first()
    if not sp:
        raise HTTPException(status_code=404, detail=t("err.service_not_found", lang))
    if not sp.is_active:
        raise HTTPException(status_code=400, detail=t("err.service_unavailable", lang))

    # `extra_chart` is a chart-less creation CREDIT: it may be bought without a
    # target chart (consumed when the next kundli is created) and may be bought
    # more than once. Every other unlock is a permanent per-chart order.
    is_credit = sp.service_key == "extra_chart"

    chart = None
    if req.chart_id:
        chart = db.query(Chart).filter(
            Chart.id == req.chart_id, Chart.user_id == current_user.id
        ).first()
        if not chart:
            raise HTTPException(status_code=404, detail=t("err.chart_not_found", lang))
    elif not is_credit:
        # per-report unlocks must name the chart they unlock
        raise HTTPException(status_code=404, detail=t("err.chart_not_found", lang))

    chart_ref_id = chart.id if chart is not None else None

    # per-chart unlocks are one-time; credits can be re-purchased
    if not is_credit:
        existing = db.query(ServiceOrder).filter(
            ServiceOrder.user_id == current_user.id,
            ServiceOrder.service_pricing_id == sp.id,
            ServiceOrder.chart_id == chart_ref_id,
            ServiceOrder.status == "completed",
        ).first()
        if existing:
            raise HTTPException(status_code=409, detail=t("err.already_purchased", lang))

    price = float(sp.price)

    # free service: check max_free_per_user limit
    if sp.is_free or price == 0:
        if sp.max_free_per_user:
            count = db.query(ServiceOrder).filter(
                ServiceOrder.user_id == current_user.id,
                ServiceOrder.service_pricing_id == sp.id,
                ServiceOrder.status == "completed",
            ).count()
            if count >= sp.max_free_per_user:
                raise HTTPException(
                    status_code=402,
                    detail=t("err.free_limit_reached", lang, limit=sp.max_free_per_user),
                )

        order = ServiceOrder(
            user_id=current_user.id,
            service_pricing_id=sp.id,
            chart_id=chart_ref_id,
            amount_paid=0,
            status="completed",
        )
        db.add(order)
        db.commit()
        db.refresh(order)
        return ServiceOrderResponse(
            id=order.id,
            user_id=order.user_id,
            service_pricing_id=order.service_pricing_id,
            chart_id=order.chart_id,
            amount_paid=0,
            status="completed",
            service_name=sp.service_name,
            service_key=sp.service_key,
            created_at=order.created_at,
        )

    # paid service: debit wallet
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet:
        raise HTTPException(status_code=400, detail=t("err.wallet_not_found", lang))
    if float(wallet.balance) < price:
        raise HTTPException(
            status_code=402,
            detail=t("err.insufficient_balance", lang, price=price, balance=wallet.balance),
        )

    # debit
    wallet.balance = Decimal(str(float(wallet.balance) - price))
    txn = WalletTransaction(
        wallet_id=wallet.id,
        txn_type="consultation_debit",
        amount=Decimal(str(price)),
        balance_after=wallet.balance,
        description=f"Purchased: {sp.service_name}",
        reference_type="service_order",
    )
    db.add(txn)
    db.flush()

    order = ServiceOrder(
        user_id=current_user.id,
        service_pricing_id=sp.id,
        chart_id=chart_ref_id,
        amount_paid=price,
        wallet_txn_id=txn.id,
        status="completed",
    )
    db.add(order)
    db.commit()
    db.refresh(order)

    return ServiceOrderResponse(
        id=order.id,
        user_id=order.user_id,
        service_pricing_id=order.service_pricing_id,
        chart_id=order.chart_id,
        amount_paid=float(order.amount_paid),
        status="completed",
        service_name=sp.service_name,
        service_key=sp.service_key,
        created_at=order.created_at,
    )


# ══════════════════════════════════════════════════════════════════════
#  ORDER HISTORY
# ══════════════════════════════════════════════════════════════════════

@router.get("/orders", response_model=List[ServiceOrderListResponse])
def list_orders(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """List user's service purchase history."""
    rows = (
        db.query(ServiceOrder, ServicePricing, Chart)
        .join(ServicePricing, ServiceOrder.service_pricing_id == ServicePricing.id)
        .outerjoin(Chart, ServiceOrder.chart_id == Chart.id)
        .filter(ServiceOrder.user_id == current_user.id)
        .order_by(ServiceOrder.created_at.desc())
        .offset(skip).limit(limit)
        .all()
    )
    return [
        ServiceOrderListResponse(
            id=order.id,
            service_name=sp.service_name,
            service_key=sp.service_key,
            icon=sp.icon,
            amount_paid=float(order.amount_paid),
            status=order.status,
            chart_name=chart.name if chart else None,
            created_at=order.created_at,
        )
        for order, sp, chart in rows
    ]


# ══════════════════════════════════════════════════════════════════════
#  ENTITLEMENTS (what's unlocked for a chart — pay-per-report)
# ══════════════════════════════════════════════════════════════════════

@router.get("/entitlements")
def get_entitlements(
    chart_id: Optional[str] = Query(None, description="Chart to check paid unlocks against"),
    category: Optional[str] = Query(None, description="Filter by pricing category"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Per-service unlock state for the current user + a specific chart.

    A service is `unlocked` when it is free (Primary-Kundli basics) OR the user
    holds a completed ServiceOrder for it on this chart. The app reads this to
    decide teaser-vs-full and to render the paywall — prices always come from
    ServicePricing (admin-editable), never hardcoded in the client.
    """
    from app.core.entitlements import find_order  # local import avoids cycle

    if chart_id:
        chart = db.query(Chart).filter(
            Chart.id == chart_id, Chart.user_id == current_user.id
        ).first()
        if not chart:
            raise HTTPException(status_code=404, detail=t("err.chart_not_found", lang))

    privileged = getattr(current_user, "role", None) in ("astrologer", "admin")

    # Session region → currency for this user (drives USD/IAP vs ₹/wallet).
    sess = region_util.session_region(user_region=getattr(current_user, "region", None))
    intl = region_util.is_international_region(sess)
    fx = pricing_util.get_fx_rate(db)
    mult = pricing_util.get_multiplier(db)

    q = db.query(ServicePricing).filter(ServicePricing.is_active == True)
    if category:
        q = q.filter(ServicePricing.category == category)
    rows = q.order_by(ServicePricing.sort_order, ServicePricing.price).all()

    out = []
    for sp in rows:
        price = float(sp.price or 0)
        is_free = bool(sp.is_free) or price == 0
        order = None
        if not is_free and not privileged and chart_id:
            order = find_order(db, current_user.id, sp.id, chart_id)
        unlocked = is_free or privileged or (order is not None)
        usd = None if is_free else pricing_util.usd_for_pricing(sp, fx, mult)
        session_amount = 0.0 if is_free else (float(usd) if (intl and usd) else price)
        out.append({
            "service_key": sp.service_key,
            "service_name": sp.service_name,
            "category": sp.category,
            "icon": sp.icon,
            "pricing_id": sp.id,
            "price": price,
            "price_usd": float(usd) if usd else None,
            "iap_product_id": sp.iap_product_id if (intl and not is_free) else None,
            "original_price": float(sp.original_price) if sp.original_price is not None else None,
            "currency": sp.currency or "INR",
            # Session view for the caller's region: what to show + how to pay.
            "session_currency": "USD" if intl else "INR",
            "session_amount": session_amount,
            "pay_via": "free" if is_free else ("iap" if intl else "wallet"),
            "is_free": is_free,
            "unlocked": unlocked,
            "order_id": order.id if order else None,
        })

    return {
        "chart_id": chart_id,
        "region": sess,
        "is_international": intl,
        "currency": "USD" if intl else "INR",
        "privileged": privileged,
        "entitlements": out,
    }


# ═══════════════════════════════════════════════════════════════════
# CITY SEARCH (Nominatim / OpenStreetMap geocoding)
# ═══════════════════════════════════════════════════════════════════

@router.get("/city-search")
def city_search(q: str = Query(..., min_length=2, max_length=100)):
    """Search cities by name using Nominatim (OSM). Returns up to 8 results
    with name, display_name, latitude, longitude, and timezone offset."""
    import requests as _req
    url = "https://nominatim.openstreetmap.org/search"
    try:
        resp = _req.get(url, params={
            "q": q, "format": "json", "limit": 8,
            "addressdetails": 1, "accept-language": "en",
        }, headers={"User-Agent": "Nakshtralogy/1.0"}, timeout=5)
        if resp.status_code != 200:
            return []
        raw = resp.json()
        results = []
        for r in raw:
            addr = r.get("address", {})
            city = addr.get("city") or addr.get("town") or addr.get("village") or addr.get("county") or ""
            state = addr.get("state", "")
            country = addr.get("country", "")
            parts = [p for p in [city, state, country] if p]
            results.append({
                "name": city or r.get("name", q),
                "display_name": ", ".join(parts) if parts else r.get("display_name", ""),
                "latitude": float(r.get("lat", 0)),
                "longitude": float(r.get("lon", 0)),
                "country": country,
            })
        return results
    except Exception:
        return []

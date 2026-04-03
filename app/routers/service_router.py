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

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role
from app.models.model import (
    User, Chart, DashaCache, ServicePricing, ServiceOrder,
    Wallet, WalletTransaction,
)
from app.schemas.service_schema import (
    ServicePricingResponse, ServicePricingCreate, ServicePricingUpdate,
    BirthChartCreateRequest, BirthChartResponse, BirthChartListResponse,
    BirthChartUpdateRequest, ComputeServiceRequest, GocharRequest,
    PurchaseServiceRequest, ServiceOrderResponse, ServiceOrderListResponse,
    MessageResponse,
)

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

@router.get("/pricing", response_model=List[ServicePricingResponse])
def list_pricing(
    category: Optional[str] = None,
    db: Session = Depends(get_db),
):
    """Public: list all active service pricing."""
    q = db.query(ServicePricing).filter(ServicePricing.is_active == True)
    if category:
        q = q.filter(ServicePricing.category == category)
    return q.order_by(ServicePricing.sort_order, ServicePricing.price).all()


@router.get("/pricing/{pricing_id}", response_model=ServicePricingResponse)
def get_pricing(pricing_id: str, db: Session = Depends(get_db)):
    p = db.query(ServicePricing).filter(ServicePricing.id == pricing_id).first()
    if not p:
        raise HTTPException(status_code=404, detail="Service not found")
    return p


@router.post("/pricing", response_model=ServicePricingResponse, status_code=201)
def create_pricing(
    req: ServicePricingCreate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin-only: create a new service pricing."""
    if db.query(ServicePricing).filter(ServicePricing.service_key == req.service_key).first():
        raise HTTPException(status_code=409, detail="service_key already exists")
    sp = ServicePricing(**req.model_dump())
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
):
    sp = db.query(ServicePricing).filter(ServicePricing.id == pricing_id).first()
    if not sp:
        raise HTTPException(status_code=404, detail="Service not found")
    for field, value in req.model_dump(exclude_unset=True).items():
        setattr(sp, field, value)
    db.commit()
    db.refresh(sp)
    return sp


@router.post("/pricing/seed", response_model=MessageResponse)
def seed_pricing(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
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
            "max_free_per_user": 3,
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
            "price": 199,
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

    created = 0
    for d in defaults:
        if not db.query(ServicePricing).filter(ServicePricing.service_key == d["service_key"]).first():
            db.add(ServicePricing(**d))
            created += 1
    db.commit()
    return MessageResponse(message=f"Seeded {created} services ({len(defaults) - created} already existed)")


# ══════════════════════════════════════════════════════════════════════
#  BIRTH CHARTS (Multiple per user)
# ══════════════════════════════════════════════════════════════════════

@router.post("/charts", response_model=BirthChartResponse, status_code=201)
def create_chart(
    req: BirthChartCreateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
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
        raise HTTPException(status_code=422, detail=f"Chart computation failed: {str(e)}")

    if pdata is None:
        raise HTTPException(status_code=422, detail="Could not compute chart — check birth data")

    chart_json = _build_chart_json(nk, pdata, divs)

    # resolve coordinates
    coords = nk.get_city(req.place)
    lat = coords[0] if coords else None
    lon = coords[1] if coords else None
    tz = str(coords[2]) if coords else None

    # if is_primary, unset existing primary
    if req.is_primary:
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
        is_primary=req.is_primary,
    )
    db.add(chart)
    db.flush()

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
    if req.is_primary:
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """List all birth charts for the current user (without heavy chart_json)."""
    charts = db.query(Chart).filter(
        Chart.user_id == current_user.id
    ).order_by(Chart.created_at.desc()).all()
    return charts


@router.get("/charts/{chart_id}", response_model=BirthChartResponse)
def get_chart(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = db.query(Chart).filter(
        Chart.id == chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail="Chart not found")
    return chart


@router.put("/charts/{chart_id}", response_model=BirthChartResponse)
def update_chart(
    chart_id: str,
    req: BirthChartUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Update chart metadata. If dob/tob/place changed, re-compute kundli."""
    chart = db.query(Chart).filter(
        Chart.id == chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail="Chart not found")

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
):
    chart = db.query(Chart).filter(
        Chart.id == chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail="Chart not found")
    db.delete(chart)
    db.commit()
    return MessageResponse(message="Chart deleted")


# ══════════════════════════════════════════════════════════════════════
#  KUNDLI COMPUTE ENDPOINTS
# ══════════════════════════════════════════════════════════════════════

@router.post("/compute/dasha")
def compute_vimshottari(
    req: ComputeServiceRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Compute Vimshottari Dasha for an existing chart."""
    chart = db.query(Chart).filter(
        Chart.id == req.chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail="Chart not found")

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
):
    """Compute Moola Dasha (paid service) for an existing chart."""
    chart = db.query(Chart).filter(
        Chart.id == req.chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail="Chart not found")

    # check pricing & payment
    sp = db.query(ServicePricing).filter(ServicePricing.service_key == "moola_dasha").first()
    if sp and not sp.is_free:
        order = db.query(ServiceOrder).filter(
            ServiceOrder.user_id == current_user.id,
            ServiceOrder.service_pricing_id == sp.id,
            ServiceOrder.chart_id == chart.id,
            ServiceOrder.status == "completed",
        ).first()
        if not order:
            raise HTTPException(
                status_code=402,
                detail=f"This is a paid service (₹{sp.price}). Purchase it first via /purchase"
            )

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
):
    """Return divisional chart positions from stored chart_json."""
    chart = db.query(Chart).filter(
        Chart.id == req.chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail="Chart not found")

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
):
    """Purchase a paid service for a specific chart. Debits wallet."""
    sp = db.query(ServicePricing).filter(ServicePricing.id == req.service_pricing_id).first()
    if not sp:
        raise HTTPException(status_code=404, detail="Service not found")
    if not sp.is_active:
        raise HTTPException(status_code=400, detail="Service is not available")

    chart = db.query(Chart).filter(
        Chart.id == req.chart_id, Chart.user_id == current_user.id
    ).first()
    if not chart:
        raise HTTPException(status_code=404, detail="Chart not found")

    # check if already purchased for this chart
    existing = db.query(ServiceOrder).filter(
        ServiceOrder.user_id == current_user.id,
        ServiceOrder.service_pricing_id == sp.id,
        ServiceOrder.chart_id == chart.id,
        ServiceOrder.status == "completed",
    ).first()
    if existing:
        raise HTTPException(status_code=409, detail="Already purchased for this chart")

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
                    detail=f"Free limit reached ({sp.max_free_per_user}). Upgrade to continue."
                )

        order = ServiceOrder(
            user_id=current_user.id,
            service_pricing_id=sp.id,
            chart_id=chart.id,
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
        raise HTTPException(status_code=400, detail="Wallet not found")
    if float(wallet.balance) < price:
        raise HTTPException(
            status_code=402,
            detail=f"Insufficient balance. Need ₹{price}, have ₹{wallet.balance}"
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
        chart_id=chart.id,
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

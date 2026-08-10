"""
PDF export endpoints. Each returns a branded, localized PDF built from the
SAME data path the on-screen views use — reusing chart loading, the
pay-per-report entitlement gate, the specialist engines, and report
translation. Presentation/export only: no astrology calculation, scoring or
pricing logic is added or changed here.

    GET /api/v1/pdf/report/{key}/{chart_id}?lang=
    GET /api/v1/pdf/kundli/{chart_id}?lang=
    GET /api/v1/pdf/milan/{chart_id1}/{chart_id2}?lang=
    GET /api/v1/pdf/forecast/{chart_id}?lang=
"""
from __future__ import annotations

import io
import contextlib
import logging
import re
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import Response
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.core.i18n import t, normalize_lang
from app.models.model import Chart, User
from app.kundli import engine as nk_engine
from app.specialists import SPECIALISTS, get_engine
from app.core.entitlements import require_entitlement
from app.services.pdf import pdf_service

logger = logging.getLogger("pdf_router")
router = APIRouter()

_LABEL_KEYS = {k: f"label.specialist.{k}" for k in SPECIALISTS}


# ── helpers ──────────────────────────────────────────────────────────────
def _chart_data(chart: Chart) -> dict:
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return nk_engine.get_chart(
            chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place)


def _load_chart(chart_id: str, user: User, db: Session, lang: str) -> Chart:
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        raise HTTPException(404, t("err.chart_not_found", lang))
    if chart.user_id != user.id and user.role not in ("astrologer", "admin"):
        raise HTTPException(403, t("err.not_authorized", lang))
    return chart


def _subject_meta(chart: Chart) -> str:
    return " · ".join([x for x in (chart.dob, chart.tob, chart.place) if x])


def _now_str() -> str:
    return datetime.now(timezone.utc).strftime("%d %b %Y")


def _labels(lang: str) -> dict:
    return {"brand": "Nakshatralogy", "generated": t("pdf.generated", lang) if _has("pdf.generated") else "Generated"}


def _has(key: str) -> bool:
    try:
        return t(key, "en") != key
    except Exception:
        return False


def _slug(s: str) -> str:
    return re.sub(r"[^A-Za-z0-9]+", "-", (s or "report")).strip("-").lower() or "report"


def _pdf_response(data: bytes, filename: str) -> Response:
    return Response(
        content=data, media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="{filename}.pdf"'},
    )


def _translate(result: dict, lang: str) -> dict:
    if lang and lang != "en":
        try:
            from app.services.report_translator import translate_report
            result = translate_report(result, lang)
        except Exception:
            logger.warning("translate_report failed for lang=%s", lang, exc_info=True)
    try:
        from app.services.freetext_translator import localize_report
        result = localize_report(result, lang)
    except Exception:
        pass
    return result


async def _fail_pdf(e: Exception, lang: str):
    if isinstance(e, RuntimeError):
        raise HTTPException(503, str(e))
    logger.error("PDF build error: %s", e, exc_info=True)
    raise HTTPException(500, t("err.pdf_failed", lang) if _has("err.pdf_failed") else f"PDF generation failed: {e}")


# ── endpoints ────────────────────────────────────────────────────────────
@router.get("/report/{key}/{chart_id}")
async def report_pdf(
    key: str,
    chart_id: str,
    lang: str = Query("en"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    lang = normalize_lang(lang)
    if key not in SPECIALISTS or key in (
            "kundli_milan", "relationship", "child_probability",
            "love_compatibility", "karma_linkage"):
        raise HTTPException(404, t("err.unknown_specialist", lang, key=key))

    chart = _load_chart(chart_id, current_user, db, lang)
    require_entitlement(db, current_user, key, chart_id, lang)

    try:
        data = _chart_data(chart)
        engine = get_engine(key)
        if key == "marriage":
            result = engine.analyze(data["_pdata"], data["birth_jd"],
                                    name=chart.name, gender=chart.gender or "M")
        else:
            result = engine.analyze(data["_pdata"], data["birth_jd"], name=chart.name)
        result = _translate(result, lang)
        label = t(_LABEL_KEYS[key], lang)
        pdf = await pdf_service.render_report_pdf(
            engine_label=label, data=result,
            subject=chart.name, subject_meta=_subject_meta(chart),
            lang=lang, generated_on=_now_str(), labels=_labels(lang),
            is_astro=current_user.role == "astrologer",
        )
        return _pdf_response(pdf, f"{_slug(key)}-{_slug(chart.name)}")
    except HTTPException:
        raise
    except Exception as e:
        await _fail_pdf(e, lang)


@router.get("/kundli/{chart_id}")
async def kundli_pdf(
    chart_id: str,
    lang: str = Query("en"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    lang = normalize_lang(lang)
    chart = _load_chart(chart_id, current_user, db, lang)
    # Kundli itself is free (primary chart); no entitlement gate.
    try:
        data = _chart_data(chart)
        pdata, jd = data["_pdata"], data["birth_jd"]

        planets = []
        for name, p in (data.get("planets") or {}).items():
            planets.append({
                "Planet": name,
                "Sign": p.get("sign_full") or p.get("sign"),
                "Degree": f"{p.get('degree', 0):.2f}" if isinstance(p.get("degree"), (int, float)) else p.get("degree"),
                "Nakshatra": p.get("nakshatra"),
                "Pada": p.get("pada"),
                "Dignity": p.get("dignity"),
            })

        def _maha(tree):
            rows = []
            for d in (tree or [])[:9]:
                rows.append({"Planet": d.get("planet"), "Years": d.get("years"),
                             "Start": d.get("start"), "End": d.get("end")})
            return rows

        vim = nk_engine.get_vimshottari(pdata, jd, 1)
        moola = nk_engine.get_moola_dasha(pdata, jd, 1)
        body = {
            "Ascendant": (data.get("lagna") or {}).get("sign_full") or (data.get("lagna") or {}).get("sign"),
            "Planetary Positions": planets,
            "Vimshottari Mahadasha": _maha(vim.get("dashas") if isinstance(vim, dict) else vim),
            "Moola Mahadasha": _maha(moola.get("dashas") if isinstance(moola, dict) else moola),
        }
        body = _translate(body, lang)
        title = t("pdf.kundli_title", lang) if _has("pdf.kundli_title") else "Birth Chart (Kundli)"
        pdf = await pdf_service.render_generic_pdf(
            title=title, data=body,
            subject=chart.name, subject_meta=_subject_meta(chart),
            lang=lang, generated_on=_now_str(), labels=_labels(lang),
            is_astro=current_user.role == "astrologer",
        )
        return _pdf_response(pdf, f"kundli-{_slug(chart.name)}")
    except HTTPException:
        raise
    except Exception as e:
        await _fail_pdf(e, lang)


@router.get("/milan/{chart_id1}/{chart_id2}")
async def milan_pdf(
    chart_id1: str,
    chart_id2: str,
    lang: str = Query("en"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    lang = normalize_lang(lang)
    c1 = _load_chart(chart_id1, current_user, db, lang)
    c2 = _load_chart(chart_id2, current_user, db, lang)
    require_entitlement(db, current_user, "kundli_milan", chart_id1, lang)
    try:
        from app.milan import milan_engine, match_phase2, match_phase3, compute_unified_score
        d1, d2 = _chart_data(c1), _chart_data(c2)
        p1, j1 = d1["_pdata"], d1["birth_jd"]
        p2, j2 = d2["_pdata"], d2["birth_jd"]
        g1, g2 = c1.gender or "M", c2.gender or "F"
        phase1 = milan_engine.match(p1, p2, c1.name, c2.name, g1, g2)
        phase2 = match_phase2(p1, j1, p2, j2, c1.name, c2.name, g1, g2)
        phase3 = match_phase3(p1, j1, p2, j2, c1.name, c2.name, g1, g2)
        unified = compute_unified_score(phase1, phase2, phase3)
        result = {"unified": unified, "phase1": phase1, "phase2": phase2, "phase3": phase3}
        result = _translate(result, lang)
        title = t("pdf.milan_title", lang) if _has("pdf.milan_title") else "Kundli Milan (Compatibility)"
        pdf = await pdf_service.render_generic_pdf(
            title=title, data=result,
            subject=f"{c1.name} & {c2.name}", subject_meta="",
            lang=lang, generated_on=_now_str(), labels=_labels(lang),
            is_astro=current_user.role == "astrologer",
        )
        return _pdf_response(pdf, f"milan-{_slug(c1.name)}-{_slug(c2.name)}")
    except HTTPException:
        raise
    except Exception as e:
        await _fail_pdf(e, lang)


@router.get("/forecast/{chart_id}")
async def forecast_pdf(
    chart_id: str,
    lang: str = Query("en"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    lang = normalize_lang(lang)
    chart = _load_chart(chart_id, current_user, db, lang)
    require_entitlement(db, current_user, "daily_forecast", chart_id, lang)
    try:
        data = _chart_data(chart)
        from all_engine.all_specialist_engine.daily_probability_forecast_specialist import (
            daily_probability_forecast_specialist_engine as fc)
        result = fc.analyze(
            data["_pdata"], data["birth_jd"],
            chart_metadata={"name": chart.name, "dob": chart.dob,
                            "tob": chart.tob, "place": chart.place})
        result = _translate(result, lang)
        title = t("pdf.forecast_title", lang) if _has("pdf.forecast_title") else "Today's Forecast"
        pdf = await pdf_service.render_generic_pdf(
            title=title, data=result,
            subject=chart.name, subject_meta=_subject_meta(chart),
            lang=lang, generated_on=_now_str(), labels=_labels(lang),
            is_astro=current_user.role == "astrologer",
        )
        return _pdf_response(pdf, f"forecast-{_slug(chart.name)}")
    except HTTPException:
        raise
    except Exception as e:
        await _fail_pdf(e, lang)

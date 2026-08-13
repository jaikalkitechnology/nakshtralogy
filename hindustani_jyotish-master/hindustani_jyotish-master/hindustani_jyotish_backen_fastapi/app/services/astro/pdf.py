"""Branded Kundli PDF generation (ReportLab)."""
from __future__ import annotations

import io
from datetime import date, time, timedelta
from typing import Any
from xml.sax.saxutils import escape as _xml_escape

from app.services.astro import interpretations as interp
from app.services.astro.engine import Chart
from app.services.astro.reference import NAKSHATRA_DEGREES, NAKSHATRA_LORDS, NAKSHATRAS, SIGNS

# Brand palette (from the blueprint).
_INDIGO = "#1E1B4B"
_SAFFRON = "#F4811F"
_COPPER = "#C77B4A"
_CREAM = "#FBF6EE"

_PLANET_ABBR = {
    "Sun": "Su", "Moon": "Mo", "Mars": "Ma", "Mercury": "Me", "Jupiter": "Ju",
    "Venus": "Ve", "Saturn": "Sa", "Rahu": "Ra", "Ketu": "Ke",
}


def _vimshottari(chart: Chart, dob: date) -> list[tuple[str, date, date, float]]:
    """Classical 120-year Vimshottari mahadasha table from the Moon's
    longitude: (lord, start, end, span_years) for the first full cycle."""
    moon = next((p for p in chart.planets if p.name == "Moon"), None)
    if moon is None:
        return []
    nak_idx = int(moon.longitude % 360 // NAKSHATRA_DEGREES)
    frac = (moon.longitude % NAKSHATRA_DEGREES) / NAKSHATRA_DEGREES
    first_lord = NAKSHATRA_LORDS[nak_idx]
    order = interp.DASHA_ORDER
    start_at = order.index(first_lord)

    def _add_years(d: date, years: float) -> date:
        return d + timedelta(days=years * 365.25)

    rows: list[tuple[str, date, date, float]] = []
    cursor = dob
    for i in range(9):
        lord = order[(start_at + i) % 9]
        span = float(interp.DASHA_YEARS[lord])
        if i == 0:
            span *= 1 - frac  # balance of the running dasha at birth
        end = _add_years(cursor, span)
        rows.append((lord, cursor, end, round(span, 2)))
        cursor = end
    return rows


def _north_indian_chart(chart: Chart):
    """North-Indian style diamond chart as a reportlab Drawing. House 1 is
    the top-centre diamond; planets are placed by their house number."""
    from reportlab.graphics.shapes import Drawing, Line, Rect, String
    from reportlab.lib import colors

    size = 340
    d = Drawing(size, size)
    d.add(Rect(0, 0, size, size, strokeColor=colors.HexColor(_INDIGO),
               fillColor=colors.HexColor(_CREAM), strokeWidth=2))
    # Diagonals + midpoint diamond.
    d.add(Line(0, 0, size, size, strokeColor=colors.HexColor(_INDIGO)))
    d.add(Line(0, size, size, 0, strokeColor=colors.HexColor(_INDIGO)))
    half = size / 2
    for x1, y1, x2, y2 in [
        (0, half, half, size), (half, size, size, half),
        (size, half, half, 0), (half, 0, 0, half),
    ]:
        d.add(Line(x1, y1, x2, y2, strokeColor=colors.HexColor(_INDIGO)))

    # Approximate label anchors for houses 1..12 (North-Indian layout).
    q = size / 4
    anchors = {
        1: (half, size - q),        # top centre diamond
        2: (q, size - q / 1.6),     # top left triangle
        3: (q / 1.6, size - q),
        4: (q, half),               # left centre diamond
        5: (q / 1.6, q),
        6: (q, q / 1.6),
        7: (half, q),               # bottom centre diamond
        8: (size - q, q / 1.6),
        9: (size - q / 1.6, q),
        10: (size - q, half),       # right centre diamond
        11: (size - q / 1.6, size - q),
        12: (size - q, size - q / 1.6),
    }

    by_house: dict[int, list[str]] = {}
    for p in chart.planets:
        by_house.setdefault(p.house, []).append(
            _PLANET_ABBR.get(p.name, p.name[:2]) + ("*" if p.retrograde else "")
        )

    # Sign number in each house (house 1 carries the lagna sign).
    lagna_sign_idx = next(
        (i for i, s in enumerate(SIGNS) if s[0] == chart.ascendant_sign), 0
    )
    for house, (x, y) in anchors.items():
        sign_no = (lagna_sign_idx + house - 1) % 12 + 1
        d.add(String(x, y + 14, str(sign_no), textAnchor="middle",
                     fontSize=9, fillColor=colors.HexColor(_COPPER)))
        occupants = " ".join(by_house.get(house, []))
        if occupants:
            d.add(String(x, y - 2, occupants, textAnchor="middle",
                         fontSize=10, fillColor=colors.HexColor(_INDIGO)))
    return d


def build_kundli_pdf(
    *,
    chart: Chart,
    name: str | None,
    dob: date,
    birth_time: time | None,
    birth_place: str | None,
    numerology: dict | None = None,
) -> bytes:
    """The complete detailed-Kundli document (~12 pages): cover, birth
    details, chart diagram, positions, lagna/moon reading, per-planet
    analysis, nakshatra, Vimshottari dasha, numerology, remedies and
    disclaimer."""
    from reportlab.lib import colors
    from reportlab.lib.enums import TA_CENTER
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
    from reportlab.lib.units import mm
    from reportlab.platypus import (
        PageBreak,
        Paragraph,
        SimpleDocTemplate,
        Spacer,
        Table,
        TableStyle,
    )

    buf = io.BytesIO()
    doc = SimpleDocTemplate(
        buf, pagesize=A4, title="Hindustani Jyotish — Detailed Kundli",
        topMargin=18 * mm, bottomMargin=18 * mm,
    )
    styles = getSampleStyleSheet()
    h1 = ParagraphStyle("h1", parent=styles["Title"], textColor=colors.HexColor(_INDIGO))
    cover_title = ParagraphStyle(
        "cover", parent=styles["Title"], fontSize=30, leading=36,
        textColor=colors.HexColor(_INDIGO), alignment=TA_CENTER,
    )
    cover_sub = ParagraphStyle(
        "coversub", parent=styles["Heading2"], alignment=TA_CENTER,
        textColor=colors.HexColor(_SAFFRON),
    )
    centered = ParagraphStyle("centered", parent=styles["BodyText"], alignment=TA_CENTER)
    h2 = ParagraphStyle("h2", parent=styles["Heading2"], textColor=colors.HexColor(_SAFFRON))
    h3 = ParagraphStyle("h3", parent=styles["Heading3"], textColor=colors.HexColor(_COPPER))
    body = ParagraphStyle("bodyx", parent=styles["BodyText"], fontSize=10.5, leading=15)

    def details_table(rows: list[list[str]], widths=(55, 105)) -> Table:
        t = Table(rows, colWidths=[widths[0] * mm, widths[1] * mm])
        t.setStyle(TableStyle([
            ("TEXTCOLOR", (0, 0), (0, -1), colors.HexColor(_COPPER)),
            ("FONTNAME", (0, 0), (0, -1), "Helvetica-Bold"),
            ("FONTSIZE", (0, 0), (-1, -1), 10),
            ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
            ("LINEBELOW", (0, 0), (-1, -1), 0.25, colors.HexColor("#E0E0E0")),
        ]))
        return t

    def grid_table(rows: list[list[str]], widths=None) -> Table:
        t = Table(rows, repeatRows=1, colWidths=widths)
        t.setStyle(TableStyle([
            ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor(_INDIGO)),
            ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
            ("FONTSIZE", (0, 0), (-1, -1), 9),
            ("GRID", (0, 0), (-1, -1), 0.25, colors.HexColor("#D6D6D6")),
            ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor(_CREAM)]),
            ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ]))
        return t

    esc = _xml_escape
    elems: list = []

    # ── Page 1: Cover ─────────────────────────────────────────────────
    elems += [
        Spacer(1, 40 * mm),
        Paragraph("🪔", cover_title),
        Paragraph("Hindustani Jyotish", cover_title),
        Spacer(1, 6 * mm),
        Paragraph("Detailed Kundli Report", cover_sub),
        Spacer(1, 24 * mm),
        Paragraph(f"<b>{esc(name) if name else 'Kundli'}</b>", cover_sub),
        Spacer(1, 4 * mm),
        Paragraph(
            f"{dob.strftime('%d %B %Y')}"
            + (f" · {birth_time.strftime('%H:%M')}" if birth_time else "")
            + (f"<br/>{esc(birth_place)}" if birth_place else ""),
            centered,
        ),
        Spacer(1, 42 * mm),
        Paragraph(
            "<font size=9 color='#888888'>Prepared with the sidereal "
            "(Vedic) zodiac · Vimshottari dasha system</font>", centered),
        PageBreak(),
    ]

    # ── Page 2: Birth details & chart summary ─────────────────────────
    moon_p = next((p for p in chart.planets if p.name == "Moon"), None)
    elems += [
        Paragraph("Birth Details", h2),
        Spacer(1, 3 * mm),
        details_table([
            ["Name", name or "—"],
            ["Date of Birth", dob.strftime("%d %B %Y")],
            ["Time of Birth", birth_time.strftime("%H:%M") if birth_time else "—"],
            ["Place of Birth", birth_place or "—"],
            ["Ayanamsa", f"{chart.ayanamsa.title()} ({chart.ayanamsa_value}°)"],
        ]),
        Spacer(1, 8 * mm),
        Paragraph("Chart Summary", h2),
        Spacer(1, 3 * mm),
        details_table([
            ["Ascendant (Lagna)", f"{chart.ascendant_sign} ({chart.ascendant:.2f}°)"],
            ["Moon Sign (Rashi)", chart.moon_sign],
            ["Sun Sign", chart.sun_sign],
            ["Birth Nakshatra",
             chart.nakshatra
             + (f" — Pada {moon_p.nakshatra_pada}" if moon_p else "")],
            ["Nakshatra Lord",
             NAKSHATRA_LORDS[NAKSHATRAS.index(chart.nakshatra)]
             if chart.nakshatra in NAKSHATRAS else "—"],
        ]),
        Spacer(1, 8 * mm),
        Paragraph(
            "This report is computed from your exact birth details using the "
            "sidereal zodiac. The pages that follow present your birth "
            "chart, the position and meaning of each of the nine grahas, "
            "your birth nakshatra, the Vimshottari dasha timeline, your "
            "numerology profile and classical remedies.", body),
        PageBreak(),
    ]

    # ── Page 3: Birth chart diagram ───────────────────────────────────
    elems += [
        Paragraph("Birth Chart (North-Indian style)", h2),
        Spacer(1, 6 * mm),
        _north_indian_chart(chart),
        Spacer(1, 6 * mm),
        Paragraph(
            "Numbers mark the zodiac sign in each house (1 = Aries … 12 = "
            "Pisces), counted from your lagna. Planet abbreviations: "
            + ", ".join(f"{v} = {k}" for k, v in _PLANET_ABBR.items())
            + ". An asterisk (*) marks a retrograde planet.", body),
        PageBreak(),
    ]

    # ── Page 4: Planetary positions ───────────────────────────────────
    rows = [["Planet", "Sign", "Degree", "House", "Nakshatra", "Pada", "Motion"]]
    for p in chart.planets:
        rows.append([
            p.name, p.sign, f"{p.degree_in_sign:.2f}°", str(p.house),
            p.nakshatra, str(p.nakshatra_pada),
            "Retrograde" if p.retrograde else "Direct",
        ])
    elems += [
        Paragraph("Planetary Positions", h2),
        Spacer(1, 3 * mm),
        grid_table(rows),
        Spacer(1, 6 * mm),
        Paragraph(
            "Degrees are within the occupied sign. Houses are counted from "
            "the lagna (whole-sign system). Rahu and Ketu are always "
            "retrograde by nature.", body),
        PageBreak(),
    ]

    # ── Page 5: Lagna & Moon reading ──────────────────────────────────
    lagna_trait = interp.SIGN_TRAITS.get(chart.ascendant_sign, "")
    moon_trait = interp.SIGN_TRAITS.get(chart.moon_sign, "")
    sun_trait = interp.SIGN_TRAITS.get(chart.sun_sign, "")
    elems += [
        Paragraph("Your Ascendant, Moon & Sun", h2),
        Spacer(1, 2 * mm),
        Paragraph(f"Lagna — {esc(chart.ascendant_sign)}", h3),
        Paragraph(
            f"The ascendant is the lens through which your whole chart "
            f"expresses. With {esc(chart.ascendant_sign)} rising you come "
            f"across as {esc(lagna_trait)}. Its lord "
            f"{esc(dict((s[0], s[3]) for s in SIGNS).get(chart.ascendant_sign, ''))} "
            f"colours your path and vitality.", body),
        Spacer(1, 4 * mm),
        Paragraph(f"Moon Sign (Rashi) — {esc(chart.moon_sign)}", h3),
        Paragraph(
            f"The Moon carries the mind. A {esc(chart.moon_sign)} Moon is "
            f"{esc(moon_trait)}. In Vedic astrology this rashi, more than "
            f"the sun sign, describes your emotional nature and daily "
            f"experience.", body),
        Spacer(1, 4 * mm),
        Paragraph(f"Sun Sign — {esc(chart.sun_sign)}", h3),
        Paragraph(
            f"The Sun is the soul's direction. In {esc(chart.sun_sign)} it "
            f"is {esc(sun_trait)} — the qualities you grow into as life "
            f"matures.", body),
        PageBreak(),
    ]

    # ── Pages 6–8: Planet-by-planet analysis (3 per page) ─────────────
    elems += [Paragraph("Planet-by-Planet Analysis", h2), Spacer(1, 2 * mm)]
    for i, p in enumerate(chart.planets):
        elems += [
            Paragraph(
                f"{esc(p.name)} in {esc(p.sign)} — "
                f"{_xml_escape(interp._ordinal(p.house))} house"
                + (" (retrograde)" if p.retrograde else ""), h3),
            Paragraph(interp.planet_in_sign_text(p.name, p.sign), body),
            Paragraph(interp.house_text(p.name, p.house), body),
            Paragraph(
                f"Nakshatra: {esc(p.nakshatra)} (pada {p.nakshatra_pada}) — "
                f"{esc(interp.NAKSHATRA_QUALITIES.get(p.nakshatra, ''))}.", body),
            Spacer(1, 4 * mm),
        ]
        if i % 3 == 2 and i < len(chart.planets) - 1:
            elems.append(PageBreak())
    elems.append(PageBreak())

    # ── Page 9: Birth nakshatra ───────────────────────────────────────
    nak = chart.nakshatra
    nak_lord = (NAKSHATRA_LORDS[NAKSHATRAS.index(nak)] if nak in NAKSHATRAS else "—")
    elems += [
        Paragraph("Your Birth Nakshatra", h2),
        Spacer(1, 2 * mm),
        Paragraph(f"{esc(nak)}", h3),
        Paragraph(
            f"Your Moon occupies {esc(nak)} — "
            f"{esc(interp.NAKSHATRA_QUALITIES.get(nak, ''))}. Its lord is "
            f"{esc(nak_lord)}, whose themes "
            f"({esc(interp.PLANET_SIGNIFICATIONS.get(nak_lord, '').split('.')[0].lower())}) "
            f"run beneath your emotional life and start your dasha sequence.",
            body),
        Spacer(1, 6 * mm),
        Paragraph("The 27 Nakshatras", h3),
        grid_table(
            [["Nakshatra", "Lord"]]
            + [[n, NAKSHATRA_LORDS[i]] for i, n in enumerate(NAKSHATRAS)],
            widths=[80 * mm, 40 * mm],
        ),
        PageBreak(),
    ]

    # ── Page 10: Vimshottari dasha ────────────────────────────────────
    dashas = _vimshottari(chart, dob)
    if dashas:
        drows = [["Mahadasha Lord", "From", "To", "Years"]]
        for lord, start, end, span in dashas:
            drows.append([
                lord, start.strftime("%d %b %Y"), end.strftime("%d %b %Y"),
                f"{span:g}",
            ])
        elems += [
            Paragraph("Vimshottari Mahadasha Timeline", h2),
            Spacer(1, 3 * mm),
            grid_table(drows, widths=[45 * mm, 40 * mm, 40 * mm, 25 * mm]),
            Spacer(1, 6 * mm),
            Paragraph(
                "The Vimshottari cycle spans 120 years across the nine "
                "grahas, starting from your birth nakshatra's lord "
                f"({esc(dashas[0][0])} — the balance of its period was "
                "running at birth). Each mahadasha broadly colours its "
                "years with that planet's significations, listed in the "
                "planet-by-planet pages above.", body),
            PageBreak(),
        ]

    # ── Page 11: Numerology ───────────────────────────────────────────
    if numerology:
        lp = numerology.get("life_path_number")
        bd = numerology.get("birth_day_number")
        elems += [
            Paragraph("Numerology Profile", h2),
            Spacer(1, 3 * mm),
            details_table([
                ["Life Path Number", str(lp)],
                ["Birth Day Number", str(bd)],
            ]),
            Spacer(1, 4 * mm),
            Paragraph(f"Life Path {lp}", h3),
            Paragraph(
                esc(numerology.get("meaning", ""))
                + " " + esc(interp.NUMBER_DETAILS.get(lp, "")), body),
            Spacer(1, 4 * mm),
            Paragraph(f"Birth Day {bd}", h3),
            Paragraph(esc(interp.NUMBER_DETAILS.get(bd, "")), body),
            PageBreak(),
        ]

    # ── Page 12: Remedies & disclaimer ────────────────────────────────
    lagna_lord = dict((s[0], s[3]) for s in SIGNS).get(chart.ascendant_sign, "")
    moon_lord = dict((s[0], s[3]) for s in SIGNS).get(chart.moon_sign, "")
    key_planets: list[str] = []
    for pl in [lagna_lord, moon_lord, nak_lord]:
        if pl and pl not in key_planets:
            key_planets.append(pl)
    rrows = [["Planet", "Gemstone", "Metal", "Day", "Mantra"]]
    for pl in key_planets:
        gem, metal, day, mantra = interp.PLANET_REMEDIES.get(pl, ("—", "—", "—", "—"))
        rrows.append([pl, gem, metal, day, mantra])
    elems += [
        Paragraph("Classical Remedies", h2),
        Spacer(1, 2 * mm),
        Paragraph(
            "Traditional strengthening measures for the key planets of "
            f"your chart — your lagna lord ({esc(lagna_lord)}), rashi lord "
            f"({esc(moon_lord)}) and nakshatra lord ({esc(nak_lord)}). "
            "Gemstones should only be adopted after consulting a qualified "
            "astrologer.", body),
        Spacer(1, 4 * mm),
        grid_table(rrows, widths=[28 * mm, 48 * mm, 28 * mm, 28 * mm, 45 * mm]),
        Spacer(1, 10 * mm),
        Paragraph("About This Report", h3),
        Paragraph(
            "Positions are computed with the sidereal zodiac "
            f"({esc(chart.ayanamsa.title())} ayanamsa) using whole-sign "
            "houses. Interpretations follow classical Vedic principles and "
            "are general in nature — individual results always depend on "
            "the full chart and its dashas.", body),
        Spacer(1, 6 * mm),
        Paragraph(
            "<font size=8 color='#888888'>Generated by Hindustani Jyotish. "
            "For guidance only; not a substitute for professional, legal, "
            "medical or financial advice.</font>", body),
    ]

    doc.build(elems)
    return buf.getvalue()


# ── Generic insight PDF (all cosmic services) ─────────────────────────

# Rendering caps so a very large curated payload (detailed kundli, milan)
# still produces a readable, bounded document.
_MAX_DEPTH = 4
_MAX_LINES_PER_SECTION = 350


def _fmt_key(key: Any) -> str:
    text = str(key).replace("_", " ").strip()
    return _xml_escape(text[:1].upper() + text[1:]) if text else _xml_escape(str(key))


def _fmt_scalar(value: Any) -> str:
    if value is None or value == "":
        return "—"
    if isinstance(value, bool):
        return "Yes" if value else "No"
    if isinstance(value, float):
        value = round(value, 4)
    return _xml_escape(str(value))


def _walk(value: Any, depth: int = 0):
    """Yield (indent_depth, mini-html line) pairs for a JSON-ish value."""
    if depth > _MAX_DEPTH:
        yield depth, _fmt_scalar(str(value))
        return
    if isinstance(value, dict):
        for k, v in value.items():
            if isinstance(v, (dict, list)) and v:
                yield depth, f"<b>{_fmt_key(k)}</b>"
                yield from _walk(v, depth + 1)
            else:
                yield depth, f"<b>{_fmt_key(k)}:</b> {_fmt_scalar(v if not isinstance(v, (dict, list)) else '—')}"
    elif isinstance(value, list):
        for item in value:
            if isinstance(item, (dict, list)):
                yield from _walk(item, depth + 1)
                yield depth, ""  # spacer between list entries
            else:
                yield depth, f"• {_fmt_scalar(item)}"
    else:
        yield depth, _fmt_scalar(value)


def build_insight_pdf(
    *,
    title: str,
    details: list[tuple[str, str]],
    sections: list[tuple[str, Any]],
) -> bytes:
    """Clean, generic PDF for any cosmic service.

    `details` — the user/birth details table (label, value).
    `sections` — (heading, curated JSON-ish data) pairs rendered as a
    readable indented dump.
    """
    from reportlab.lib import colors
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
    from reportlab.lib.units import mm
    from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle

    buf = io.BytesIO()
    doc = SimpleDocTemplate(
        buf, pagesize=A4, title=f"Hindustani Jyotish — {title}",
        topMargin=16 * mm, bottomMargin=16 * mm,
    )
    styles = getSampleStyleSheet()
    h1 = ParagraphStyle("h1", parent=styles["Title"], textColor=colors.HexColor(_INDIGO))
    h2 = ParagraphStyle("h2", parent=styles["Heading2"], textColor=colors.HexColor(_SAFFRON))
    body = styles["BodyText"]
    line_styles = [
        ParagraphStyle(
            f"line{d}", parent=body, fontSize=9, leading=12,
            leftIndent=d * 5 * mm, spaceAfter=1,
        )
        for d in range(_MAX_DEPTH + 2)
    ]

    elems = [Paragraph("🪔 Hindustani Jyotish", h1), Paragraph(_xml_escape(title), h2)]
    if details:
        t = Table(
            [[label, value] for label, value in details],
            colWidths=[55 * mm, 105 * mm],
        )
        t.setStyle(
            TableStyle([
                ("TEXTCOLOR", (0, 0), (0, -1), colors.HexColor(_COPPER)),
                ("FONTNAME", (0, 0), (0, -1), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 10),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
                ("LINEBELOW", (0, 0), (-1, -1), 0.25, colors.HexColor("#E0E0E0")),
            ])
        )
        elems += [Spacer(1, 4 * mm), t]

    for heading, data in sections:
        elems += [Spacer(1, 5 * mm), Paragraph(_fmt_key(heading), h2)]
        count = 0
        for depth, text in _walk(data):
            if not text:
                continue
            count += 1
            if count > _MAX_LINES_PER_SECTION:
                elems.append(Paragraph("<i>… (truncated)</i>", line_styles[0]))
                break
            elems.append(Paragraph(text, line_styles[min(depth, _MAX_DEPTH + 1)]))

    elems += [
        Spacer(1, 8 * mm),
        Paragraph(
            "<font size=8 color='#888888'>Generated by Hindustani Jyotish. "
            "For guidance only.</font>",
            body,
        ),
    ]
    doc.build(elems)
    return buf.getvalue()

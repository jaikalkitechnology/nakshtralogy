"""
Turn an already-localized specialist-report dict into a clean, presentation
structure the PDF template can render beautifully — without hand-mapping every
one of the 19 engines.

The engines return richly structured, human-readable, translated data (scores,
verdicts, lists, nested sections). This module introspects that shape with a
few heuristics and emits a normalized "view" (hero + metrics + sections of
typed blocks). Presentation only — values are passed through untouched; nothing
is recomputed.
"""
from __future__ import annotations

import re
from typing import Any

# Keys we never surface (internal / engine plumbing).
_HIDDEN = {
    "_pdata", "birth_jd", "explanation", "raw", "debug", "_meta", "chart_id",
    "confidence_internal", "driver", "drivers_raw",
}
_HIDDEN_PAT = re.compile(r"^_|_id$|_raw$|_json$")

_SCORE_HINT = re.compile(
    r"(score|strength|probability|favou?rability|level|index|rating|percent|"
    r"harmony|compatibility|intensity)", re.I)
_VERDICT_HINT = re.compile(r"(verdict|summary|overview|conclusion|outlook)", re.I)
_OVERALL_HINT = re.compile(r"overall|primary|composite|total", re.I)
_REMEDY_HINT = re.compile(r"remed|upay|mantra|gemstone|donation|puja", re.I)
_TIMING_HINT = re.compile(r"timing|window|period|dasha|transit|when|date", re.I)


def _title(key: str) -> str:
    s = re.sub(r"[_\-]+", " ", str(key)).strip()
    s = re.sub(r"\s+", " ", s)
    return s[:1].upper() + s[1:] if s else s


def _is_num(v: Any) -> bool:
    return isinstance(v, (int, float)) and not isinstance(v, bool)


def band_for(score: float) -> str:
    if score >= 75:
        return "great"
    if score >= 60:
        return "good"
    if score >= 45:
        return "ok"
    if score >= 30:
        return "weak"
    return "low"


def _fmt(v: Any) -> str:
    if isinstance(v, bool):
        return "Yes" if v else "No"
    if isinstance(v, float):
        return f"{v:.0f}" if v.is_integer() else f"{v:.1f}"
    return str(v)


def _pct(v: float) -> int:
    # Most engine scores are already 0..100; clamp defensively.
    return max(0, min(100, int(round(v))))


def _block_for(key: Any, value: Any, depth: int = 0) -> dict | None:
    """Build a single typed block for a (key, value) pair, or None to skip.

    Keys may be non-strings (e.g. int house numbers), so coerce first — the
    regex hints and label helpers all require a string.
    """
    key = str(key)
    if key in _HIDDEN or _HIDDEN_PAT.search(key):
        return None
    label = _title(key)

    # Numbers that look like scores → a labelled meter.
    if _is_num(value):
        if _SCORE_HINT.search(key) and 0 <= float(value) <= 100:
            return {"type": "meter", "label": label, "value": _fmt(value),
                    "pct": _pct(float(value)), "band": band_for(float(value))}
        return {"type": "kv", "items": [(label, _fmt(value))]}

    if isinstance(value, bool):
        return {"type": "kv", "items": [(label, _fmt(value))]}

    if isinstance(value, str):
        v = value.strip()
        if not v:
            return None
        if len(v) > 90:
            return {"type": "para", "title": label, "text": v}
        return {"type": "kv", "items": [(label, v)]}

    if isinstance(value, list):
        items = [x for x in value if x not in (None, "", [])]
        if not items:
            return None
        if all(isinstance(x, (str, int, float, bool)) for x in items):
            return {"type": "bullets", "title": label,
                    "items": [_fmt(x) for x in items]}
        if all(isinstance(x, dict) for x in items):
            # A table if the dicts are flat & share columns; else stacked cards.
            cols: list[str] = []
            for d in items:
                for k in d:
                    if k not in cols and not _HIDDEN_PAT.search(str(k)):
                        cols.append(k)
            flat = all(
                all(not isinstance(dv, (dict, list)) for dv in d.values())
                for d in items)
            if flat and 1 <= len(cols) <= 8:
                head = [_title(c) for c in cols]
                rows = [[_fmt(d.get(c, "")) for c in cols] for d in items]
                return {"type": "table", "title": label, "head": head, "rows": rows}
            cards = []
            for d in items:
                cards.append({"title": None, "blocks": _blocks_from_dict(d, depth + 1)})
            return {"type": "cards", "title": label, "cards": cards}
        # mixed list — stringify
        return {"type": "bullets", "title": label,
                "items": [_fmt(x) for x in items]}

    if isinstance(value, dict):
        blocks = _blocks_from_dict(value, depth + 1)
        if not blocks:
            return None
        return {"type": "group", "title": label, "blocks": blocks}

    return None


def _blocks_from_dict(d: dict, depth: int = 0) -> list[dict]:
    if depth > 3:
        return []
    out: list[dict] = []
    kv_accum: list[tuple[str, str]] = []
    for k, v in d.items():
        blk = _block_for(k, v, depth)
        if blk is None:
            continue
        if blk["type"] == "kv":
            kv_accum.extend(blk["items"])
        else:
            if kv_accum:
                out.append({"type": "kv", "items": kv_accum})
                kv_accum = []
            out.append(blk)
    if kv_accum:
        out.append({"type": "kv", "items": kv_accum})
    return out


def build_report_view(data: dict) -> dict:
    """Normalize a localized report dict into {hero, metrics, sections}."""
    data = {k: v for k, v in (data or {}).items()
            if k not in _HIDDEN and not _HIDDEN_PAT.search(str(k))}

    hero: dict | None = None
    verdict_text: str | None = None
    used: set[str] = set()

    # Hero: the "overall …" score, else the first score-like number.
    best_key = None
    for k, v in data.items():
        if _is_num(v) and _SCORE_HINT.search(str(k)) and 0 <= float(v) <= 100:
            if _OVERALL_HINT.search(str(k)):
                best_key = k
                break
            if best_key is None:
                best_key = k
    if best_key is not None:
        sc = float(data[best_key])
        hero = {"title": _title(best_key), "value": _fmt(sc),
                "pct": _pct(sc), "band": band_for(sc)}
        used.add(best_key)

    # Verdict / summary text near the top.
    for k, v in data.items():
        if isinstance(v, str) and v.strip() and _VERDICT_HINT.search(str(k)):
            verdict_text = v.strip()
            used.add(k)
            break
    if hero is not None:
        hero["verdict"] = verdict_text

    # Secondary metrics (other score-like numbers) → a meter grid.
    metrics: list[dict] = []
    for k, v in data.items():
        if k in used:
            continue
        if _is_num(v) and _SCORE_HINT.search(str(k)) and 0 <= float(v) <= 100:
            metrics.append({"label": _title(k), "value": _fmt(v),
                            "pct": _pct(float(v)), "band": band_for(float(v))})
            used.add(k)

    # Everything else → titled sections. Group remedy/timing keys with a hint
    # so the template can badge them.
    sections: list[dict] = []
    for k, v in data.items():
        if k in used:
            continue
        blk = _block_for(k, v)
        if blk is None:
            continue
        kind = "remedy" if _REMEDY_HINT.search(str(k)) else \
               "timing" if _TIMING_HINT.search(str(k)) else "default"
        title = blk.get("title") or _title(k)
        if blk["type"] == "group":
            blocks = blk.get("blocks")
        else:
            # The section heading already carries the label; drop the block's
            # own title so it isn't shown twice.
            blk = {**blk, "title": None}
            blocks = [blk]
        sections.append({"title": title, "kind": kind, "blocks": blocks})

    return {"hero": hero, "metrics": metrics, "sections": sections}

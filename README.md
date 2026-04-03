# Nakshtralogy — Full-Stack Vedic Astrology Platform

> **Python Core Engine → FastAPI Backend → Flutter Mobile (Astrologer + User) → React Admin Dashboard**

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture Diagram](#2-architecture-diagram)
3. [Core Engine — nakshtralogy_v2.py](#3-core-engine)
4. [Backend — FastAPI](#4-backend-fastapi)
5. [Mobile Apps — Flutter](#5-mobile-apps-flutter)
6. [Admin Dashboard — React](#6-admin-dashboard-react)
7. [Database Schema](#7-database-schema)
8. [API Reference](#8-api-reference)
9. [Deployment](#9-deployment)
10. [Environment Variables](#10-environment-variables)
11. [Development Setup](#11-development-setup)

---

## 1. Project Overview

Nakshtralogy is a full-stack Vedic astrology platform built around `nakshtralogy_v2.py` — a 2400-line Python engine implementing:

| Feature | Description |
|---------|-------------|
| **Graha Positions** | Sidereal (Lahiri) positions for Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn, Rahu, Ketu |
| **Lagna Calculation** | Ascendant via Swiss Ephemeris (pyswisseph) with VSOP87 fallback |
| **Divisional Charts** | D-1 through D-60 (20 charts) per BPHS |
| **Kundli Grid** | North Indian style visual chart |
| **Vimshottari Dasha** | 6 levels: MD → AD → PD → SD → PAD → Deha |
| **Moola Dasha** | Lagna Kendradi Graha Dasha — 6 levels (JHora-matched) |
| **Gochar** | Daily transit scoring for all 12 rashis with Sade Sati / Chandrashtama alerts |

### Audience

| App | Users |
|-----|-------|
| **Flutter (User)** | Clients who want their chart, dasha timeline, daily gochar |
| **Flutter (Astrologer)** | Professionals who read charts, write notes, consult clients |
| **React Admin** | Platform owner — manages users, astrologers, subscriptions, analytics |

---

## 2. Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENTS                              │
│                                                             │
│   Flutter (User App)    Flutter (Astrologer App)            │
│   iOS / Android         iOS / Android                       │
│                                                             │
│              React Admin Dashboard (Web)                    │
└──────────────────────┬──────────────────────────────────────┘
                       │ HTTPS / REST / WebSocket
┌──────────────────────▼──────────────────────────────────────┐
│                    FastAPI Backend                          │
│                                                             │
│  /api/v1/chart    /api/v1/dasha    /api/v1/gochar          │
│  /api/v1/auth     /api/v1/users    /api/v1/consult         │
│  /api/v1/admin    /api/v1/notify   /api/v1/payments        │
│                                                             │
│         nakshtralogy_v2.py  (Python Core Engine)           │
│         pyswisseph / VSOP87 fallback                       │
└──────────┬──────────────────────────────┬───────────────────┘
           │                              │
    ┌──────▼──────┐               ┌───────▼───────┐
    │ PostgreSQL  │               │     Redis     │
    │  (primary)  │               │  (cache/jobs) │
    └─────────────┘               └───────────────┘
```

---

## 3. Core Engine

### File: `nakshtralogy_v2.py`

### Dependencies

```bash
pip install pyswisseph geopy timezonefinder pytz
```

> **Note:** `pyswisseph` is strongly recommended for accurate sidereal positions.
> The script includes a VSOP87 fallback that returns tropical positions (~23.7° off sidereal)
> when pyswisseph is unavailable. Always install pyswisseph in production.

### Key Public Functions

```python
# ── Ephemeris ─────────────────────────────────────────────────────────
get_all_positions(jd_ut)
# → dict {planet: {"lon": float, "speed": float, "lat": float}}

get_lagna(jd_ut, lat, lon_deg)
# → (lagna_lon, house_cusps, ayanamsha)

to_julian_day(year, month, day, hour_ut) → float
jd_to_date(jd) → str  # "DD/MM/YYYY"

# ── Chart Building ────────────────────────────────────────────────────
calculate_chart(name, gender, dob, tob, place)
# Prints full chart to stdout + returns (pdata, all_divs)
# pdata: dict with all 10 planet/lagna positions
# all_divs: dict {planet: {d_num: sign_idx}} for D1–D60

divisional_sign(sid_lon, d) → int  # sign index 0–11
compute_all_divisionals(sid_lon) → dict

make_kundli_grid(base_rashi_idx, planets_by_rashi, label) → str

# ── Dasha Systems ─────────────────────────────────────────────────────
vimshottari_dasha(moon_sid_lon, birth_jd)
# → (dashas_list, balance_yrs, first_lord)
# Each dasha has: planet, years, start_jd, end_jd, sub (AD→Deha)

moola_dasha_lagna(pdata, birth_jd)
# → (dashas_list, balance_yrs, info_dict)
# 6-level sub-periods. Confirmed against JHora software.

# ── Gochar (Transits) ─────────────────────────────────────────────────
gochar_chart(date_str=None, native_moon_sign=None, show_detail=False)
# date_str: "DD/MM/YYYY" | "today" | "yesterday" | "tomorrow"
# → list of 12 rashi score dicts

gochar_score_rashi(transit_signs, ref_rashi)
# → (score: float, details: dict, flags: list)
```

### Wrapping as a Library

For FastAPI integration, `nakshtralogy_v2.py` should be imported as a module.
Suppress stdout output during API calls:

```python
import io, contextlib
import nakshtralogy_v2 as nk

def silent_chart(name, gender, dob, tob, place):
    """Run calculate_chart without printing to stdout."""
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        pdata, divs = nk.calculate_chart(name, gender, dob, tob, place)
    return pdata, divs
```

---

## 4. Backend — FastAPI

### Project Structure

```
backend/
├── main.py                    # FastAPI app entry point
├── requirements.txt
├── .env
│
├── core/
│   ├── astro_engine.py        # Wraps nakshtralogy_v2.py
│   ├── config.py              # Settings via pydantic-settings
│   ├── security.py            # JWT auth, password hashing
│   └── dependencies.py        # get_db, get_current_user
│
├── api/
│   └── v1/
│       ├── __init__.py
│       ├── auth.py            # /auth/register, /auth/login, /auth/refresh
│       ├── chart.py           # /chart/generate, /chart/{id}
│       ├── dasha.py           # /dasha/vimshottari, /dasha/moola
│       ├── gochar.py          # /gochar/today, /gochar/date
│       ├── consult.py         # /consult/book, /consult/{id}/notes
│       ├── users.py           # /users/me, /users/{id}
│       ├── astrologers.py     # /astrologers/, /astrologers/{id}/profile
│       ├── payments.py        # /payments/create, /payments/verify
│       └── admin.py           # /admin/* (protected)
│
├── models/
│   ├── user.py
│   ├── chart.py
│   ├── dasha.py
│   ├── consult.py
│   └── payment.py
│
├── schemas/
│   ├── chart.py               # Pydantic request/response schemas
│   ├── dasha.py
│   ├── gochar.py
│   └── user.py
│
├── services/
│   ├── chart_service.py       # Business logic, caching
│   ├── dasha_service.py
│   ├── gochar_service.py
│   ├── notify_service.py      # Push notifications (Firebase)
│   └── payment_service.py     # Razorpay / Stripe
│
├── db/
│   ├── database.py            # SQLAlchemy engine + session
│   └── migrations/            # Alembic migrations
│
└── scripts/
    └── nakshtralogy_v2.py     # ← Copy of the core engine
```

### Installation

```bash
python -m venv venv && source venv/bin/activate

pip install fastapi uvicorn[standard] sqlalchemy alembic \
            psycopg2-binary redis pydantic-settings \
            python-jose[cryptography] passlib[bcrypt] \
            pyswisseph geopy timezonefinder pytz \
            firebase-admin razorpay httpx python-multipart
```

### `main.py`

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.v1 import auth, chart, dasha, gochar, consult, users, astrologers, payments, admin

app = FastAPI(title="Nakshtralogy API", version="2.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # tighten in production
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(auth.router,         prefix="/api/v1/auth",        tags=["Auth"])
app.include_router(chart.router,        prefix="/api/v1/chart",       tags=["Chart"])
app.include_router(dasha.router,        prefix="/api/v1/dasha",       tags=["Dasha"])
app.include_router(gochar.router,       prefix="/api/v1/gochar",      tags=["Gochar"])
app.include_router(consult.router,      prefix="/api/v1/consult",     tags=["Consult"])
app.include_router(users.router,        prefix="/api/v1/users",       tags=["Users"])
app.include_router(astrologers.router,  prefix="/api/v1/astrologers", tags=["Astrologers"])
app.include_router(payments.router,     prefix="/api/v1/payments",    tags=["Payments"])
app.include_router(admin.router,        prefix="/api/v1/admin",       tags=["Admin"])

@app.get("/health")
def health(): return {"status": "ok", "engine": "nakshtralogy_v2"}
```

### `core/astro_engine.py`

```python
import io, contextlib, json
from datetime import date, datetime
from typing import Optional
import nakshtralogy_v2 as nk

def build_chart_data(name: str, gender: str, dob: str, tob: str, place: str) -> dict:
    """
    Returns structured chart dict without printing to stdout.
    dob: DD/MM/YYYY  tob: HH:MM  place: city name
    """
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        pdata, divs = nk.calculate_chart(name, gender, dob, tob, place)

    if pdata is None:
        raise ValueError("Could not compute chart — check birth data")

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
            f"D{d}": SIGNS[s] for d, s in chart_map.items()
        }

    return {
        "planets":     planets_out,
        "divisionals": divisionals_out,
        "lagna_sign":  SIGNS_FULL[pdata["Lagna"]["rashi_idx"]],
        "lagna_idx":   pdata["Lagna"]["rashi_idx"],
    }


def build_vimshottari(moon_lon: float, birth_jd: float) -> dict:
    dashas, balance, lord = nk.vimshottari_dasha(moon_lon, birth_jd)
    result = []
    for md in dashas:
        ads = []
        for ad in md.get("sub", []):
            pds = []
            for pd in ad.get("sub", []):
                pds.append({
                    "planet": pd["planet"],
                    "start":  nk.jd_to_date(pd["start_jd"]),
                    "end":    nk.jd_to_date(pd["end_jd"]),
                    "months": round(pd["months"], 3),
                })
            ads.append({
                "planet": ad["planet"],
                "start":  nk.jd_to_date(ad["start_jd"]),
                "end":    nk.jd_to_date(ad["end_jd"]),
                "months": round(ad["months"], 3),
                "sub":    pds,
            })
        result.append({
            "planet": md["planet"],
            "years":  md["years"],
            "start":  nk.jd_to_date(md["start_jd"]),
            "end":    nk.jd_to_date(md["end_jd"]),
            "sub":    ads,
        })
    return {"balance_yrs": round(balance, 4), "first_lord": lord, "dashas": result}


def build_moola(pdata: dict, birth_jd: float) -> dict:
    dashas, balance, info = nk.moola_dasha_lagna(pdata, birth_jd)
    result = []
    for md in dashas:
        ads = []
        for ad in md.get("sub", []):
            ads.append({
                "planet": ad["planet"],
                "start":  nk.jd_to_date(ad["start_jd"]),
                "end":    nk.jd_to_date(ad["end_jd"]),
                "days":   round(ad["end_jd"] - ad["start_jd"], 2),
            })
        result.append({
            "planet":  md["planet"],
            "cycle":   md["cycle"],
            "group":   md["group"],
            "bhava":   md["bhava"],
            "c1_yrs":  md["c1_yrs"],
            "c2_yrs":  md["c2_yrs"],
            "eff_yrs": md["eff_yrs"],
            "start":   nk.jd_to_date(md["start_jd"]),
            "end":     nk.jd_to_date(md["end_jd"]),
            "sub":     ads,
        })
    return {
        "balance_yrs": round(balance, 4),
        "lagna_sign":  info["lagna_sign_name"],
        "group_order": info["group_order"],
        "dashas":      result,
    }


def build_gochar(date_str: Optional[str] = None,
                 native_moon_sign: Optional[int] = None) -> dict:
    results = nk.gochar_chart(date_str=date_str,
                               native_moon_sign=native_moon_sign,
                               show_detail=False)
    # gochar_chart() also prints — suppress in production
    SIGNS_FULL = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
                  'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
    out = []
    for r in results:
        gr_label, gr_stars = r["grade"]
        out.append({
            "rashi":     SIGNS_FULL[r["rashi"]],
            "rashi_idx": r["rashi"],
            "score":     r["score"],
            "grade":     gr_label.strip(),
            "flags":     r["flags"],
        })
    return {"date": date_str or "today", "rashis": out}
```

### `api/v1/chart.py`

```python
from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from sqlalchemy.orm import Session
from core.dependencies import get_db, get_current_user
from core.astro_engine import build_chart_data, build_vimshottari, build_moola
from models.user import User
from models.chart import Chart
from schemas.chart import ChartCreateRequest, ChartResponse
import nakshtralogy_v2 as nk

router = APIRouter()

@router.post("/generate", response_model=ChartResponse)
def generate_chart(req: ChartCreateRequest,
                   db: Session = Depends(get_db),
                   current_user: User = Depends(get_current_user)):
    try:
        chart_data = build_chart_data(
            req.name, req.gender, req.dob, req.tob, req.place
        )
    except Exception as e:
        raise HTTPException(status_code=422, detail=str(e))

    # Cache in DB
    db_chart = Chart(
        user_id=current_user.id,
        name=req.name, gender=req.gender,
        dob=req.dob, tob=req.tob, place=req.place,
        chart_json=chart_data,
    )
    db.add(db_chart); db.commit(); db.refresh(db_chart)

    # Compute dashas on the fly (fast enough)
    moon_lon = chart_data["planets"]["Moon"]["longitude"]
    birth_jd = nk.to_julian_day(
        *map(int, req.dob.split("/")[::-1]),
        float(req.tob.split(":")[0]) + float(req.tob.split(":")[1])/60 - 5.5
    )
    vimsh  = build_vimshottari(moon_lon, birth_jd)

    return {
        "chart_id":    str(db_chart.id),
        "planets":     chart_data["planets"],
        "divisionals": chart_data["divisionals"],
        "lagna_sign":  chart_data["lagna_sign"],
        "vimshottari": vimsh,
    }

@router.get("/{chart_id}", response_model=ChartResponse)
def get_chart(chart_id: str, db: Session = Depends(get_db),
              current_user: User = Depends(get_current_user)):
    chart = db.query(Chart).filter(Chart.id == chart_id,
                                    Chart.user_id == current_user.id).first()
    if not chart:
        raise HTTPException(status_code=404, detail="Chart not found")
    return chart.chart_json
```

### `api/v1/gochar.py`

```python
from fastapi import APIRouter, Query
from typing import Optional
from core.astro_engine import build_gochar
import io, contextlib
import nakshtralogy_v2 as nk

router = APIRouter()

@router.get("/today")
def gochar_today(moon_sign: Optional[int] = Query(None, ge=0, le=11)):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = build_gochar("today", moon_sign)
    return result

@router.get("/date/{date_str}")
def gochar_date(date_str: str,
                moon_sign: Optional[int] = Query(None, ge=0, le=11)):
    # date_str format: YYYY-MM-DD
    parts = date_str.split("-")
    formatted = f"{parts[2]}/{parts[1]}/{parts[0]}"
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = build_gochar(formatted, moon_sign)
    return result

@router.get("/range")
def gochar_range(start: str, end: str,
                 moon_sign: Optional[int] = Query(None, ge=0, le=11)):
    """Return daily gochar scores for a date range (for calendar view)."""
    from datetime import date, timedelta
    results = []
    from datetime import datetime
    d = datetime.strptime(start, "%Y-%m-%d").date()
    end_d = datetime.strptime(end, "%Y-%m-%d").date()
    while d <= end_d:
        ds = d.strftime("%d/%m/%Y")
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            day_result = build_gochar(ds, moon_sign)
        if moon_sign is not None:
            score = next((r["score"] for r in day_result["rashis"]
                          if r["rashi_idx"] == moon_sign), 0)
            grade = next((r["grade"] for r in day_result["rashis"]
                          if r["rashi_idx"] == moon_sign), "Normal")
        else:
            score = max(r["score"] for r in day_result["rashis"])
            grade = "Best"
        results.append({"date": d.isoformat(), "score": score, "grade": grade})
        d += timedelta(days=1)
    return {"moon_sign": moon_sign, "range": results}
```

---

## 5. Mobile Apps — Flutter

### Separate Apps

| App | Package | Description |
|-----|---------|-------------|
| `nakshtralogy_user` | `com.nakshtralogy.user` | End-user: view chart, dasha, daily gochar |
| `nakshtralogy_astro` | `com.nakshtralogy.astro` | Astrologer: manage clients, write readings |

### Shared Flutter Project Structure

```
flutter_apps/
├── packages/
│   └── nakshtralogy_core/       # Shared Dart package
│       ├── lib/
│       │   ├── api/
│       │   │   ├── api_client.dart         # Dio HTTP client
│       │   │   ├── chart_api.dart
│       │   │   ├── dasha_api.dart
│       │   │   └── gochar_api.dart
│       │   ├── models/
│       │   │   ├── chart.dart
│       │   │   ├── dasha.dart
│       │   │   ├── gochar.dart
│       │   │   └── user.dart
│       │   └── utils/
│       │       ├── date_utils.dart
│       │       └── sign_utils.dart
│       └── pubspec.yaml
│
├── user_app/                    # User-facing app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── chart/
│   │   │   │   ├── chart_screen.dart       # Full D-1 Kundli
│   │   │   │   ├── kundli_widget.dart      # SVG North Indian grid
│   │   │   │   └── planet_table.dart
│   │   │   ├── dasha/
│   │   │   │   ├── dasha_screen.dart       # MD/AD/PD timeline
│   │   │   │   └── dasha_timeline.dart     # Gantt-style widget
│   │   │   ├── gochar/
│   │   │   │   ├── gochar_screen.dart      # Daily score cards
│   │   │   │   └── gochar_calendar.dart    # Month heat-map
│   │   │   └── profile/
│   │   │       └── profile_screen.dart
│   │   └── shared/
│   │       ├── theme.dart
│   │       └── widgets/
│   └── pubspec.yaml
│
└── astro_app/                   # Astrologer-facing app
    ├── lib/
    │   ├── main.dart
    │   ├── features/
    │   │   ├── clients/
    │   │   │   ├── client_list_screen.dart
    │   │   │   ├── client_detail_screen.dart
    │   │   │   └── chart_reader_screen.dart  # Full chart analysis
    │   │   ├── consult/
    │   │   │   ├── consultation_screen.dart
    │   │   │   └── notes_editor.dart
    │   │   ├── schedule/
    │   │   │   └── calendar_screen.dart
    │   │   └── earnings/
    │   │       └── earnings_screen.dart
    └── pubspec.yaml
```

### User App `pubspec.yaml`

```yaml
name: nakshtralogy_user
description: Vedic Astrology for everyone

dependencies:
  flutter:
    sdk: flutter
  nakshtralogy_core:
    path: ../packages/nakshtralogy_core
  dio: ^5.4.0
  flutter_riverpod: ^2.5.0
  go_router: ^13.0.0
  flutter_svg: ^2.0.10
  table_calendar: ^3.1.0
  fl_chart: ^0.68.0
  shared_preferences: ^2.2.2
  firebase_messaging: ^14.9.0
  razorpay_flutter: ^1.3.6
```

### `api_client.dart`

```dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const _baseUrl = 'https://api.nakshtralogy.com/api/v1';
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> generateChart({
    required String name, required String gender,
    required String dob, required String tob, required String place,
  }) async {
    final r = await _dio.post('/chart/generate', data: {
      'name': name, 'gender': gender,
      'dob': dob, 'tob': tob, 'place': place,
    });
    return r.data;
  }

  Future<Map<String, dynamic>> getGocharToday({int? moonSign}) async {
    final r = await _dio.get('/gochar/today',
        queryParameters: moonSign != null ? {'moon_sign': moonSign} : null);
    return r.data;
  }

  Future<Map<String, dynamic>> getGocharRange({
    required String start, required String end, int? moonSign,
  }) async {
    final r = await _dio.get('/gochar/range', queryParameters: {
      'start': start, 'end': end,
      if (moonSign != null) 'moon_sign': moonSign,
    });
    return r.data;
  }
}
```

### `gochar_screen.dart` (User App)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GocharScreen extends ConsumerWidget {
  const GocharScreen({super.key});

  Color _gradeColor(String grade) {
    switch (grade.trim()) {
      case 'Excellent': return Colors.green.shade700;
      case 'Very Good': return Colors.green.shade400;
      case 'Good':      return Colors.teal;
      case 'Normal':    return Colors.blue.shade300;
      case 'Caution':   return Colors.orange;
      case 'Bad':       return Colors.deepOrange;
      case 'Very Bad':  return Colors.red.shade700;
      case 'Critical':  return Colors.red.shade900;
      default:          return Colors.grey;
    }
  }

  IconData _gradeIcon(String grade) {
    switch (grade.trim()) {
      case 'Excellent':
      case 'Very Good': return Icons.star;
      case 'Good':
      case 'Normal':    return Icons.star_half;
      case 'Caution':   return Icons.warning_amber;
      default:          return Icons.dangerous;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gocharAsync = ref.watch(gocharTodayProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Gochar')),
      body: gocharAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (data) {
          final rashis = (data['rashis'] as List)
              .cast<Map<String, dynamic>>()
              ..sort((a, b) => (b['score'] as double)
                  .compareTo(a['score'] as double));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rashis.length + 1,
            itemBuilder: (ctx, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text('Transit Scores — ${data['date']}',
                      style: Theme.of(context).textTheme.titleMedium),
                );
              }
              final rashi = rashis[i - 1];
              final grade = rashi['grade'] as String;
              final score = (rashi['score'] as num).toDouble();
              final flags = (rashi['flags'] as List).cast<String>();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _gradeColor(grade),
                    child: Icon(_gradeIcon(grade),
                        color: Colors.white, size: 18),
                  ),
                  title: Row(children: [
                    Text(rashi['rashi'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text('${score >= 0 ? '+' : ''}${score.toStringAsFixed(1)}',
                        style: TextStyle(color: _gradeColor(grade))),
                  ]),
                  subtitle: flags.isEmpty
                      ? Text(grade)
                      : Text('$grade  •  ${flags.join(' ')}'),
                  trailing: _ScoreBar(score: score),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final double score;
  const _ScoreBar({required this.score});

  @override
  Widget build(BuildContext context) {
    const max = 12.0;
    final pct = ((score + max) / (2 * max)).clamp(0.0, 1.0);
    return SizedBox(
      width: 60,
      child: LinearProgressIndicator(
        value: pct,
        backgroundColor: Colors.red.shade100,
        color: score > 2 ? Colors.green : score > -2 ? Colors.orange : Colors.red,
        minHeight: 8,
      ),
    );
  }
}
```

### `kundli_widget.dart` (North Indian Grid)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NorthIndianKundli extends StatelessWidget {
  final Map<String, dynamic> planets;  // from API response
  final int lagnaIdx;

  const NorthIndianKundli({
    super.key, required this.planets, required this.lagnaIdx,
  });

  // North Indian house layout: house positions in the diamond grid
  // House 1 (lagna) = top center cell, etc.
  static const List<int> _cellHouseMap = [
    // row 0: cells 0-3
    12, 1, 2, 3,
    // row 1: cells 4-7
    11, -1, -1, 4,
    // row 2: cells 8-11
    10, -1, -1, 5,
    // row 3: cells 12-15
    9, 8, 7, 6,
  ];

  String _planetsInHouse(int house) {
    final List<String> result = [];
    for (final entry in planets.entries) {
      final signIdx = entry.value['sign_idx'] as int;
      final houseOfPlanet = ((signIdx - lagnaIdx + 12) % 12) + 1;
      if (houseOfPlanet == house) {
        result.add(entry.key == 'Lagna' ? 'As' : entry.key.substring(0, 2));
      }
    }
    return result.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: 16,
        itemBuilder: (ctx, i) {
          final house = _cellHouseMap[i];
          if (house == -1) return const SizedBox(); // center cells
          final content = _planetsInHouse(house);
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber.shade700, width: 1),
              color: house == 1
                  ? Colors.amber.shade50
                  : Colors.grey.shade900,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$house', style: TextStyle(
                    fontSize: 9, color: Colors.grey.shade500)),
                Text(content, style: const TextStyle(
                    fontSize: 11, color: Colors.white, height: 1.3),
                    textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

## 6. Admin Dashboard — React

### Project Structure

```
admin_dashboard/
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── api/
│   │   ├── client.ts               # axios instance
│   │   ├── chartsApi.ts
│   │   ├── usersApi.ts
│   │   ├── astrologersApi.ts
│   │   └── analyticsApi.ts
│   ├── pages/
│   │   ├── Dashboard.tsx           # KPI cards + charts
│   │   ├── Users.tsx               # User management table
│   │   ├── Astrologers.tsx         # Astrologer approval / management
│   │   ├── Charts.tsx              # All generated charts
│   │   ├── Consultations.tsx       # Booking history
│   │   ├── Payments.tsx            # Revenue / transactions
│   │   ├── Gochar.tsx              # Live transit board
│   │   └── Settings.tsx            # Platform config
│   ├── components/
│   │   ├── layout/
│   │   │   ├── Sidebar.tsx
│   │   │   └── TopBar.tsx
│   │   ├── charts/
│   │   │   ├── RevenueChart.tsx    # recharts line chart
│   │   │   ├── UserGrowthChart.tsx
│   │   │   └── GocharHeatMap.tsx   # 12-rashi score grid
│   │   └── common/
│   │       ├── DataTable.tsx
│   │       ├── StatCard.tsx
│   │       └── GocharBadge.tsx
│   ├── hooks/
│   │   ├── useGochar.ts
│   │   └── useAnalytics.ts
│   └── store/
│       └── authStore.ts            # Zustand
├── package.json
└── vite.config.ts
```

### `package.json` (key deps)

```json
{
  "dependencies": {
    "react": "^18.3.0",
    "react-router-dom": "^6.23.0",
    "axios": "^1.7.0",
    "zustand": "^4.5.0",
    "@tanstack/react-query": "^5.40.0",
    "recharts": "^2.12.0",
    "@mui/material": "^5.15.0",
    "@mui/x-data-grid": "^7.5.0",
    "@mui/x-date-pickers": "^7.5.0",
    "react-hot-toast": "^2.4.1",
    "dayjs": "^1.11.11"
  }
}
```

### `pages/Gochar.tsx`

```tsx
import { useQuery } from '@tanstack/react-query';
import axios from '../api/client';
import { Box, Card, CardContent, Typography, Chip, LinearProgress } from '@mui/material';

const RASHI_COLORS: Record<string, string> = {
  'Excellent': '#2e7d32', 'Very Good': '#388e3c', 'Good': '#00897b',
  'Normal':    '#1565c0', 'Caution':   '#f57c00', 'Bad': '#d84315',
  'Very Bad':  '#b71c1c', 'Critical':  '#4a148c',
};

export default function GocharPage() {
  const { data, isLoading } = useQuery({
    queryKey: ['gochar-today'],
    queryFn: () => axios.get('/gochar/today').then(r => r.data),
    refetchInterval: 1000 * 60 * 30,  // refresh every 30 min
  });

  if (isLoading) return <LinearProgress />;

  const rashis = [...(data?.rashis ?? [])].sort(
    (a: any, b: any) => b.score - a.score
  );

  return (
    <Box>
      <Typography variant="h5" mb={2}>
        Gochar Transit Scores — {data?.date}
      </Typography>
      <Box display="grid" gridTemplateColumns="repeat(auto-fill, minmax(200px, 1fr))" gap={2}>
        {rashis.map((r: any) => (
          <Card key={r.rashi} sx={{ borderLeft: `4px solid ${RASHI_COLORS[r.grade] ?? '#9e9e9e'}` }}>
            <CardContent>
              <Typography variant="subtitle1" fontWeight="bold">{r.rashi}</Typography>
              <Typography variant="h6" color={RASHI_COLORS[r.grade]}>
                {r.score >= 0 ? '+' : ''}{r.score.toFixed(2)}
              </Typography>
              <Chip
                label={r.grade}
                size="small"
                sx={{ bgcolor: RASHI_COLORS[r.grade], color: '#fff', mt: 0.5 }}
              />
              {r.flags.slice(0, 2).map((f: string) => (
                <Typography key={f} variant="caption" display="block" color="text.secondary">
                  {f}
                </Typography>
              ))}
            </CardContent>
          </Card>
        ))}
      </Box>
    </Box>
  );
}
```

### `pages/Dashboard.tsx`

```tsx
import { Grid, Card, CardContent, Typography } from '@mui/material';
import { useQuery } from '@tanstack/react-query';
import { LineChart, Line, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';
import axios from '../api/client';

function StatCard({ title, value, sub }: any) {
  return (
    <Card>
      <CardContent>
        <Typography color="text.secondary" variant="body2">{title}</Typography>
        <Typography variant="h4" fontWeight="bold">{value}</Typography>
        <Typography variant="caption" color="text.secondary">{sub}</Typography>
      </CardContent>
    </Card>
  );
}

export default function Dashboard() {
  const { data: stats } = useQuery({
    queryKey: ['admin-stats'],
    queryFn: () => axios.get('/admin/stats').then(r => r.data),
  });

  return (
    <Grid container spacing={3}>
      <Grid item xs={12} sm={6} md={3}>
        <StatCard title="Total Users" value={stats?.total_users ?? '—'} sub="Registered accounts" />
      </Grid>
      <Grid item xs={12} sm={6} md={3}>
        <StatCard title="Active Astrologers" value={stats?.active_astrologers ?? '—'} sub="Approved on platform" />
      </Grid>
      <Grid item xs={12} sm={6} md={3}>
        <StatCard title="Charts Generated" value={stats?.charts_generated ?? '—'} sub="All time" />
      </Grid>
      <Grid item xs={12} sm={6} md={3}>
        <StatCard title="Revenue (₹)" value={stats?.revenue_inr ?? '—'} sub="This month" />
      </Grid>

      <Grid item xs={12} md={8}>
        <Card>
          <CardContent>
            <Typography variant="h6" mb={2}>User Growth (Last 30 days)</Typography>
            <ResponsiveContainer width="100%" height={250}>
              <LineChart data={stats?.user_growth ?? []}>
                <XAxis dataKey="date" tick={{ fontSize: 11 }} />
                <YAxis tick={{ fontSize: 11 }} />
                <Tooltip />
                <Line type="monotone" dataKey="users" stroke="#1976d2" strokeWidth={2} dot={false} />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  );
}
```

---

## 7. Database Schema

```sql
-- Users
CREATE TABLE users (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email       TEXT UNIQUE NOT NULL,
    phone       TEXT,
    password    TEXT NOT NULL,
    name        TEXT,
    role        TEXT DEFAULT 'user',  -- user | astrologer | admin
    moon_sign   INT,                  -- 0-11, cached for gochar
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Astrologer profiles
CREATE TABLE astrologers (
    id              UUID PRIMARY KEY REFERENCES users(id),
    display_name    TEXT,
    bio             TEXT,
    languages       TEXT[],
    specializations TEXT[],
    rate_per_min    NUMERIC(10,2),
    rating          NUMERIC(3,2) DEFAULT 0.0,
    is_approved     BOOLEAN DEFAULT FALSE,
    is_online       BOOLEAN DEFAULT FALSE
);

-- Birth charts
CREATE TABLE charts (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID REFERENCES users(id),
    name        TEXT NOT NULL,
    gender      CHAR(1),
    dob         TEXT NOT NULL,  -- DD/MM/YYYY
    tob         TEXT NOT NULL,  -- HH:MM
    place       TEXT NOT NULL,
    latitude    NUMERIC(9,6),
    longitude   NUMERIC(9,6),
    timezone    TEXT,
    chart_json  JSONB NOT NULL,  -- full output of build_chart_data()
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Dasha cache (pre-computed for performance)
CREATE TABLE dasha_cache (
    chart_id        UUID PRIMARY KEY REFERENCES charts(id),
    vimshottari     JSONB,
    moola           JSONB,
    computed_at     TIMESTAMPTZ DEFAULT NOW()
);

-- Gochar daily cache
CREATE TABLE gochar_daily (
    date        DATE PRIMARY KEY,
    scores_json JSONB NOT NULL,  -- all 12 rashi scores
    computed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Consultations
CREATE TABLE consultations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID REFERENCES users(id),
    astrologer_id   UUID REFERENCES astrologers(id),
    chart_id        UUID REFERENCES charts(id),
    status          TEXT DEFAULT 'pending',  -- pending | active | completed | cancelled
    scheduled_at    TIMESTAMPTZ,
    duration_min    INT,
    notes           TEXT,
    rating          INT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Payments
CREATE TABLE payments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID REFERENCES users(id),
    consult_id      UUID REFERENCES consultations(id),
    amount          NUMERIC(10,2),
    currency        TEXT DEFAULT 'INR',
    gateway         TEXT,          -- razorpay | stripe
    gateway_id      TEXT,
    status          TEXT,          -- pending | success | failed | refunded
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 8. API Reference

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | Create user account |
| POST | `/api/v1/auth/login` | Get JWT tokens |
| POST | `/api/v1/auth/refresh` | Refresh access token |

### Chart

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/chart/generate` | Generate new chart |
| GET | `/api/v1/chart/{id}` | Retrieve saved chart |
| GET | `/api/v1/chart/{id}/dasha/vimshottari` | Vimshottari dasha |
| GET | `/api/v1/chart/{id}/dasha/moola` | Moola dasha |
| GET | `/api/v1/chart/{id}/divisionals` | D-1 to D-60 positions |

### Gochar

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/gochar/today?moon_sign=6` | Today's scores (optional native Moon) |
| GET | `/api/v1/gochar/date/2026-04-03` | Scores for specific date |
| GET | `/api/v1/gochar/range?start=2026-04-01&end=2026-04-30` | Monthly range |

### Admin

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/admin/stats` | KPI dashboard data |
| GET | `/api/v1/admin/users` | Paginated user list |
| PATCH | `/api/v1/admin/astrologers/{id}/approve` | Approve astrologer |
| GET | `/api/v1/admin/payments` | Transaction history |

---

## 9. Deployment

### Docker Compose

```yaml
version: '3.9'
services:
  api:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://naksh:naksh@db:5432/naksh
      - REDIS_URL=redis://redis:6379
    depends_on: [db, redis]
    volumes:
      - ./backend/scripts:/app/scripts  # ephemeris files

  db:
    image: postgres:16
    environment:
      POSTGRES_USER: naksh
      POSTGRES_PASSWORD: naksh
      POSTGRES_DB: naksh
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine

  admin:
    build: ./admin_dashboard
    ports:
      - "3000:80"

volumes:
  pgdata:
```

### `backend/Dockerfile`

```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Swiss Ephemeris data files (required for accurate positions)
RUN mkdir -p /usr/share/swisseph
ENV SE_EPHE_PATH=/usr/share/swisseph

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
```

### Swiss Ephemeris Data Files

Required for `pyswisseph` accuracy (free download from astro.com):

```bash
# Download ephemeris files to backend/ephe/
wget https://www.astro.com/swisseph/ephe/seas_18.se1
wget https://www.astro.com/swisseph/ephe/semo_18.se1
wget https://www.astro.com/swisseph/ephe/sepl_18.se1
```

---

## 10. Environment Variables

### Backend `.env`

```env
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/nakshtralogy

# Redis
REDIS_URL=redis://localhost:6379

# JWT
SECRET_KEY=your-256-bit-secret-key
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=30

# Ephemeris
SE_EPHE_PATH=/usr/share/swisseph

# Firebase (push notifications)
FIREBASE_CREDENTIALS_PATH=./firebase-service-account.json

# Payments
RAZORPAY_KEY_ID=rzp_live_xxxxx
RAZORPAY_KEY_SECRET=xxxxx

# CORS
ALLOWED_ORIGINS=https://admin.nakshtralogy.com,http://localhost:3000
```

---

## 11. Development Setup

```bash
# 1. Backend
cd backend
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
cp nakshtralogy_v2.py scripts/
alembic upgrade head
uvicorn main:app --reload
# → http://localhost:8000/docs

# 2. Admin Dashboard
cd admin_dashboard
npm install
npm run dev
# → http://localhost:3000

# 3. Flutter (User App)
cd flutter_apps/user_app
flutter pub get
flutter run

# 4. Flutter (Astrologer App)
cd flutter_apps/astro_app
flutter pub get
flutter run
```

---

## Notes on `nakshtralogy_v2.py` in Production

```python
# In production, always:
# 1. Install pyswisseph for accurate sidereal positions
pip install pyswisseph

# 2. Set SE_EPHE_PATH before importing
import os
os.environ['SE_EPHE_PATH'] = '/usr/share/swisseph'
import nakshtralogy_v2 as nk

# 3. Suppress stdout when calling from API
import io, contextlib
buf = io.StringIO()
with contextlib.redirect_stdout(buf):
    pdata, divs = nk.calculate_chart(...)

# 4. Cache chart results in DB — chart computation is ~200ms
# 5. Cache gochar_daily scores in Redis (expire at midnight IST)
# 6. Pre-compute dasha timelines asynchronously after chart save
```

---

*Nakshtralogy v2 — Built with Python · FastAPI · Flutter · React*

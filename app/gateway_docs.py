"""
Public API documentation for the Developer API Platform gateway
(developerApiPlatform/ Phase 4.6/4.7, extended in Phase 8.6).

Builds a dedicated FastAPI sub-application — mounted at `/api/v2` by
app/main.py — with its OWN OpenAPI schema, Swagger (`/api/v2/docs`) and
Redoc (`/api/v2/redoc`), completely separate from the internal consumer
app's docs. Developers only ever see the 4 gateway categories here, never
the internal user/astrologer/admin surface.

Every endpoint registered on app.routers.gateway_router.router already
carries its own summary/description/tags/responses (Phase 8 granular
category APIs), so FastAPI's auto-generated OpenAPI schema documents all
~53 endpoints — grouped/tagged by the 4 categories — without any manual
schema authoring here.

Also exposes copy-paste code samples (curl / Python / Node / PHP):
  - `GET /api/v2/code-samples/{product}` — legacy single-endpoint sample
    per product (`kundli`, `specialist`, `milan`, `forecast`) — kept for
    back-compat (Phase 4.7).
  - `GET /api/v2/code-samples/category/{category}` — every endpoint in a
    category (`kundli`, `reports`, `rashi`, `forecast`), each with its own
    curl/Python/Node/PHP snippet (Phase 8.6).
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.routers import gateway_router

GATEWAY_DESCRIPTION = """
# Nakshtralogy Developer API

A metered, subscription-based gateway to 4 Vedic-astrology product
categories — **Kundli**, **Special Reports** (19 report engines), **Rashi**
(zodiac sign predictions), and **Today Forecast** — all included in a
single monthly **All-Access** subscription.

## Authentication

Every request must carry your API key as a bearer token:

```
Authorization: Bearer sk_live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Create/rotate/revoke keys from the developer dashboard or
`POST /api/v1/developer/keys`. Use an `sk_test_...` key while integrating
— it behaves identically but is tracked separately from `sk_live_...`
traffic in your usage analytics.

## Subscription

Every call requires an **active All-Access subscription**
(`POST /api/v1/developer/subscribe`, wallet-funded, 30 days, renewable).
Calls made without one return **402 Payment Required**.

## Rate limit

Every subscriber is rate-limited to the plan's TPS — **1 request/second**
today. Exceeding it returns **429 Too Many Requests** with a `Retry-After`
header (seconds to wait before retrying). A per-key monthly quota and a
concurrency cap apply on top of the TPS limit (also 429).

## Response envelope

Every successful response has the same shape:

```json
{
  "status": "success",
  "data": { "...": "endpoint-specific payload" },
  "meta": {
    "product": "kundli",
    "endpoint": "/api/v2/kundli/all",
    "tps_limit": 1,
    "subscription_expires_at": "2026-08-31T00:00:00",
    "latency_ms": 842,
    "cache_hit": false
  }
}
```

## Error codes

| Status | Meaning |
|---|---|
| 401 | Missing/invalid/revoked API key |
| 402 | No active subscription — subscribe first |
| 403 | Key not scoped for this product, or account suspended/blocked |
| 404 | Unknown report key / rashi sign |
| 429 | Rate limit / monthly quota / concurrency exceeded — see `Retry-After` header |
| 500 | Engine computation error (see `detail`) |

## Idempotent retries

Pass an `Idempotency-Key` header on any `POST` to safely retry without
double-billing usage — the same key + endpoint replays the original
response instead of re-running the engine.

## Response language

Every Kundli, Special Reports, Rashi, and Today Forecast endpoint accepts
an optional `?lang=` query parameter to localize the response:

```
POST /api/v2/kundli/all?lang=hi
```

Supported short codes: `en` (default), `hi`, `mr`, `gu`, `ta`, `te`, `kn`,
`bn`, `pa`, `ml`. Common full-name aliases (`hindi`, `tamil`, `marathi`,
...) and `Accept-Language`-style values (e.g. `hi-IN`) are also accepted
and normalized automatically. An omitted or unrecognized `lang` falls back
to English with no error. The FULL report is localized — display text
(grades, dignities, karaka roles, categories, sign/planet/nakshatra names)
AND the free-text body (summaries, dosh/yoga descriptions, remedies,
predictions and other prose) — while numeric scores, dates, chart IDs, and
every other machine field stay unchanged; calculation/scoring logic never
varies by language. Free-text is translated once and cached per language,
so the first request in a new language is slightly slower than repeats.

## Product categories (Phase 8 — granular)

- **`kundli`** — `POST /kundli/all` (everything) plus one endpoint per
  feature: `summary`, `planets`, `chart`, `divisional`,
  `dasha/vimshottari`, `dasha/moola`, `dosh`, `yoga`, `shadbala`,
  `ashtakavarga`, `aspects`, `life-areas`, `bhava`, `chakra-health`,
  `gochar`, `dasha-activation`.
- **`reports`** — 19 report endpoints: 14 single-chart specialists
  (`career`, `business`, `education`, `wealth`, `debt_recovery`, `love`,
  `marriage`, `health`, `mental_stress`, `property`, `legal`, `life_path`,
  `character`, `past_life`) + 5 combined two-chart reports
  (`kundli_milan`, `relationship`, `child_probability`,
  `love_compatibility`, `karma_linkage`) + a generic `POST /reports/{key}`.
- **`rashi`** — `GET /rashi/all` (all 12 signs) + `GET /rashi/{sign}` for
  each of the 12 zodiac signs.
- **`forecast`** — `POST /forecast` (today's probability forecast).

### Back-compat aliases

The original Phase-4 broad endpoints keep working unmodified so existing
keys/integrations never break: `POST /kundli` (= `/kundli/all`),
`POST /reports/{key}` (generic dispatcher), `POST /milan` (full 3-phase
Kundli Milan — distinct from the shorter `/reports/kundli_milan`),
`POST /forecast`.

See `GET /products` for the live category/report-key/rashi-sign catalog,
`GET /code-samples/{product}` for legacy single-sample snippets, and
`GET /code-samples/category/{category}` for every endpoint's curl/Python/
Node/PHP snippet.
"""

GATEWAY_TAGS = [
    {"name": "Discovery", "description": "Product/report-key/rashi-sign catalog."},
    {"name": "Kundli", "description": "Full birth chart + one endpoint per analysis module (dasha, dosh, yoga, shadbala, ashtakavarga, aspects, life areas, bhava, chakra health, gochar) plus /kundli/all for everything in one call."},
    {"name": "Special Reports", "description": "19 report engines: 14 single-chart specialists (career, wealth, marriage, health, legal, ...) + 5 combined two-chart reports (Kundli Milan, Relationship Intelligence, Child Probability, Love Compatibility, Karma Linkage)."},
    {"name": "Rashi", "description": "12-sign zodiac metadata, traits, and gochar-based daily/weekly/monthly predictions — GET /rashi/all + one endpoint per sign."},
    {"name": "Today Forecast", "description": "Daily probability forecast for a birth chart."},
    {"name": "Code Samples", "description": "Copy-paste snippets per product/endpoint."},
]


def _path_for(product: str) -> str:
    """Legacy single-endpoint lookup for back-compat `/code-samples/{product}`."""
    return {
        "kundli": "/api/v2/kundli",
        "specialist": "/api/v2/reports/career",
        "reports": "/api/v2/reports/career",
        "milan": "/api/v2/milan",
        "rashi": "/api/v2/rashi/all",
        "forecast": "/api/v2/forecast",
    }[product]


def _sample_body_for(product: str) -> dict:
    if product in ("milan",):
        return {
            "person1": {"name": "Priya Singh", "gender": "F", "dob": "22/03/1995", "tob": "14:15", "place": "Mumbai, India"},
            "person2": {"name": "Rahul Kumar", "gender": "M", "dob": "15/08/1992", "tob": "06:30", "place": "Delhi, India"},
        }
    if product == "rashi":
        return {}
    return {"name": "Rahul Kumar", "gender": "M", "dob": "15/08/1992", "tob": "06:30", "place": "Delhi, India"}


def _samples_for(method: str, path: str, body: dict) -> dict:
    """Builds curl/Python/Node/PHP snippets for one gateway endpoint."""
    import json as _json

    full_path = f"/api/v2{path}" if not path.startswith("/api/v2") else path
    has_body = method.upper() == "POST" and body is not None
    body_json = _json.dumps(body, indent=2) if has_body else "null"
    body_json_compact = _json.dumps(body) if has_body else ""

    curl_data = f" \\\n  -d '{body_json_compact}'" if has_body else ""
    curl = f"""curl -X {method.upper()} "https://api.nakshatralogy.com{full_path}" \\
  -H "Authorization: Bearer sk_live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \\
  -H "Content-Type: application/json"{curl_data}"""

    python_json_kw = f",\n    json={body_json},\n" if has_body else ",\n"
    python = f"""import requests

resp = requests.{method.lower()}(
    "https://api.nakshatralogy.com{full_path}",
    headers={{
        "Authorization": "Bearer sk_live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "Content-Type": "application/json",
    }}{python_json_kw})
print(resp.status_code, resp.json())"""

    node_body_kw = f"\n  body: JSON.stringify({body_json}),\n" if has_body else "\n"
    node = f"""const resp = await fetch("https://api.nakshatralogy.com{full_path}", {{
  method: "{method.upper()}",
  headers: {{
    "Authorization": "Bearer sk_live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "Content-Type": "application/json",
  }},{node_body_kw}}});
const data = await resp.json();
console.log(resp.status, data);"""

    php_postfields = f'\ncurl_setopt($ch, CURLOPT_POSTFIELDS, json_encode({_json.dumps(body)}));' if has_body else ""
    php = f"""<?php
$ch = curl_init("https://api.nakshatralogy.com{full_path}");
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "{method.upper()}");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Authorization: Bearer sk_live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "Content-Type: application/json",
]);{php_postfields}
$response = curl_exec($ch);
curl_close($ch);
echo $response;"""

    return {"curl": curl, "python": python, "node": node, "php": php}


def _code_samples(product: str) -> dict:
    """Legacy single-endpoint response — back-compat (Phase 4.7)."""
    path = _path_for(product)
    body = _sample_body_for(product)
    return {
        "product": product,
        "endpoint": path,
        "sample_body": body,
        "samples": _samples_for("GET" if product == "rashi" else "POST", path.replace("/api/v2", ""), body),
    }


def _code_samples_for_category(category: str) -> dict:
    """Phase 8.6 — every endpoint in a category with its own samples."""
    entries = [e for e in gateway_router.GATEWAY_ENDPOINTS_MANIFEST if e["category"] == category]
    if not entries:
        raise HTTPException(status_code=404, detail="Unknown category. Use kundli, reports, rashi or forecast.")
    return {
        "category": category,
        "endpoint_count": len(entries),
        "endpoints": [
            {
                "method": e["method"],
                "path": f"/api/v2{e['path']}",
                "summary": e["summary"],
                "sample_body": e["sample_body"],
                "samples": _samples_for(e["method"], e["path"], e["sample_body"]),
            }
            for e in entries
        ],
    }


def build_gateway_app() -> FastAPI:
    """Builds the /api/v2 sub-application (own OpenAPI schema + docs)."""
    gateway_app = FastAPI(
        title="Nakshtralogy Developer API",
        version="2.0.0",
        description=GATEWAY_DESCRIPTION,
        docs_url="/docs",
        redoc_url="/redoc",
        openapi_url="/openapi.json",
        openapi_tags=GATEWAY_TAGS,
    )
    gateway_app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.CORS_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    gateway_app.include_router(gateway_router.router)

    @gateway_app.get("/health", tags=["Discovery"], summary="Gateway health check")
    def gateway_health():
        # Also report localization readiness so an integrator can confirm, right
        # after a deploy, that ?lang= will actually translate — and whether the
        # free-text (prose) LLM pass is configured (the enum/label/astro-term
        # passes need no LLM and are always on).
        providers = []
        try:
            from app.services._llm_translate_backend import _providers as _llm_providers
            providers = [u.split("//", 1)[-1].split("/", 1)[0] for (u, _k, _m) in _llm_providers()]
        except Exception:
            providers = []
        try:
            from app.core.config import settings as _s
            if getattr(_s, "OLLAMA_URL", ""):
                providers.append("ollama")
        except Exception:
            pass
        llm_on = bool(providers)
        return {
            "status": "ok",
            "gateway": "nakshtralogy-api-v2",
            "localization": {
                "enabled": True,
                "languages": ["en", "hi", "mr", "gu", "ta", "te", "kn", "bn", "pa", "ml"],
                "freetext_llm_configured": llm_on,
                "llm_providers": providers,
                "note": (
                    "Localization active — enum/label/astro-term always, plus "
                    "free-text prose via the configured LLM."
                    if llm_on else
                    "Enum/label/astro-term translation is active. Free-text PROSE "
                    "stays English until an LLM is configured — set GROQ_API_KEY "
                    "or OPENROUTER_API_KEY (or OLLAMA_URL) and restart."
                ),
            },
        }

    @gateway_app.get(
        "/code-samples/category/{category}",
        tags=["Code Samples"],
        summary="Code samples for EVERY endpoint in a category",
        description="Returns curl/Python/Node/PHP snippets for every endpoint under `kundli`, `reports`, `rashi` or `forecast` (Phase 8.6).",
    )
    def code_samples_category(category: str):
        return _code_samples_for_category(category)

    @gateway_app.get(
        "/code-samples/{product}",
        tags=["Code Samples"],
        summary="[Legacy] Copy-paste code samples for one representative endpoint",
        description=(
            "Back-compat single-endpoint sample. Use `kundli`, `reports`, `rashi` or "
            "`forecast` for a representative endpoint in that category, or the "
            "legacy `specialist`/`milan` values. Prefer "
            "`GET /code-samples/category/{category}` for full per-endpoint coverage."
        ),
    )
    def code_samples(product: str):
        if product not in ("kundli", "specialist", "reports", "milan", "rashi", "forecast"):
            raise HTTPException(status_code=404, detail="Unknown product. Use kundli, reports, rashi or forecast (legacy: specialist, milan).")
        return _code_samples(product)

    return gateway_app

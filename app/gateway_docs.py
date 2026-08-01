"""
Public API documentation for the Developer API Platform gateway
(developerApiPlatform/ Phase 4.6 / 4.7).

Builds a dedicated FastAPI sub-application — mounted at `/api/v2` by
app/main.py — with its OWN OpenAPI schema, Swagger (`/api/v2/docs`) and
Redoc (`/api/v2/redoc`), completely separate from the internal consumer
app's docs. Developers only ever see the 4 gateway products here, never
the internal user/astrologer/admin surface.

Also exposes copy-paste code samples (curl / Python / Node / PHP) per
product at `GET /api/v2/code-samples/{product}` (Phase 4.7).
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.routers import gateway_router

GATEWAY_DESCRIPTION = """
# Nakshtralogy Developer API

A metered, subscription-based gateway to 4 Vedic-astrology products:
**Kundli**, **Special Reports** (15 specialist engines), **Kundli Milan**,
and **Today Forecast** — all included in a single monthly **All-Access**
subscription.

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
header (seconds to wait before retrying).

## Response envelope

Every successful response has the same shape:

```json
{
  "status": "success",
  "data": { "...": "product-specific payload" },
  "meta": {
    "product": "kundli",
    "tps_limit": 1,
    "subscription_expires_at": "2026-08-31T00:00:00",
    "latency_ms": 842
  }
}
```

## Error codes

| Status | Meaning |
|---|---|
| 401 | Missing/invalid/revoked API key |
| 402 | No active subscription — subscribe first |
| 403 | Key not scoped for this product, or account suspended/blocked |
| 404 | Unknown specialist report `key` |
| 429 | Rate limit exceeded — see `Retry-After` header |
| 500 | Engine computation error (see `detail`) |

## Products

- `POST /kundli` — full birth chart + every analysis module
- `POST /reports/{key}` — one of 15 specialist reports (career, wealth, marriage, health, legal, ...)
- `POST /milan` — 3-phase Kundli Milan compatibility matching
- `POST /forecast` — today's probability forecast

See `GET /products` for the live product/report-key catalog, and
`GET /code-samples/{product}` for copy-paste curl/Python/Node/PHP snippets.
"""

GATEWAY_TAGS = [
    {"name": "Discovery", "description": "Product & report-key catalog."},
    {"name": "Kundli", "description": "Full birth chart + every analysis module."},
    {"name": "Special Reports", "description": "15 specialist engines (career, wealth, marriage, health, legal, ...)."},
    {"name": "Kundli Milan", "description": "3-phase compatibility matching with a unified score."},
    {"name": "Today Forecast", "description": "Daily probability forecast for a birth chart."},
    {"name": "Code Samples", "description": "Copy-paste snippets per product."},
]


def _sample_body(product: str) -> dict:
    if product == "milan":
        return {
            "person1": {"name": "Priya Singh", "gender": "F", "dob": "22/03/1995", "tob": "14:15", "place": "Mumbai, India"},
            "person2": {"name": "Rahul Kumar", "gender": "M", "dob": "15/08/1992", "tob": "06:30", "place": "Delhi, India"},
        }
    return {"name": "Rahul Kumar", "gender": "M", "dob": "15/08/1992", "tob": "06:30", "place": "Delhi, India"}


def _path_for(product: str) -> str:
    return {
        "kundli": "/api/v2/kundli",
        "specialist": "/api/v2/reports/career",
        "milan": "/api/v2/milan",
        "forecast": "/api/v2/forecast",
    }[product]


def _code_samples(product: str) -> dict:
    import json as _json

    path = _path_for(product)
    body = _sample_body(product)
    body_json = _json.dumps(body, indent=2)
    body_json_compact = _json.dumps(body)

    curl = f"""curl -X POST "https://api.nakshatralogy.com{path}" \\
  -H "Authorization: Bearer sk_live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \\
  -H "Content-Type: application/json" \\
  -d '{body_json_compact}'"""

    python = f"""import requests

resp = requests.post(
    "https://api.nakshatralogy.com{path}",
    headers={{
        "Authorization": "Bearer sk_live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "Content-Type": "application/json",
    }},
    json={body_json},
)
print(resp.status_code, resp.json())"""

    node = f"""const resp = await fetch("https://api.nakshatralogy.com{path}", {{
  method: "POST",
  headers: {{
    "Authorization": "Bearer sk_live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "Content-Type": "application/json",
  }},
  body: JSON.stringify({body_json}),
}});
const data = await resp.json();
console.log(resp.status, data);"""

    php = f"""<?php
$ch = curl_init("https://api.nakshatralogy.com{path}");
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Authorization: Bearer sk_live_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    "Content-Type: application/json",
]);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode({_json.dumps(body)}));
$response = curl_exec($ch);
curl_close($ch);
echo $response;"""

    return {
        "product": product,
        "endpoint": path,
        "sample_body": body,
        "samples": {"curl": curl, "python": python, "node": node, "php": php},
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
        return {"status": "ok", "gateway": "nakshtralogy-api-v2"}

    @gateway_app.get(
        "/code-samples/{product}",
        tags=["Code Samples"],
        summary="Copy-paste code samples for a product",
        description="Returns curl / Python / Node / PHP snippets for `kundli`, `specialist`, `milan` or `forecast`.",
    )
    def code_samples(product: str):
        if product not in ("kundli", "specialist", "milan", "forecast"):
            raise HTTPException(status_code=404, detail="Unknown product. Use kundli, specialist, milan or forecast.")
        return _code_samples(product)

    return gateway_app

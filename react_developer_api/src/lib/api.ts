// API client for the Nakshtralogy Developer Portal.
// Talks to /api/v1/developer/* (account, keys, subscription, wallet, usage)
// and /api/v2/* (the metered gateway itself, used by the docs "try-it"
// playground with the developer's own test key).

const BASE = "https://api.nakshatralogy.com/api/v1";
const GATEWAY_BASE = "https://api.nakshatralogy.com/api/v2";

function getToken(): string | null {
  return localStorage.getItem("developer_access_token");
}

function authHeaders(): Record<string, string> {
  const token = getToken();
  return {
    "Content-Type": "application/json",
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  };
}

async function request<T = any>(
  url: string,
  options: RequestInit = {},
): Promise<{ ok: boolean; status: number; data: T }> {
  const res = await fetch(`${BASE}${url}`, {
    ...options,
    headers: { ...authHeaders(), ...(options.headers as Record<string, string>) },
  });
  const data = await res.json().catch(() => ({}));
  return { ok: res.ok, status: res.status, data };
}

// ── Auth ─────────────────────────────────────────────────────────────

export interface DeveloperUser {
  id: string;
  email: string;
  name: string | null;
  phone: string | null;
  role: string;
  is_active: boolean;
  is_verified: boolean;
  wallet_balance: number;
  profile?: {
    account_type: string;
    company_name: string | null;
    gst_number: string | null;
    kyc_status: string;
    status: string;
  } | null;
  subscription?: {
    plan_code: string | null;
    plan_name: string | null;
    status: string | null;
    tps_limit: number | null;
    expires_at: string | null;
    auto_renew: boolean;
  } | null;
}

function persistSession(data: any) {
  localStorage.setItem("developer_access_token", data.access_token);
  localStorage.setItem("developer_refresh_token", data.refresh_token);
  localStorage.setItem("developer_user", JSON.stringify(data.user));
}

export async function signupDeveloper(payload: Record<string, any>) {
  const res = await fetch(`${BASE}/developer/signup`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  const data = await res.json().catch(() => ({}));
  if (res.ok) persistSession(data);
  return { ok: res.ok, status: res.status, data };
}

export async function loginDeveloper(email: string, password: string) {
  const res = await fetch(`${BASE}/developer/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });
  const data = await res.json().catch(() => ({}));
  if (res.ok) persistSession(data);
  return { ok: res.ok, status: res.status, data };
}

export function logoutDeveloper() {
  localStorage.removeItem("developer_access_token");
  localStorage.removeItem("developer_refresh_token");
  localStorage.removeItem("developer_user");
}

export function getStoredDeveloper(): DeveloperUser | null {
  const raw = localStorage.getItem("developer_user");
  return raw ? JSON.parse(raw) : null;
}

export async function getMe() {
  return request<DeveloperUser>("/developer/me");
}

export async function updateProfile(payload: Record<string, any>) {
  return request("/developer/me/profile", { method: "PUT", body: JSON.stringify(payload) });
}

// ── API keys ─────────────────────────────────────────────────────────

export async function listApiKeys(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/developer/keys?${qs}`);
}

export async function createApiKey(payload: { label?: string; mode: "live" | "test"; scopes?: string[] }) {
  return request("/developer/keys", { method: "POST", body: JSON.stringify(payload) });
}

export async function rotateApiKey(keyId: string) {
  return request(`/developer/keys/${keyId}/rotate`, { method: "POST" });
}

export async function revokeApiKey(keyId: string) {
  return request(`/developer/keys/${keyId}`, { method: "DELETE" });
}

// ── Subscription ─────────────────────────────────────────────────────

export async function listPlans() {
  return request("/developer/plans");
}

export async function getSubscription() {
  return request("/developer/subscription");
}

export async function subscribe(planCode = "all_access", autoRenew = false) {
  return request("/developer/subscribe", {
    method: "POST",
    body: JSON.stringify({ plan_code: planCode, auto_renew: autoRenew }),
  });
}

// ── Wallet ───────────────────────────────────────────────────────────

export async function getWalletBalance() {
  return request("/developer/wallet/balance");
}

export async function rechargeWallet(amount: number, reference?: string) {
  return request("/developer/wallet/recharge", {
    method: "POST",
    body: JSON.stringify({ amount, reference }),
  });
}

export async function listWalletTransactions(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/developer/wallet/transactions?${qs}`);
}

// ── Usage analytics ──────────────────────────────────────────────────

export async function listUsage(params: Record<string, any> = {}) {
  const qs = new URLSearchParams(params).toString();
  return request(`/developer/usage?${qs}`);
}

export async function getUsageSummary(days = 30) {
  return request(`/developer/usage/summary?days=${days}`);
}

// ── Gateway playground (/api/v2, uses the developer's own key) ──────
// Phase 8: the gateway is a granular, category-based surface (kundli /
// reports / rashi / forecast — ~53 endpoints). Every endpoint's full
// path + sample body + code samples come from
// GET /code-samples/category/{category} (see fetchGatewayCategorySamples).

export interface GatewayEndpointSample {
  method: "GET" | "POST";
  path: string; // full path incl. /api/v2 prefix
  summary: string;
  sample_body: Record<string, any> | null;
  samples: { curl: string; python: string; node: string; php: string };
}

export interface GatewayCategorySamples {
  category: string;
  endpoint_count: number;
  endpoints: GatewayEndpointSample[];
}

export const GATEWAY_CATEGORIES = ["kundli", "reports", "rashi", "forecast"] as const;

export async function fetchGatewayCategorySamples(category: string) {
  const res = await fetch(`${GATEWAY_BASE}/code-samples/category/${category}`);
  const data = await res.json().catch(() => ({}));
  return { ok: res.ok, status: res.status, data: data as GatewayCategorySamples };
}

/** Runs a live "try it" call against any gateway endpoint using the
 * developer's own key. `path` is the full path returned by
 * fetchGatewayCategorySamples (already includes /api/v2). */
export async function callGatewayEndpoint(
  method: "GET" | "POST",
  path: string,
  apiKey: string,
  body?: Record<string, any> | null,
) {
  const url = path.startsWith("/api/v2") ? `https://api.nakshatralogy.com${path}` : `${GATEWAY_BASE}${path}`;
  const started = performance.now();
  const res = await fetch(url, {
    method,
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    ...(method === "POST" && body ? { body: JSON.stringify(body) } : {}),
  });
  const data = await res.json().catch(() => ({}));
  const elapsedMs = Math.round(performance.now() - started);
  return { ok: res.ok, status: res.status, data, elapsedMs };
}
